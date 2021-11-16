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
    final entries = transformToWidgets(mode, obscureText, password, extraInfos);
    if (mode == DetailViewMode.modify) {
      entries.add(ListTile(
        leading: const Icon(Icons.delete),
        onTap: () => context.read<PassDetailModel>().delete(),
        title: Text(
          S.of(context).viewPassDetailButtonDelete,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }
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
                          FlatButton(
                            child: Text(
                                S.of(context).dialogBackToViewModeButtonCancel),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text(
                                S.of(context).dialogBackToViewModeButtonAbort),
                            textColor: Colors.red,
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
                : extraInfos.isEmpty
                    ? Center(
                        child: Text(S.of(context).pagePassDetailNoExtraInfos))
                    : ListView(children: entries),
          );
  }

  List<Widget> transformToWidgets(
      mode, obscurePassword, password, List<String>? extraInfos) {
    return List.empty(growable: true)
      ..add(buildPasswordField(password, obscurePassword, mode))
      ..addAll(buildExtraInfoFields(extraInfos, mode));
  }

  List<Widget> buildExtraInfoFields(
    List<String>? extraInfos,
    DetailViewMode mode,
  ) =>
      extraInfos == null
          ? List.empty()
          : extraInfos.map((line) {
              var index = extraInfos.indexOf(line);
              var split = line.split(': ');
              return TextFormField(
                initialValue: split.length == 2 ? split.last : line,
                decoration: InputDecoration(
                  labelText: split.length == 2
                      ? split.first
                      : S.current.pagePassDetailExtraInfoFieldNoLabel,
                ),
                readOnly: mode == DetailViewMode.readOnly,
                onChanged: (value) => extraInfos[index] = value,
              );
            }).toList();

  Widget buildPasswordField(
    String? password,
    bool obscurePassword,
    DetailViewMode mode,
  ) =>
      Builder(
        builder: (context) => Stack(
          children: [
            TextFormField(
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: S.of(context).pagePassDetailPasswordFieldLabel,
              ),
              readOnly: mode == DetailViewMode.readOnly,
              controller: context.select(
                  (PassDetailModel model) => model.passwordInputController),
            ),
            Positioned(
              child: Row(
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
                    icon: Icon(obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        context.read<PassDetailModel>().toggleObscurePassword(),
                  ),
                ],
              ),
              right: 0,
            ),
          ],
        ),
      );
}
