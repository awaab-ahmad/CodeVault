import 'package:code_snippet/elements/small_global_elements.dart';
import 'package:code_snippet/management/codes_list.dart';
import 'package:code_snippet/management/lanaguages_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSnippetPage extends ConsumerStatefulWidget {
  const AddSnippetPage({super.key});

  @override
  ConsumerState<AddSnippetPage> createState() => _AddSnippetPageState();
}

class _AddSnippetPageState extends ConsumerState<AddSnippetPage> {
  CodeController codeController = CodeController(text: '');
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(allCodesPro.notifier).lanIndexSettingToZero();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).colorScheme;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const .symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: 05),
                topRow(context, h, w, t),
                const SizedBox(height: 10),
                globalLine(t),
                const SizedBox(height: 10),
                gText('Snippet Title', t.onSurface, 14, .w600),
                const SizedBox(height: 10),
                globalTextField(
                  Icon(Icons.text_fields_sharp, color: t.onSurface, size: 30),
                  t,
                  titleController,
                  () {},
                ),
                const SizedBox(height: 10),
                gText('Languages', t.onSurface, 14, .w600),
                const SizedBox(height: 05),
                languagesSection(h, t, ref),
                const SizedBox(height: 10),
                gText('Code', t.onSurface, 14, .w600),
                const SizedBox(height: 10),
                codeContainer(t, h, w),
                const SizedBox(height: 10),
                pinnedSection(t, h, ref),
                const Expanded(child: SizedBox()),
                saveSnippetButton(t, h, ref, context),
                const SizedBox(height: 08),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row topRow(BuildContext context, double h, double w, ColorScheme t) {
    return Row(
      mainAxisAlignment: .start,
      children: [
        globalBack(context, h, w, t),
        const SizedBox(width: 10),
        gText('Add Snippet', t.surface, 18, .w600),
      ],
    );
  }

  SizedBox languagesSection(double h, ColorScheme t, WidgetRef ref) {
    return SizedBox(
      height: h * 0.11,
      width: double.maxFinite,
      child: GridView.builder(
        itemCount: programmingLanguages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          final fullName = programmingLanguages[index].full;
          final shortName = programmingLanguages[index].short;
          return Padding(
            padding: const .symmetric(vertical: 03, horizontal: 02),
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(allCodesPro.notifier)
                    .lanIndexSelection(index, fullName, shortName);
              },
              style: ElevatedButton.styleFrom(
                padding: const .symmetric(horizontal: 0, vertical: 0),
                side: BorderSide(color: t.onSurface, width: .5),
                elevation: 0,
                backgroundColor: ref.watch(allCodesPro).languageIndex == index
                    ? t.onPrimaryContainer
                    : const Color(0x4D5B5B5B),
              ),
              child: FittedBox(
                child: gText(
                  fullName,
                  ref.watch(allCodesPro).languageIndex == index
                      ? t.surface
                      : t.onSurface,
                  11,
                  .w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container codeContainer(ColorScheme t, double h, double w) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 04),
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        border: .all(color: t.secondary, width: .5),
        color: t.primary,
        borderRadius: .circular(20),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            height: h * 0.2,
            child: SingleChildScrollView(
              child: CodeField(
                cursorColor: t.surface,
                smartDashesType: .enabled,
                background: Colors.amber.shade100,
                padding: const .symmetric(vertical: 05),
                textStyle: textFieldStyles(t.surface, 12, .w500),
                gutterStyle: GutterStyle(
                  textAlign: .left,
                  showLineNumbers: true,
                ),
                decoration: BoxDecoration(
                  color: t.primary,
                  borderRadius: .circular(20),
                ),
                controller: codeController,
              ),
            ),
          ),
          const SizedBox(height: 08),
          insideCodeLine(t),
          const SizedBox(height: 08),
          SizedBox(
            height: h * 0.05,
            width: w * 0.5,
            child: GestureDetector(
              onTap: () async {
                await pastingClipboardData();
              },
              child: Card(
                color: const Color(0x00000000),
                elevation: 0,
                child: Row(
                  children: [
                    Icon(Icons.copy, color: t.onSurface, size: h * 0.025),
                    const SizedBox(width: 08),
                    gText('Paste your code', t.onSurface, 11, .w500),
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

  Container pinnedSection(ColorScheme t, double h, WidgetRef ref) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 05),
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        color: t.primary,
        border: .all(color: t.secondary),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Image.asset('images/pin.png', height: h * 0.03),
                  const SizedBox(width: 08),
                  gText('Pin this snippet', t.surface, 13, .w600),
                ],
              ),
              const SizedBox(height: 05),
              gText('Show in pinned section', t.onSurface, 10, .w600),
            ],
          ),
          const Expanded(child: SizedBox()),
          Switch(
            padding: const .symmetric(horizontal: 0, vertical: 0),
            activeTrackColor: t.secondary,
            inactiveTrackColor: t.secondary,
            inactiveThumbColor: t.onSurface,
            activeThumbColor: const Color(0xFF0F0F14),
            value: ref.watch(allCodesPro).isPinned,
            onChanged: (value) {
              ref.read(allCodesPro.notifier).changingPinned(value);
            },
          ),
        ],
      ),
    );
  }

  ElevatedButton saveSnippetButton(
    ColorScheme t,
    double h,
    WidgetRef ref,
    BuildContext cn,
  ) {
    return ElevatedButton(
      onPressed: () {
        ref
            .read(allCodesPro.notifier)
            .savingSnippet(titleController, codeController, cn);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: t.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: .circular(15)),
        fixedSize: Size(double.maxFinite, h * 0.07),
      ),
      child: gText('Save Snippet', t.surface, 15, .w600),
    );
  }

  Future<void> pastingClipboardData() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (kDebugMode) print(data!.text);
    if (data != null) {
      codeController.text = data.text.toString();
    } else {
      if (kDebugMode) print('Nothing in clipboard');
    }
  }
}
