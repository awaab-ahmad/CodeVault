import 'package:code_snippet/elements/small_global_elements.dart';
import 'package:code_snippet/management/codes_list.dart';
import 'package:code_snippet/management/snippet_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodeSnippetDetailsPage extends ConsumerStatefulWidget {
  const CodeSnippetDetailsPage({super.key});

  @override
  ConsumerState<CodeSnippetDetailsPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<CodeSnippetDetailsPage> {
  CodeController textController = CodeController(text: '');
  TextEditingController title = TextEditingController();
  @override
  void initState() {
    super.initState();
    ref.read(sniNotifierPro.notifier).assigningCode(textController);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final t = Theme.of(context).colorScheme;
    final p = ref.watch(sniNotifierPro);
    final h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const .symmetric(horizontal: 16, vertical: 0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: 05),
                topBar(context, h, w, t, ref),
                const SizedBox(height: 15),
                globalLine(t),
                const SizedBox(height: 10),
                nameSection(t, h, w, p),
                const SizedBox(height: 10),
                gText('Code', t.onSurface, 16, .w600),
                const SizedBox(height: 10),
                codeSection(t, h, w, p),
                const SizedBox(height: 10),
                pinnedSection(h, t, p),
                const Expanded(child: SizedBox()),
                deleteButton(h),
                const SizedBox(height: 06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row topBar(
    BuildContext context,
    double h,
    double w,
    ColorScheme t,
    WidgetRef ref,
  ) {
    return Row(
      children: [
        globalBack(context, h, w, t),
        const Expanded(flex: 2, child: SizedBox()),
        gText('Snippet Details', t.surface, 18, .w600),
        const Expanded(flex: 2, child: SizedBox()),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: t.primary,
            borderRadius: .circular(100),
          ),
          child: Center(
            child: IconButton(
              padding: const .all(0),
              onPressed: () {
                final rf = ref.watch(sniNotifierPro);
                ref.read(sniNotifierPro.notifier).isEditingEnabled(() {
                  ref.read(allCodesPro.notifier).editingSnippetDetails(
                    rf.isNotEditing,
                    rf.indexNo,
                    title,
                    textController,
                    rf.isPinned,
                    () {
                      ref
                          .read(sniNotifierPro.notifier)
                          .changingTitleAfterEdit(rf.indexNo);
                      ref.read(allCodesPro.notifier).fillingFilteredList();
                    },
                  );
                });
              },
              icon: ref.watch(sniNotifierPro).isNotEditing == true
                  ? Icon(
                      Icons.edit_outlined,
                      color: t.secondary,
                      size: h * 0.033,
                    )
                  : Icon(Icons.check, color: t.secondary, size: h * 0.035),
            ),
          ),
        ),
      ],
    );
  }

  Container nameSection(ColorScheme t, double h, double w, final p) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 08),
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        color: t.primary,
        border: .all(color: t.secondary, width: .8),
        borderRadius: .circular(20),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          SizedBox(
            width: w * 0.5,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                p.isNotEditing == true
                    ? gText(p.snippetTitle, t.surface, 16, .w600)
                    : editTextField(t, title),
                const SizedBox(height: 10),
                Container(
                  padding: const .symmetric(horizontal: 15, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.onPrimaryContainer,
                    borderRadius: .circular(20),
                  ),
                  child: gText(p.lanFullForm, t.surface, 12, .w500),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: h * 0.025,
                      color: t.onSurface,
                    ),
                    const SizedBox(width: 08),
                    gText('Created on ${p.savingTime}', t.onSurface, 10, .w400),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const .symmetric(horizontal: 06, vertical: 04),
            decoration: BoxDecoration(
              color: const Color(0x33A78BFA),
              borderRadius: .circular(20),
              border: .all(color: t.secondary),
            ),
            child: Row(
              children: [
                Image.asset('images/pin.png', height: h * 0.02),
                const SizedBox(width: 06),
                gText(
                  p.isPinned == true ? 'Pinned' : '-',
                  t.onSurface,
                  10,
                  .w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container codeSection(ColorScheme t, double h, double w, final p) {
    return Container(
      clipBehavior: .antiAlias,
      padding: const .symmetric(horizontal: 10, vertical: 04),
      decoration: BoxDecoration(
        color: t.primary,
        borderRadius: .circular(20),
        border: .all(color: t.secondary, width: .8),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            height: h * 0.3,
            child: SingleChildScrollView(
              child: CodeField(
                readOnly: p.isNotEditing,
                textStyle: textFieldStyles(t.surface, 12, .w500),
                gutterStyle: GutterStyle(textAlign: .start),
                decoration: BoxDecoration(borderRadius: .circular(20)),
                background: const Color(0x44FFFFFF),
                controller: textController,
              ),
            ),
          ),
          const SizedBox(height: 08),
          SizedBox(
            height: 1,
            width: double.maxFinite,
            child: Card(color: t.onSurface, margin: const .all(0)),
          ),
          const SizedBox(height: 08),
          GestureDetector(
            onTap: () {
              final dataToCopy = textController.text.trim();
              if (kDebugMode) print(dataToCopy);
              Clipboard.setData(ClipboardData(text: dataToCopy));
            },
            child: SizedBox(
              width: w * 0.3,
              child: Card(
                margin: const .all(0),
                elevation: 0,
                color: const Color(0x00000000),
                child: Row(
                  children: [
                    Icon(
                      Icons.content_copy_outlined,
                      color: t.secondary,
                      size: h * 0.025,
                    ),
                    const SizedBox(width: 08),
                    gText('Copy Code', t.secondary, 10, .w600),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 08),
        ],
      ),
    );
  }

  Container pinnedSection(double h, ColorScheme t, final p) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        border: .all(color: t.secondary, width: .8),
      ),
      child: Row(
        children: [
          Image.asset('images/pin.png', height: h * 0.03),
          const SizedBox(width: 08),
          gText('Snippet Status', t.surface, 14, .w600),
          const Expanded(child: SizedBox()),
          Switch(
            padding: const .symmetric(horizontal: 0, vertical: 0),
            activeTrackColor: t.secondary,
            inactiveTrackColor: t.secondary,
            inactiveThumbColor: t.onSurface,
            activeThumbColor: const Color(0xFF0F0F14),
            value: p.isPinned,
            onChanged: (value) {
              p.isNotEditing == false
                  ? ref.read(sniNotifierPro.notifier).changingPinnedFun()
                  : () {};
            },
          ),
        ],
      ),
    );
  }

  ElevatedButton deleteButton(double h) {
    return ElevatedButton(
      onPressed: () {
        final ind = ref.watch(sniNotifierPro).indexNo;
        ref.read(allCodesPro.notifier).deletingSnippet(ind);
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        padding: const .symmetric(vertical: 10),
        elevation: 0,
        backgroundColor: const Color(0xFF1F1218),
        shape: RoundedRectangleBorder(borderRadius: .circular(15)),
        side: BorderSide(color: const Color(0xFF4A1A2A), width: 1),
      ),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.delete, color: const Color(0xFFF87171), size: h * 0.04),
          const SizedBox(width: 06),
          gText('Delete Snippet', const Color(0xFFF87171), 14, .w500),
        ],
      ),
    );
  }
}
