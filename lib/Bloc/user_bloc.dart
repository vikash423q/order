import 'dart:async';

import 'package:order/Models/user.dart';

class UserBloc {
  User _currentUser = User.empty();
  final _userStateController = StreamController<User>();

  StreamSink<User> get putUser => _userStateController.sink;
  Stream<User> get user => _userStateController.stream;

  final _userEventController = StreamController<UserEvent>();

  Sink<UserEvent> get userEventSink => _userEventController.sink;

  UserBloc() {
    _userEventController.stream.listen(mapEventToState);
  }

  void mapEventToState(UserEvent event) {
    if (event is UserChangedEvent) {
      this.putUser.add(event.user);
      this._currentUser = event.user;
    } else if (event is UserRefreshEvent) {
      this.putUser.add(this._currentUser);
    }
  }

  void dispose() {
    _userStateController.close();
    _userEventController.close();
  }
}

class UserEvent {}

class UserChangedEvent extends UserEvent {
  User user;
  UserChangedEvent(this.user);
}

class UserRefreshEvent extends UserEvent {}
