import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const PhoneInputField({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9), // Light grey
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              border: Border(right: BorderSide(color: AppTheme.borderColor)),
            ),
            child: Row(
              children: [
                Text(
                  '+62',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: AppTheme.subtitleColor),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: '000-0000-0000',
                hintStyle: TextStyle(color: AppTheme.subtitleColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
