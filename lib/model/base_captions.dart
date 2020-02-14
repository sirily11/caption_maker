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

abstract class BaseCaptionMaker {
  List<BaseCaption> captions = [];
  BaseCaption currentCaption;

  /// Add [caption] to [captions]
  Future<void> addCaption(BaseCaption caption);

  /// Delete [caption] from [captions]
  Future<void> deleteCaption(BaseCaption caption);

  /// Set [caption]'s start time, endtime and content
  Future<void> setCaption({
    BaseCaption caption,
    Duration starttime,
    Duration endtime,
    String content
  });

  /// Get [caption] based on [current]
  BaseCaption getCurrentCaption(Duration current);

  /// Convert [captions] into file format
  Future<void> convertToFile(BaseCaptionOutput converter);

  /// Save current [captions] into file
  Future<void> save();

  /// Load [file] into captions
  Future<void> load();
}

abstract class BaseCaptionOutput {
  Future output(File outputFile);
}
