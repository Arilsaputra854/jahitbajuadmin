import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/note_controller.dart';
import 'package:jahit_baju_admin/data/model/note.dart';
import 'package:jahit_baju_admin/data/model/product.dart';
import 'package:provider/provider.dart';

class ProductNoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteController>(
      builder: (context, controller, child) {
        controller.fetchNote();

        TextEditingController customController = TextEditingController(
          text: controller.customNote?.data ?? "",
        );
        TextEditingController rtwController = TextEditingController(
          text: controller.rtwNote?.data ?? "",
        );

        return Scaffold(
          appBar: AppBar(title: Text("Catatan Produk")),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNoteSection(
                  title: "Catatan Produk Ready to Wear",
                  note: controller.rtwNote,
                  controller: rtwController,
                  onSave: () {
                    _saveNote(
                      controller,
                      controller.rtwNote!,
                      rtwController.text
                    );
                  },
                ),
                SizedBox(height: 24),
                _buildNoteSection(
                  title: "Catatan Produk Kustomisasi",
                  note: controller.customNote,
                  controller: customController,
                  onSave: () {
                    _saveNote(
                      controller,
                      controller.customNote!,
                      customController.text
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoteSection({
    required String title,
    required Note? note,
    required TextEditingController controller,
    required VoidCallback onSave,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            note?.data ?? "Tidak ada catatan",
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Edit Catatan",
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: Colors.red, // Latar belakang merah
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          ),
          onPressed: onSave,
          child: Text("Simpan Perubahan",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.sp),),
        ),
      ],
    );
  }

  void _saveNote(NoteController controller, Note note, String text) {
    controller.updateNote(note, text);
    if (controller.errorMsg != null) {
      Fluttertoast.showToast(msg: controller.errorMsg!);
    } else {
      Fluttertoast.showToast(msg: "Perubahan disimpan!",);
    }
  }
}
