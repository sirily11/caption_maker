import 'package:captions_maker/model/base_captions.dart';
import 'package:captions_maker/model/videoProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:provider/provider.dart';
import 'package:captions_maker/extensions/string_extensions.dart';

const double CAPTION_ROW_HEIGHT = 230;
const double CAPTION_ROW_PANDDING = 10;

class CaptionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoProvider videoProvider = Provider.of(context);
    // List<TimelineModel> items = videoProvider.captions
    //     .map(
    //       (e) => TimelineModel(
    //         CaptionRow(
    //           caption: e,
    //         ),
    //         position: TimelineItemPosition.left,
    //         leading: Text("${e.id}"),
    //       ),
    //     )
    //     .toList();
    // items.add(
    //   TimelineModel(
    //     Center(
    //       child: IconButton(
    //         onPressed: () async {
    //           videoProvider.addCaption(
    //             BaseCaption(
    //               id: videoProvider.captions.length,
    //               content: "Empty Content",
    //               starttime: videoProvider.currentPosition,
    //               endtime: Duration(
    //                   seconds: videoProvider.currentPosition.inSeconds + 10),
    //             ),
    //           );
    //         },
    //         iconSize: 40,
    //         icon: Icon(Icons.add_box),
    //       ),
    //     ),
    //     iconBackground: Colors.blue,
    //     icon: Icon(Icons.timelapse),
    //   ),
    // );
    // return Timeline(
    //   children: items,
    //   position: TimelinePosition.Left,
    //   lineColor: Colors.white,
    //   controller: videoProvider.scrollController,
    // );
    return ScrollablePositionedList.builder(
      itemScrollController: videoProvider.scrollController,
      itemCount: videoProvider.captions.length + 1,
      itemBuilder: (c, index) {
        if (index == videoProvider.captions.length) {
          return Center(
            child: IconButton(
              onPressed: () async {
                videoProvider.addCaption(
                  BaseCaption(
                    id: videoProvider.captions.length > 0
                        ? videoProvider.captions.last.id + 1
                        : 1,
                    content: "Empty Content",
                    starttime: videoProvider.currentPosition,
                    endtime: Duration(
                        seconds: videoProvider.currentPosition.inSeconds + 10),
                  ),
                );
              },
              iconSize: 40,
              icon: Icon(Icons.add_box),
            ),
          );
        }
        return ListTile(
          onTap: () {
            videoProvider.setCurrentCaption(videoProvider.captions[index]);
          },
          leading: Text("${index + 1}"),
          title: CaptionRow(
            caption: videoProvider.captions[index],
          ),
        );
      },
    );
  }
}

class CaptionRow extends StatefulWidget {
  final BaseCaption caption;

  CaptionRow({this.caption});

  @override
  _CaptionRowState createState() => _CaptionRowState();
}

class _CaptionRowState extends State<CaptionRow> {
  TextEditingController starttime;
  TextEditingController endtime;
  TextEditingController content;
  FocusNode startFocus;
  FocusNode endFocus;

  @override
  void initState() {
    super.initState();
    starttime =
        TextEditingController(text: widget.caption.starttime.toString());
    endtime = TextEditingController(text: widget.caption.endtime.toString());
    content = TextEditingController(
      text: widget.caption.content,
    );
    startFocus = FocusNode();
    endFocus = FocusNode();
  }

  @override
  void didUpdateWidget(CaptionRow oldWidget) {
    var oldStart = starttime.text;
    var newStart = widget.caption.starttime.toString();
    var oldEnd = endtime.text;
    var newEnd = widget.caption.endtime.toString();
    // VideoProvider provider = Provider.of(context);

    // if (provider.currentCaption == widget.caption &&
    //     provider.state == VideoState.edit &&
    //     provider.isPlaying) {
    //   if (provider.isSettingStartTime) {
    //     startFocus.requestFocus();
    //   } else {
    //     endFocus.requestFocus();
    //   }
    // }

    // if (provider.currentCaption == null && provider.isPlaying) {
    //   FocusScope.of(context).requestFocus(FocusNode());
    // }

    if (oldEnd != newEnd) {
      endtime = TextEditingController(text: newEnd);
    }
    if (newStart != oldStart) {
      starttime = TextEditingController(text: newStart);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    starttime.dispose();
    endtime.dispose();
    content.dispose();
    super.dispose();
  }

  bool get isStart {
    VideoProvider provider = Provider.of(context);
    return provider.state == VideoState.edit &&
        provider.currentCaption == widget.caption &&
        provider.isSettingStartTime == true;
  }

  bool get isEnd {
    VideoProvider provider = Provider.of(context);
    return provider.state == VideoState.edit &&
        provider.currentCaption == widget.caption &&
        provider.isSettingStartTime == false;
  }

  bool get shouldAutoVaildate {
    VideoProvider provider = Provider.of(context);
    if (provider.state == VideoState.edit) {
      if (provider.currentCaption == widget.caption) {
        return true;
      }
    } else {
      return true;
    }

    return false;
  }

  Widget _addjustTime(TextEditingController controller, Function onSet) {
    return Container(
      height: 50,
      child: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          InkWell(
            onTap: () async {
              var duration = Duration(
                  milliseconds: controller.text.duration.inMilliseconds + 1000);
              controller.text = duration.toString();
              await onSet();
            },
            child: Icon(Icons.arrow_drop_up),
          ),
          InkWell(
            onTap: () async {
              var duration = Duration(
                  milliseconds: controller.text.duration.inMilliseconds - 1000);
              controller.text = duration.toString();
              await onSet();
            },
            child: Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    VideoProvider provider = Provider.of(context);
    return Card(
      color: provider.currentCaption == widget.caption
          ? Theme.of(context).highlightColor.withAlpha(200)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(CAPTION_ROW_PANDDING),
        child: SizedBox(
          height: CAPTION_ROW_HEIGHT,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: isStart ? Colors.yellow.withAlpha(100) : null,
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        autovalidate: shouldAutoVaildate,
                        validator: (v) {
                          if (starttime.text.duration == null ||
                              endtime.text.duration == null) {
                            return "Invalid starttime";
                          }
                          if (starttime.text.duration.inMilliseconds >=
                              endtime.text.duration.inMilliseconds) {
                            return "Invalid starttime";
                          }
                          return null;
                        },
                        onEditingComplete: () async {
                          await provider.setCaption(
                            caption: widget.caption,
                            starttime: starttime.text.duration,
                          );
                        },
                        controller: starttime,
                        decoration: InputDecoration(
                          labelText: "Start Time",
                          suffix: _addjustTime(starttime, () async {
                            await provider.setCaption(
                              caption: widget.caption,
                              starttime: starttime.text.duration,
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: isEnd ? Colors.yellow.withAlpha(100) : null,
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        focusNode: endFocus,
                        autovalidate: shouldAutoVaildate,
                        validator: (v) {
                          if (starttime.text.duration == null ||
                              endtime.text.duration == null) {
                            return "Invalid Endtime";
                          }
                          if (starttime.text.duration.inMilliseconds >=
                              endtime.text.duration.inMilliseconds) {
                            return "Invalid Endtime";
                          }
                          return null;
                        },
                        onEditingComplete: () async {
                          await provider.setCaption(
                            caption: widget.caption,
                            endtime: endtime.text.duration,
                          );
                        },
                        controller: endtime,
                        decoration: InputDecoration(
                          suffix: _addjustTime(endtime, () async {
                            await provider.setCaption(
                              caption: widget.caption,
                              endtime: endtime.text.duration,
                            );
                          }),
                          labelText: "End Time",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                onChanged: (v) async {
                  await provider.setCaption(
                    caption: widget.caption,
                    content: v,
                  );
                },
                controller: content,
                decoration: InputDecoration(labelText: "Caption"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    tooltip: "Delete caption",
                    onPressed: () async {
                      await provider.deleteCaption(widget.caption, context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    tooltip: "Jump to this line",
                    onPressed: () async {
                      await provider.seek(starttime.text.duration);
                    },
                    icon: Icon(Icons.touch_app),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
