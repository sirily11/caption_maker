import 'package:captions_maker/model/videoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoProvider provider = Provider.of(context);
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: () async {
            if (provider.controller == null) {
              return;
            }
            if (provider.isPlaying) {
              await provider.pause();
            } else {
              await provider.play();
            }
          },
          icon: Icon(provider.isPlaying ? Icons.pause : Icons.play_arrow),
        ),
      ],
    );
  }
}
