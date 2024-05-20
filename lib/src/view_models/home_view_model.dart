/// Load Dummy Media Data

import 'dart:convert';

import 'package:sleep/src/models/sleep_media_model.dart';
import 'package:sleep/src/utils/prefs_data.dart';

import '../models/sleep_media_source.dart';

Future<List<SleepMediaItem>> getMediaDatas({int? categoryId}) {
  return Future.delayed(const Duration(seconds: 1), () {
    List<SleepMediaItem> filteredMedia = [];
    if (categoryId != null) {
      if (categoryId == 1) {
        filteredMedia = sleepMediaDataSource
            .where((item) => item.category!.id == 1)
            .toList();
        return filteredMedia;
      } else if (categoryId == 2) {
        filteredMedia = sleepMediaDataSource
            .where((item) => item.category!.id == 2)
            .toList();
        return filteredMedia;
      } else if (categoryId == 3) {
        filteredMedia = sleepMediaDataSource
            .where((item) => item.category!.id == 3)
            .toList();
        return filteredMedia;
      } else if (categoryId == 5) {
        filteredMedia = sleepMediaDataSource
            .where((item) => item.category!.id == 5)
            .toList();
        return filteredMedia;
      } else if (categoryId == 6) {
        filteredMedia = sleepMediaDataSource
            .where((item) => item.category!.id == 6)
            .toList();
        return filteredMedia;
      } else if (categoryId == 4) {
        filteredMedia = sleepMediaDataSource
            .where((item) => item.isFavorite == true)
            .toList();
        return filteredMedia;
      }
    }
    return sleepMediaDataSource;
  });
}
