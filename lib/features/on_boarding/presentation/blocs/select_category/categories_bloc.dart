import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/categories_entity.dart';
import '../../../domain/usecase/on_boarding_usecase.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../utils/app_utils/app_utils.dart';

part 'categories_event.dart';

part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  OnBoardingUseCase useCase;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  CategoriesBloc({
    required this.useCase,
    required this.preferencesHelper,
    this.helper,
  }) : super(CategoriesInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategoriesEvent);
    on<CategorySelectedEvent>(_onCategorySelectedEvent);
    on<CategorySearchEvent>(_onCategorySearchEvent);
    on<CategoriesSaveEvent>(_onCategoriesSaveEvent);
  }

  List<CategoryEntity> selectedCategories = [];
  List<CategoryEntity> categories = [];

  FutureOr<void> _onCategorySelectedEvent(CategorySelectedEvent event, Emitter<CategoriesState> emit) {
    categories = List.from(categories);
    CategoryEntity updatedCategory = categories[event.position].copyWith(isSelected: event.isSelected);
    categories[event.position] = updatedCategory;
    selectedCategories = List.from(selectedCategories);
    if (event.isSelected) {
      // Check if the category already exists in selectedCategories
      if (!selectedCategories.any((category) => category.id == updatedCategory.id)) {
        selectedCategories.add(updatedCategory);
      }
    } else {
      // Remove the category from selectedCategories based on its category property
      selectedCategories.removeWhere((category) => category.id == updatedCategory.id);
    }

    emit(CategoriesFetchedState(
      categories: categories,
      selectedCategories: selectedCategories,
      selectCategoryState: SelectCategoryState.loaded,
    ));
  }

  FutureOr<void> _onFetchCategoriesEvent(FetchCategoriesEvent event, Emitter<CategoriesState> emit) async {
    categories.clear();
    emit(CategoriesFetchedState(
      categories: categories,
      selectedCategories: selectedCategories,
      selectCategoryState: SelectCategoryState.loading,
    ));
    try {
      List<CategoryEntity> response = await useCase.getCategories();
      categories = response
          .map((e) => CategoryEntity(
              id: e.id ?? "", value: e.value ?? "", category: e.category ?? "", isSelected: e.isSelected ?? false))
          .toList();
      emit(CategoriesFetchedState(
        categories: categories,
        selectedCategories: const [],
        selectCategoryState: SelectCategoryState.loaded,
      ));
    } catch (e) {
      emit(CategoriesFailureState(errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onCategorySearchEvent(CategorySearchEvent event, Emitter<CategoriesState> emit) async {
    final query = event.query.toLowerCase();
    if (helper != null) {
      await helper!.setString(PrefConstKeys.searchCategoryInput, query);
    } else {
      await preferencesHelper.setString(PrefConstKeys.searchCategoryInput, query);
    }
  }

  FutureOr<void> _onCategoriesSaveEvent(CategoriesSaveEvent event, Emitter<CategoriesState> emit) async {
    emit(CategoriesFetchedState(
      categories: List.from(categories),
      selectedCategories: List.from(selectedCategories),
      selectCategoryState: SelectCategoryState.loading,
    ));
    try {
      // Extract category names from selectedCategories and filter out null values
      final selectedCategoryNames = selectedCategories
          .where((category) => category.id != null)
          .map((category) => category.id!) // Use ! to assert non-nullability
          .toList();
      Map<String, dynamic> dataMap = <String, dynamic>{};
      dataMap['deviceId'] = sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId);
      dataMap['categories'] = selectedCategoryNames;
      final success = await useCase.updateDevicePreference(dataMap);
      if (success) {
        String categoriesJson = jsonEncode(selectedCategories.map((e) => e.toJson()).toList());
        AppUtils.printLogs('Category JSON.... $categoriesJson');
        await sl<SharedPreferencesHelper>().setString(PrefConstKeys.listOfCategory, categoriesJson);

        //emit(CategoriesSavingState());
        emit(CategoriesFetchedState(
          categories: List.from(categories),
          selectedCategories: List.from(selectedCategories),
          selectCategoryState: SelectCategoryState.saved,
        ));
      }
    } catch (e) {
      emit(CategoriesFailureState(errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }
}
