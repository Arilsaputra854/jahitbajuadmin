
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

String convertToRupiah(dynamic value) {
  String converted = "";

  final formatter = NumberFormat.currency(
    locale: 'id_ID', // Locale Indonesia
    symbol: 'Rp ', // Simbol Rupiah
    decimalDigits: 0, // Tanpa desimal
  );

  converted = formatter.format(value.toDouble());
  return converted;
}

String customFormatDate(DateTime date){
  return DateFormat('HH:mm, dd-MM-yyyy').format(date);
}

Widget loadingWidget({String? text}){
  return Container(
                color: const Color.fromARGB(92, 0, 0, 0),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white, size: 50),
                      if(text != null) DefaultTextStyle(
    style: TextStyle(decoration: TextDecoration.none), 
    child : Text(text))],
                  )
                ),
              );
}