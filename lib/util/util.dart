import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

String customFormatDate(DateTime date) {
  return DateFormat('HH:mm, dd-MM-yyyy').format(date);
}

Widget shimmerWidget() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: double.infinity,
      height: 100.h,
      margin: const EdgeInsets.symmetric(horizontal: 10),
    ),
  );
}

Widget loadingWidget({String? text}) {
  return Container(
    color: const Color.fromARGB(92, 0, 0, 0),
    width: double.infinity,
    height: double.infinity,
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 50,
          ),
          if (text != null)
            DefaultTextStyle(
              style: TextStyle(decoration: TextDecoration.none),
              child: Text(text),
            ),
        ],
      ),
    ),
  );
}

Widget svgViewer(String svg) {
  Logger logger = Logger();
  WebViewController controller = WebViewController();
  var htmlContent = '''
            <!DOCTYPE html>
            <html lang="en">
            <head>
              <meta name="viewport" content="width=device-width, initial-scale=0.7, maximum-scale=1, user-scalable=0">
              <style>
                body {
                  margin: 0;
                  padding: 0;
                  overflow: hidden; /* Disable scrolling */
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  height: 100vh;
                }
                svg {
                  max-width: 100%;
                  max-height: 100%;
                  display: block;
                  margin: auto;
                }
              </style>
            </head>
            <body>
              $svg
            </body>
            </html>
            ''';
  controller.loadHtmlString(htmlContent);
  logger.d("SVG Loaded: $htmlContent");
  return WebViewWidget(controller: controller, gestureRecognizers: Set());
}
