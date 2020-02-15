import 'package:captions_maker/model/ittOutput.dart';
import 'package:captions_maker/model/srtOutput.dart';
import 'package:captions_maker/model/videoProvider.dart';
import 'package:captions_maker/pages/home/captionList.dart';
import 'package:captions_maker/pages/home/captionPreview.dart';
import 'package:captions_maker/pages/home/controlPanel.dart';
import 'package:captions_maker/pages/home/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:menubar/menubar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    VideoProvider provider = Provider.of(context, listen: false);
    setApplicationMenu([
      Submenu(label: "File", children: [
        MenuItem(
            label: "Open Saved File",
            onClicked: () async {
              provider.loadSaved();
            }),
        MenuItem(
            label: "Open Text File",
            onClicked: () async {
              provider.load();
            }),
        MenuItem(
            label: "Open Video File",
            onClicked: () async {
              await provider.openFile();
            }),
        Submenu(label: "Save As", children: [
          MenuItem(
              label: "SRT File",
              onClicked: () async {
                await provider.convertToFile(SRTOutput());
              }),
          MenuItem(
              label: "iTT file",
              onClicked: () async {
                await provider.convertToFile(IttOutput());
              })
        ]),
        MenuItem(
            label: "Save",
            onClicked: () async {
              await provider.save();
            })
      ]),
      Submenu(label: "Caption", children: [
        MenuItem(
            label: "Add caption time",
            shortcut: LogicalKeySet(LogicalKeyboardKey.f1),
            onClicked: () async {
              await provider.setTime();
            }),
        MenuItem(
            label: "Settings",
            onClicked: () async {
              await provider.showSettings(context);
            })
      ])
    ]);
    super.initState();
  }

  @override
  void dispose() {
    VideoProvider provider = Provider.of(context, listen: false);
    provider.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VideoProvider provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            tooltip: "Edit Mode",
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
