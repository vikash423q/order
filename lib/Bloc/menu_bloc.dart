import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:order/Models/menu_item.dart';
import 'package:order/Services/orderService.dart';

class MenuBloc {
  final List<MenuItem> _menuItems = List<MenuItem>();

  final _menuStateController = StreamController<List<MenuItem>>();

  StreamSink<List<MenuItem>> get putMenu => _menuStateController.sink;
  Stream<List<MenuItem>> get menu => _menuStateController.stream;

  final _menuEventController = StreamController<MenuEvent>();

  Sink<MenuEvent> get menuEventSink => _menuEventController.sink;

  MenuBloc() {
    _menuEventController.stream.listen(mapEventToState);
  }

  void mapEventToState(MenuEvent event) {
    if (event is MenuUpdatedEvent) {
      print('MenuUpdated Called');

      this._menuItems.addAll(event.menuItems);
      this.putMenu.add(event.menuItems);
    } else if (event is MenuRefreshEvent) {
      print('MenuRefresh Called');

      try {
        // Firestore.instance.collection('menu').getDocuments().then((snapshots) {
        //   snapshots.documents.forEach(
        //       (element) => this._menuItems.add(MenuItem.fromSnapshot(element)));
        // this.putMenu.add(this._menuItems);
        // });
        getMenuList().then((items) {
          this._menuItems.addAll(items);
          this.putMenu.add(this._menuItems);
        });
      } on PlatformException catch (pe) {} on Exception catch (error) {
        print(error);
      }
    } else if (event is MenuNonVegItemResetEvent) {
      print('MenuNonVegItemReset Called');
      this
          ._menuItems
          .where((element) => element.nonVeg)
          .forEach((element) => element.numOfItem = 0);
      this.putMenu.add(this._menuItems);
    } else if (event is MenuSyncWithCartEvent) {
      for (var i = 0; i < this._menuItems.length; i++) {
        for (var j = 0; j < event.menuItems.length; j++) {
          if (this._menuItems[i].uid == event.menuItems[j].uid) {
            this._menuItems[i] = event.menuItems[j];
          }
        }
      }
      this.putMenu.add(this._menuItems);
    } else if (event is MenuOnlyVegItemEvent) {
      this
          ._menuItems
          .where((element) => element.nonVeg)
          .forEach((element) => element.numOfItem = 0);
      var filtered =
          this._menuItems.where((element) => !element.nonVeg).toList();
      this.putMenu.add(filtered);
    } else if (event is MenuAllItemEvent) {
      this.putMenu.add(this._menuItems);
    }
  }

  void dispose() {
    _menuStateController.close();
    _menuEventController.close();
  }
}

class MenuEvent {}

class MenuUpdatedEvent extends MenuEvent {
  List<MenuItem> menuItems;
  MenuUpdatedEvent(this.menuItems);
}

class MenuLoadEvent extends MenuEvent {}

class MenuRefreshEvent extends MenuEvent {}

class MenuNonVegItemResetEvent extends MenuEvent {}

class MenuOnlyVegItemEvent extends MenuEvent {}

class MenuAllItemEvent extends MenuEvent {}

class MenuSyncWithCartEvent extends MenuEvent {
  List<MenuItem> menuItems;
  MenuSyncWithCartEvent(this.menuItems);
}
