import 'package:code_snippet/Pages/add_snippet_page.dart';
import 'package:code_snippet/Pages/all_snippets.dart';
import 'package:code_snippet/Pages/code_details_page.dart';
import 'package:code_snippet/elements/small_global_elements.dart';
import 'package:code_snippet/management/codes_list.dart';
import 'package:code_snippet/management/snippet_model.dart';
import 'package:code_snippet/management/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FrontPage extends ConsumerStatefulWidget {
  const FrontPage({super.key});

  @override
  ConsumerState<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends ConsumerState<FrontPage>
    with SingleTickerProviderStateMixin {
  CodeController pinnedText = CodeController(text: '');
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(stPro.notifier)
          .gettingData(
            () => ref.read(allCodesPro.notifier).fillingFilteredList(),
          );
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final t = Theme.of(context).colorScheme;
    final p = ref.watch(allCodesPro);
    final firstPinned = p.allSnippets.firstWhere(
      (item) => item['isPinned'] == true,
      orElse: () => {},
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: 10),
              topSection(h, w, t, context),
              const SizedBox(height: 5),
              personalLine(t),
              const SizedBox(height: 5),
              snippetsAmount(t, p),
              const SizedBox(height: 5),
              Expanded(
                child: p.filteredList.isEmpty
                    ? Center(
                        child: transition(
                          _controller,
                          noSnippetsPresent(h, w, t, context),
                        ),
                      )
                    : transition(
                        _controller,
                        Column(
                          children: [
                            searchButton(t, h, context, ref),
                            pinnedLine(t, h, ref, context),
                            pinnedContainer(h, w, t, p, firstPinned),
                            recentLine(t, h, context, ref),
                            recentSection(t, w, h, p, ref),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row topSection(double h, double w, ColorScheme t, BuildContext c) {
    return Row(
      children: [
        Container(
          height: h * 0.08,
          width: w * 0.16,
          decoration: BoxDecoration(
            borderRadius: .circular(15),
            gradient: LinearGradient(colors: [t.onSecondary, t.secondary]),
          ),
          child: Icon(Icons.code, size: h * 0.055, color: t.surface),
        ),
        const SizedBox(width: 10),
        gText('CodeVault', t.surface, 18, FontWeight.w600),
        const Expanded(child: SizedBox()),
        Container(
          decoration: BoxDecoration(
            borderRadius: .circular(100),
            gradient: LinearGradient(colors: [t.onSecondary, t.secondary]),
          ),
          child: Center(
            child: IconButton(
              onPressed: () {
                Navigator.of(c).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (c) => AddSnippetPage(),
                  ),
                );
              },
              icon: Icon(Icons.add, size: h * 0.045, color: t.surface),
            ),
          ),
        ),
      ],
    );
  }

  Text personalLine(ColorScheme t) {
    return gText(
      'Your Personal Code Library',
      t.onSurface,
      14,
      FontWeight.w500,
    );
  }

  Text snippetsAmount(ColorScheme t, final p) {
    return gText(
      '${p.allSnippets.length} snippets saved',
      t.surface,
      15,
      FontWeight.w500,
    );
  }

  ElevatedButton searchButton(
    ColorScheme t,
    double h,
    BuildContext cn,
    WidgetRef ref,
  ) {
    return ElevatedButton(
      onPressed: () {
        ref.read(allCodesPro.notifier).fillingFilteredList();
        Navigator.of(cn).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (cn) => AllSnippetsPage(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0x4D5B5B5B),
        side: BorderSide(width: .5, color: t.onSurface),
        shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: t.onSurface, size: h * 0.04),
          const SizedBox(width: 05),
          gText('Search Snippets, tags', t.onSurface, 13, FontWeight.w500),
        ],
      ),
    );
  }

  Row pinnedLine(ColorScheme t, double h, WidgetRef ref, BuildContext cn) {
    return Row(
      children: [
        Image.asset('images/pin.png', height: h * 0.025),
        const SizedBox(width: 05),
        gText('Pinned', t.onSurface, 13, FontWeight.w500),
        const Expanded(child: SizedBox()),
        IconButton(
          visualDensity: VisualDensity(vertical: -4),
          padding: const .all(0),
          onPressed: () {
            ref.read(allCodesPro.notifier).typeOfFilter('Pinned', 1);
            Navigator.of(cn).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (cn) => AllSnippetsPage(),
              ),
            );
          },
          icon: gText('See All', t.secondary, 11, .w600),
        ),
      ],
    );
  }

  Container pinnedContainer(
    double h,
    double w,
    ColorScheme t,
    final p,
    Map<String, dynamic> pinned,
  ) {
    return Container(
      // height: h * 0.32,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 08),
      width: w * 1.0,
      decoration: BoxDecoration(
        color: t.primary,
        borderRadius: .circular(20),
        border: BoxBorder.all(color: t.secondary, width: 0.7),
      ),
      child: pinned.isNotEmpty
          ? Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    gText(pinned['Title'], t.surface, 15, FontWeight.w600),
                    const Expanded(child: SizedBox()),
                    Container(
                      height: h * 0.04,
                      padding: const .symmetric(horizontal: 05),
                      decoration: BoxDecoration(
                        borderRadius: .circular(20),
                        border: .all(color: t.secondary, width: .6),
                        color: const Color(0x33A78BFA),
                      ),
                      child: Center(
                        child: gText(
                          pinned['languageFull'],
                          t.surface,
                          10,
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                gText(pinned['datedOn'], t.onSurface, 12, FontWeight.w500),
                const SizedBox(height: 05),
                Container(
                  height: h * 0.17,
                  clipBehavior: .antiAlias,
                  decoration: BoxDecoration(
                    color: t.onPrimary,
                    borderRadius: .circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: CodeField(
                      readOnly: true,
                      textStyle: textFieldStyles(t.surface, 12, .w500),
                      gutterStyle: GutterStyle(textAlign: .start),
                      background: t.onPrimary,
                      controller: CodeController(text: pinned['code']),
                    ),
                  ),
                ),
                const SizedBox(height: 05),
                Row(
                  children: [
                    IconButton(
                      padding: const .all(0),
                      visualDensity: VisualDensity(vertical: -4),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: pinned['code']));
                        if (kDebugMode) print(pinned['code']);
                      },
                      icon: Row(
                        children: [
                          Icon(Icons.copy, color: t.onSurface, size: 20),
                          const SizedBox(width: 05),
                          gText('Copy', t.onSurface, 12, FontWeight.w600),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisAlignment: .center,
              children: [
                Container(
                  padding: const .all(10),
                  decoration: BoxDecoration(
                    color: const Color(0x4DA78BFA),
                    borderRadius: .circular(20),
                  ),
                  child: Image.asset('images/pin.png', height: 50),
                ),
                const SizedBox(height: 10),
                gText('No Snippets Pinned', t.surface, 14, .w600),
              ],
            ),
    );
  }

  Row recentLine(ColorScheme t, double h, BuildContext cn, WidgetRef ref) {
    return Row(
      children: [
        Icon(Icons.alarm, color: t.onSurface, size: h * 0.03),
        const SizedBox(width: 08),
        gText('Recent', t.onSurface, 13, FontWeight.w600),
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () {
            ref.read(allCodesPro.notifier).fillingFilteredList();
            Navigator.of(cn).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (cn) => AllSnippetsPage(),
              ),
            );
          },
          padding: const .all(0),
          visualDensity: VisualDensity(vertical: -4),
          icon: gText('See All', t.secondary, 11, .w500),
        ),
      ],
    );
  }

  Expanded recentSection(
    ColorScheme t,
    double w,
    double h,
    final p,
    WidgetRef r,
  ) {
    return Expanded(
      child: p.filteredList.isEmpty
          ? emptyBoxShowing(t)
          : ListView.builder(
              itemCount: p.filteredList.length > 3 ? 3 : p.filteredList.length,
              itemBuilder: (context, index) {
                final indVal = p.allSnippets[index];
                final title = indVal['Title'];
                final language = indVal['languageShort'];
                final langFull = indVal['languageFull'];
                final date = indVal['datedOn'];
                Color? c;
                Color? background;
                switch (index) {
                  case 0:
                    c = t.error;
                    background = const Color(0x4DF7C948);
                    break;

                  case 1:
                    c = t.onError;
                    background = const Color(0x4D3B82F6);
                    break;

                  case 2:
                    c = t.onErrorContainer;
                    background = const Color(0x4D34D399);
                    break;
                }
                return Padding(
                  padding: const .symmetric(vertical: 03),
                  child: ElevatedButton(
                    onPressed: () {
                      r
                          .read(sniNotifierPro.notifier)
                          .assigningElements(index, p.filteredList);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => CodeSnippetDetailsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const .symmetric(horizontal: 14, vertical: 05),
                      backgroundColor: t.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(20),
                      ),
                      side: BorderSide(color: t.secondary, width: 0.6),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                color: c,
                                borderRadius: .circular(100),
                              ),
                            ),
                            const SizedBox(width: 10),
                            gText(title, t.surface, 13, FontWeight.w500),
                            const Expanded(child: SizedBox()),
                            Container(
                              width: w * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: .circular(20),
                                color: background,
                              ),
                              child: Center(
                                child: gText(language, c!, 12, FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            gText(
                              '$langFull - $date',
                              t.onSurface,
                              10,
                              FontWeight.w500,
                            ),
                            const Expanded(child: SizedBox()),
                            Icon(
                              Icons.arrow_forward,
                              color: t.secondary,
                              size: h * 0.03,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
