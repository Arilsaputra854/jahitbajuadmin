import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:jahit_baju_admin/controller/privacy_controller.dart';
import 'package:provider/provider.dart';

Widget termConditionWidget(BuildContext privacy) {
  TextEditingController htmlController = TextEditingController();

  return Consumer<PrivacyController>(
    builder: (context, controller, child) {
      controller.fetchPrivacy();

      // Format HTML agar lebih rapi
      String formattedHtml = formatHtml(controller.privacy ?? "");
      htmlController.text = formattedHtml;

      return Scaffold(
        appBar: AppBar(title: Text("Syarat & Ketentuan")),
        body: Row(
          children: [
            // Preview HTML
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Html(data: formattedHtml),
              ),
            ),

            // HTML Editor + Simpan Perubahan
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: htmlController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Edit HTML",
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Tombol Simpan Perubahan
                    ElevatedButton(
                      onPressed: () {
                        String editedHtml = htmlController.text;
                        controller.updatePrivacy(editedHtml);
                        if (controller.errorMsg != null) {
                          Fluttertoast.showToast(msg: controller.errorMsg!);
                        } else {
                          Fluttertoast.showToast(msg: "Perubahan disimpan!");
                          controller.refresh();
                        }
                      },
                      child: Text("Simpan Perubahan"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Fungsi untuk memformat HTML agar lebih rapi
String formatHtml(String htmlString) {
  dom.Document document = html_parser.parse(htmlString);
  return document.outerHtml; // Mengembalikan HTML yang sudah terstruktur
}
