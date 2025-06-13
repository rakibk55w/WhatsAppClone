import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.tabColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.blackColor)),
    );
  }
}
