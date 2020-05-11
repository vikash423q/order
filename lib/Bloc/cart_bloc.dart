import 'dart:async';

import 'package:order/Bloc/menu_bloc.dart';
import 'package:order/Models/menu_item.dart';

class CartBloc {
  List<MenuItem> cartItems = List<MenuItem>();
  final _cartStateController = StreamController<List<MenuItem>>();

  StreamSink<List<MenuItem>> get putItem => _cartStateController.sink;
  Stream<List<MenuItem>> get cartList => _cartStateController.stream;

  final _cartEventController = StreamController<CartEvent>();

  Sink<CartEvent> get cartEventSink => _cartEventController.sink;

  CartBloc() {
    _cartEventController.stream.listen(mapEventToState);
  }

  void mapEventToState(CartEvent event) {
    if (event is CartItemAddedEvent) {
      print('CartItemAdded Called');
      print(event.menuItem.numOfItem);

      bool alreadyExist = false;
      for (var idx = 0; idx < this.cartItems.length; idx++) {
        if (this.cartItems[idx].uid == event.menuItem.uid) {
          alreadyExist = true;
          this.cartItems[idx] = event.menuItem;
          if (event.fromCart) this.cartItems[idx].numOfItem++;
          break;
        }
      }
      if (!alreadyExist) this.cartItems.add(event.menuItem);
      this.putItem.add(this.cartItems);
    } else if (event is CartItemUpdatedEvent) {
      print('CartItemUpdated Called');

      this.putItem.add(this.cartItems);
    } else if (event is CartNonVegItemReset) {
      print('CartNonVegItemReset Called');

      this.cartItems.removeWhere((element) => element.nonVeg);
      this.putItem.add(this.cartItems);
    } else if (event is CartItemRemovedEvent) {
      print('CartItemRemoved Called');

      for (var idx = 0; idx < this.cartItems.length; idx++) {
        if (this.cartItems[idx].uid == event.menuItem.uid) {
          if (event.menuItem.numOfItem > 0) {
            this.cartItems[idx] = event.menuItem;
            if (event.fromCart) this.cartItems[idx].numOfItem--;
          }
          if (!event.fromCart || this.cartItems[idx].numOfItem == 0) {
            print('removing from cart');
            this.cartItems.removeAt(idx);
          }

          break;
        }
      }
      this.putItem.add(this.cartItems);
    } else if (event is CartClearEvent) {
      this.cartItems = List<MenuItem>();
      this.putItem.add(this.cartItems);
    } else if (event is CartListUpdatedEvent) {
      this.cartItems = event.updatedItems;
      this.putItem.add(this.cartItems);
    }
  }

  void dispose() {
    _cartStateController.close();
    _cartEventController.close();
  }
}

class CartEvent {}

class CartItemAddedEvent extends CartEvent {
  MenuItem menuItem;
  bool fromCart;
  CartItemAddedEvent(this.menuItem, {this.fromCart = false});
}

class CartItemRemovedEvent extends CartEvent {
  MenuItem menuItem;
  bool fromCart = false;
  CartItemRemovedEvent(this.menuItem, {this.fromCart = false});
}

class CartItemUpdatedEvent extends CartEvent {}

class CartListUpdatedEvent extends CartEvent {
  List<MenuItem> updatedItems;
  CartListUpdatedEvent(this.updatedItems);
}

class CartNonVegItemReset extends CartEvent {}

class CartClearEvent extends CartEvent {}
