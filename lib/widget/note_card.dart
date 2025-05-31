import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../model/model_note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFCBA4), // Custom peach color
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Adjust height to content
          children: [
            /// Top Row: Title + Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                /// Popup Menu
                PopupMenuButton<String>(
                  icon: const Icon(Iconsax.more, color: Colors.orange),
                  onSelected: (value) {
                    if (value == 'edit') {
                      if (onEdit != null) onEdit!();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: const [
                          Icon(Iconsax.trash, color: Colors.orangeAccent, size: 18),
                          SizedBox(width: 8),
                          Text("Hapus"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Note Content
            Text(
              note.content,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),

            const SizedBox(height: 12),

            /// Bottom Row: Date + Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      const Icon(Iconsax.calendar, size: 14, color: Colors.orange),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          note.date,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Iconsax.note_text, size: 14, color: Colors.orange),
              ],
            ),
          ],
        ),
      ).animate().fade(duration: 400.ms).slideY(begin: 0.3, duration: 400.ms),
    );
  }
}