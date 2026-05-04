import 'dart:convert';

import 'package:code_snippet/management/codes_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {}

final stPro = StateNotifierProvider((ref) => StorageProvider(ref));

class StorageProvider extends StateNotifier {
  final Ref ref;
  StorageProvider(this.ref) : super(Storage()) {
    ref.listen(allCodesPro, (previous, next) {});
  }

  Future<void> savingStats() async {
    final pref = await SharedPreferences.getInstance();
    final data = jsonEncode(ref.watch(allCodesPro).allSnippets).toString();
    pref.setString('AllData', data);
    if (kDebugMode) print('Data saved');
  }

  Future<void> gettingData(Function() fc) async {
    final pref = await SharedPreferences.getInstance();
    final r = ref.watch(allCodesPro);
    final convertedData = pref.getString('AllData');
    if (convertedData != null && convertedData.isNotEmpty) {
      r.allSnippets = (jsonDecode(convertedData) as List)
          .cast<Map<String, dynamic>>();
      await fc();
    } else {
      if (kDebugMode) print('Data store is empty');
    }
  }
}
