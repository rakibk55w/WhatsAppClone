import 'package:flutter/material.dart';

import '../../../common/utils/device_utility.dart';


class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome to WhatsApp',
              style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: AppDeviceUtils.getScreenHeight(context) / 9),
            Image(
              image: AssetImage('assets/images/bg.png'),
              height: 340,
              width: 340,
            ),
          ],
        ),
      ),
    );
  }
}
