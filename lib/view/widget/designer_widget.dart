import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/designer_controller.dart';
import 'package:jahit_baju_admin/data/model/designer.dart';
import 'package:jahit_baju_admin/view/widget/look_widget.dart';
import 'package:provider/provider.dart';
Widget designerWidget(BuildContext context) {
  return Consumer<DesignerController>(
    builder: (context, controller, child) {
      controller.fetchAllDesigners();
      return Scaffold(
        appBar: AppBar(
          actions: [
                TextButton.icon(
                  onPressed: () {
                    controller.refresh();
                  }, // Fungsi untuk refresh data
                  icon: Icon(Icons.refresh, color: Colors.black),
                  label: Text("Refresh", style: TextStyle(color: Colors.black)),
                ),
              ],
              centerTitle: true,
              title: Text("Desainer",
                style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.designers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Text(
                            controller.designers[index].name,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          /// **Deskripsi Designer**
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Showcase: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: controller.designers[index].description,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        removeDesigner(context,controller,controller.designers[index]);
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> LookWidget(designer: controller.designers[index])));
            },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addNewDesigner(context, controller);
          },
          child: Icon(Icons.add),
        ),
      );
    },
  );
}

void removeDesigner(
  BuildContext context,
  DesignerController controller,
  Designer designer,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus desainer ini?"),
        actions: [
          TextButton(
            onPressed:
                () => Navigator.pop(context), // Tutup dialog tanpa menghapus
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeDesigner(designer).then((_) {
                if (controller.errorMsg != null) {
                  Fluttertoast.showToast(msg: "${controller.errorMsg}");
                } else {
                  Fluttertoast.showToast(msg: "Berhasil menghapus desainer!");
                  controller.refresh();
                  Navigator.pop(context);
                }
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}


void addNewDesigner(BuildContext context, DesignerController controller) {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Tambah Designer"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama Designer",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: "Deskripsi Showcase",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog tanpa menyimpan
            },
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              //add
              if (descController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                controller.addDesigner(
                  Designer(
                    name: nameController.text,
                    description: descController.text,
                  ),
                );
                Navigator.pop(context); // Tutup dialog setelah menambahkan
              } else {
                Fluttertoast.showToast(msg: "Silakan lengkapi kolom!");
              }
            },
            child: Text("Tambah Designer"),
          ),
        ],
      );
    },
  );
}
