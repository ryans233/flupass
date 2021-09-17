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
    var entries = transformToWidgets(mode, obscureText, lines);
    if (mode == DetailViewMode.modify) {
      entries.add(ListTile(
        leading: Icon(Icons.delete),
        onTap: () => context.read<PassDetailModel>().delete(),
        title: Text(
          "Delete",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }
    return lines.isEmpty
        ? const Center(child: Text("Empty"))
        : Scaffold(
            appBar: AppBar(
              title: Text(
                mode.toString(),
                style: const TextStyle(
                  color: Colors.grey,
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
                    context
                        .read<PassDetailModel>()
                        .setMode(DetailViewMode.readOnly);
                  } else {
                    if (widget.singleColumn) {
                      Navigator.of(context).pop();
                    }
                    context.read<PassDetailModel>().clear();
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
                        child: Text("Edit".toUpperCase())),
                mode == DetailViewMode.readOnly
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () => context.read<PassDetailModel>().save(),
                        child: Text("Done".toUpperCase())),
              ],
            ),
            body: lines.isEmpty
                ? const Center(child: Text("No result."))
                : ListView(children: entries),
          );
  }

  List<Widget> transformToWidgets(mode, obscurePassword, List<String> lines) =>
      lines
          .map((line) {
            var index = lines.indexOf(line);
            if (line.isEmpty) {
              return null;
            } else if (index == 0) {
              return Stack(
                children: [
                  TextFormField(
                    obscureText: obscurePassword,
                    initialValue: line,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    readOnly: mode == DetailViewMode.readOnly,
                    onChanged: (value) => lines[0] = value,
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
              return TextFormField(
                initialValue: split.length == 2 ? split.last : line,
                decoration: InputDecoration(
                  labelText: split.length == 2 ? split.first : "No Label",
                ),
                readOnly: mode == DetailViewMode.readOnly,
                onChanged: (value) => lines[index] = value,
              );
            }
          })
          .where((element) => element != null)
          .map((widget) => ListTile(title: widget))
          .toList();
}
