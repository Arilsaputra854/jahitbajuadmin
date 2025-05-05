import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:jahit_baju_admin/controller/banner_controller.dart';
import 'package:jahit_baju_admin/data/model/app_banner.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/util/util.dart';
import 'package:provider/provider.dart';

class ModifyAppBanner extends StatefulWidget {
  final AppBanner? banner;

  const ModifyAppBanner({Key? key, this.banner}) : super(key: key);

  @override
  _ModifyAppBannerState createState() => _ModifyAppBannerState();
}

class _ModifyAppBannerState extends State<ModifyAppBanner> {
  late TextEditingController linkController;

  Uint8List? bannerFile;
  String? bannerUrl;

  @override
  void initState() {
    super.initState();
    bannerUrl = widget.banner?.imageUrl;
    linkController = TextEditingController(text: widget.banner?.link);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(centerTitle: true, title: Text("Modifikasi Banner")),
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
                            bannerUrl == null && bannerFile == null
                                ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
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
                                : bannerFile != null ? AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              
                                                return Image.memory(
                                                  bannerFile!,
                                                );
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: ()=>_removeImage(),
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
                                  ))
                                 : AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              
                                                return Image.network(
                                                  bannerUrl!,
                                                );
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: ()=>_removeImage(),
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
                                )
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),
                      _buildTextField("Link: (opsional)", linkController),

                      SizedBox(height: 20.h),
                      Center(
                        child: ElevatedButton(
                          onPressed:
                              widget.banner != null
                                  ? () {
                                    _saveChanges(controller);
                                  }
                                  : () {
                                    _saveBanner(controller);
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

  
  void _removeImage() {
    setState(() {
      bannerFile = null;
      bannerUrl = null; 
    });
  }


  Future<void> _pickFile() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

    if (bytesFromPicker != null) {
      setState(() {
        bannerFile = bytesFromPicker;
      });
      Fluttertoast.showToast(msg: "Berhasil menambahkan gambar");
    }
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

  _saveChanges(BannerController controller) async {
    // Simpan perubahan ke dalam objek Product
    if (widget.banner != null) {
      if (bannerFile != null) {
        String? uploadedFilename = await controller.uploadBanner(bannerFile!);
        bannerUrl = "${ApiService.baseUrl}upload/${uploadedFilename}";
      }

      AppBanner banner = AppBanner(
        id: widget.banner!.id,
        link: linkController.text,
        imageUrl: bannerUrl,
      );

      controller.updateBanner(banner).then((_) {
        Fluttertoast.showToast(msg: "Banner berhasil diperbarui!");
        Navigator.pop(context);
      });
    } else {
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan, tidak dapat melakukan update banner.",
      );
    }
  }

  _saveBanner(BannerController controller) {
    // Simpan perubahan ke dalam objek Product
    if (bannerFile != null) {
      controller.uploadBanner(bannerFile!).then((banner) {
        bannerUrl = "${ApiService.baseUrl}upload/${banner}";
        if (controller.errorMsg != null) {
          Fluttertoast.showToast(msg: controller.errorMsg!);
        } else {
          if (bannerUrl != null) {
            Fluttertoast.showToast(msg: "Berhasil mengupload file");
            String? text;
            if(linkController.text.isEmpty){
              text = "-";
            }else{
              text = linkController.text;
            }

            AppBanner newBanner = AppBanner(
              link: text,
              imageUrl: bannerUrl,
            );

            controller.addBanner(newBanner).then((_) {
              Fluttertoast.showToast(msg: "Banner berhasil ditambah!");
              Navigator.pop(context);
            });
          } else {
            Fluttertoast.showToast(msg: "Tidak dapat menambahkan foto Banner");
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
    linkController.dispose();
    super.dispose();
  }
}
