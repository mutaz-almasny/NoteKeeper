import 'package:flutter/material.dart';
import 'package:notes/edit_notes.dart';
import 'package:notes/sqldb.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDB sqlDB = SqlDB();
  List<Map> notes = [];
  bool isLoading = true;

  Future<void> _readData() async {
    // List<Map> response = await sqlDB.readData("SELECT * from notes");
    List<Map> response = await sqlDB.read("notes");
    notes.addAll(response);
    isLoading = false;

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NoteKeeper")),
      body: Center(
        child: Column(
          spacing: 15,
          crossAxisAlignment: .center,
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          notes[index]["title"],
                          style: TextStyle(fontWeight: .bold, fontSize: 20),
                        ),
                        subtitle: Text(notes[index]["note"]),
                        trailing: Row(
                          mainAxisSize: .min,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditNotes(
                                    note: {
                                      "id": notes[index]["id"],
                                      "title": notes[index]["title"],
                                      "note": notes[index]["note"],
                                    },
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              onPressed: () async {
                                int id = notes[index]["id"];
                                // int data = await sqlDB.deleteData(
                                //   "DELETE FROM notes WHERE id = '$id'",
                                // );
                                int data = await sqlDB.delete(
                                  "notes",
                                  id.toString(),
                                );
                                if (data > 0) {
                                  notes.removeWhere((e) => e["id"] == id);
                                }
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("addNote"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
