import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jahit_baju_admin/controller/costumer_controller.dart';
import 'package:jahit_baju_admin/controller/designer_controller.dart';
import 'package:jahit_baju_admin/controller/login_controller.dart';
import 'package:jahit_baju_admin/controller/look_controller.dart';
import 'package:jahit_baju_admin/controller/note_controller.dart';
import 'package:jahit_baju_admin/controller/order_controller.dart';
import 'package:jahit_baju_admin/controller/packaging_controller.dart';
import 'package:jahit_baju_admin/controller/privacy_controller.dart';
import 'package:jahit_baju_admin/controller/product_care_term_controller.dart';
import 'package:jahit_baju_admin/controller/product_controller.dart';
import 'package:jahit_baju_admin/controller/shipping_controller.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/view/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginController(ApiService(context)),
        ),
        ChangeNotifierProvider(
          create: (context) => ShippingController(ApiService(context)),
        ),
        ChangeNotifierProvider(
          create: (context) => PackagingController(ApiService(context)),
        ),
        ChangeNotifierProvider(
          create: (context) => CostumerController(ApiService(context)),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductController(ApiService(context)),
        ),
        
        ChangeNotifierProvider(
          create: (context) => DesignerController(ApiService(context)),
        ),

        
        ChangeNotifierProvider(
          create: (context) => LookController(ApiService(context)),
        ),
        
        ChangeNotifierProvider(
          create: (context) => PrivacyController(ApiService(context)),
        ),

         ChangeNotifierProvider(
          create: (context) => ProductCareTermController(ApiService(context)),
        ),

        
         ChangeNotifierProvider(
          create: (context) => NoteController(ApiService(context)),
        ),

        
         ChangeNotifierProvider(
          create: (context) => OrderController(ApiService(context)),
        ),
      ],

      child: ScreenUtilInit(
        designSize: const Size(1280, 832),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Jahit Baju Admin',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
