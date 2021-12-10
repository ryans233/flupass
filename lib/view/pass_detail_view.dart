import 'package:flupass/generated/l10n.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/view/pass_field_builder.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class PassDetailView extends StatelessWidget {
  const PassDetailView(this.onExit, {Key? key}) : super(key: key);

  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    final path =
        context.select((PassDetailModel model) => model.selectedPassPath);
    final mode = context.select((PassDetailModel model) => model.mode);
    final isWysiwyg =
        context.select((PassDetailModel model) => model.isWysiwyg);
    return path == null
        ? const Scaffold()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                basename(path),
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  mode == DetailViewMode.modify
                      ? Icons.arrow_back
                      : Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (mode == DetailViewMode.modify) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(S.of(context).dialogBackToViewModeTitle),
                        content:
                            Text(S.of(context).dialogBackToViewModeContent),
                        actions: [
                          TextButton(
                            child: Text(S.of(context).dialogButtonCancel),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text(
                              S.of(context).dialogButtonAbort,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              context
                                  .read<PassDetailModel>()
                                  .setMode(DetailViewMode.readOnly);
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    onExit?.call();
                  }
                },
              ),
              actions: [
                IconButton(
                  onPressed: () =>
                      context.read<PassDetailModel>().toggleWysiwyg(),
                  icon: Icon(
                    isWysiwyg
                        ? Icons.text_snippet_rounded
                        : Icons.view_list_rounded,
                    color: Colors.grey,
                  ),
                ),
                mode != DetailViewMode.readOnly
                    ? TextButton(
                        onPressed: () => context.read<PassDetailModel>().save(),
                        child: Text(
                            S.of(context).pagePassDetailToolbarActionDoneTitle))
                    : TextButton(
                        onPressed: () => context
                            .read<PassDetailModel>()
                            .setMode(DetailViewMode.modify),
                        child: Text(S
                            .of(context)
                            .pagePassDetailToolbarActionEditTitle)),
              ],
            ),
            body: Selector<PassDetailModel, List<String>>(
              selector: (context, model) => model.passContent,
              builder: (_, value, ___) =>
                  value.isEmpty && mode == DetailViewMode.readOnly
                      ? Center(child: Text(S.of(context).pagePassDetailEmpty))
                      : !isWysiwyg
                          ? buildRawEditor(value, mode)
                          : buildWysiwygEditor(value, mode),
            ),
          );
  }

  Widget buildRawEditor(List<String> value, DetailViewMode mode) => Builder(
      builder: (context) => Flex(
            direction: Axis.vertical,
            children: [
              if (mode == DetailViewMode.modify) ...[
                buildDeletePassButton(),
              ],
              Expanded(
                flex: 1,
                child: TextFormField(
                  initialValue: value.join("\n"),
                  onChanged: (value) =>
                      context.read<PassDetailModel>().updatePass(value),
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintText: S.of(context).pagePassDetailRawEditorHint,
                  ),
                ),
              ),
            ],
          ));

  Widget buildWysiwygEditor(List<String> value, DetailViewMode mode) =>
      ListView(
        children: [
          ...value.asMap().entries.map(
              (e) => PassFieldBuilder().buildFromLine(e.key, e.value, mode)),
          if (mode == DetailViewMode.modify) ...[
            buildAddExtraInfoEntryButton(),
            const Divider(),
            buildDeletePassButton(),
          ]
        ],
      );

  Widget buildDeletePassButton() => Builder(
      builder: (context) => ListTile(
            tileColor: Colors.white,
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(S.of(context).dialogDeletePassTitle),
                content: Text(S.of(context).dialogDeletePassContent(basename(
                    context.read<PassDetailModel>().selectedPassPath ?? ""))),
                actions: [
                  TextButton(
                    child: Text(S.of(context).dialogButtonCancel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text(
                      S.of(context).dialogButtonDelete,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<PassDetailModel>().delete();
                    },
                  ),
                ],
              ),
            ),
            title: Text(
              S.of(context).viewPassDetailButtonDelete,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ));

  Widget buildAddExtraInfoEntryButton() => Builder(builder: (context) {
        final formKeyAddEntry = GlobalKey<FormState>();
        return ListTile(
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (formKeyAddEntry.currentState?.validate() == true) {
                context.read<PassDetailModel>().addExtraInfo();
              }
            },
          ),
          title: Form(
            key: formKeyAddEntry,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller:
                        context.read<PassDetailModel>().newEntryKeyController,
                    decoration: InputDecoration(
                        hintText: S
                            .of(context)
                            .pagePassDetailNewExtraInfoEntryHintKey),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller:
                        context.read<PassDetailModel>().newEntryValueController,
                    decoration: InputDecoration(
                        hintText: S
                            .of(context)
                            .pagePassDetailNewExtraInfoEntryHintValue),
                    validator: (value) => value?.isEmpty != true
                        ? null
                        : S
                            .of(context)
                            .pagePassDetailNewExtraInfoEntryValueError,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
