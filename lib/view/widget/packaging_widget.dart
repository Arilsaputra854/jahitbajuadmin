import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/packaging_controller.dart';
import 'package:jahit_baju_admin/data/model/packaging.dart';
import 'package:jahit_baju_admin/util/util.dart'
    show convertToRupiah, loadingWidget;
import 'package:provider/provider.dart';

class PackagingWidget extends StatefulWidget {
  const PackagingWidget({super.key});

  @override
  State<PackagingWidget> createState() => _PackagingWidgetState();
}

class _PackagingWidgetState extends State<PackagingWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final controller = Provider.of<PackagingController>(
        context,
        listen: false,
      );
      controller.fetchAllPackaging();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PackagingController>(
      builder: (context, controller, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Packaging",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      controller.refresh();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.black),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  controller.setCurrentPackaging(null);
                  addNewPackaging(context, controller);
                },
                child: Icon(Icons.add),
              ),
              body: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.packaging.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.setCurrentPackaging(
                        controller.packaging[index],
                      );
                      addNewPackaging(context, controller);
                    },
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.packaging[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  controller.packaging[index].description,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  convertToRupiah(
                                    controller.packaging[index].price,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                controller
                                    .removePackaging(
                                      controller.packaging[index].id,
                                    )
                                    .then((_) {
                                      if (controller.errorMsg != null) {
                                        Fluttertoast.showToast(
                                          msg: controller.errorMsg!,
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Berhasil menghapus packaging!",
                                        );
                                      }
                                    });
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (controller.loading) loadingWidget(),
          ],
        );
      },
    );
  }
}

void addNewPackaging(BuildContext context, PackagingController controller) {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  if (controller.currentPackaging != null) {
    nameController.text = controller.currentPackaging!.name;
    descController.text = controller.currentPackaging!.description;
    priceController.text = controller.currentPackaging!.price.toString();
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Tambah Packaging"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama packaging",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: "Deskripsi packaging",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              controller: priceController,
              decoration: InputDecoration(
                labelText: "harga packaging",
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
            onPressed:
                controller.currentPackaging != null
                    ? () {
                      //update
                      if (descController.text.isNotEmpty &&
                          nameController.text.isNotEmpty &&
                          priceController.text.isNotEmpty) {
                        controller.updatePackaging(
                          nameController.text,
                          int.parse(priceController.text),
                          descController.text,
                        );
                        Navigator.pop(
                          context,
                        ); 
                        Fluttertoast.showToast(msg: "Berhasil memperbarui packaging!");
                      } else {
                        Fluttertoast.showToast(msg: "Silakan lengkapi kolom!");
                      }
                    }
                    : () {
                      //add
                      if (descController.text.isNotEmpty &&
                          nameController.text.isNotEmpty &&
                          priceController.text.isNotEmpty) {
                        controller.addPackaging(
                          descController.text,
                          int.parse(priceController.text),
                          nameController.text,
                        );
                        Navigator.pop(
                          context,
                        ); // Tutup dialog setelah menambahkan
                      } else {
                        Fluttertoast.showToast(msg: "Silakan lengkapi kolom!");
                      }
                    },
            child:
                controller.currentPackaging != null
                    ? Text("Update")
                    : Text("Simpan"),
          ),
        ],
      );
    },
  );
}
