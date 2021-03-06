import 'dart:io';

import 'package:flupass/generated/l10n.dart';
import 'package:flupass/model/pass_store_list_model.dart';
import 'package:flupass/page/page.dart';
import 'package:flupass/routes.dart';
import 'package:flupass/view/drag_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class PassListView extends StatefulWidget {
  const PassListView(
    this.onItemClick, {
    Key? key,
  }) : super(key: key);

  final void Function(File)? onItemClick;

  @override
  State<PassListView> createState() => _PassListViewState();
}

class _PassListViewState extends State<PassListView> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final root = context.select((PassStoreListModel model) => model.root);
    final relativePath =
        context.select((PassStoreListModel model) => model.relativePath);
    final shouldShowTitle =
        (relativePath.isEmpty || relativePath == Platform.pathSeparator);
    return Builder(
      builder: (context) => Column(
        children: [
          AppBar(
            leading: IconButton(
              onPressed: () =>
                  context.read<PassStoreListModel>().toggleSearchMode(),
              icon: Icon(
                  context.select((PassStoreListModel model) => model.searchMode)
                      ? Icons.arrow_back
                      : Icons.search),
            ),
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PasswordGeneratorPage(
                            needResult: false,
                          ))),
                  icon: const Icon(Icons.autorenew)),
              IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.settings),
                  icon: const Icon(Icons.settings)),
            ],
            title: context
                    .select((PassStoreListModel model) => model.searchMode)
                ? buildSearchBar()
                : shouldShowTitle
                    ? Text(S.of(context).appName)
                    : ScrollConfiguration(
                        behavior: DragScrollBehavior(),
                        child: BreadCrumb.builder(
                          builder: (index) {
                            final pathname = index == 0
                                ? Platform.pathSeparator
                                : relativePath
                                    .split(Platform.pathSeparator)[index];
                            return BreadCrumbItem(
                              content: Tooltip(
                                message: pathname,
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                child: Text(
                                  pathname,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              onTap: () {
                                final split =
                                    relativePath.split(Platform.pathSeparator);
                                context
                                    .read<PassStoreListModel>()
                                    .navigateToFolder(split.fold(
                                        "",
                                        (previousValue, element) =>
                                            split.indexOf(element) <= index
                                                ? previousValue += element +
                                                    Platform.pathSeparator
                                                : previousValue));
                              },
                            );
                          },
                          itemCount:
                              relativePath.split(Platform.pathSeparator).length,
                          divider: const Icon(Icons.chevron_right),
                          overflow: ScrollableOverflow(
                            keepLastDivider: false,
                            reverse: false,
                            direction: Axis.horizontal,
                            controller: scrollController,
                          ),
                        ),
                      ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: root.length,
              itemBuilder: (_, index) {
                var entry = root[index];
                return ListTile(
                  leading: Icon(
                      (entry is Directory) ? Icons.folder : Icons.file_present),
                  title: Text(basename(entry.path)),
                  subtitle: context.read<PassStoreListModel>().searchMode
                      ? Text(
                          entry.parent.path.replaceFirst(
                            context.read<PassStoreListModel>().passStorePath +
                                Platform.pathSeparator,
                            Platform.pathSeparator,
                          ),
                          softWrap: false,
                        )
                      : null,
                  onTap: () {
                    if (entry is File) {
                      widget.onItemClick?.call(entry);
                    } else if (entry is Directory) {
                      context
                          .read<PassStoreListModel>()
                          .navigateToFolder(entry.path);
                      if (scrollController.hasClients) {
                        Future.delayed(const Duration(milliseconds: 50), () {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 50),
                          );
                        });
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() => Builder(
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          child: TextField(
            maxLines: 1,
            style: const TextStyle(
              fontSize: 15,
            ),
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.search),
              hintText: S.of(context).viewPassListSearchBarHintText,
              border: InputBorder.none,
            ),
            onChanged: (value) =>
                context.read<PassStoreListModel>().search(value),
          ),
        ),
      );
}
