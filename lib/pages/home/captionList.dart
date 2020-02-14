import 'package:captions_maker/model/base_captions.dart';
import 'package:captions_maker/model/videoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:captions_maker/extensions/string_extensions.dart';

class CaptionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoProvider videoProvider = Provider.of(context);
    List<TimelineModel> items = videoProvider.captions
        .map(
          (e) => TimelineModel(
            CaptionRow(
              caption: e,
            ),
            position: TimelineItemPosition.left,
            leading: Text("${e.id}"),
          ),
        )
        .toList();
    return Timeline(
        children: items,
        position: TimelinePosition.Left,
        lineColor: Colors.white);
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

  @override
  void initState() {
    super.initState();
    starttime =
        TextEditingController(text: widget.caption.starttime.toString());
    endtime = TextEditingController(text: widget.caption.endtime.toString());
    content = TextEditingController(
      text: widget.caption.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    VideoProvider provider = Provider.of(context);
    return Card(
      color: provider.currentCaption == widget.caption
          ? Theme.of(context).highlightColor.withAlpha(200)
          : null,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        onChanged: (v) async {
                          await provider.setCaption(
                            caption: widget.caption,
                            starttime: v.duration,
                          );
                        },
                        controller: starttime,
                        decoration: InputDecoration(labelText: "Start Time"),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        onChanged: (v) async {
                          await provider.setCaption(
                            caption: widget.caption,
                            endtime: v.duration,
                          );
                        },
                        controller: endtime,
                        decoration: InputDecoration(labelText: "End Time"),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
