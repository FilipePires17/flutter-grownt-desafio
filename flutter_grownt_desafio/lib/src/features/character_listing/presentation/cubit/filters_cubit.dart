import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/character_filters.dart';

part 'filters_state.dart';

class FiltersCubit extends Cubit<FiltersState> {
  FiltersCubit() : super(FiltersState());

  void updateFilters(CharacterFilters filters) {
    emit(state.copyWith(filters: filters));
  }
}
