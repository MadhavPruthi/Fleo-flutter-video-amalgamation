import 'package:fleo/UI/chat/video_chat.dart';
import 'package:fleo/UI/global/theme/app_themes.dart';
import 'package:fleo/UI/global/theme/bloc/theme_bloc.dart';
import 'package:fleo/UI/utils/media_queries.dart';
import 'file:///D:/Projects/fleo/lib/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  final String title;
  final String subtitle;

  const HomePage({
    Key key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textEditingController = new TextEditingController();
  MediaQueryData queryData;
  Permissions permissions = new Permissions();

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              icon: Icon(_chooseIconAccordingToMode()),
              onPressed: _toggleMode,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  top: 10,
                ),
                child: ListTile(
                  title: Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    widget.subtitle,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )),
            Expanded(
                child: Stack(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                    )),
                margin: EdgeInsets.only(top: 50),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _textField(),
                    SizedBox(
                      height: 10,
                    ),
                    _submitButton()
                  ],
                ),
              ),
            ]))
          ]),
    );
  }

  IconData _chooseIconAccordingToMode() {
    final currentTheme = _getCurrentTheme();
    if (currentTheme == appThemeData[AppTheme.Light]) return Icons.brightness_3;

    return Icons.brightness_5;
  }

  ThemeData _getCurrentTheme() {
    return BlocProvider.of<ThemeBloc>(context).state.themeData;
  }

  void _toggleMode() {
    final currentTheme = _getCurrentTheme();
    if (currentTheme == appThemeData[AppTheme.Light])
      BlocProvider.of<ThemeBloc>(context)
          .add(ThemeChanged(theme: AppTheme.Dark));
    else
      BlocProvider.of<ThemeBloc>(context)
          .add(ThemeChanged(theme: AppTheme.Light));
  }

  Widget _textField() {
    const double radius = 16.0;
    return TextField(
      controller: _textEditingController,
      cursorColor: Theme.of(context).primaryColor,
      cursorWidth: 4.0,
      decoration: InputDecoration(
        hintText: "Enter the room code to join or create",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius)),
          borderSide: BorderSide(
            width: 2.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius)),
          borderSide: BorderSide(
            width: 2.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return RaisedButton(
      onPressed: _onPressSubmit,
      child: Text(
        "Let's Jump in",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      color: Theme.of(context).primaryColor,
    );
  }

  _onPressSubmit() {
    if (permissions.getActiveStatus()) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return VideoCallWidget(
          channelName: _textEditingController.text,
        );
      }));
    } else {
      permissions.requestPermission().then((value) {
        if (permissions.getActiveStatus())
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return VideoCallWidget(
              channelName: _textEditingController.text,
            );
          }));
        else
          Toast.show("Kindly give the permissions!", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      });
    }
  }
}
