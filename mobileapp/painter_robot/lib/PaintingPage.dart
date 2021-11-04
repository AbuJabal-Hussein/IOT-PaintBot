import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:painter_robot/PaintingState.dart';
import 'package:painter_robot/services/DatabaseServices.dart';


class PaintingPage extends StatefulWidget {

  @override
  _PaintingPageState createState() => _PaintingPageState();
}

class _PaintingPageState extends State<PaintingPage> {
  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(

        onPressed: (){
          DBServices().addPainting(PaintingState.paths);
          //todo: show alert to confirm uploading the painting to the cloud
        },
        child: Icon(Icons.cloud_upload),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.brown[400],
              // padding: EdgeInsets.only(left: 5, right: 5),
              child: Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => setState(() => PaintingState.paintingMode = PaintingMode.DefaultPen),
                    child: Icon(Icons.brush),

                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => setState(() => PaintingState.paintingMode = PaintingMode.StraightLine),
                    child: Transform.rotate(angle: 315 * pi / 180,
                    child: Icon(Icons.trending_neutral_outlined))
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => setState(() => PaintingState.paintingMode = PaintingMode.Eraser),
                      child: Icon(Icons.cleaning_services),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => setState(() => PaintingState.paths.clear()),
                      child: Icon(Icons.clear),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      if(PaintingState.paths.isNotEmpty) {
                        PaintingState.paths.removeLast();
                      }
                    }),
                    child: Icon(Icons.undo),
                  ),
                  Spacer(),
                  // ElevatedButton(
                  //   onPressed: () => setState(() {
                  //     DBServices().addPainting(PaintingState.paths);
                  //   }),
                  //   child: Icon(Icons.cloud_upload),
                  // ),
                  // Spacer(),
                  // Spacer(),

                ],
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: CustomGestureDetector(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomGestureDetector extends StatefulWidget{

  @override
  _CustomGestureDetectorState createState() => _CustomGestureDetectorState();
}

class _CustomGestureDetectorState extends State<CustomGestureDetector> {

  /// checks if the given points are approximately equal
  bool pointsAreEqual(Offset point1, Offset point2){
    // print("x = " + (point1.dx - point2.dx).abs().toString());
    // print("y = " + (point1.dy - point2.dy).abs().toString());
    return (point1.dx - point2.dx).abs() < 20 && (point1.dy - point2.dy).abs() < 20;
  }

  /// erases a point from all existing paths.
  /// deletes the path if it becomes empty.
  void erasePoint(Offset point){
    print("PaintingState.paths.length before = " + PaintingState.paths.length.toString());
    print("point = " + point.toString());

    for(int i = 0; i < PaintingState.paths.length; i++){
      // print("currPath = " + PaintingState.paths[i].toString());
      setState(() {
        PaintingState.paths[i].removeWhere((item) => pointsAreEqual(item, point));
      });
      // if(PaintingState.paths[i].any((item) => pointsAreEqual(item, point))) {
      //   print(i);
      //   // setState(() {
      //   //   PaintingState.paths.removeAt(i);
      //   // });
      // }

      // if(PaintingState.paths[i].isEmpty){
      //   PaintingState.paths.removeAt(i);
      // }
    }
    print("PaintingState.paths.length after = " + PaintingState.paths.length.toString());

  }

  void startPan(DragStartDetails details){
    print('start drawing');
    Offset point = details.localPosition;
    print(details.localPosition);

    switch(PaintingState.paintingMode){

      case PaintingMode.DefaultPen:
        List<Offset> newPath = [point];
        setState(() {
          // path.addPolygon([details.globalPosition], false);
          // path.lineTo(dx, dy);
          PaintingState.paths.add(newPath);
        });
        break;
      case PaintingMode.StraightLine:
        List<Offset> newPath = [point, point];
        setState(() {
          PaintingState.paths.add(newPath);
        });
        break;
      case PaintingMode.Circle:
      // TODO: Handle this case.
        break;
      case PaintingMode.Eraser:
        erasePoint(point);
        break;
      case PaintingMode.ZoomIn:
      // TODO: Handle this case.
        break;
      case PaintingMode.ZoomOut:
      // TODO: Handle this case.
        break;
    }

  }

  void updatePan(DragUpdateDetails details){
    // print(details.localPosition);

    Offset point = details.localPosition;
    switch(PaintingState.paintingMode){

      case PaintingMode.DefaultPen:
        setState(() {
          // path.addPolygon([details.globalPosition], false);
          // path.lineTo(dx, dy);
          PaintingState.paths.last.add(point);
        });
        break;
      case PaintingMode.StraightLine:
        setState(() {
          // path.addPolygon([details.globalPosition], false);
          // path.lineTo(dx, dy);
          PaintingState.paths.last.removeLast();
          PaintingState.paths.last.add(point);
        });
        break;
      case PaintingMode.Circle:
      // TODO: Handle this case.
        break;
      case PaintingMode.Eraser:
        erasePoint(point);
        break;
      case PaintingMode.ZoomIn:
      // TODO: Handle this case.
        break;
      case PaintingMode.ZoomOut:
      // TODO: Handle this case.
        break;
    }

  }

  void endPan(DragEndDetails details){
    print('end drawing');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: startPan,
      onPanUpdate: updatePan,
      onPanEnd: endPan,
      child: CustomPaint(
        painter: MyPainter(PaintingState.paths),
      ),
    );
  }
}

class MyPainter extends CustomPainter{
  final List<List<Offset>> paths;

  MyPainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    final paintL = Paint()
      ..color = PaintingState.paintColor
      ..strokeWidth = 7;
    final paintP = Paint()
      ..color = PaintingState.paintColor
      ..strokeWidth = 5.77;
    for(List<Offset> currPath in paths) {
      for (int i = 0; i < currPath.length - 1; i++) {
        canvas.drawLine(currPath[i], currPath[i + 1], paintL);
      }
      canvas.drawPoints(PointMode.points, currPath, paintP);
      // canvas.clipPath(path))
    }


    // canvas.drawLine(Offset(10,10), Offset(200,200), paint);
    // canvas.drawCircle(Offset(200, 200), 100, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }


}
