import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../helper/db_helper.dart';
import '../model/model_note.dart';

class AddNote extends StatefulWidget {
  final Note? note;
  const AddNote({super.key, this.note});

  @override
  State<AddNote> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<AddNote> with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  late final AnimationController _btnController;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _btnController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void saveNote() async {
    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi tidak boleh kosong')),
      );
      return;
    }
    _btnController.forward();

    final now = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
    final note = Note(
      id: widget.note?.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: now,
    );

    if (widget.note == null) {
      await DatabaseHelper.instance.insertNote(note);
    } else {
      await DatabaseHelper.instance.updateNote(note);
    }
    _btnController.reverse();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade800,
        centerTitle: true,
        title: Text(
          widget.note == null ? 'Tambah Catatan' : 'Edit Catatan',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Judul
              TextField(
                controller: _titleController,
                cursorColor: Colors.orange,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Judul catatan..',
                  hintStyle: const TextStyle(color: Colors.black38),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Iconsax.note_1, color: Colors.orange),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 16),

              // Input isi catatan
              TextField(
                controller: _contentController,
                cursorColor: Colors.orange,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.5,
                ),
                maxLines: 3, // Limit the number of lines
                decoration: InputDecoration(
                  hintText: 'Isi catatan..',
                  hintStyle: const TextStyle(color: Colors.black38),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

              const SizedBox(height: 20),

              // Spacer to push the button to the bottom
              const Spacer(),

              // Tombol simpan
              Center(
                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.08).animate(
                    CurvedAnimation(
                      parent: _btnController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: saveNote,
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.shade200.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}