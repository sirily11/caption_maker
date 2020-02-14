import 'dart:convert';

import 'package:captions_maker/model/base_captions.dart';

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
}
