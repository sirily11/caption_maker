import 'package:captions_maker/model/videoProvider.dart';
import 'package:captions_maker/pages/home/captionList.dart';
import 'package:captions_maker/pages/home/captionPreview.dart';
import 'package:captions_maker/pages/home/controlPanel.dart';
import 'package:captions_maker/pages/home/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoProvider provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (provider.state == VideoState.edit) {
                provider.state = VideoState.preview;
              } else {
                provider.state = VideoState.edit;
              }
            },
            icon: Icon(
              provider.state == VideoState.preview ? Icons.edit : Icons.done,
            ),
          ),
          IconButton(
            tooltip: "Edit Mode",
            onPressed: () async {
              await provider.openFile();
            },
            icon: Icon(Icons.folder),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: CaptionList(),
          ),
          Expanded(
            flex: 6,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: VideoPlayer(),
                ),
                Expanded(
                  flex: 1,
                  child: ControlPanel(),
                ),
                Divider(),
                Expanded(
                  flex: 2,
                  child: CaptionPreview(),
                ),
                Divider(),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (provider.state == VideoState.edit) {
            await provider.setTime();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
