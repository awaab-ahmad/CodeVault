import 'package:code_snippet/Pages/code_details_page.dart';
import 'package:code_snippet/elements/small_global_elements.dart';
import 'package:code_snippet/management/codes_list.dart';
import 'package:code_snippet/management/snippet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> languages = ['All', 'Dart', 'Python', 'SQL', 'Java'];

class AllSnippetsPage extends ConsumerWidget {
  AllSnippetsPage({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final t = Theme.of(context).colorScheme;
    final pro = ref.watch(allCodesPro);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 16, vertical: 0),
          child: Column(
            children: [
              const SizedBox(height: 05),
              topSection(context, h, w, t, ref),
              const SizedBox(height: 10),
              globalLine(t),
              const SizedBox(height: 10),
              globalTextField(
                Icon(Icons.search, size: 30, color: t.onSurface),
                t,
                searchController,
                () => ref
                    .read(allCodesPro.notifier)
                    .filteringList(searchController.text),
              ),
              const SizedBox(height: 10),
              pro.filteredList.isEmpty
                  ? emptyBoxShowing(t)
                  : allSnippetsTile(t, pro, ref),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  Row topSection(
    BuildContext cn,
    double h,
    double w,
    ColorScheme t,
    WidgetRef ref,
  ) {
    return Row(
      children: [
        globalBack(cn, h, w, t),
        const Expanded(child: SizedBox()),
        gText('Search Snippet', t.surface, 16, .w600),
        const Expanded(child: SizedBox()),
        Container(
          alignment: .center,
          height: 40,
          width: 40,
          decoration: BoxDecoration(shape: .circle, color: t.primary),
          child: IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                bottomSheet(cn, t, sheetContainer(h, w, ref, t));
              });
            },
            icon: Icon(
              Icons.filter_alt_outlined,
              color: t.secondary,
              size: h * 0.035,
            ),
          ),
        ),
      ],
    );
  }

  Row allLanguage(double w, double h, ColorScheme t) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: h * 0.04,
            child: Card(
              margin: const .all(0),
              clipBehavior: .antiAlias,
              color: const Color(0x00000000),
              elevation: 0,
              child: ListView.builder(
                scrollDirection: .horizontal,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const .symmetric(horizontal: 03),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: index == 0
                            ? t.onPrimaryContainer
                            : const Color(0x4D5B5B5B),
                        side: BorderSide(
                          color: index != 0
                              ? t.onSurface
                              : const Color(0x00000000),
                        ),
                        fixedSize: Size(w * 0.2, h * 0.04),
                        padding: const .all(0),
                      ),
                      onPressed: () {},
                      child: FittedBox(
                        child: gText(
                          languages[index],
                          index == 0 ? const Color(0xFFFFFFFF) : t.onSurface,
                          12,
                          .w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 08),
        IconButton(
          onPressed: () {},
          visualDensity: VisualDensity(vertical: -4),
          padding: const .all(0),
          icon: gText('See All', t.secondary, 12, .w600),
        ),
      ],
    );
  }

  Expanded allSnippetsTile(ColorScheme t, final p, WidgetRef ref) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        clipBehavior: .antiAlias,
        padding: const .symmetric(horizontal: 10, vertical: 05),
        decoration: BoxDecoration(
          color: t.primary,
          border: .all(color: t.secondary, width: .6),
          borderRadius: .circular(20),
        ),
        child: ListView.builder(
          itemCount: p.filteredList.length,
          itemBuilder: (context, index) {
            final indVal = p.filteredList[index];
            final title = indVal['Title'];
            final shortLan = indVal['languageShort'];
            final longLan = indVal['languageFull'];
            final date = indVal['datedOn'];
            return Padding(
              padding: const .symmetric(vertical: 08),
              child: SizedBox(
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    ref.read(sniNotifierPro.notifier).assigningElements(index);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => CodeSnippetDetailsPage(),
                        ),
                      );
                    });
                  },
                  child: Card(
                    margin: const .all(0),
                    color: const Color(0x00000000),
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            gText(title, t.surface, 15, .w500),
                            const Expanded(child: SizedBox()),
                            indVal['isPinned'] == true
                                ? Image.asset('images/pin.png', height: 20)
                                : SizedBox.shrink(),
                            const SizedBox(width: 10),
                            Container(
                              padding: const .symmetric(
                                horizontal: 12,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: .circular(20),
                                color: index.isEven
                                    ? const Color(0x4DF7C948)
                                    : const Color(0x4D3B82F6),
                              ),
                              child: gText(
                                shortLan,
                                index.isEven ? t.error : t.onError,
                                12,
                                .w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            gText('$longLan - $date', t.onSurface, 10, .w500),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: t.secondary,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        insideCodeLine(t),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
