import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> textAsBitmap(String text) async {
  var span = TextSpan(
    text: text,
    style: TextStyle(
      fontSize: 45.0,
      color: Colors.white,
      letterSpacing: 1.0,
    ),
  );

  var tp = new TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  var recorder = ui.PictureRecorder();
  var canvas = Canvas(recorder);

  tp.layout();

  var textRect =
      RRect.fromLTRBR(0, 0, tp.width + 40, tp.height + 40, Radius.circular(50));
  var rectPaint = Paint();
  rectPaint.color = Colors.blue;
  canvas.drawRRect(textRect, rectPaint);

  tp.paint(canvas, new Offset(20, 20));

  var picture = recorder.endRecording();
  var image =
      await picture.toImage(textRect.width.toInt(), textRect.height.toInt());
  var pngBytes = await (image).toByteData(format: ui.ImageByteFormat.png);

  var buffer = pngBytes?.buffer;
  var data = buffer != null ? Uint8List.view(buffer) : Uint8List(0);

  return BitmapDescriptor.fromBytes(data);
}
