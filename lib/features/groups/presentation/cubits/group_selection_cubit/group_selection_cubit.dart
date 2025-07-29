import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSelectionCubit extends Cubit<Set<String>> {
  GroupSelectionCubit() : super({});

  void toggleMember(String id) {
    final updated = Set<String>.from(state);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    emit(updated);
  }

  void clearSelection() => emit({});
  void selectAll(List<String> allIds) => emit(allIds.toSet());
}
