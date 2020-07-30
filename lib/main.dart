
import 'package:fleo/UI/global/theme/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'UI/Home/home_page.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithThemeEntryPoint,
      ),
    );
  }

  Widget _buildWithThemeEntryPoint(BuildContext context, ThemeState state) {
    const TITLE_APP = 'Fleo';
    const SUBTITLE_APP = "Flutter Video Call Amalgamation";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fleo - Flutter Video Call Amalgamation',
      theme: state.themeData,
      home: HomePage(title: TITLE_APP, subtitle: SUBTITLE_APP),
    );
  }
}
