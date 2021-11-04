
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';


class DBServices{
  final databaseRef = FirebaseDatabase.instance.reference();

  void addPainting(List<List<Offset>> painting) {

    for(int i = 0; i < painting.length; i++) {
      String pathName = "path" + i.toString();
      String currPath = painting[i].map((point) => point.dx.toInt().toString() + " " + point.dy.toInt().toString()).reduce((value, element) => value + " " + element);
      print(currPath);

      databaseRef.child(pathName).set({
        "len": painting[i].length * 2,
        "points": currPath,
      });
    }
    databaseRef.child("num").set(painting.length);
  }

  int getPaintingsNum(){
    DBServices().databaseRef.child("/paintings_num").once().then((DataSnapshot data){
      print(data.value);
      print(data.key);
      return data.value;
    });
    return 0;
  }

}
