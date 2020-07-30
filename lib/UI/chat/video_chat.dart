import 'package:fleo/services/agora_engine.dart';
import 'package:flutter/material.dart';

class VideoCallWidget extends StatefulWidget {
  final String channelName;

  const VideoCallWidget({Key key, @required this.channelName})
      : super(key: key);

  @override
  _VideoCallWidgetState createState() => _VideoCallWidgetState();
}

class _VideoCallWidgetState extends State<VideoCallWidget> {
  AgoraEngineService _agoraEngineService = new AgoraEngineService();
  bool muted = false;
  final _infoStrings = <String>[];

  @override
  void initState() {
    super.initState();
    _agoraEngineService.initialize(widget.channelName);
    _agoraEngineService.streamController.stream.listen((event) {
      setState(() {
        _infoStrings.add(event);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _agoraEngineService.endCall();
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _expandedVideoRow(List<Widget> views) {
    List<Widget> wrappedViews =
        views.map((Widget view) => _videoView(view)).toList();
    return Expanded(
        child: Row(
      children: wrappedViews,
    ));
  }

  Widget _viewRows() {
    List<Widget> views = _agoraEngineService.getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  Widget _toolbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(90, 100),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: Text(
                  "Channel Name: ${widget.channelName}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      _agoraEngineService.onToggleMute(muted);
                      setState(() {
                        muted = !muted;
                      });
                    },
                    child: new Icon(
                      muted ? Icons.mic : Icons.mic_off,
                      color: muted
                          ? Theme.of(context).accentColor
                          : Colors.blueAccent,
                      size: 20.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: muted
                        ? Colors.blueAccent
                        : Theme.of(context).accentColor,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  RawMaterialButton(
                    onPressed: () => _onCallEnd(context),
                    child: new Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  RawMaterialButton(
                    onPressed: () => _agoraEngineService.onSwitchCamera(),
                    child: new Icon(
                      Icons.switch_camera,
                      color: Colors.blueAccent,
                      size: 20.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Theme.of(context).accentColor,
                    padding: const EdgeInsets.all(12.0),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panel() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.topRight,
        child: FractionallySizedBox(
          heightFactor: 0.1,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: ListView.builder(
                  reverse: true,
                  itemCount: _infoStrings.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_infoStrings.length == 0) {
                      return null;
                    }
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(_infoStrings[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1)))
                        ]));
                  })),
        ));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Stack(
          children: <Widget>[
            _viewRows(),
            _panel(),
            _toolbar(),
          ],
        )));
  }
}
