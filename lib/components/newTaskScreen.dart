import 'package:flutter/material.dart';
import 'package:flutter_todo/main.dart';
import 'package:provider/provider.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({
    super.key,
  });

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        // top buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => {appState.setSreen(Screen.list)},
              icon: Icon(Icons.close),
            ),
            ElevatedButton(
              onPressed: () {
                // save task
                appState.addNew(textController.text);

                // dismiss keyboard
                FocusManager.instance.primaryFocus?.unfocus();
                textController.clear();

                // close screen
                appState.setSreen(Screen.list);
              },
              child: Icon(Icons.send),
            ),
          ],
        ),
        // task title
        TextField(
          controller: textController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration.collapsed(hintText: 'Add title'),
        ),
      ],
    );
  }
}
