import 'package:flupass/generated/l10n.dart';
import 'package:flupass/model/password_generator_model.dart';
import 'package:flupass/view/colorized_password_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordGeneratorPage extends StatelessWidget {
  const PasswordGeneratorPage({
    Key? key,
    required this.needResult,
  }) : super(key: key);

  final bool needResult;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PasswordGeneratorModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).pagePasswordGeneratorTitle),
          actions: [
            if (needResult)
              Builder(
                  builder: (context) => IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () => Navigator.pop(context,
                            context.read<PasswordGeneratorModel>().password),
                      )),
          ],
        ),
        body: ListView(
          children: [
            buildPassword(),
            buildGenerateButton(),
            buildDivider(),
            buildCopyButton(),
            ...buildOptions(),
          ],
        ),
      ),
    );
  }

  Widget buildGenerateButton() => Builder(
        builder: (context) => ListTile(
          tileColor: Colors.white,
          title: Text(
            S.of(context).pagePasswordGeneratorButtonGenerate,
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () => context.read<PasswordGeneratorModel>().generate(),
        ),
      );

  Widget buildCopyButton() => Builder(
        builder: (context) => ListTile(
          tileColor: Colors.white,
          title: Text(
            S.of(context).pagePasswordGeneratorButtonCopy,
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () => context
              .read<PasswordGeneratorModel>()
              .copy()
              .then(
                (_) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(S.of(context).pagePasswordGeneratorSnackMsgCopied),
                  ),
                ),
              )
              .catchError(
                (_) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S
                        .of(context)
                        .pagePasswordGeneratorSnackMsgFailedToCopy),
                  ),
                ),
              ),
        ),
      );

  Widget buildPassword() => Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
          child: ColorizedPasswordView(
            context.select((PasswordGeneratorModel model) => model.password),
            fontSize: 24.0,
            textAlign: TextAlign.center,
          ),
        ),
      );

  List<Widget> buildOptions() {
    return [
      Builder(
        builder: (context) {
          return ListTile(
            title:
                Text(S.of(context).pagePasswordGeneratorOptionEntryLengthTitle),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${context.select((PasswordGeneratorModel model) => model.length)}',
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 200,
                  child: Slider(
                    value: context
                        .select((PasswordGeneratorModel model) => model.length)
                        .toDouble(),
                    min: 4,
                    max: 32,
                    onChanged: (value) => context
                        .read<PasswordGeneratorModel>()
                        .setLength(value.round()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      Builder(
        builder: (context) => SwitchListTile(
          title: Text(
              S.of(context).pagePasswordGeneratorOptionEntryUppercaseTitle),
          value: context
              .select((PasswordGeneratorModel model) => model.hasUppercase),
          onChanged: (value) =>
              context.read<PasswordGeneratorModel>().setUppercase(value),
        ),
      ),
      Builder(
        builder: (context) => SwitchListTile(
          title: Text(
              S.of(context).pagePasswordGeneratorOptionEntryLowercaseTitle),
          value: context
              .select((PasswordGeneratorModel model) => model.hasLowercase),
          onChanged: (value) =>
              context.read<PasswordGeneratorModel>().setLowercase(value),
        ),
      ),
      Builder(
        builder: (context) => SwitchListTile(
          title:
              Text(S.of(context).pagePasswordGeneratorOptionEntryNumberTitle),
          value:
              context.select((PasswordGeneratorModel model) => model.hasNumber),
          onChanged: (value) =>
              context.read<PasswordGeneratorModel>().setNumber(value),
        ),
      ),
      Builder(
        builder: (context) => SwitchListTile(
            title: Text(
                S.of(context).pagePasswordGeneratorOptionEntrySymbolsTitle),
            value: context.select(
                (PasswordGeneratorModel model) => model.hasSpecialSymbols),
            onChanged: (value) => context
                .read<PasswordGeneratorModel>()
                .setSpecialSymbols(value)),
      ),
    ];
  }

  Widget buildDivider() => const Divider(
        height: 0,
        thickness: 0.0,
      );
}
