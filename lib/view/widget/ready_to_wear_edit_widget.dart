import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:jahit_baju_admin/controller/product_controller.dart';
import 'package:jahit_baju_admin/data/model/product.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/util/util.dart';
import 'package:provider/provider.dart';

class ModifyProductPage extends StatefulWidget {
  final Product? product;

  const ModifyProductPage({Key? key, this.product}) : super(key: key);

  @override
  _ModifyProductPageState createState() => _ModifyProductPageState();
}

class _ModifyProductPageState extends State<ModifyProductPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController categoryController;
  late TextEditingController tagController;
  late TextEditingController stockController;
  late TextEditingController productCodeController;

  List<String> selectedSizes = [];
  final List<String> sizes = ["S", "M", "L", "XL", "XXL", "XXXL", "ALL SIZE"];
  List<String> imageUrls = [];
  List<String> _materials = [];
  List<Uint8List> imageFiles = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name);
    descriptionController = TextEditingController(
      text: widget.product?.description,
    );
    priceController = TextEditingController(
      text: widget.product?.price.toString(),
    );
    categoryController = TextEditingController(
      text: widget.product?.category?.join(", ") ?? "",
    );
    tagController = TextEditingController(
      text: widget.product?.tags.join(", "),
    );
    stockController = TextEditingController(
      text: widget.product?.stock.toString(),
    );
    productCodeController = TextEditingController(
      text: widget.product?.productCode.toString(),
    );
    selectedSizes = widget.product?.size ?? [];

    imageUrls = widget.product?.imageUrl ?? [];
    _materials = widget.product?.materials ?? [];
  }

  void _removeImage(int index) {
    setState(() {
      imageUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(centerTitle: true, title: Text("Modifikasi Produk")),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    imageUrls.length + imageFiles.length + 1,

                                itemBuilder: (context, index) {
                                  if (index ==
                                      imageUrls.length + imageFiles.length) {
                                    // Kotak tambah gambar
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 4 / 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            _pickFile();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (index < imageUrls.length) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 4 / 5,
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ), // Tambahkan border
                                                borderRadius: BorderRadius.circular(
                                                  8,
                                                ), // Sesuaikan dengan kotak tambah
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                  8,
                                                ), // Pastikan gambar juga mengikuti border
                                                child: CachedNetworkImage(
                                                  imageUrl: imageUrls[index],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: GestureDetector(
                                                onTap:
                                                    () => _removeImage(index),
                                                child: CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: Colors.red,
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    final fileIndex = index - imageUrls.length;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 4 / 5,
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.memory(
                                                  imageFiles[fileIndex],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    imageFiles.removeAt(
                                                      fileIndex,
                                                    );
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: Colors.red,
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),
                      _buildTextField("Kode Produk", productCodeController),
                      _buildTextField("Nama Produk", nameController),
                      _buildTextField(
                        "Deskripsi",
                        descriptionController,
                        maxLines: 3,
                      ),
                      _buildTextField(
                        "Harga",
                        priceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextField(
                        "Kategori (pisahkan dengan koma)",
                        categoryController,
                      ),
                      _buildTextField(
                        "Tag Produk (pisahkan dengan koma)",
                        tagController,
                      ),
                      _buildTextField(
                        "Stok Produk",
                        stockController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                      ),
                      Text(
                        'Material Produk:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _materials.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: ListTile(
                              title: Text("${index + 1}. ${_materials[index]}"),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _materials.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _addMaterial,
                        child: Text('+ Tambah Material'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Ukuran Tersedia",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        spacing: 8.0,
                        children:
                            sizes.map((size) {
                              return FilterChip(
                                label: Text(size),
                                selected: selectedSizes.contains(size),
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedSizes.add(size);
                                    } else {
                                      selectedSizes.remove(size);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: ElevatedButton(
                          onPressed:
                              widget.product != null
                                  ? () {
                                    _saveChanges(controller);
                                  }
                                  : () {
                                    _saveProduct(controller);
                                  },
                          child: Text("Simpan Perubahan"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.loading) loadingWidget(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFile() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

    if (bytesFromPicker != null) {
      setState(() {
        imageFiles.add(bytesFromPicker);
      });
      Fluttertoast.showToast(msg: "Berhasil menambahkan gambar");
    }
  }

  void _addMaterial() {
    showDialog(
      context: context,
      builder: (context) {
        String newMaterial = '';
        return AlertDialog(
          title: Text('Tambah Material'),
          content: TextField(
            onChanged: (value) {
              newMaterial = value;
            },
            decoration: InputDecoration(hintText: 'Masukkan nama material'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (newMaterial.isNotEmpty) {
                  setState(() {
                    _materials.add(newMaterial);
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters, // Tambahkan input formatters
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        inputFormatters: inputFormatters, // Terapkan input formatters
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  _saveChanges(ProductController controller) async {
    // Simpan perubahan ke dalam objek Product
    if (widget.product != null) {
      List<String> finalImageUrls = List.from(imageUrls);

      if (imageFiles.isNotEmpty) {
        // Upload gambar baru
        List<String> uploadedUrls = await controller.uploadImage(imageFiles);
        final modifiedImageUrls =
            uploadedUrls
                .map((filename) => "${ApiService.baseUrl}upload/$filename")
                .toList();
        finalImageUrls.addAll(modifiedImageUrls);
      }

      Product updatedProduct = Product(
        id: widget.product!.id,
        
        name: nameController.text,
        description: descriptionController.text,
        price: double.tryParse(priceController.text) ?? widget.product!.price,
        imageUrl: finalImageUrls,
        category:
            categoryController.text.split(",").map((e) => e.trim()).toList(),
        tags: tagController.text.split(",").map((e) => e.trim()).toList(),
        stock: int.parse(stockController.text),
        sold: widget.product!.sold,
        seen: widget.product!.seen,
        favorite: widget.product!.favorite,
        materials: _materials,
        size: selectedSizes,
        productCode: productCodeController.text,
        lastUpdate: DateTime.now().toIso8601String(),
      );

      controller.updateProduct(updatedProduct).then((_) {
        Fluttertoast.showToast(msg: "Produk berhasil diperbarui!");
        Navigator.pop(context);
      });
    } else {
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan, tidak dapat melakukan update produk.",
      );
    }
  }

  _saveProduct(ProductController controller) {
    // Simpan perubahan ke dalam objek Product
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        categoryController.text.isNotEmpty &&
        tagController.text.isNotEmpty &&
        stockController.text.isNotEmpty &&
        selectedSizes.isNotEmpty && productCodeController.text.isNotEmpty) {
      controller.uploadImage(imageFiles).then((listImageUrls) {
        final modifiedImageUrls =
            listImageUrls
                .map((filename) => "${ApiService.baseUrl}upload/$filename")
                .toList();
        if (controller.errorMsg != null) {
          Fluttertoast.showToast(msg: controller.errorMsg!);
        } else {
          if (listImageUrls.isNotEmpty) {
            Fluttertoast.showToast(msg: "Berhasil mengupload file");
            Product newProduct = Product(
              name: nameController.text,
              productCode: productCodeController.text,
              description: descriptionController.text,
              price: double.parse(priceController.text),
              imageUrl: modifiedImageUrls,
              category:
                  categoryController.text
                      .split(",")
                      .map((e) => e.trim())
                      .toList(),
              tags: tagController.text.split(",").map((e) => e.trim()).toList(),
              stock: int.parse(stockController.text),
              sold: 0,
              seen: 0,
              favorite: 0,
        materials: _materials,
              size: selectedSizes,
              lastUpdate: DateTime.now().toIso8601String(),
            );

            controller.addProduct(newProduct).then((_) {
              Fluttertoast.showToast(msg: "Produk berhasil diperbarui!");
              Navigator.pop(context);
            });
          } else {
            Fluttertoast.showToast(msg: "Tidak dapat menambahkan foto produk");
          }
        }
      });
    } else {
      Fluttertoast.showToast(
        msg: "Harap isi semua kolom sebelum menyimpan produk.",
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    categoryController.dispose();
    tagController.dispose();
    stockController.dispose();
    super.dispose();
  }
}
