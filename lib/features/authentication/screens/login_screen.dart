import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.arrow_left),
        title: const Text('Enter your phone number'),
      ),
      body: const Column(
        children: [
          SizedBox(height: 10),
          Text('WhatsApp will need to verify your phone number.'),
          SizedBox(height: 20),
          Text('Pick country'),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 128.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'phone number'),
            ),
          )
        ],
      ),
    );
  }
}
