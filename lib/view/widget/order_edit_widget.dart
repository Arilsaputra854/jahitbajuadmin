import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/order_controller.dart';
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/data/model/product.dart';
import 'package:jahit_baju_admin/util/util.dart';
import 'package:jahit_baju_admin/data/model/order.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ModifyOrderWidget extends StatefulWidget {
  final Order order;

  const ModifyOrderWidget({Key? key, required this.order}) : super(key: key);

  @override
  _ModifyOrderWidgetState createState() => _ModifyOrderWidgetState();
}

class _ModifyOrderWidgetState extends State<ModifyOrderWidget> {
  late TextEditingController discountController;
  late TextEditingController resiController;
  late TextEditingController descriptionController;
  String selectedOrderStatus = Order.WAITING_FOR_PAYMENT;
  

  @override
  void initState() {
    super.initState();
    discountController = TextEditingController(
      text: widget.order.discount.toString(),
    );
    resiController = TextEditingController(text: widget.order.resi);
    descriptionController = TextEditingController(
      text: widget.order.description ?? "",
    );
    selectedOrderStatus = widget.order.orderStatus;
  }

  @override
  void dispose() {
    discountController.dispose();
    resiController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Modifikasi Order"),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCardInfo(),
                  _buildOrderItem(controller),
                  SizedBox(height: 16.h),
                  _buildTextField("Diskon", discountController, true),
                  _buildTextField("Resi", resiController, false),
                  _buildTextField("Deskripsi", descriptionController, false),
                  widget.order.orderStatus != Order.WAITING_FOR_PAYMENT
                      ? _buildDropdown()
                      : Text("Status Order : ${widget.order.orderStatus}"),
                  SizedBox(height: 24.h),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Text(
              "Detail Order",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            _buildInfoTile("Shipping ID", widget.order.shippingId),
            _buildInfoTile("Packaging ID", widget.order.packagingId),
            _buildInfoTile("RTW Harga", convertToRupiah(widget.order.rtwPrice)),
            _buildInfoTile(
              "Custom Harga",
              convertToRupiah(widget.order.customPrice),
            ),
            _buildInfoTile(
              "Ongkir",
              convertToRupiah(widget.order.shippingPrice),
            ),
            _buildInfoTile(
              "Harga Packaging",
              convertToRupiah(widget.order.packagingPrice),
            ),

            _buildInfoTile(
              "Total Harga",
              convertToRupiah(widget.order.totalPrice),
            ),
            _buildInfoTile("Metode Pembayaran", widget.order.paymentMethod!),
            _buildInfoTile(
              "Payment URL",
              widget.order.paymentUrl!,
              isLink: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, {bool isLink = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
      subtitle:
          isLink
              ? GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(value);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.platformDefault);
                  } else {
                    debugPrint("Could not launch $value");
                  }
                },
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
              : Text(
                value,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isNumber,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: DropdownButtonFormField<String>(
        value: selectedOrderStatus,
        decoration: InputDecoration(
          labelText: "Status Order",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
        ),
        items:
            [Order.PROCESS, Order.ON_DELIVERY, Order.ARRIVED, Order.DONE]
                .map(
                  (option) =>
                      DropdownMenuItem(value: option, child: Text(option)),
                )
                .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedOrderStatus = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: saveChanges,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          "Simpan Perubahan",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  saveChanges() {
    Order updatedOrder = Order(
      id: widget.order.id,
      shippingId: widget.order.shippingId,
      packagingId: widget.order.packagingId,
      buyerId: widget.order.buyerId,
      cartId: widget.order.cartId,
      product: widget.order.product,
      look: widget.order.look,
      size: widget.order.size,
      quantity: widget.order.quantity,
      buyerAddress: widget.order.buyerAddress,
      totalPrice: widget.order.totalPrice,
      rtwPrice: widget.order.rtwPrice,
      customPrice: widget.order.customPrice,
      shippingPrice: widget.order.shippingPrice,
      packagingPrice: widget.order.packagingPrice,
      discount: int.tryParse(discountController.text) ?? 0,
      orderCreated: widget.order.orderCreated,
      orderStatus: selectedOrderStatus,
      paymentUrl: widget.order.paymentUrl,
      expiredDate: widget.order.expiredDate,
      resi: resiController.text,
      xenditStatus: widget.order.xenditStatus,
      paymentDate: widget.order.paymentDate,
      description: descriptionController.text,
    );
    final controller = Provider.of<OrderController>(context, listen: false);
    controller.updateOrder(updatedOrder).then((_) {
      if (controller.errorMsg != null) {
        Fluttertoast.showToast(msg: controller.errorMsg!);
      } else {
        Fluttertoast.showToast(msg: "Berhasil memperbarui order");
        Navigator.pop(context);
      }
    });
  }

  _buildOrderItem(OrderController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Text(
              "Detail Produk",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.order.items.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (widget.order.items[index].customDesign != null) {
                  return FutureBuilder<Look?>(
                    future: controller.getLookById(
                      widget.order.items[index].lookId!,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return shimmerWidget();
                      }
                      if (snapshot.hasData) {
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(width: 2),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 130.h,
                                padding: const EdgeInsets.all(5),
                                color: Colors.white,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 5,
                                    child: FutureBuilder(
                                      future: controller.fetchSvg(
                                        widget.order.items[index].customDesign!,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        if (snapshot.hasData) {
                                          return svgViewer(snapshot.data!);
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data?.name ??
                                                "Nama Produk",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                          Text(
                                            convertToRupiah(
                                              widget.order.items[index].price,
                                            ),
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          Text(
                                            '${widget.order.items[index].size}',
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${widget.order.items[index].quantity} pcs",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Text(
                          "Tidak dapat memuat detail produk.",
                          style: TextStyle(fontSize: 12.sp),
                        );
                      }
                    },
                  );
                } else {
                  return FutureBuilder<Product?>(
                    future: controller.getProductByid(
                      widget.order.items[index].productId!,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return shimmerWidget();
                      }
                      if (snapshot.hasData || snapshot.data != null) {
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(width: 2),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 130.h,
                                padding: const EdgeInsets.all(5),
                                color: Colors.white,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 5,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.imageUrl.first,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data?.name ??
                                                "Nama Produk",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                          Text(
                                            convertToRupiah(
                                              widget.order.items[index].price,
                                            ),
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          Text(
                                            '${widget.order.items[index].size}',
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${widget.order.items[index].quantity} pcs",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Text(
                          "Tidak dapat memuat detail produk.",
                          style: TextStyle(fontSize: 12.sp),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
