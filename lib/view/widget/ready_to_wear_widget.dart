import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/costumer_controller.dart';
import 'package:jahit_baju_admin/controller/product_controller.dart';
import 'package:jahit_baju_admin/controller/shipping_controller.dart';
import 'package:jahit_baju_admin/data/model/product.dart';
import 'package:jahit_baju_admin/util/util.dart'
    show convertToRupiah, loadingWidget;
import 'package:jahit_baju_admin/view/widget/delivery_widget.dart';
import 'package:jahit_baju_admin/view/widget/ready_to_wear_edit_widget.dart';
import 'package:provider/provider.dart';

Widget readyToWearWidget(BuildContext context, {int weight = 500}) {
  return Consumer<ProductController>(
    builder: (context, controller, child) {
      controller.fetchAllProduct();
      return Stack(
        children: [
          Scaffold(
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
              title: Text(
                "Data Produk Ready to Wear",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                addNewProduct(context, controller);
              },
              child: Icon(Icons.add),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    controller.setCurrentProduct(controller.products[index]);
                    goToModifyProduct(context, controller);
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
                          Expanded(child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    controller.products[index].imageUrl[0],
                                errorWidget: (context, url, error) {
                                  return Icon(Icons.warning);
                                },
                                width: 100.w,
                              ),
                              SizedBox(width: 20),
                              Expanded(child: 
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.products[index].productCode ?? "Tidak ada Kode Produk",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Text(
                                    controller.products[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                 Text(
                                      controller.products[index].description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                      softWrap: true,
                                    ),
                                  Text(
                                    convertToRupiah(
                                      controller.products[index].price,
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Text(
                                    "${controller.products[index].favorite} menyukai produk ini"
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  
                                  Text(
                                    "${controller.products[index].sold} terjual"
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  Text(
                                    "${controller.products[index].seen} orang melihat"
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),)
                            ],
                          ),),
                          IconButton(
                            onPressed: () {
                              removeProduct(
                                context,
                                controller,
                                controller.products[index],
                              );
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

void goToModifyProduct(BuildContext context, ProductController controller) {
  if (controller.currentProduct != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ModifyProductPage(product: controller.currentProduct!),
      ),
    );
  }
}

void removeProduct(
  BuildContext context,
  ProductController controller,
  Product product,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(
            onPressed:
                () => Navigator.pop(context), // Tutup dialog tanpa menghapus
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeProduct(product).then((_) {
                if (controller.errorMsg != null) {
                  Fluttertoast.showToast(msg: "${controller.errorMsg}");
                } else {
                  Fluttertoast.showToast(msg: "Berhasil menghapus produk!");
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

void addNewProduct(BuildContext context, ProductController controller) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ModifyProductPage()),
  ).then((_) {
    controller.refresh();
  });
}
