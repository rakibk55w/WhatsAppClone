import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';

class AppDeviceUtils {

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight;
  }

  static double getAppbarHeight() {
    return kToolbarHeight;
  }

  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  // static Future<bool> hasInternetConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup("example.com");
  //     return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  //   } on SocketException catch (_) {
  //     return false;
  //   }
  // }

  // static Future<bool> hasInternetConnection() async {
  //   try {
  //     var connectivityResult = await Connectivity().checkConnectivity();
  //
  //     if (connectivityResult == ConnectivityResult.none) {
  //       _showNoInternetDialog(Get.context!, "Please turn on Wi-Fi or mobile data to continue.");
  //       return false;
  //     }
  //
  //     final result = await InternetAddress.lookup("example.com");
  //     return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  //
  //   } on SocketException catch (_) {
  //     _showNoInternetDialog(Get.context!, "No internet connection available.");
  //     return false;
  //   }
  // }
  //
  // static void _showNoInternetDialog(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Could not connect to internet."),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("OK"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void showSnackBar({required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  Future<File?> pickImageFromGallery(BuildContext context) async {
    File? image;
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
    return image;
  }

  Future<File?> pickVideoFromGallery(BuildContext context) async {
    File? video;
    try {
      final pickedVideo =
      await ImagePicker().pickVideo(source: ImageSource.gallery);

      if (pickedVideo != null) {
        video = File(pickedVideo.path);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }    }
    return video;
  }

  Future<GiphyGif?> pickGIF(BuildContext context) async {
    GiphyGif? gif;
    try {
      gif = await Giphy.getGif(
        context: context,
        apiKey: 'pwXu0t7iuNVm8VO5bgND2NzwCpVH9S0F',
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }    }
    return gif;
  }
}
