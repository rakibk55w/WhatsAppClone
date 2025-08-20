import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../env/env.dart';
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

  static void showSnackBar({
    required BuildContext context,
    required String content,
  }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(content)));
  }

  static Future<File?> pickImageFromGallery(BuildContext context) async {
    File? image;
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return image;
  }

  static Future<File?> pickVideoFromGallery(BuildContext context) async {
    File? video;
    try {
      final pickedVideo = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedVideo != null) {
        video = File(pickedVideo.path);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return video;
  }

  static Future<GiphyGif?> pickGIF(BuildContext context) async {
    try {
      final gif = await GiphyGet.getGif(
        context: context,
        apiKey: Env.giphyKey,
        lang: GiphyLanguage.english,
        modal: true,
        showGIFs: true,
        showEmojis: true,
        showStickers: true,
      );
      return gif;
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return null;
    }
  }

  static Future<File> getDefaultImage() async {
    final byteData = await rootBundle.load('assets/images/profile_default.png');

    final file = File(
      '${(await getTemporaryDirectory()).path}/profile_default.png',
    );

    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }
}
