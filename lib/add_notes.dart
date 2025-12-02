import 'package:flutter/material.dart';
import 'package:notes/sqldb.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();

  final TextEditingController _note = TextEditingController();

  final SqlDB _sqlDB = SqlDB();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _title.dispose();
    _note.dispose();
  }

  Future<void> _save(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final title = _title.text;
      final note = _note.text;

      // final data = await _sqlDB.insertData(
      //   "INSERT INTO notes (title,note) values('$title', '$note')",
      // );
      final data = await _sqlDB.insert("notes", {"title": title, "note": note});

      if (data > 0) {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("Add Notes")),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: InputDecoration(hint: Text("Title")),
                  ),
                  TextFormField(
                    controller: _note,
                    decoration: InputDecoration(hint: Text("Note")),
                  ),

                  ElevatedButton(
                    onPressed: () => _save(context),
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
