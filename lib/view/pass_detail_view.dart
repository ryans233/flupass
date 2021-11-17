import 'package:flupass/generated/l10n.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/page/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class PassDetailView extends StatelessWidget {
  const PassDetailView(this.onExit, {Key? key}) : super(key: key);

  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    final path =
        context.select((PassDetailModel model) => model.selectedPassPath);
    final extraInfos =
        context.select((PassDetailModel model) => model.extraInfos);
    final mode = context.select((PassDetailModel model) => model.mode);
    final obscureText =
        context.select((PassDetailModel model) => model.obscurePassword);
    final password = context
        .select((PassDetailModel model) => model.passwordInputController.text);

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
                            child: Text(
                                S.of(context).dialogBackToViewModeButtonCancel),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text(
                              S.of(context).dialogBackToViewModeButtonAbort,
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
                mode != DetailViewMode.readOnly
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () => context
                            .read<PassDetailModel>()
                            .setMode(DetailViewMode.modify),
                        child: Text(S
                            .of(context)
                            .pagePassDetailToolbarActionEditTitle)),
                mode == DetailViewMode.readOnly
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () => context.read<PassDetailModel>().save(),
                        child: Text(S
                            .of(context)
                            .pagePassDetailToolbarActionDoneTitle)),
              ],
            ),
            body: extraInfos == null
                ? const Center(child: CircularProgressIndicator())
                : password.isEmpty && extraInfos.isEmpty
                    ? Center(child: Text(S.of(context).pagePassDetailEmpty))
                    : ListView(
                        children: [
                          ...transformToWidgets(
                              mode, obscureText, password, extraInfos),
                          if (mode == DetailViewMode.modify) ...[
                            buildAddExtraInfoEntryButton(),
                            const Divider(),
                            buildDeletePassButton(),
                          ]
                        ],
                      ),
          );
  }

  Widget buildDeletePassButton() => Builder(
      builder: (context) => ListTile(
            tileColor: Colors.white,
            onTap: () => context.read<PassDetailModel>().delete(),
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

  List<Widget> transformToWidgets(
          mode, obscurePassword, password, List<String>? extraInfos) =>
      List.empty(growable: true)
        ..add(buildPasswordField(password, obscurePassword, mode))
        ..addAll(buildExtraInfoFields(extraInfos, mode));

  List<Widget> buildExtraInfoFields(
    List<String>? extraInfos,
    DetailViewMode mode,
  ) =>
      extraInfos == null
          ? List.empty()
          : extraInfos
              .map((line) => Builder(builder: (context) {
                    final index = extraInfos.indexOf(line);
                    final split = line.split(': ');
                    return ListTile(
                      leading: mode == DetailViewMode.readOnly
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => context
                                  .read<PassDetailModel>()
                                  .deleteExtraInfo(index),
                            ),
                      title: mode == DetailViewMode.readOnly
                          ? TextFormField(
                              initialValue:
                                  split.length == 2 ? split.last : line,
                              decoration: InputDecoration(
                                labelText: split.length == 2 &&
                                        split.first.isNotEmpty
                                    ? split.first
                                    : S.current
                                        .pagePassDetailExtraInfoFieldNoLabel,
                              ),
                              readOnly: mode == DetailViewMode.readOnly,
                              onChanged: (value) => context
                                  .read<PassDetailModel>()
                                  .updateExtraInfo(
                                      index, "${split.first}: $value"),
                            )
                          : Column(
                              children: [
                                TextFormField(
                                  initialValue:
                                      split.length == 2 ? split.first : "",
                                  decoration: InputDecoration(
                                    labelText: S
                                        .of(context)
                                        .pagePassDetailNewExtraInfoEntryHintKey,
                                    border: InputBorder.none,
                                  ),
                                  readOnly: mode == DetailViewMode.readOnly,
                                  onChanged: (value) => context
                                      .read<PassDetailModel>()
                                      .updateExtraInfo(
                                          index, "$value: ${split.last}"),
                                ),
                                TextFormField(
                                  initialValue:
                                      split.length == 2 ? split.last : line,
                                  decoration: InputDecoration(
                                    labelText: S
                                        .of(context)
                                        .pagePassDetailNewExtraInfoEntryHintValue,
                                  ),
                                  readOnly: mode == DetailViewMode.readOnly,
                                  onChanged: (value) => context
                                      .read<PassDetailModel>()
                                      .updateExtraInfo(
                                          index, "${split.first}: $value"),
                                ),
                              ],
                            ),
                    );
                  }))
              .toList();

  Widget buildPasswordField(
    String? password,
    bool obscurePassword,
    DetailViewMode mode,
  ) =>
      Builder(
        builder: (context) => ListTile(
          title: TextFormField(
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: S.of(context).pagePassDetailPasswordFieldLabel,
            ),
            readOnly: mode == DetailViewMode.readOnly,
            controller: context.select(
                (PassDetailModel model) => model.passwordInputController),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              mode == DetailViewMode.readOnly
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.autorenew),
                      onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PasswordGeneratorPage(
                                        needResult: true),
                              ))
                          .then((value) => context
                              .read<PassDetailModel>()
                              .setPassword(value.toString())),
                    ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: password)),
              ),
              IconButton(
                icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () =>
                    context.read<PassDetailModel>().toggleObscurePassword(),
              ),
            ],
          ),
        ),
      );
}
