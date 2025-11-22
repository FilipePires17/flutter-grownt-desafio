part of 'filters_cubit.dart';

class FiltersState extends Equatable {
  final CharacterFilters filters;
  final String? errorMessage;

  const FiltersState({
    this.filters = const CharacterFilters(page: 1),
    this.errorMessage,
  });

  FiltersState copyWith({CharacterFilters? filters, String? errorMessage}) {
    return FiltersState(
      filters: filters ?? this.filters,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [filters, errorMessage];
}
