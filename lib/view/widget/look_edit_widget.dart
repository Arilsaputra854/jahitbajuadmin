import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/look_controller.dart';
import 'package:jahit_baju_admin/data/model/designer.dart';
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/data/model/look_texture.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class LookEditWidget extends StatefulWidget {
  final Look? look;
  final Designer? designer;

  const LookEditWidget({Key? key, this.look, this.designer}) : super(key: key);

  @override
  _LookEditWidgetPageState createState() => _LookEditWidgetPageState();
}

class _LookEditWidgetPageState extends State<LookEditWidget> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController lookPriceController;
  late TextEditingController weightController;
  final TextEditingController designUrlController = TextEditingController();

  List<String> selectedSizes = [];
  final List<String> sizes = ["S", "M", "L", "XL", "XXL", "XXXL", "ALL SIZE"];
  String? designUrl;
  List<String> _materials = [];
  List<LookTexture> _textures = [];
  List<String> _features = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.look?.name);
    descriptionController = TextEditingController(
      text: widget.look?.description,
    );
    priceController = TextEditingController(
      text: widget.look?.price.toString(),
    );
    lookPriceController = TextEditingController(
      text: widget.look?.lookPrice.toString(),
    );
    weightController = TextEditingController(
      text: widget.look?.weight.toString() ?? 500.toString(),
    );
    selectedSizes = widget.look?.size ?? [];

    designUrl = widget.look?.designUrl;
    _materials = widget.look?.materials ?? [];
    _textures = widget.look?.textures ?? [];
    _features = widget.look?.features ?? [];
  }

  void _showAddImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah link desain"),
          content: TextField(
            controller: designUrlController,
            decoration: InputDecoration(hintText: "Masukkan URL gambar"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (designUrlController.text.isNotEmpty) {
                  setState(() {
                    designUrl = designUrlController.text;
                    designUrlController.clear();
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LookController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:
                widget.look != null
                    ? Text("Modifikasi Look")
                    : Text("Tambah Look"),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100.h,
                    child:
                        designUrl == null
                            ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: AspectRatio(
                                aspectRatio: 4 / 5,
                                child: GestureDetector(
                                  onTap: _showAddImageDialog,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
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
                            )
                            : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
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
                                        child: FutureBuilder<String>(
                                          future: controller.fetchSvg(
                                            designUrl!,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Icon(Icons.error);
                                            } else {
                                              return SvgPicture.string(
                                                snapshot.data!,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap:
                                            () =>
                                                removeLook(context, controller),
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
                            ),
                  ),

                  SizedBox(height: 16.h),
                  _buildTextField("Nama Produk", nameController),
                  _buildTextField(
                    "Deskripsi",
                    descriptionController,
                    maxLines: 3,
                  ),
                  _buildTextField(
                    "Harga",
                    priceController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    "Harga Look",
                    lookPriceController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                  Text(
                    'Material Produk:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _materials.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addMaterial,
                    child: Text('+ Tambah Material'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bagian Produk:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _features.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: ListTile(
                          title: Text("${index + 1}. ${_features[index]}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _features.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addFeature,
                    child: Text('+ Tambah Bagian'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ukuran Tersedia",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  _buildTextField(
                    "Berat Look",
                    weightController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          widget.look != null
                              ? () {
                                _saveChanges(controller);
                              }
                              : () {
                                _saveLook(controller);
                              },
                      child:
                          widget.look != null
                              ? Text("Simpan Perubahan")
                              : Text("Simpan Look"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  void _addFeature() {
    showDialog(
      context: context,
      builder: (context) {
        String newFeature = '';
        return AlertDialog(
          title: Text('Tambah Bagian'),
          content: TextField(
            onChanged: (value) {
              newFeature = value.toLowerCase().replaceAll(' ', '-');
            },

            decoration: InputDecoration(
              hintText: 'Masukkan nama bagian (gunakan - untuk spasi)',
            ),
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
                if (newFeature.isNotEmpty) {
                  setState(() {
                    _features.add(newFeature);
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

  _saveChanges(LookController controller) {
    // Simpan perubahan ke dalam objek Product
    if (widget.look != null) {
      if (nameController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          lookPriceController.text.isNotEmpty &&
          selectedSizes.isNotEmpty) {

        Look updatedProduct = Look(
          id: widget.look!.id!,
          name: nameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          lookPrice: double.parse(lookPriceController.text),
          features: _features,
          sold: widget.look?.sold ?? 0,
          seen: widget.look?.seen ?? 0,
          materials: _materials,
          size: selectedSizes,
          lastUpdate: DateTime.now().toIso8601String(),
          designerId: widget.designer!.id!,
          designUrl: designUrl!,
          weight: int.parse(weightController.text),
        );
        controller.updateLook(updatedProduct).then((_) {
          if (controller.errorMsg != null) {
            Fluttertoast.showToast(msg: controller.errorMsg!);
          } else {
            Fluttertoast.showToast(msg: "Look berhasil diperbarui!");
            Navigator.pop(context);
          }
        });
      } else {
        Fluttertoast.showToast(
          msg: "Harap isi semua kolom sebelum menyimpan produk.",
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan, tidak dapat melakukan update produk.",
      );
    }
  }

  _saveLook(LookController controller) {
    // Simpan perubahan ke dalam objek Product
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        lookPriceController.text.isNotEmpty &&
        selectedSizes.isNotEmpty) {
      Look newLook = Look(
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        lookPrice: double.parse(lookPriceController.text),
        features: _features,
        sold: widget.look?.sold ?? 0,
        seen: widget.look?.seen ?? 0,
        materials: _materials,
        size: selectedSizes,
        lastUpdate: DateTime.now().toIso8601String(),
        designerId: widget.designer!.id!,
        designUrl: designUrl!,
        weight: int.parse(weightController.text),
      );

      controller.addLook(newLook).then((_) {
        if (controller.errorMsg != null) {
          Fluttertoast.showToast(msg: controller.errorMsg!);
        } else {
          Fluttertoast.showToast(msg: "Produk berhasil diperbarui!");
          Navigator.pop(context);
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
    lookPriceController.dispose();
    super.dispose();
  }

  void removeLook(BuildContext context, LookController controller) {
    if (widget.look != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Konfirmasi Hapus"),
            content: Text("Apakah Anda yakin ingin menghapus look ini?"),
            actions: [
              TextButton(
                onPressed:
                    () =>
                        Navigator.pop(context), // Tutup dialog tanpa menghapus
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.removeLook(widget.look!).then((_) {
                    if (controller.errorMsg != null) {
                      Fluttertoast.showToast(msg: "${controller.errorMsg}");
                    } else {
                      Fluttertoast.showToast(msg: "Berhasil menghapus look!");
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
  }
}
