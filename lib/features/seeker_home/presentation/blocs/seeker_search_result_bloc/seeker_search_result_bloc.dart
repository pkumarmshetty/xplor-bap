import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:xplor/const/local_storage/shared_preferences_helper.dart';
import 'package:xplor/core/dependency_injection.dart';
import 'package:xplor/features/seeker_home/domain/usecases/seeker_home_usecases.dart';
import 'package:xplor/features/seeker_home/presentation/blocs/seeker_search_result_bloc/seeker_search_result_event.dart';
import 'package:xplor/features/seeker_home/presentation/blocs/seeker_search_result_bloc/seeker_search_result_state.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';

import '../../../domain/entities/get_response_entity/services_items.dart';
import '../../../domain/entities/post_request_entity/search_post_entity.dart';

class SeekerSearchResultBloc extends Bloc<SeekerSearchResultEvent, SeekerSearchResultState> {
  SeekerHomeUseCase seekerHomeUseCase;

  int initialIndex = 1;
  String lastIndex = "10";
  List<SearchItemEntity> providers = [];
  String transactionId = "";

  SeekerSearchResultBloc({required this.seekerHomeUseCase}) : super(SearchResultInitialState()) {
    on<SearchSSEvent>(_onSeekerSSEConnectionEvent);
  }

  FutureOr<void> _onSeekerSSEConnectionEvent(SearchSSEvent event, Emitter<SeekerSearchResultState> emit) async {
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

    if (event.isFromSearch) {
      providers = [];
      initialIndex = 1;
    }
    try {
      emit(SearchResultUpdatedState(state: DataState.loading, providerData: providers));
      SearchPostEntity entity = SearchPostEntity(
          deviceId: sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId),
          searchText: event.search,
          initialIndex: initialIndex.toString(),
          lastIndex: lastIndex);

      var res = await seekerHomeUseCase.search(entity);
      transactionId = res.transactionId.toString();
      providers.addAll(res.items!);
      // Remove duplicates from the providers
      providers = LinkedHashSet<SearchItemEntity>.from(providers).toList();

      initialIndex = initialIndex++;

      emit(SearchResultUpdatedState(state: DataState.success, providerData: List.from(providers)));
    } catch (e) {
      emit(SearchResultUpdatedState(
          state: DataState.error,
          errorMessage: AppUtils.getErrorMessage(e.toString()),
          providerData: List.from(providers)));
    }
  }
}
