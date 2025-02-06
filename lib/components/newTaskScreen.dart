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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => appState.setSreen(Screen.list),
                icon: Icon(Icons.close, color: theme.iconTheme.color),
              ),
              ElevatedButton(
                onPressed: () {
                  appState.addNew(textController.text);
                  FocusManager.instance.primaryFocus?.unfocus();
                  textController.clear();
                  appState.setSreen(Screen.list);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Task title
          TextField(
            controller: textController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Add title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
