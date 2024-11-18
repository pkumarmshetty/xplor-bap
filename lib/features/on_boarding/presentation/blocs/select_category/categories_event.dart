part of 'categories_bloc.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class FetchCategoriesEvent extends CategoriesEvent {
  @override
  List<Object> get props => [];
}

class CategoriesSaveEvent extends CategoriesEvent {}

class CategorySelectedEvent extends CategoriesEvent {
  final int position;
  final bool isSelected;

  @override
  List<Object> get props => [position, isSelected];

  const CategorySelectedEvent({
    required this.position,
    required this.isSelected,
  });
}

class CategorySearchEvent extends CategoriesEvent {
  final String query;

  @override
  List<Object> get props => [query];

  const CategorySearchEvent({required this.query});
}
