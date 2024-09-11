import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../domain/entities/post_request_entity/search_post_entity.dart';
import 'seeker_home_event.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../domain/entities/get_response_entity/services_items.dart';
import '../../../domain/usecases/seeker_home_usecases.dart';
import 'seeker_home_state.dart';

/// Seeker home bloc
class SeekerHomeBloc extends Bloc<SeekerHomeEvent, SeekerHomeState> {
  SeekerHomeUseCase seekerHomeUseCase;

  int initialIndex = 1;
  String lastIndex = "10";
  List<SearchItemEntity> providers = [];
  String transactionId = "";

  SeekerHomeBloc({required this.seekerHomeUseCase})
      : super(SeekerHomeInitialState()) {
    on<SeekerSSEvent>(_onSeekerSSEConnectionEvent);
  }

  /// Seeker home event handler
  FutureOr<void> _onSeekerSSEConnectionEvent(
      SeekerSSEvent event, Emitter<SeekerHomeState> emit) async {
    /*if (event.isFromInit) {
      products.clear();
      providers.clear();
      emit(SeekerHomeUpdatedState(
        productsList: List.from(products),
        state: DataState.loading,
        courseList: List.from(providers),
      ));
    } else {
      emit(SeekerHomeUpdatedState(
          state: DataState.loading,
          productsList: products,
          courseList: providers));
    }*/
    try {
      if (event.isFirstTime) {
        providers = [];
        initialIndex = 1;
      }
      emit(SeekerHomeUpdatedState(
          state: DataState.loading, providerData: providers));

      SearchPostEntity entity = SearchPostEntity(
          deviceId:
              sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId),
          searchText: event.search,
          initialIndex: initialIndex.toString(),
          lastIndex: lastIndex);

      var res = await seekerHomeUseCase.search(entity);
      transactionId = res.transactionId.toString();
      providers.addAll(res.items!);

      // Remove duplicates from the providers
      providers = LinkedHashSet<SearchItemEntity>.from(providers).toList();

      initialIndex = initialIndex++;

      emit(SeekerHomeUpdatedState(
          state: DataState.success, providerData: List.from(providers)));
    } catch (e) {
      emit(SeekerHomeUpdatedState(
          state: DataState.error,
          errorMessage: AppUtils.getErrorMessage(e.toString()),
          providerData: List.from(providers)));
    }
  }
}
