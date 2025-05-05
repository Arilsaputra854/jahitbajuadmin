import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:jahit_baju_admin/controller/privacy_controller.dart';
import 'package:jahit_baju_admin/controller/product_care_term_controller.dart';
import 'package:jahit_baju_admin/util/util.dart';
import 'package:provider/provider.dart';

class ProductCareTermWidget extends StatefulWidget {
  const ProductCareTermWidget({super.key});

  @override
  State<ProductCareTermWidget> createState() => _ProductCareTermWidgetState();
}

class _ProductCareTermWidgetState extends State<ProductCareTermWidget> {
  TextEditingController htmlController = TextEditingController();

  @override
  void initState() {
    
      final controller = Provider.of<ProductCareTermController>(context, listen: false);
    Future.microtask((){
      controller.fetchProductCareTerm();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductCareTermController>(
      builder: (context, controller, child) {
        htmlController.text = controller.term ?? "";

        return Stack(children:[ Scaffold(
          appBar: AppBar(title: Text("Panduan Perawatan Pakaian")),
          body: Column(
            children: [
              // Preview HTML
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Text(controller.term ?? "Tidak ada panduan"),
              ),

              // Editor + Simpan Perubahan
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: htmlController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Edit",
                      ),
                    ),
                    SizedBox(height: 16),

                    // Tombol Simpan Perubahan
                    ElevatedButton(
                      onPressed: () {
                        String editedHtml = htmlController.text;
                        controller.updateProductCareTerm(editedHtml);
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
            ],
          ),
        ),
        if(controller.loading) loadingWidget()],);
      },
    );
  }
}
