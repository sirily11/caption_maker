import 'dart:io';

import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:captions_maker/extensions/string_extensions.dart';

class BaseCaption {
  int id;
  String content;
  Duration starttime;
  Duration endtime;

  BaseCaption({
    @required this.id,
    @required this.content,
    @required this.starttime,
    @required this.endtime,
  });

  factory BaseCaption.fromJson(Map<String, dynamic> json) {
    return BaseCaption(
      id: json['id'],
      content: json['content'],
      starttime: (json['starttime'] as String).duration,
      endtime: (json['endtime'] as String).duration,
    );
  }

  Map<String, dynamic> toJson() => {
        "content": content,
        'starttime': starttime.toString(),
        'endtime': endtime.toString(),
        "id": id
      };
}

abstract class BaseCaptionMaker {
  List<BaseCaption> captions = [];
  BaseCaption currentCaption;

  /// Add [caption] to [captions]
  Future<void> addCaption(BaseCaption caption);

  /// Delete [caption] from [captions]
  Future<void> deleteCaption(BaseCaption caption, BuildContext context);

  /// Set [caption]'s start time, endtime and content
  Future<void> setCaption(
      {BaseCaption caption,
      Duration starttime,
      Duration endtime,
      String content});

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
  String extensionName;

  String convert(List<BaseCaption> captions);
  Future output(List<BaseCaption> captions) async {
    var result =
        await showSavePanel(suggestedFileName: "My Caption.$extensionName");
    if (!result.canceled) {
      var path = result.paths.first;
      var file = File(path);
      var content = convert(captions);
      await file.writeAsString(content);
    }
  }
}
