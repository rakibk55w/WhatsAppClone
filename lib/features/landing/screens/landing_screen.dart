import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/common/widgets/custom_button.dart';

import '../../../common/utils/device_utility.dart';
import '../../authentication/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

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
              color: AppColors.tabColor,
            ),
            SizedBox(height: AppDeviceUtils.getScreenHeight(context) / 9),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Read our Privacy Policy. Tap "Agree and Continue" to accept the Terms of Service.',
                style: TextStyle(color: AppColors.greyColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: AppDeviceUtils.getScreenWidth(context) * 0.75,
              child: CustomButton(
                text: 'AGREE AND CONTINUE',
                onPressed: () => _navigateToLoginScreen(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
