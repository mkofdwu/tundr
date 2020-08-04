import 'dart:async';
import 'dart:convert';
import "dart:html";
import "dart:ui" as ui;

import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:tundr/models/media.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/enums/mediatype.dart';

class TakePicturePage extends StatefulWidget {
  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  static int _numPicturesTaken;

  final VideoElement _videoElement = VideoElement();
  Widget _widget;

  @override
  void initState() {
    super.initState();
    ui.platformViewRegistry
        .registerViewFactory("videoElement", (int viewId) => _videoElement);
    _widget = HtmlElementView(viewType: "videoElement");
    window.navigator.getUserMedia(video: true).then(
      (MediaStream stream) {
        print("retrieved stream");
        setState(() {
          _videoElement.srcObject = stream;
        });
        _videoElement.play();
      },
      onError: (Object err, [StackTrace stackTrace]) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Camera not found"),
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
    return Material(
      child: Column(
        // FIXME: FUTURE: DESIGN: improve ui
        children: <Widget>[
          Expanded(child: _widget),
          SizedBox(
            height: 100.0,
            child: Material(
              color: AppColors.darkGrey,
              child: InkWell(
                child: Center(
                  child: Icon(
                    Icons.photo_camera,
                    size: 50.0,
                  ),
                ),
                splashColor: AppColors.gold,
                highlightColor: AppColors.gold.withOpacity(0.6),
                onTap: () async {
                  if (_videoElement.srcObject != null &&
                      _videoElement.srcObject.active) {
                    final Blob blob = await ImageCapture(
                            _videoElement.srcObject.getVideoTracks()[0])
                        .takePhoto();

                    final Completer<Media> completer = Completer();
                    final FileReader reader = FileReader();
                    reader.readAsDataUrl(blob);
                    reader.onLoad.listen((_) {
                      completer.complete(Media.bytes(
                        type: MediaType.image,
                        name: "webcamimg$_numPicturesTaken",
                        bytes: base64Decode((reader.result as String)
                            .replaceFirst(
                                RegExp(r"data:image/[^;]+;base64,"), "")),
                      ));
                    });
                    reader.onError
                        .listen((error) => completer.completeError(error));

                    completer.future
                        .then((media) => Navigator.pop(context, media));
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
