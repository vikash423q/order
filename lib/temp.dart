import "package:cloud_firestore/cloud_firestore.dart";

import "package:order/Models/menu_item.dart";

List<MenuItem> _menuItems = [
  MenuItem(
      name: 'Chicken 65',
      cuisine: 'CHINESE',
      category: ['Non Veg', 'Biryani'],
      actualPrice: 320,
      offeredPrice: 220,
      available: true,
      nonVeg: true,
      recommended: true,
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS2DwfyjtmYPPuuIZjNICpSlgu2dMglRkXv0ar4sGIwAylRqrYA&usqp=CAU"),
  MenuItem(
      name: 'Mushroom Biryani',
      cuisine: 'INDIAN',
      category: ['Biryani'],
      actualPrice: 220,
      offeredPrice: 180,
      available: true,
      nonVeg: false,
      recommended: true,
      imageUrl:
          "https://i2.wp.com/cookingfromheart.com/wp-content/uploads/2017/05/Chettinad-Mushroom-Biryani-4.jpg?fit=1024%2C683&ssl=1"),
  MenuItem(
      name: 'Poha',
      cuisine: 'INDIAN',
      category: ['Breakfast'],
      actualPrice: 120,
      offeredPrice: 80,
      available: true,
      nonVeg: false,
      recommended: true,
      imageUrl:
          "https://www.cookwithmanali.com/wp-content/uploads/2014/08/Poha-Recipe.jpg"),
  MenuItem(
      name: 'Chicken Chilli',
      cuisine: 'CHINESE',
      category: ['Non Veg'],
      actualPrice: 280,
      offeredPrice: 200,
      available: true,
      nonVeg: true,
      recommended: false,
      imageUrl:
          "https://pupswithchopsticks.com/wp-content/uploads/chilli-chicken-thumbnail.jpg"),
  MenuItem(
      name: 'Chicken Fried Rice',
      cuisine: 'CHINESE',
      category: ['Non Veg'],
      actualPrice: 240,
      offeredPrice: 180,
      available: true,
      nonVeg: true,
      recommended: false,
      imageUrl:
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2019/05/chicken-fried-rice-500x500.jpg"),
  MenuItem(
      name: 'Dahi Vada',
      cuisine: 'STARTER',
      category: ['Breakfast', 'Desserts'],
      actualPrice: 160,
      offeredPrice: 100,
      available: true,
      nonVeg: false,
      recommended: false,
      imageUrl: ""),
  MenuItem(
      name: 'Idli & Vada',
      cuisine: 'SOUTH INDIAN',
      category: ['Breakfast'],
      actualPrice: 110,
      offeredPrice: 80,
      available: true,
      nonVeg: false,
      recommended: false,
      imageUrl:
          "https://i2.wp.com/www.vegrecipesofindia.com/wp-content/uploads/2013/11/dahi-vada-recipe-1.jpg"),
  MenuItem(
      name: 'Hyderabadi Chicken Biryani',
      cuisine: 'INDIAN',
      category: ['Biryani', 'Non Veg'],
      actualPrice: 320,
      offeredPrice: 220,
      available: true,
      nonVeg: true,
      recommended: false,
      imageUrl:
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2019/02/hyderabadi-biryani-recipe-500x500.jpg"),
  MenuItem(
      name: 'Paneer Biryani',
      cuisine: 'INDIAN',
      category: ['Biryani'],
      actualPrice: 280,
      offeredPrice: 200,
      available: true,
      nonVeg: false,
      recommended: false,
      imageUrl:
          "https://pull-revisfoodography.netdna-ssl.com/wp-content/uploads/2017/01/paneer-biryani-vert3.jpg"),
];

void upload() {
  var batch = Firestore.instance.batch();
  var instance = Firestore.instance;

  _menuItems.forEach((doc) {
    var docRef = instance
        .collection("menu")
        .document(); //automatically generate unique id
    batch.setData(docRef, doc.toJson());
  });

  batch.commit();
}

void main() {
  upload();
}
