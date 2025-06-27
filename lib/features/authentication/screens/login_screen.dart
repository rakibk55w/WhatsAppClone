import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/common/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text('Enter your phone number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text('WhatsApp will need to verify your phone number.'),
            const SizedBox(height: 20),
            TextButton(onPressed: (){}, child: const Text('Pick Country')),
            SizedBox(height: 5,),
            Row(
              children: [
                Text('+91'),
                SizedBox(width: 10),
                SizedBox(
                  width: AppDeviceUtils.getScreenWidth(context) * 0.7,
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(hintText: 'phone number'),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDeviceUtils.getScreenHeight(context) * 0.6,),
            SizedBox(
              width: 90,
              child: CustomButton(text: 'NEXT', onPressed: (){}),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}
