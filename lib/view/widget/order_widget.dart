import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jahit_baju_admin/controller/order_controller.dart';
import 'package:jahit_baju_admin/data/model/order.dart';
import 'package:jahit_baju_admin/util/util.dart'
    show convertToRupiah, loadingWidget;
import 'package:jahit_baju_admin/view/widget/order_edit_widget.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<OrderController>(context, listen: false);
    controller.fetchAllOrder();

    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (context, controller, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Order",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: "Menunggu Pembayaran"),
                    Tab(text: "Diproses"),
                    Tab(text: "Dalam Pengiriman"),
                    Tab(text: "Tiba"),
                    Tab(text: "Selesai"),
                  ],
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
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(controller, Order.WAITING_FOR_PAYMENT),
                  _buildOrderList(controller, Order.PROCESS),
                  _buildOrderList(controller, Order.ON_DELIVERY),
                  _buildOrderList(controller, Order.ARRIVED),
                  _buildOrderList(controller, Order.DONE),
                ],
              ),
            ),
            if (controller.loading) loadingWidget(),
          ],
        );
      },
    );
  }

  /// Widget untuk menampilkan daftar order berdasarkan status tertentu
  Widget _buildOrderList(OrderController controller, String status) {
    List<Order> filteredOrders =
        controller.orders
            .where((order) => order.orderStatus == status)
            .toList();

    if (filteredOrders.isEmpty) {
      return const Center(child: Text("Tidak ada order"));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        Order order = filteredOrders[index];
        return GestureDetector(
          onTap: () {
            controller.setCurrentOrder(order);
            modifyOrder(context, order, controller);
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: FutureBuilder(
                future: controller.getUserById(filteredOrders[index].buyerId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pembeli: ${snapshot.data!.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          "ID Order: ${order.id}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          "Status: $status",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          "Total: ${convertToRupiah(order.totalPrice)}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }else{
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void modifyOrder(
    BuildContext context,
    Order order,
    OrderController controller,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ModifyOrderWidget(order: order)),
    ).then((_) {
      controller.refresh();
    });
  }
}
