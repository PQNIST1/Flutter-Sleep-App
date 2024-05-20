import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep/src/app.dart';
import 'package:sleep/src/view_models/detail_view_model.dart';

import 'src/utils/http_overrides.dart';

void main() async {
  /// Fix Error Http Request CERTIFICATE_VERIFY_FAILED
  /// This userful for error image network request
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ChangeNotifierProvider(
      create: (context) => DetailViewModel(),
      child: MyApp(),
    ),
  );
}
