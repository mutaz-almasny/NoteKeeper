import 'package:flutter/material.dart';
import 'package:notes/sqldb.dart';

class EditNotes extends StatefulWidget {
  const EditNotes({super.key, required this.note});

  final Map note;

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _title;

  late TextEditingController _note;

  final SqlDB _sqlDB = SqlDB();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title = TextEditingController(text: widget.note["title"]);
    _note = TextEditingController(text: widget.note["note"]);
  }

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

      // final data = await _sqlDB.updateData(
      //   "UPDATE notes set title = '$title', note= '$note' where id = '${widget.note["id"]}'",
      // );

      final data = await _sqlDB.update("notes", {
        "title": title,
        "note ": note,
      }, widget.note["id"].toString());

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
                    child: const Text("Save"),
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
