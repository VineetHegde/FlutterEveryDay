import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('notesBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final box = Hive.box('notesBox');
  final TextEditingController controller = new TextEditingController();

  void addNote() {
    box.add(controller.text);
    controller.clear();
    setState(() {});
  }

  void deleteNote(int index) {
    box.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final notes = box.values.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Hive Notes")),
      body: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter Note: "),
          ),
          ElevatedButton(
            onPressed: addNote,
            child: Text('Add'),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notes[index]),
                    trailing: IconButton(
                        onPressed: () => deleteNote(index),
                        icon: Icon(Icons.delete)),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
