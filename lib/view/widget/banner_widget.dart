import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/banner_controller.dart';
import 'package:jahit_baju_admin/data/model/app_banner.dart';
import 'package:jahit_baju_admin/util/util.dart';
import 'package:jahit_baju_admin/view/widget/app_banner_edit_widget.dart';
import 'package:provider/provider.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  void initState() {
    Future.microtask(() {
      final controller = Provider.of<BannerController>(context, listen: false);
      controller.fetchAllBanner();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerController>(
      builder: (context, controller, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Banner Aplikasi",
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
                  addNewAppBanner(context, controller);
                },
                child: Icon(Icons.add),
              ),
              body:
                  controller.appBanner.length > 0
                      ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.appBanner.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              modifyAppBanner(
                                context,
                                controller,
                                controller.appBanner[index],
                              );
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 100.h,child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                controller
                                                    .appBanner[index]
                                                    .imageUrl!,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Container(
                                                  color: Colors.grey[300],
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                      child: Icon(
                                                        Icons.broken_image,
                                                      ),
                                                    ),
                                          ),
                                        ),),

                                        Text(
                                          "Tautan: ${controller.appBanner[index].link ?? "-"}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller
                                            .removeAppBanner(
                                              controller.appBanner[index],
                                            )
                                            .then((_) {
                                              if (controller.errorMsg != null) {
                                                Fluttertoast.showToast(
                                                  msg: controller.errorMsg!,
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Berhasil menghapus banner!",
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
                      )
                      : Center(child: Text("Tidak ada App Banner")),
            ),
            if (controller.loading) loadingWidget(),
          ],
        );
      },
    );
  }

  void modifyAppBanner(
    BuildContext context,
    BannerController controller,
    AppBanner appBanner,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModifyAppBanner(banner: appBanner),
      ),
    ).then((_) {
      controller.refresh();
    });
  }

  void addNewAppBanner(BuildContext context, BannerController controller) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ModifyAppBanner()),
    ).then((_) {
      controller.refresh();
    });
  }
}
