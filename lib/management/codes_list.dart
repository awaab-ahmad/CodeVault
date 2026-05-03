// This is the file in which there is a list that is responsible for storing

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

class AllSnippets {
  String lanFull;
  String lanShort;
  bool isPinned;
  int languageIndex;
  int index;
  List<Map<String, dynamic>> allSnippets;
  List<Map<String, dynamic>> filteredList;
  String filter;
  int otherOptionInd;

  AllSnippets({
    required this.lanFull,
    required this.lanShort,
    required this.isPinned,
    required this.languageIndex,
    required this.allSnippets,
    required this.index,
    required this.filteredList,
    required this.filter,
    required this.otherOptionInd,
  });

  AllSnippets copyWith({
    String? lanFull,
    String? lanShort,
    bool? isPinned,
    int? languageIndex,
    List<Map<String, dynamic>>? allSnippets,
    List<Map<String, dynamic>>? filteredList,
    int? index,
    int? otherOptionInd,
    String? filter,
  }) {
    return AllSnippets(
      lanFull: lanFull ?? this.lanFull,
      lanShort: lanShort ?? this.lanShort,
      isPinned: isPinned ?? this.isPinned,
      languageIndex: languageIndex ?? this.languageIndex,
      allSnippets: allSnippets ?? this.allSnippets,
      filteredList: filteredList ?? this.filteredList,
      index: index ?? this.index,
      otherOptionInd: otherOptionInd ?? this.otherOptionInd,
      filter: filter ?? this.filter,
    );
  }
}

final allCodesPro = StateNotifierProvider((ref) => AllSnippetsManagement());

class AllSnippetsManagement extends StateNotifier<AllSnippets> {
  AllSnippetsManagement()
    : super(
        AllSnippets(
          lanFull: 'Python',
          lanShort: 'py',
          isPinned: false,
          languageIndex: 0,
          index: 0,
          otherOptionInd: 0,
          filteredList: [],
          allSnippets: [],
          filter: 'All',
        ),
      );

  void lanIndexSelection(int ind, String long, String short) {
    if (kDebugMode) print('Index is: $ind');
    state = state.copyWith(languageIndex: ind, lanFull: long, lanShort: short);
    if (kDebugMode) print('Lan Index: ${state.lanShort}');
  }

  void lanIndexSettingToZero() {
    if (state.languageIndex != 0) {
      if (kDebugMode) print('Setting it to zero');
      state = state.copyWith(languageIndex: 0);
    } else {
      if (kDebugMode) print('Already Zero');
    }
  }

  void changingPinned(bool val) {
    state = state.copyWith(isPinned: val);
  }

  // making the Function for assigning the data
  void savingSnippet(
    TextEditingController title,
    CodeController code,
    BuildContext cn,
  ) {
    if (title.text.trim().isNotEmpty) {
      if (code.text.trim().isNotEmpty) {
        DateTime dt = DateTime.now().toLocal();
        String format = DateFormat('MMMM dd, yyyy').format(dt);
        state = state.copyWith(
          allSnippets: List.from(state.allSnippets)
            ..insert(0, {
              'Title': title.text.trim(),
              'languageFull': state.lanFull,
              'languageShort': state.lanShort,
              'code': code.text.trim(),
              'isPinned': state.isPinned,
              'datedOn': format,
            }),
        );
        Navigator.of(cn).pop();
      } else {
        if (kDebugMode) print('Code is empty');
      }
    } else {
      if (kDebugMode) print('Title is empty');
    }
  }

  void deletingSnippet(int index) {
    state = state.copyWith(
      allSnippets: List.from(state.allSnippets)..removeAt(index),
    );
  }

  void editingSnippetDetails(
    bool isNotEdit,
    int ind,
    TextEditingController txt,
    CodeController code,
    bool pinnedChanged,
    Function() changeTitle,
  ) {
    final list = List<Map<String, dynamic>>.from(state.allSnippets);
    list[ind] = {
      ...list[ind],
      'Title': txt.text.trim().isNotEmpty
          ? txt.text.trim()
          : state.allSnippets[ind]['Title'],
      'code': code.text.trim().isNotEmpty
          ? code.text.trim()
          : state.allSnippets[ind]['code'],
      'isPinned': state.isPinned != pinnedChanged
          ? pinnedChanged
          : state.isPinned,
    };
    state = state.copyWith(allSnippets: list);
    changeTitle();
  }

  // making the function for filtering
  void fillingFilteredList() {
    state = state.copyWith(filteredList: state.allSnippets);
  }

  // making the function for the filtering
  void filteringList(String tc) {
    if (tc.trim().isNotEmpty) {
      final query = tc.toLowerCase().trim();
      state = state.copyWith(
        filteredList: state.filteredList.where((e) {
          final title = e['Title'].toString().toLowerCase().trim().contains(
            query,
          );
          final languagefl = e['languageFull']
              .toString()
              .toLowerCase()
              .trim()
              .contains(query);
          final languagesh = e['languageShort']
              .toString()
              .toLowerCase()
              .trim()
              .contains(query);
          return title || languagefl || languagesh;
        }).toList(),
      );
    } else {
      state = state.copyWith(filteredList: state.allSnippets);
    }
  }

  void typeOfFilter(String filterType, int filInd) {
    switch (filterType) {
      case 'All':
        state = state.copyWith(
          filteredList: state.allSnippets,
          otherOptionInd: filInd,
        );
        break;

      case 'Pinned':
        state = state.copyWith(
          filteredList: state.allSnippets
              .where((filter) => filter['isPinned'] == true)
              .toList(),
          otherOptionInd: filInd,
        );
    }
  }

  void programmingLanguageFilter(String name, BuildContext cn) {
    state = state.copyWith(
      filteredList: state.allSnippets
          .where((nm) => nm['languageFull'] == name)
          .toList(),
    );
    Navigator.of(cn).pop();
  }
}
