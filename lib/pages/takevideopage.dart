import "dart:html";
import "dart:ui" as ui;

import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:tundr/models/media.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/enums/mediatype.dart';

class TakeVideoPage extends StatefulWidget {
  @override
  _TakeVideoPageState createState() => _TakeVideoPageState();
}

class _TakeVideoPageState extends State<TakeVideoPage> {
  final VideoElement _videoElement = VideoElement();
  final Widget _videoWidget = HtmlElementView(viewType: "videoElement");
  MediaRecorder _recorder;
  final List<Blob> _chunks = [];
  bool _recording = false;

  @override
  void initState() {
    super.initState();
    ui.platformViewRegistry
        .registerViewFactory("videoElement", (int viewId) => _videoElement);
    window.navigator.getUserMedia(audio: true, video: true).then(
      (MediaStream stream) {
        _videoElement.srcObject = stream;
        _recorder = MediaRecorder(stream, {
          "type": "video/mp4"
        }); // TODO: test if a different type will allow it to be played
        _recorder.addEventListener("ondataavailable", (Event event) {
          final BlobEvent blobEvent = event;
          print((event as BlobEvent)
              .data); // normally dart refuses to allow this to run, but after printing out event to console I realised that the event being returned here was of BlobEvent type (it printed out '[object BlobEvent]') and after a minute I realised that casting it to BlobEvent worked (allowing me to also access the .data field)

          if (blobEvent.data.size > 0) {
            _chunks.add(blobEvent.data);
          }
        });
        setState(() {});
      },
      onError: (Object err, [StackTrace stackTrace]) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Camera or Microphone not found"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ).then((_) => Navigator.pop(context));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_videoElement.srcObject != null) _videoElement.play();
    return Material(
      child: Column(
        children: <Widget>[
          Expanded(child: _videoWidget),
          SizedBox(
            height: 100.0,
            child: Material(
              color: AppColors.grey,
              child: InkWell(
                child: Center(
                  child: Icon(
                    _recording ? Icons.stop : Icons.fiber_manual_record,
                    size: 50.0,
                  ),
                ),
                splashColor: AppColors.gold,
                highlightColor: AppColors.gold.withOpacity(0.6),
                onTap: () {
                  if (_recording) {
                    _recorder.stop();
                    // TODO: or return blob bytes directly (convert to Uint8List with FileReader)
                    final String url =
                        Url.createObjectUrlFromBlob(Blob(_chunks));
                    print("created video blob url: $url");
                    Navigator.pop(
                      context,
                      Media(
                        type: MediaType.video,
                        url: url,
                        isLocalFile: false,
                      ),
                    );
                  } else {
                    _recorder.start();
                    _recorder
                        .requestData(); // it was actually because I did not call this that it did not work, but by some miracle I saw this method in vscode's autocomplete and decided to try it, so it was purely due to luck that it worked. maybe in some alternate universe i would still be trying to fix this (maybe still trying to get flutter_webview_plugin to work) and would be working on this for many more days. But thank goodness that is not the case. Now I understand that everything that can be done in javascript in web can be done directly using dart:html, this would also make design sense as you shouldn't need a third party library to do something as basic as this.
                    setState(() => _recording = true);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
