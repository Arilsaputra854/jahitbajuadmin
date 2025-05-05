import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:jahit_baju_admin/controller/look_controller.dart';
import 'package:jahit_baju_admin/data/model/designer.dart';
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/data/model/look_texture.dart';
import 'package:jahit_baju_admin/data/model/texture.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/util/util.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

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

  final List<String> sizes = ["S", "M", "L", "XL", "XXL", "XXXL", "ALL SIZE"];
  String? designUrl;
  Uint8List? designFile;

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

    final controller = Provider.of<LookController>(context, listen: false);
    Future.microtask(() {
      controller.getTextures();
      controller.setSelectedSize(widget.look?.size);
      controller.setMaterials(widget.look?.materials);
      controller.setFeatures(widget.look?.features);
    });
    designUrl = widget.look?.designUrl;
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
                        child:
                            designUrl == null && designFile == null
                                ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 5,
                                    child: GestureDetector(
                                      onTap: _pickFile,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                            child: Builder(
                                              builder: (context) {
                                                if (designUrl != null) {
                                                  return FutureBuilder<String?>(
                                                    future: controller.fetchSvg(
                                                      designUrl!,
                                                    ),
                                                    builder: (
                                                      context,
                                                      snapshot,
                                                    ) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return CircularProgressIndicator();
                                                      } else if (snapshot
                                                          .hasError && snapshot.data == null) {
                                                        return Icon(
                                                          Icons.error,
                                                        );
                                                      } else {
                                                        return SvgPicture.string(
                                                          snapshot.data!,
                                                        );
                                                      }
                                                    },
                                                  );
                                                } else if (designFile != null) {
                                                  return SvgPicture.string(
                                                    utf8.decode(designFile!),
                                                  );
                                                } else {
                                                  return SizedBox();
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
                                                () => removeLook(
                                                  context,
                                                  controller,
                                                ),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextField(
                        "Harga Look",
                        lookPriceController,
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
                        itemCount: controller.materials.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: ListTile(
                              title: Text(
                                "${index + 1}. ${controller.materials[index]}",
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  controller.removeMaterial(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _addMaterial(controller),
                        child: Text('+ Tambah Material'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bagian Produk:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.features.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: ListTile(
                              title: Text(
                                "${index + 1}. ${controller.features[index]}",
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  controller.removeFeature(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 10),
                      Text(
                        'Texture Produk:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.textures.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading:
                                  controller.textures[index].urlTexture != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              controller
                                                  .textures[index]
                                                  .urlTexture!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(
                                            int.parse(
                                              controller.textures[index].hex!
                                                  .replaceAll("#", "FF"),
                                              radix: 16,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                              title: Text(
                                "${controller.textures[index].hex != null ? "Warna :" : "Texture :"} ${controller.textures[index].title}",
                              ),
                              subtitle: Text(
                                controller.textures[index].description ?? "-",
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  controller.removeTexture(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await showAddTextureDialog(
                                context,
                                Colors.white,
                                controller,
                              );
                            },
                            child: Text('+ Tambah Warna'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await showAddTextureDialog(
                                context,
                                Colors.white,
                                controller,
                                isImage: true,
                              );
                            },
                            child: Text('+ Tambah Texture'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Ukuran Tersedia",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        children:
                            sizes.map((size) {
                              return FilterChip(
                                label: Text(size),
                                selected: controller.selectedSizes.contains(
                                  size,
                                ),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    controller.selectedSizes.add(size);
                                  } else {
                                    controller.selectedSizes.remove(size);
                                  }
                                },
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        "Berat Look",
                        weightController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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

              if (controller.loading) loadingWidget(),
            ],
          ),
        );
      },
    );
  }

  void _addMaterial(LookController controller) {
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
                  controller.addMaterial(newMaterial);
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

  void _addTexture(LookController controller) {
    showDialog(
      context: context,
      builder: (context) {
        String newMaterial = '';
        return AlertDialog(
          title: Text('Tambah File Texture'),
          content: TextField(
            onChanged: (value) {
              newMaterial = value;
            },
            decoration: InputDecoration(hintText: 'Masukkan '),
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
                  controller.addMaterial(newMaterial);
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

  void _addFeature(LookController controller) {
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
                  controller.addFeature(newFeature);
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

  _saveChanges(LookController controller) async {
    // Simpan perubahan ke dalam objek Product
    if (widget.look != null) {
      if (nameController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          lookPriceController.text.isNotEmpty &&
          controller.selectedSizes.isNotEmpty) {
        if (designFile != null) {
          String? uploadedLookUrl = await controller.uploadImage(designFile!);
          if (uploadedLookUrl != null) {
            designUrl = "${ApiService.baseUrl}upload/$uploadedLookUrl";
          }
        }

        Look updatedProduct = Look(
          id: widget.look!.id!,
          name: nameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          lookPrice: double.parse(lookPriceController.text),
          features: controller.features,
          sold: widget.look?.sold ?? 0,
          seen: widget.look?.seen ?? 0,
          materials: controller.materials,
          size: controller.selectedSizes,
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

  _saveLook(LookController controller) async {
    // Simpan perubahan ke dalam objek Product
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        lookPriceController.text.isNotEmpty &&
        controller.selectedSizes.isNotEmpty &&
        designFile != null) {
      String? uploadedLookUrl = await controller.uploadImage(designFile!);
      if (uploadedLookUrl != null) {
        designUrl = "${ApiService.baseUrl}upload/$uploadedLookUrl";
      }
      Look newLook = Look(
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        lookPrice: double.parse(lookPriceController.text),
        features: controller.features,
        sold: widget.look?.sold ?? 0,
        seen: widget.look?.seen ?? 0,
        materials: controller.materials,
        size: controller.selectedSizes,
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
    setState(() {
      designUrl = null;
      designFile = null;
    });
  }

  Future<void> _pickFile() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

    if (bytesFromPicker != null) {
      setState(() {
        designFile = bytesFromPicker;
      });
      Fluttertoast.showToast(msg: "Berhasil menambahkan gambar");
    }
  }

  Future<void> showAddTextureDialog(
    BuildContext context,
    Color initialColor,
    LookController controller, {
    bool isImage = false,
  }) async {
    Color selectedColor = initialColor;
    Uint8List? selectedImageTexture;

    final TextEditingController hexController = TextEditingController(
      text: colorToHex(initialColor),
    );
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Tambah Texture Baru'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul / Title
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Judul Texture",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Deskripsi
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: "Deskripsi",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 16),

                    if (isImage)
                      Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              Uint8List? bytesFromPicker =
                                  await ImagePickerWeb.getImageAsBytes();

                              if (bytesFromPicker != null) {
                                // Cek ukuran file maksimal 2MB
                                final maxSizeInBytes = 2 * 1024 * 1024; // 2MB
                                if (bytesFromPicker.lengthInBytes >
                                    maxSizeInBytes) {
                                  setState(() {
                                    Fluttertoast.showToast(
                                      msg: "Ukuran gambar melebihi 2MB.",
                                    );
                                    selectedImageTexture = null;
                                  });
                                  return;
                                }

                                final image = img.decodeImage(bytesFromPicker);
                                if (image == null) {
                                  setState(() {
                                    Fluttertoast.showToast(
                                      msg: "Gagal membaca gambar.",
                                    );
                                    selectedImageTexture = null;
                                  });
                                  return;
                                }

                                final width = image.width;
                                final height = image.height;
                                final aspectRatio = width / height;

                                const expectedRatio = 2 / 5;
                                const tolerance = 0.01;
                                if ((aspectRatio - expectedRatio).abs() >
                                    tolerance) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Rasio gambar harus 2:5. (misal 200x500)",
                                  );
                                  return;
                                }

                                setState(() {
                                  selectedImageTexture = bytesFromPicker;
                                });
                              }
                            },
                            icon: Icon(Icons.image),
                            label: Text("Pilih gambar"),
                          ),
                          if (selectedImageTexture != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Image.memory(
                                selectedImageTexture!,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                        ],
                      )
                    else ...[
                      ColorPicker(
                        pickerColor: selectedColor,
                        onColorChanged: (color) {
                          setState(() {
                            selectedColor = color;
                            hexController.text = colorToHex(color);
                          });
                        },
                        enableAlpha: false,
                        showLabel: true,
                        pickerAreaHeightPercent: 0.6,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: hexController,
                        decoration: InputDecoration(
                          labelText: "Kode Hex (tanpa #)",
                          prefixText: "#",
                          border: OutlineInputBorder(),
                        ),
                        maxLength: 6,
                        onChanged: (value) {
                          if (value.length == 6) {
                            try {
                              final color = hexToColor(value);
                              setState(() {
                                selectedColor = color;
                              });
                            } catch (_) {}
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Batal'),
                  onPressed: () => Navigator.of(context).pop(null),
                ),
                ElevatedButton(
                  child: Text('Tambah'),
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      if (isImage && selectedImageTexture != null) {
                        String? uploadedLookUrl = await controller
                            .uploadLookTexture(selectedImageTexture!);

                        if (uploadedLookUrl != null) {
                          uploadedLookUrl =
                              "${ApiService.baseUrl}upload/${uploadedLookUrl}";
                          controller
                              .uploadTexture(
                                widget.look!.id!,
                                titleController.text,
                                descController.text,
                                url_texture: uploadedLookUrl,
                              )
                              .then((texture) {
                                if (controller.errorMsg != null) {
                                  Fluttertoast.showToast(
                                    msg: controller.errorMsg!,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Berhasil menambah tekstur gambar",
                                  );

                                  Navigator.pop(context);
                                  controller.getTextures();
                                }
                              });
                        }
                      } else if (!isImage) {
                        controller
                            .uploadTexture(
                              widget.look!.id!,
                              titleController.text,
                              descController.text,
                              hex: colorToHex(selectedColor),
                            )
                            .then((texture) {
                              if (controller.errorMsg != null) {
                                Fluttertoast.showToast(
                                  msg: controller.errorMsg!,
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Berhasil menambah tekstur warna",
                                );
                                Navigator.pop(context);
                                controller.getTextures();
                              }
                            });
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  String colorToHex(Color color) {
    return color.value.toRadixString(16).substring(2).toUpperCase();
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "").padLeft(6, '0');
    return Color(int.parse("FF$hex", radix: 16));
  }
}
