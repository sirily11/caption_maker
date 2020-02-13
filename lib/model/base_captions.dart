import 'dart:io';

import 'package:flutter/material.dart';

class BaseCaption {
  int id;
  String content;
  Duration starttime;
  Duration endtime;

  BaseCaption(
      {@required this.id,
      @required this.content,
      @required this.starttime,
      @required this.endtime});

  factory BaseCaption.fromJson(Map<String, dynamic> json) {
    return BaseCaption(
        id: json['id'],
        content: json['content'],
        starttime: json['starttime'],
        endtime: json['endtime']);
  }

  Map<String, dynamic> toJson() => {
        "content": content,
        'starttime': starttime,
        'endtime': endtime,
        "id": id
      };
}

abstract class CaptionMaker {
  List<BaseCaption> captions = [];

  Future<void> addCaption(BaseCaption caption);
  Future<void> deleteCaption(BaseCaption caption);
  Future<void> setCaptionTime(
    BaseCaption caption,
    Duration starttime,
    Duration endtime,
  );

  Future<String> convertToFile(BaseCaptionOutput converter);
}

abstract class BaseCaptionOutput {
  Future output(File outputFile);
}
