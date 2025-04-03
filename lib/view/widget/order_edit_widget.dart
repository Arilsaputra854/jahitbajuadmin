import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/order_controller.dart';
import 'package:jahit_baju_admin/util/util.dart';
import 'package:jahit_baju_admin/data/model/order.dart';
import 'package:provider/provider.dart';

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
                  SizedBox(height: 16.h),
                  _buildTextField("Diskon", discountController, true),
                  _buildTextField("Resi", resiController, false),
                  _buildTextField("Deskripsi", descriptionController, false),
                  _buildDropdown(),
                  SizedBox(height: 24.h),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
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
            _buildInfoTile("Shipping ID", widget.order.shippingId),
            _buildInfoTile("Packaging ID", widget.order.packagingId),
            _buildInfoTile(
              "Total Harga",
              convertToRupiah(widget.order.totalPrice),
            ),
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
            _buildInfoTile("Metode Pembayaran", widget.order.paymentMethod!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
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
    final controller = Provider.of<OrderController>(context,listen: false);
    controller.updateOrder(updatedOrder).then((_) {
      if (controller.errorMsg != null) {
        Fluttertoast.showToast(msg: controller.errorMsg!);
      } else {
        Fluttertoast.showToast(msg: "Berhasil memperbarui order");
        Navigator.pop(context);
      }
    });
  }

  
}
