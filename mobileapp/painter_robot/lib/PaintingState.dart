import 'dart:ui';

import 'package:flutter/material.dart';


enum PaintingMode{
  DefaultPen, StraightLine, Circle, Eraser, ZoomIn, ZoomOut
}


abstract class PaintingState{
  static List<List<Offset>> paths = [];
  static PaintingMode paintingMode = PaintingMode.DefaultPen;
  static Color paintColor = Colors.blue;
}