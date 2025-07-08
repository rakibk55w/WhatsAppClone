import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/common/widgets/custom_button.dart';

import '../controller/authentication_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login-screen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneNumberController = TextEditingController();
  Country? country;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text('Enter your phone number'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text('WhatsApp will need to verify your phone number.'),
              const SizedBox(height: 20),
              TextButton(onPressed: pickCountry, child: const Text('Pick Country')),
              SizedBox(height: 5,),
              Row(
                children: [
                  if (country!=null)
                    Text('+${country!.phoneCode}'),
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
                child: CustomButton(text: 'NEXT', onPressed: sendPhoneNumber),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  void pickCountry(){
    showCountryPicker(useSafeArea: true, context: context, onSelect: (Country selectedCountry){
      setState(() {
        country = selectedCountry;
      });
    });
  }

  void sendPhoneNumber(){
    String phoneNumber = phoneNumberController.text.trim();
    if(country!=null && phoneNumber.isNotEmpty){
      ref.read(authenticationControllerProvider).signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    }
  }
}
