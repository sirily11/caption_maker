import 'package:captions_maker/model/base_captions.dart';
import 'package:captions_maker/extensions/duration_extensions.dart';

class IttOutput extends BaseCaptionOutput {
  String extensionName = "itt";

  @override
  String convert(List<BaseCaption> captions) {
    String output = "";

    for (var caption in captions) {
      var c = caption.content.replaceAll("\n", "<br/>");
      output +=
          ' <p begin="${caption.starttime.ittString}" end="${caption.endtime.ittString}" region="bottom">$c</p>\n';
    }

    return '''<?xml version="1.0"?>
<tt xmlns:vt="http://namespace.itunes.apple.com/itt/ttml-extension#vertical" xmlns:ttp="http://www.w3.org/ns/ttml#parameter" xmlns:ittp="http://www.w3.org/ns/ttml/profile/imsc1#parameter" xmlns:tt_feature="http://www.w3.org/ns/ttml/feature/" xmlns:ebutts="urn:ebu:tt:style" xmlns:tts="http://www.w3.org/ns/ttml#styling" xmlns:tt_extension="http://www.w3.org/ns/ttml/extension/" xmlns:tt_profile="http://www.w3.org/ns/ttml/profile/" xmlns:ttm="http://www.w3.org/ns/ttml#metadata" xmlns:ry="http://namespace.itunes.apple.com/itt/ttml-extension#ruby" xmlns:itts="http://www.w3.org/ns/ttml/profile/imsc1#styling" xmlns="http://www.w3.org/ns/ttml" xml:lang="cmn-Hans" ttp:dropMode="nonDrop" ttp:frameRate="30" ttp:frameRateMultiplier="1 1" ttp:timeBase="smpte" xmlns:tt="http://www.w3.org/ns/ttml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <head>
    <styling>
      <style xml:id="normal" tts:color="white" tts:fontFamily="sansSerif" tts:fontSize="100%" tts:fontStyle="normal" tts:fontWeight="normal"/>
    </styling>
    <layout>
      <region xml:id="top" tts:displayAlign="before" tts:extent="100% 15%" tts:origin="0% 0%" tts:textAlign="center" tts:writingMode="lrtb"/>
      <region xml:id="bottom" tts:displayAlign="after" tts:extent="100% 15%" tts:origin="0% 85%" tts:textAlign="center" tts:writingMode="lrtb"/>
    </layout>
  </head>
  <body tts:color="white" region="bottom" style="normal">
    <div>
      $output
    </div>
  </body>
</tt>''';
  }
}
