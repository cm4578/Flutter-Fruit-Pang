import 'enums.dart';

class Fruit {
  String id;
  int x;
  int y;
  FruitType fruitType;
  bool isSelect = false;
  bool isDismiss = false;

  Fruit(this.id, this.x, this.y, this.fruitType);
}

