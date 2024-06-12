part of 'categories_bloc.dart';

enum SelectCategoryState { loading, loaded, saved, failure }

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoadingState extends CategoriesState {}

class CategoriesFetchedState extends CategoriesState {
  final List<CategoryEntity> categories;
  final List<CategoryEntity> selectedCategories;
  final SelectCategoryState selectCategoryState;

  @override
  List<Object> get props => [categories, selectedCategories, selectCategoryState];

  const CategoriesFetchedState({
    required this.categories,
    required this.selectedCategories,
    required this.selectCategoryState,
  });
}

class CategoriesSavingState extends CategoriesState {}

class CategoriesFailureState extends CategoriesState {
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];

  const CategoriesFailureState({
    required this.errorMessage,
  });
}
