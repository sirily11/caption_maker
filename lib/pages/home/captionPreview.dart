import 'package:captions_maker/model/videoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:captions_maker/extensions/duration_extensions.dart';

class CaptionPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoProvider provider = Provider.of(context);

    return Row(
      children: <Widget>[
        Container(
          width: 120,
          child: Text(
            "${provider.currentPosition.shortString}   :  ${provider.controller?.value?.duration?.shortString ?? Duration(milliseconds: 0)}",
          ),
        ),
        VerticalDivider(),
        Text(
          "abcde",
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
