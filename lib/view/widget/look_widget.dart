import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/look_controller.dart';
import 'package:jahit_baju_admin/data/model/designer.dart';
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/view/widget/look_edit_widget.dart';
import 'package:provider/provider.dart';

Widget lookWidget(BuildContext context, Designer designer) {
  List<Look> looks = designer.looks ?? [];
  return Consumer<LookController>(
    builder: (context, controller, child) {
      return Scaffold(
        appBar: AppBar(title: Text("Look Desainer"),centerTitle: true,),        
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: looks.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            looks[index].name,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            looks[index].description,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                       removeLook(context, controller,looks[index]);
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            onTap: (){
              goToModifyLook(context,look: looks[index]);
            },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            goToModifyLook(context,designer: designer);
          },
          child: Icon(Icons.add),
        ),
      );
    },
  );
}


void goToModifyLook(BuildContext context,{Look? look,Designer? designer}) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LookEditWidget(look: look,designer: designer,),
      ),
    );
}

void removeLook(
  BuildContext context,
  LookController controller,
  Look look,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus look ini?"),
        actions: [
          TextButton(
            onPressed:
                () => Navigator.pop(context), // Tutup dialog tanpa menghapus
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeLook(look).then((_) {
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
