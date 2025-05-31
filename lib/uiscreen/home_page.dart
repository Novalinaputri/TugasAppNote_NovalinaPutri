import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tugas_aplikasi_note/model/model_note.dart';
import 'package:tugas_aplikasi_note/uiscreen/add_note.dart';
import 'package:tugas_aplikasi_note/widget/note_card.dart';
import '../helper/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() async {
    final data = await DatabaseHelper.instance.getNotes();
    setState(() => notes = data);
  }

  void onSearch(String value) {
    setState(() => searchQuery = value.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = notes.where((note) {
      return note.title.toLowerCase().contains(searchQuery) ||
          note.content.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade600,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.format_align_left, size: 28, color: Colors.white),
                      const SizedBox(width: 10),
                      const Text(
                        "My Notes",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "gambar/aing.jpg",
                          height: 46,
                          width: 46,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Search Bar
                  TextField(
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Iconsax.search_normal, color: Colors.orange),
                      suffixIcon: IconButton(
                        icon: const Icon(Iconsax.microphone_2, color: Colors.orange),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Fitur voice belum tersedia"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black87),
                    cursorColor: Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // List Notes
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: filteredNotes.isEmpty
                    ? Center(
                  child: Text(
                    searchQuery.isEmpty ? 'Belum ada catatan' : 'Catatan tidak ditemukan 😢',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
                    : GridView.builder(
                  itemCount: filteredNotes.length,
                  padding: const EdgeInsets.only(bottom: 60),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return NoteCard(
                      note: filteredNotes[index],
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddNote(note: filteredNotes[index]),
                          ),
                        );
                        fetchNotes();
                      },
                      onDelete: () async {
                        await DatabaseHelper.instance.deleteNote(filteredNotes[index].id!);
                        fetchNotes();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade600,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNote()),
          );
          fetchNotes();
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }
}