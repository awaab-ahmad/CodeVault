import 'package:code_snippet/Pages/add_snippet_page.dart';
import 'package:code_snippet/management/codes_list.dart';
import 'package:code_snippet/management/lanaguages_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Future bottomSheet(BuildContext cn, ColorScheme t, Widget child) {
  return showModalBottomSheet(
    barrierColor: const Color(0x33FFFFFF),
    backgroundColor: t.primary,
    context: cn,
    builder: (context) => child,
  );
}

Expanded allLanaugesSection(double h, ColorScheme t, WidgetRef ref) {
  return Expanded(
    child: Consumer(
      builder: (context, ref, child) => GridView.builder(
        itemCount: programmingLanguages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
        ),
        itemBuilder: (context, index) {
          final fullName = programmingLanguages[index].full;
          return Padding(
            padding: const .symmetric(vertical: 03, horizontal: 02),
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(allCodesPro.notifier)
                    .programmingLanguageFilter(fullName, context);
              },
              style: ElevatedButton.styleFrom(
                padding: const .symmetric(horizontal: 0, vertical: 0),
                side: BorderSide(color: t.onSurface, width: .5),
                elevation: 0,
                backgroundColor: const Color(0x4D5B5B5B),
              ),
              child: FittedBox(child: gText(fullName, t.onSurface, 11, .w500)),
            ),
          );
        },
      ),
    ),
  );
}

Text gText(String s, Color c, double sz, FontWeight fw) {
  return Text(
    s,
    style: GoogleFonts.poppins(color: c, fontSize: sz, fontWeight: fw),
  );
}

// making the global text style
TextStyle textFieldStyles(Color c, double sz, FontWeight fw) {
  return GoogleFonts.poppins(color: c, fontSize: sz, fontWeight: fw);
}

SizedBox globalLine(ColorScheme t) {
  return SizedBox(
    height: 01,
    width: double.maxFinite,
    child: Card(elevation: 0, color: t.onSurface, margin: const .all(0)),
  );
}

Container globalBack(BuildContext context, double h, double w, ColorScheme t) {
  return Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(color: t.primary, borderRadius: .circular(100)),
    child: IconButton(
      padding: const .all(0),
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      },
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        size: h * 0.035,
        color: t.onSurface,
      ),
    ),
  );
}

// making the global variables for the borders
OutlineInputBorder border() {
  return OutlineInputBorder(
    borderRadius: .circular(15),
    borderSide: BorderSide(color: const Color(0xFFA78BFA), width: 0.6),
  );
}

TextField globalTextField(
  Widget icon,
  ColorScheme t,
  TextEditingController tc,
  Function() onChanged,
) {
  return TextField(
    maxLength: 20,
    cursorColor: t.surface,
    onChanged: (value) => onChanged(),
    style: textFieldStyles(t.onSurface, 13, .w500),
    controller: tc,
    decoration: InputDecoration(
      counterText: '',
      contentPadding: const .symmetric(horizontal: 10, vertical: 06),
      isDense: true,
      visualDensity: VisualDensity(vertical: -2),
      hintText: 'e.g. Auth Handler',
      hintStyle: textFieldStyles(t.onSurface, 13, .w500),
      focusedBorder: border(),
      enabledBorder: border(),
      prefixIcon: icon,
      suffixIcon: tc.text.trim().isNotEmpty
          ? IconButton(
              onPressed: () {
                tc.clear();
                onChanged();
              },
              visualDensity: VisualDensity(vertical: -4),
              padding: const .all(0),
              icon: Icon(Icons.clear, size: 30, color: t.onSurface),
            )
          : SizedBox.shrink(),
    ),
  );
}

TextField editTextField(ColorScheme t, TextEditingController tc) {
  return TextField(
    maxLength: 20,
    cursorColor: t.surface,
    style: textFieldStyles(t.surface, 11, .w500),
    controller: tc,
    decoration: InputDecoration(
      counterText: '',
      contentPadding: const .symmetric(horizontal: 10, vertical: 06),
      isDense: true,
      visualDensity: VisualDensity(vertical: -1),
      hintText: 'Enter new title',
      hintStyle: textFieldStyles(t.surface, 11, .w500),
      focusedBorder: border(),
      enabledBorder: border(),
    ),
  );
}

SizedBox insideCodeLine(ColorScheme t) {
  return SizedBox(
    height: 1,
    width: double.maxFinite,
    child: Card(color: t.onSurface, margin: const .all(0)),
  );
}

Container emptyBoxShowing(ColorScheme t) {
  return Container(
    width: double.maxFinite,
    clipBehavior: .antiAlias,
    padding: const .symmetric(horizontal: 10, vertical: 05),
    decoration: BoxDecoration(
      color: t.primary,
      border: .all(color: t.secondary, width: .6),
      borderRadius: .circular(20),
    ),
    child: Column(
      mainAxisAlignment: .center,
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0x80A78BFA),
            borderRadius: .circular(15),
          ),
          height: 60,
          width: 60,
          child: Center(
            child: Icon(Icons.search_rounded, color: t.secondary, size: 40),
          ),
        ),
        const SizedBox(height: 08),
        gText('No Snippets Found', t.surface, 15, .w500),
        const SizedBox(height: 08),
        Text(
          textAlign: .center,
          'Try a different keyword \nor change filter',
          style: GoogleFonts.poppins(
            color: t.onSurface,
            fontSize: 10,
            fontWeight: .w600,
          ),
        ),
        const SizedBox(height: 08),
      ],
    ),
  );
}

Container noSnippetsPresent(
  double h,
  double w,
  ColorScheme t,
  BuildContext cn,
) {
  return Container(
    width: w * 0.9,
    height: h * 0.38,
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A26),
      boxShadow: [
        BoxShadow(
          blurStyle: .outer,
          spreadRadius: .5,
          color: const Color(0xFFA78BFA),
          offset: Offset(1, 1),
        ),
      ],
      borderRadius: .circular(20),
    ),
    child: Column(
      crossAxisAlignment: .center,
      mainAxisAlignment: .center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0x80A78BFA),
            borderRadius: .circular(15),
          ),
          height: 60,
          width: 60,
          child: Center(
            child: Icon(Icons.code_outlined, color: t.surface, size: 40),
          ),
        ),
        const SizedBox(height: 05),
        gText('Your Library is empty', t.surface, 18, .w600),
        const SizedBox(height: 02),
        Text(
          'Save your first snippet and access \nyour code from anywhere, anytime.',
          textAlign: .center,
          style: GoogleFonts.poppins(
            color: t.onSurface,
            fontSize: 10.5,
            fontWeight: .w500,
          ),
        ),
        const SizedBox(height: 5),
        ElevatedButton(
          onPressed: () {
            Navigator.of(cn).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (cn) => AddSnippetPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: t.secondary,
            elevation: 4,
            shadowColor: const Color(0xFFFFFFFF),
          ),
          child: gText('Add you First Snippet', t.surface, 12, .w600),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: .spaceEvenly,
          children: [
            Container(
              width: w * 0.35,
              height: h * 0.04,
              padding: const .symmetric(horizontal: 05, vertical: 02),
              decoration: BoxDecoration(
                color: const Color(0x4D5B5B5B),
                border: .all(color: t.onSurface, width: .7),
                borderRadius: .circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, color: t.secondary, size: h * 0.03),
                  const SizedBox(width: 05),
                  gText('Quick Access', t.onSurface, 10, .w600),
                ],
              ),
            ),
            Container(
              width: w * 0.35,
              height: h * 0.04,
              padding: const .symmetric(horizontal: 05, vertical: 02),
              decoration: BoxDecoration(
                color: const Color(0x4D5B5B5B),
                border: .all(color: t.onSurface, width: .7),
                borderRadius: .circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.content_copy, color: t.secondary, size: h * 0.025),
                  const SizedBox(width: 05),
                  gText('Easy Copy', t.onSurface, 10, .w600),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget sheetContainer(double h, double w, WidgetRef ref, ColorScheme t) {
  return Container(
    padding: const .symmetric(horizontal: 10),
    height: h * 0.4,
    child: Column(
      crossAxisAlignment: .start,
      children: [
        const SizedBox(height: 10),
        Center(
          child: SizedBox(
            height: 04,
            width: 80,
            child: Card(color: const Color(0xFFFFFFFF), margin: const .all(0)),
          ),
        ),
        const SizedBox(height: 10),
        gText('Other Options', t.surface, 12, .w600),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(allCodesPro.notifier).typeOfFilter('All', 0);
              },
              style: eleButtonSheet(t),
              child: gText('All', t.onSurface, 10, .w600),
            ),
            const SizedBox(width: 05),
            ElevatedButton(
              onPressed: () {
                ref.read(allCodesPro.notifier).typeOfFilter('Pinned', 1);
              },
              style: eleButtonSheet(t),
              child: gText('Pinned', t.onSurface, 10, .w600),
            ),
          ],
        ),
        const SizedBox(height: 10),
        gText('Languages', t.surface, 12, .w600),
        allLanaugesSection(h, t, ref),
      ],
    ),
  );
}

ButtonStyle eleButtonSheet(ColorScheme t) {
  return ElevatedButton.styleFrom(
    fixedSize: Size(100, 40),
    padding: const .all(0),
    backgroundColor: const Color(0x4D5B5B5B),
    side: BorderSide(color: t.onSurface, width: .6),
  );
}
