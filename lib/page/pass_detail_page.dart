import 'package:flupass/model/pass_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DetailView extends StatefulWidget {
  const DetailView(
    this.singleColumn, {
    Key? key,
  }) : super(key: key);

  final bool singleColumn;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lines =
        context.select((PassDetailModel model) => model.decryptedLines);
    final mode = context.select((PassDetailModel model) => model.mode);
    final obscureText =
        context.select((PassDetailModel model) => model.obscurePassword);
    return lines.isEmpty
        ? const Center(child: Text("Empty"))
        : Scaffold(
            appBar: AppBar(
              title: Text(mode.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                  )),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (widget.singleColumn) Navigator.of(context).pop();
                  context.read<PassDetailModel>().clear();
                },
              ),
            ),
            body: lines.isEmpty
                ? const Center(child: Text("No result."))
                : ListView(
                    children: transformToWidgets(mode, obscureText, lines),
                  ),
          );
  }

  List<Widget> transformToWidgets(mode, obscurePassword, List<String> lines) =>
      lines
          .map((line) {
            if (line.isEmpty) {
              return null;
            } else if (lines.indexOf(line) == 0) {
              return Stack(
                children: [
                  TextFormField(
                    obscureText: obscurePassword,
                    initialValue: line,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    readOnly: mode == DetailViewMode.readOnly,
                  ),
                  Positioned(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () =>
                              Clipboard.setData(ClipboardData(text: line)),
                        ),
                        IconButton(
                          icon: Icon(obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => context
                              .read<PassDetailModel>()
                              .toggleObscurePassword(),
                        ),
                      ],
                    ),
                    right: 0,
                  ),
                ],
              );
            } else {
              var split = line.split(': ');
              if (split.length == 2) {
                return TextFormField(
                  initialValue: split.last,
                  decoration: InputDecoration(
                    labelText: split.first,
                  ),
                  readOnly: mode == DetailViewMode.readOnly,
                );
              } else {
                return TextFormField(
                  initialValue: line,
                  decoration: const InputDecoration(
                    labelText: "No Label",
                  ),
                  readOnly: mode == DetailViewMode.readOnly,
                );
              }
            }
          })
          .where((element) => element != null)
          .map((widget) => ListTile(title: widget))
          .toList();
}
