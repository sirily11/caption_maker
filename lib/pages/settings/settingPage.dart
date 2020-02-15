import 'package:captions_maker/model/videoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoProvider provider = Provider.of(context);
    return AlertDialog(
      title: Text("Settings"),
      content: Container(
        width: 300,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: <Widget>[
            SwitchListTile(
                title: Text("Use Start time replace end time"),
                value: provider.useStarttimeReplaceEndtime,
                onChanged: (v) {
                  provider.useStarttimeReplaceEndtime = v;
                }),
            TextFormField(
              initialValue: provider.timeSpace.toString(),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                provider.timeSpace = int.parse(v);
              },
              decoration: InputDecoration(labelText: "Time Period"),
            )
          ],
        ),
      ),
    );
  }
}
