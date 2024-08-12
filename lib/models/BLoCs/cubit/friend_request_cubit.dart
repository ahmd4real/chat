import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendRequestCubit extends Cubit<Map<int, bool>> {
  static const _friendRequestKey = 'friendRequestStates';

  FriendRequestCubit() : super({}) {
    loadFriendRequestStates(); // Call the public method
  }

  Future<void> addFriend(int id) async {
    final currentState = Map<int, bool>.from(state);
    currentState[id] = true;
    emit(currentState);
    await _saveFriendRequestStates(currentState);
  }

  Future<void> cancelFriend(int id) async {
    final currentState = Map<int, bool>.from(state);
    currentState[id] = false;
    emit(currentState);
    await _saveFriendRequestStates(currentState);
  }

  Future<void> _saveFriendRequestStates(Map<int, bool> states) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert the map to a List of Strings
    final statesList = states.entries.map((entry) => '${entry.key}:${entry.value}').toList();
    await prefs.setStringList(_friendRequestKey, statesList);
  }

  // Make this method public by removing the leading underscore
  Future<void> loadFriendRequestStates() async {
    final prefs = await SharedPreferences.getInstance();
    final statesList = prefs.getStringList(_friendRequestKey) ?? [];
    final states = <int, bool>{};

    for (var entry in statesList) {
      final split = entry.split(':');
      if (split.length == 2) {
        final id = int.tryParse(split[0]);
        final isPending = split[1] == 'true';
        if (id != null) {
          states[id] = isPending;
        }
      }
    }

    emit(states);
  }

  Future<void> clearFriendRequestStates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_friendRequestKey);
    emit({});
  }
}
