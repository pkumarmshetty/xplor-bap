import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:xplor/features/apply_course/domain/entities/post_request_entity/init_post_entity.dart';
import 'package:xplor/features/apply_course/domain/entities/post_request_entity/select_post_entity.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_vc_list_entity.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../core/exception_errors.dart';
import '../../../course_description/domain/entity/services_items.dart';
import '../../domain/entities/get_response_entity/sse_services_entity.dart';
import '../../domain/entities/post_request_entity/confirm_post_entity.dart';

import '../../domain/usecases/apply_form_usecases.dart';

part 'apply_course_event.dart';

part 'apply_course_state.dart';

class ApplyCourseBloc extends Bloc<ApplyCourseEvent, ApplyCourseState> {
  ApplyFormUseCase useCase;

  bool linkCopied = false;
  bool sseWaiting = false;
  bool isEnabledOnSelect = false;
  String deviceId = "";
  String transactionId = "";
  String courseMediaUrl = "";

  String url = "";

  var timeout = const Duration(minutes: 2);

  CourseDetailsDataEntity? course;

  SseServicesEntity? order;

  ApplyCourseBloc(this.useCase) : super(ApplyCourseInitial()) {
    on<UpdateInitStateEvent>(_onUpdateInitialStateEvent);
    on<ApplyCourseEvent>(_onApplyCourse);
    on<CourseGetUrlEvent>(_onUrlStreamData);
    on<InitSseResponseEvent>(_onInitSseResponse);
    on<CourseDocumentSelectedEvent>(_onDocumentSelected);
    on<CourseDocumentRemovedEvent>(_onDocumentRemoved);
    on<DocumentLinkCopiedEvent>(_onDocumentLinkCopied);
    on<CourseSelectEvent>(_onSelectEvent);
    on<SelectSseResponseEvent>(_onSelectSseResponse);
    on<OnSelectResponseEvent>(_onOnSelectResponseData);
    on<CourseInitEvent>(_onCourseInitEvent);
    on<ConfirmSseResponseEvent>(_onConfirmSseResponse);
    on<CourseConfirmEvent>(_onCourseConfirmEvent);
    on<FormSubmitSuccessfully>(_onFormSubmitEvent);
    on<SuccessNavigatedEvent>(_onNavigatedConfirmEvent);
    on<SeekerFailureEvent>(_failureState);
  }

  FutureOr<void> _onApplyCourse(ApplyCourseEvent event, Emitter<ApplyCourseState> emit) {}

  FutureOr<void> _onDocumentSelected(CourseDocumentSelectedEvent event, Emitter<ApplyCourseState> emit) {
    linkCopied = true;
    emit(CourseDocumentState(docs: [event.selectedDoc], linkCopied: true));
  }

  FutureOr<void> _onFormSubmitEvent(FormSubmitSuccessfully event, Emitter<ApplyCourseState> emit) {
    emit(FormSubmittedState());
  }

  FutureOr<void> _onUpdateInitialStateEvent(UpdateInitStateEvent event, Emitter<ApplyCourseState> emit) {
    isEnabledOnSelect = false;
    linkCopied = false;
    deviceId = sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId);
    emit(ApplyCourseInitial());
  }

  FutureOr<void> _onSelectEvent(CourseSelectEvent courseSelectEvent, Emitter<ApplyCourseState> emit) {
    course = courseSelectEvent.data;
    transactionId = courseSelectEvent.transactionId;
    emit(const ApplyFormLoaderState());

    final sseStream = useCase.sseConnection(transactionId: transactionId, timeout: const Duration(minutes: 2));

    try {
      sseStream.listen(
        (event) {
          if (event.success) {
            add(SelectSseResponseEvent(transactionId: courseSelectEvent.transactionId));
          } else {
            order = event;
            if (order!.action == "on_select" && order != null) {
              add(OnSelectResponseEvent(order: order!));
            }
          }
        },
        onError: (error) {
          // Handle error
          if (kDebugMode) {
            print('Error occurred: $error');
          }

          var message = AppUtils.getErrorMessage(error.toString());

          if (message.toString().startsWith('ClientException with SocketNetwork')) {
            message = ExceptionErrors.checkInternetConnection.stringToString;
          }

          add(SeekerFailureEvent(error: message));
        },
      );
    } catch (e) {
      add(SeekerFailureEvent(error: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onSelectSseResponse(SelectSseResponseEvent event, Emitter<ApplyCourseState> emit) {
    var body = SelectPostEntity(
      itemId: course!.itemId,
      providerId: course!.providerId,
      deviceId: deviceId,
      domain: course!.domain,
      transactionId: event.transactionId,
    ).toJson();

    try {
      useCase.select(body);
    } catch (e) {
      if (kDebugMode) {
        print("exception exception ${e.toString()}");
      }
      emit(CourseFailureState(errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onOnSelectResponseData(OnSelectResponseEvent event, Emitter<ApplyCourseState> emit) {
    isEnabledOnSelect = true;

    transactionId = event.order.transactionId;
    emit(const SuccessOnSelectState());
  }

  FutureOr<void> _onCourseInitEvent(CourseInitEvent event, Emitter<ApplyCourseState> emit) {
    emit(const ApplyFormLoaderState());
    final sseStream = useCase.sseConnection(transactionId: transactionId, timeout: const Duration(minutes: 2));

    try {
      sseStream.listen(
        (event) {
          if (event.success) {
            add(InitSseResponseEvent(transactionId: course!.transactionId, domain: course!.domain));
          } else {
            order = event;
            if (order!.action == "on_init") {
              if (order!.formUrl.isNotEmpty) {
                add(CourseGetUrlEvent(url: order!.formUrl));
              } else {
                add(const CourseConfirmEvent(data: ""));
              }
            }
          }
        },
        onError: (error) {
          // Handle error
          if (kDebugMode) {
            print('Error occurred: $error');
          }

          var message = AppUtils.getErrorMessage(error.toString());

          if (message.toString().startsWith('ClientException with SocketNetwork')) {
            message = ExceptionErrors.checkInternetConnection.stringToString;
          }

          add(SeekerFailureEvent(error: message));
        },
      );
    } catch (e) {
      add(SeekerFailureEvent(error: AppUtils.getErrorMessage(e.toString())));
    }
  }

  Future<void> _onInitSseResponse(InitSseResponseEvent event, Emitter<ApplyCourseState> emit) async {
    linkCopied = false;
    courseMediaUrl = "";
    var body = InitPostEntity(
            billingAddress: BillingAddress(
                street: "123 Main St", city: "Any town", state: "CA", postalCode: "12345", country: "USA"),
            providerId: course!.providerId,
            deviceId: deviceId,
            domain: order!.domain,
            itemId: course!.itemId,
            transactionId: transactionId)
        .toJson();

    try {
      useCase.init(body);
    } catch (e) {
      emit(CourseFailureState(errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onDocumentLinkCopied(DocumentLinkCopiedEvent event, Emitter<ApplyCourseState> emit) {
    linkCopied = true;
    emit(const CourseDocumentState(docs: [], linkCopied: true));
  }

  FutureOr<void> _onDocumentRemoved(CourseDocumentRemovedEvent event, Emitter<ApplyCourseState> emit) {
    emit(const CourseDocumentState(docs: [], linkCopied: false));
  }

  Future<void> _failureState(SeekerFailureEvent event, Emitter<ApplyCourseState> emit) async {
    emit(CourseFailureState(errorMessage: event.error));
  }

  Future<void> _onUrlStreamData(CourseGetUrlEvent event, Emitter<ApplyCourseState> emit) async {
    url = event.url;
    //if (!isLoadedUrl) {
    //isLoadedUrl = true;

    emit(CourseUrlDataState(
      url: event.url,
    ));
    // }
  }

  FutureOr<void> _onCourseConfirmEvent(CourseConfirmEvent event, Emitter<ApplyCourseState> emit) {
    emit(const ApplyFormLoaderState());
    final sseStream = useCase.sseConnection(transactionId: transactionId, timeout: const Duration(minutes: 2));

    try {
      sseStream.listen(
        (event) {
          if (event.success) {
            add(const ConfirmSseResponseEvent());
          } else {
            order = event;
            if (order!.action == "on_confirm") {
              // if (!isConfirm) {
              courseMediaUrl = order!.stops![0].instructions.media[0].url.toString();
              add(const SuccessNavigatedEvent());
              //}
            }
          }
        },
        onError: (error) {
          // Handle error
          if (kDebugMode) {
            print('Error occurred: $error');
          }

          var message = AppUtils.getErrorMessage(error.toString());

          if (message.toString().startsWith('ClientException with SocketNetwork')) {
            message = ExceptionErrors.checkInternetConnection.stringToString;
          }

          add(SeekerFailureEvent(error: message));
        },
      );
    } catch (e) {
      add(SeekerFailureEvent(error: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onConfirmSseResponse(ConfirmSseResponseEvent event, Emitter<ApplyCourseState> emit) {
    String entity = ConfirmPostEntity(
            itemId: order!.itemId,
            transactionId: transactionId,
            domain: order!.domain,
            deviceId: deviceId,
            providerId: course!.providerId)
        .toJson();

    try {
      useCase.confirm(entity);
    } catch (e) {
      if (kDebugMode) {
        print("init data failed");
      }
      emit(CourseFailureState(errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

/*  FutureOr<void> _onCourseStatusEvent(
      CourseStatusEvent event, Emitter<ApplyCourseState> emit) {
    emit(const ApplyFormLoaderState());
    final sseStream = useCase.sseConnection(
        transactionId: transactionId, timeout: const Duration(minutes: 2));

    try {
      sseStream.listen(
        (event) {
          if (event.success) {
            add(const StatusSseResponseEvent());
          } else {
            order = event;
            if (order!.action == "on_status") {
              // if (!isStatus) {
              add(const SuccessNavigatedEvent());
              //}
            }
          }
        },
        onError: (error) {
          // Handle error
          if (kDebugMode) {
            print('Error occurred: $error');
          }

          var message = AppUtils.getErrorMessage(error.toString());

          if (message
              .toString()
              .startsWith('ClientException with SocketNetwork')) {
            message = ExceptionErrors.checkInternetConnection.stringToString;
          }

          add(SeekerFailureEvent(error: message));
        },
      );
    } catch (e) {
      add(SeekerFailureEvent(error: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onStatusSseResponse(
      StatusSseResponseEvent event, Emitter<ApplyCourseState> emit) {
    String entity = StatusPostEntity(
            itemId: course!.itemId,
            domain: order!.domain,
            deviceId: deviceId,
            transactionId: transactionId,
            orderId: order!.orderId)
        .toJson();

    try {
      useCase.status(entity);
    } catch (e) {
      if (kDebugMode) {
        print("init data failed");
      }
      emit(CourseFailureState(
          errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }*/

  FutureOr<void> _onNavigatedConfirmEvent(SuccessNavigatedEvent event, Emitter<ApplyCourseState> emit) {
    // isStatus = true;
    SSEClient.unsubscribeFromSSE();
    emit(const NavigationSuccessState());
  }
}

/*  void _sseConnectionData() {
    final sseStream = useCase.sseConnection(
        transactionId: transactionId, timeout: const Duration(minutes: 2));

    sseStream.listen(
      (event) {
        order = event;

        if (order!.action == "on_select" && order != null) {
          add(OnSelectResponseEvent(order: order!));
        }
        if (order!.action == "on_init") {
          if (order!.formUrl.isNotEmpty) {
            add(CourseGetUrlEvent(url: order!.formUrl));
          } else {
            add(const CourseConfirmEvent(data: ""));
          }
        }
        if (order!.action == "on_confirm") {
          // if (!isConfirm) {
          add(const CourseStatusEvent());
          //}
        }

        if (order!.action == "on_status") {
          // if (!isStatus) {
          add(const SuccessNavigatedEvent());
          //}
        }
      },
      onError: (error) {
        // Handle error
        if (kDebugMode) {
          print('Error occurred: $error');
        }

        var message = AppUtils.getErrorMessage(error.toString());

        if (message
            .toString()
            .startsWith('ClientException with SocketNetwork')) {
          message = ExceptionErrors.checkInternetConnection.stringToString;
        }

        add(SeekerFailureEvent(error: message));
      },
    );
  }*/
