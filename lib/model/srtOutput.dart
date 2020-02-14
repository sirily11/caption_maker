import 'dart:io';

import 'package:captions_maker/model/base_captions.dart';
import 'package:captions_maker/extensions/duration_extensions.dart';

class SRTOutput extends BaseCaptionOutput {
  @override
  String extensionName = "srt";

  @override
  String convert(List<BaseCaption> captions) {
    String output = "";
    for (var caption in captions) {
      String startS = caption.starttime.srtString;
      String endS = caption.endtime.srtString;

      output += "${caption.id}\n$startS --> $endS\n${caption.content}\n\n";
    }
    return output;
  }
}
