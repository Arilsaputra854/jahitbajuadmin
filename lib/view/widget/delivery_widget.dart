import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jahit_baju_admin/controller/shipping_controller.dart';
import 'package:jahit_baju_admin/data/model/city.dart';
import 'package:jahit_baju_admin/util/util.dart'
    show convertToRupiah, loadingWidget;
import 'package:provider/provider.dart';

  TextEditingController originTextController = TextEditingController();
TextEditingController destinationTextController = TextEditingController();
Widget deliveryWidget(BuildContext context, {int weight = 500}) {
  TextEditingController weightController = TextEditingController(
    text: weight.toString(),
  );

  originTextController.text = "Tangerang Selatan";
  destinationTextController.text = "Tangerang Selatan";

  return Consumer<ShippingController>(
    builder: (context, controller, child) {
      controller.fetchListCity();
      controller.fetchAllDelivery(
        weight,
        originTextController.text,
        destinationTextController.text,
      );
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Jasa Pengiriman",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // TextFields untuk kota asal, kota tujuan, dan berat
                  
                  _originCityWidget(controller),
                  _destinationCityWidget(controller),
                  SizedBox(height: 10),
                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Berat (gram)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        int weight = int.tryParse(value) ?? 0;
                        if (weight > 30000) {
                          weightController.text = "30000";
                          weightController
                              .selection = TextSelection.fromPosition(
                            TextPosition(offset: weightController.text.length),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.setWeight(int.parse(weightController.text));
                      controller.setOrigin(originTextController.text);
                      controller.setDestination(destinationTextController.text);
                      controller.refresh();
                    },
                    child: Text("Hitung Ongkir"),
                  ),
                  SizedBox(height: 20),
                  // List pengiriman
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.shippings.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.setCurrentShipping(
                              controller.shippings[index],
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
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        controller.shippings[index].imgUrl,
                                    errorWidget: (context, url, error) {
                                      return Icon(Icons.warning);
                                    },
                                    width: 50,
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.shippings[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      Text(
                                        convertToRupiah(
                                          controller.shippings[index].price ??
                                              0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (controller.loading) loadingWidget(),
        ],
      );
    },
  );
}
_originCityWidget(ShippingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Kabupaten/Kota",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TypeAheadField<City>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: originTextController, // Gunakan controller global
          decoration: InputDecoration(
            hintText: "Masukkan kota asal",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return controller.listOfCity
                  ?.where((city) => city.cityName
                      .toLowerCase()
                      .contains(pattern.toLowerCase()))
                  .toList() ??
              [];
        },
        itemBuilder: (context, City suggestion) {
          return ListTile(
            title: Text("${suggestion.type} ${suggestion.cityName}"),
          );
        },
        onSuggestionSelected: (City suggestion) {
          controller.setOrigin(suggestion.cityName);
          originTextController.text = suggestion.cityName; // Perbarui teks
        },
        noItemsFoundBuilder: (context) => const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Kota tidak ditemukan"),
        ),
      ),
    ],
  );
}


_destinationCityWidget(ShippingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Kabupaten/Kota",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TypeAheadField<City>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: destinationTextController, // Gunakan controller global
          decoration: InputDecoration(
            hintText: "Masukkan kota tujuan",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return controller.listOfCity
                  ?.where((city) => city.cityName
                      .toLowerCase()
                      .contains(pattern.toLowerCase()))
                  .toList() ??
              [];
        },
        itemBuilder: (context, City suggestion) {
          return ListTile(
            title: Text("${suggestion.type} ${suggestion.cityName}"),
          );
        },
        onSuggestionSelected: (City suggestion) {
          controller.setOrigin(suggestion.cityName);
          destinationTextController.text = suggestion.cityName; // Perbarui teks
        },
        noItemsFoundBuilder: (context) => const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Kota tidak ditemukan"),
        ),
      ),
    ],
  );
}