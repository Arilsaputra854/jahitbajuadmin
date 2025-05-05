import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/util/token_storage.dart';
import 'package:jahit_baju_admin/view/login_screen.dart';
import 'package:jahit_baju_admin/view/widget/banner_widget.dart';
import 'package:jahit_baju_admin/view/widget/costumer_widget.dart';
import 'package:jahit_baju_admin/view/widget/delivery_widget.dart';
import 'package:jahit_baju_admin/view/widget/designer_widget.dart';
import 'package:jahit_baju_admin/view/widget/order_widget.dart';
import 'package:jahit_baju_admin/view/widget/packaging_widget.dart';
import 'package:jahit_baju_admin/view/widget/privacy_widget.dart';
import 'package:jahit_baju_admin/view/widget/product_care_term_widget.dart';
import 'package:jahit_baju_admin/view/widget/product_note_widget.dart';
import 'package:jahit_baju_admin/view/widget/ready_to_wear_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();

    items = [
      SideMenuItem(
        title: 'Banner Aplikasi',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.home),
      ),
      SideMenuItem(
        title: 'Jasa Pengiriman',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.place_rounded),
      ),
      SideMenuItem(
        title: 'Packaging',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.shopping_bag),
      ),

      SideMenuItem(
        title: 'Order',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.shopping_cart),
      ),
      SideMenuItem(
        title: 'Data Kostumer',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: Icon(Icons.person),
      ),
      SideMenuExpansionItem(
        title: "Produk",
        icon: const Icon(Icons.discount),
        onTap:
            (index, _, isExpanded) => {print('$index, expanded $isExpanded')},
        children: [
          SideMenuItem(
            title: 'Produk Ready to Wear',
            onTap: (index, _) {
              sideMenu.changePage(index);
            },
            icon: const Icon(Icons.discount),
          ),
          SideMenuItem(
            title: 'Produk Custom',
            onTap: (index, _) {
              sideMenu.changePage(index);
            },
            icon: const Icon(Icons.discount),
          ),
          
          SideMenuItem(
            title: 'Catatan Produk',
            onTap: (index, _) {
              sideMenu.changePage(index);
            },
            icon: const Icon(Icons.note_alt),
          ),
        ],
      ),
      SideMenuExpansionItem(
        title: "Kebijakan",
        icon: const Icon(Icons.policy),
        onTap:
            (index, _, isExpanded) => {print('$index, expanded $isExpanded')},
        children: [
          SideMenuItem(
            title: 'Kebijakan Pengguna dan Privasi',
            onTap: (index, _) {
              sideMenu.changePage(index);
            },
            icon: const Icon(Icons.policy),
          ),
          SideMenuItem(
            title: 'Kebijakan Perawatan Pakaian',
            onTap: (index, _) {
              sideMenu.changePage(index);
            },
            icon: const Icon(Icons.policy),
          ),
        ],
      ),
      SideMenuItem(
        title: 'Logout',
        onTap: (index, _) {
          logout();
        },
        icon: Icon(Icons.exit_to_app),
      ),
    ];

    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          // Tampilkan pesan jika ukuran layar terlalu kecil
          return Scaffold(
            body: Center(
              child: Text(
                "Hanya tersedia di versi desktop",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              SideMenu(
                controller: sideMenu,
                title: Image.asset('assets/logo/title_jahit_baju.png'),
                footer: Text('Jahit Baju Admin'),
                items: items,
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: [
                    BannerWidget(),
                    DeliveryWidget(),
                    PackagingWidget(),
                    OrderWidget(),
                    CostumerWidget(),
                    readyToWearWidget(),
                    DesignerWidget(),
                    ProductNoteWidget(),
                    PrivacyWidget(),
                    ProductCareTermWidget(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
