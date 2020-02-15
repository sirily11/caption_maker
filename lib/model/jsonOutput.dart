import 'dart:convert';
import 'dart:io';

import 'package:captions_maker/model/base_captions.dart';
import 'package:file_chooser/file_chooser.dart';

class JSONOutput extends BaseCaptionOutput {
  String extensionName = "json";

  @override
  String convert(List<BaseCaption> captions) {
    var output = [];
    for (var cap in captions) {
      output.add(cap.toJson());
    }

    return JsonEncoder().convert(output);
  }

  // @override
  // Future output(List<BaseCaption> captions) async {
  //   var result =
  //       await showSavePanel(suggestedFileName: "My Caption.$extensionName");
  //   if (!result.canceled) {
  //     var path = result.paths.first;
  //     var file = File(path);
  //     var content = convert(captions);
  //     await file.writeAsString(content);
  //     while (true) {
  //       await Future.delayed(Duration(minutes: 1));
  //       await file.w
  //     }
  //   }
  // }
}
