import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/costumer_controller.dart';
import 'package:jahit_baju_admin/data/model/user.dart';
import 'package:jahit_baju_admin/util/util.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomerDataSource extends DataGridSource {
  List<DataGridRow> _users = [];
  final BuildContext context;
  final CostumerController controller;

  CustomerDataSource(this.context, this.controller, List<User> users) {
    _users =
        users.map<DataGridRow>((user) {
          return DataGridRow(
            cells: [
              DataGridCell<int>(
                columnName: 'No',
                value: users.indexOf(user) + 1,
              ),
              DataGridCell<String>(columnName: 'Nama', value: user.name),
              DataGridCell<String>(columnName: 'Email', value: user.email),
              DataGridCell<String>(
                columnName: 'Nomor HP',
                value: user.phoneNumber,
              ),
              DataGridCell<String>(
                columnName: 'Alamat',
                value: user.address?.streetAddress ?? 'Tidak ada alamat',
              ),
              DataGridCell<String>(columnName: 'Role', value: user.role),
              DataGridCell<String>(
                columnName: 'Email Terverifikasi',
                value: user.emailVerified ? "✅" : "❌",
              ),
              DataGridCell<String>(
                columnName: 'Akses Fitur Kostumisasi',
                value: user.customAccess ? "✅" : "❌",
              ),
              DataGridCell<String>(
                columnName: 'Tanggal Update Terakhir',
                value:customFormatDate(user.lastUpdate!),
              ),
              DataGridCell<Widget>(
                columnName: 'Aksi',
                value:
                    user.role == "Admin"
                        ? SizedBox() // Jika Admin, tampilkan widget kosong
                        : Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed:
                                  () =>
                                      removeProduct(context, controller, user),
                            ),
                          ],
                        ),
              ),
            ],
          );
        }).toList();
  }

  @override
  List<DataGridRow> get rows => _users;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((cell) {
            return Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child:
                  cell.value is Widget
                      ? cell.value
                      : Text(
                        cell.value.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
            );
          }).toList(),
    );
  }
}

Widget costumerWidget(BuildContext context) {
  return Consumer<CostumerController>(
    builder: (context, controller, child) {
      controller.fetchAllUser();
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Data Customer",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.w),
          child:
              controller.users.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : SfDataGrid(
                    source: CustomerDataSource(
                      context,
                      controller,
                      controller.users,
                    ),columnWidthMode: ColumnWidthMode.fill,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columns: [
                      GridColumn(
                        columnName: 'No',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment:
                              Alignment
                                  .center, // Tengah secara horizontal & vertikal
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'No',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Nama',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Nama',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Email',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Nomor HP',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Nomor HP',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Alamat',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Alamat',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Role',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Role',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Email Terverifikasi',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Email Terverifikasi',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Akses Fitur Kostumisasi',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Akses Fitur Kostumisasi',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Tanggal Update Terakhir',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Tanggal Update Terakhir',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Aksi',
                        label: Container(
                          padding: EdgeInsets.all(12.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Aksi',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      );
    },
  );
}

void removeProduct(
  BuildContext context,
  CostumerController controller,
  User user,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus pengguna ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeUser(user).then((_) {
                if (controller.errorMsg != null) {
                  Fluttertoast.showToast(msg: "${controller.errorMsg}");
                } else {
                  Fluttertoast.showToast(msg: "Berhasil menghapus pengguna!");
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