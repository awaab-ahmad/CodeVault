// Making the Model Class of the Snippet and all its Details here.

import 'package:code_snippet/management/codes_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class SnippetModel {
  int indexNo;
  String snippetTitle;
  String lanFullForm;
  String lanShortForm;
  String code;
  bool isPinned;
  bool isNotEditing;
  String savingTime;

  SnippetModel({
    required this.indexNo,
    this.snippetTitle = '',
    this.lanFullForm = '',
    this.lanShortForm = '',
    this.code = 'Hello World',
    this.isPinned = false,
    required this.isNotEditing,

    required this.savingTime,
  });

  SnippetModel copyWith({
    int? indexNo,
    String? snippetTitle,
    String? lanFullForm,
    String? lanShortForm,
    String? code,
    bool? isPinned,
    bool? isNotEditing,
    String? savingTime,
  }) {
    return SnippetModel(
      indexNo: indexNo ?? this.indexNo,
      snippetTitle: snippetTitle ?? this.snippetTitle,
      lanFullForm: lanFullForm ?? this.lanFullForm,
      lanShortForm: lanShortForm ?? this.lanShortForm,
      code: code ?? this.code,
      isPinned: isPinned ?? this.isPinned,
      isNotEditing: isNotEditing ?? this.isNotEditing,
      savingTime: savingTime ?? this.savingTime,
    );
  }
}

final sniNotifierPro = StateNotifierProvider((ref) => SnippetManagement(ref));

class SnippetManagement extends StateNotifier<SnippetModel> {
  final Ref ref;
  SnippetManagement(this.ref)
    : super(SnippetModel(savingTime: '', indexNo: 0, isNotEditing: true)) {
    ref.listen(allCodesPro, (previous, next) {});
  }

  // this would be called at the time we move to next page
  void assigningElements(int index, List<Map<String, dynamic>> ls) {
    state = state.copyWith(
      indexNo: index,
      snippetTitle: ls[index]['Title'],
      lanFullForm: ls[index]['languageFull'],
      savingTime: ls[index]['datedOn'],
      code: ls[index]['code'],
      isPinned: ls[index]['isPinned'],
      isNotEditing: true,
    );
    if (kDebugMode) print(state.indexNo);
  }

  void assigningCode(CodeController tc) {
    tc.text = state.code;
  }

  void isEditingEnabled(Function() fn) {
    if (kDebugMode) print(state.isNotEditing);
    state = state.copyWith(isNotEditing: !state.isNotEditing);
    if (kDebugMode) print(state.isNotEditing);
    if (state.isNotEditing == true) {
      fn();
      if (kDebugMode) print('Body is Running');
    } else {
      if (kDebugMode) print('Not In edit state');
    }
  }

  void changingPinnedFun() {
    state = state.copyWith(isPinned: !state.isPinned);
  }

  void changingTitleAfterEdit(int ind) {
    final rf = ref.read(allCodesPro);
    state = state.copyWith(snippetTitle: rf.allSnippets[ind]['Title']);
  }
}
