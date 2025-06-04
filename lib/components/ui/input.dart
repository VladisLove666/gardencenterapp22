import 'package:gardencenterapppp/components/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController controller;
  final String? hint;
  final bool? error;
  final bool? obscure;
  final TextInputType? inputType;
  final bool? isEnabled;
  final bool? isTextArea;
  final IconData? prefixIcon;
  final int? maxLength;

  const Input({
    required this.controller,
    this.label,
    this.placeholder,
    this.hint,
    this.maxLength,
    this.error = false,
    this.obscure = false,
    this.inputType = TextInputType.text,
    this.isEnabled = true,
    this.isTextArea = false,
    this.prefixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    if (label != null) {
      widgets.add(
        Text(
          label!,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
      widgets.add(const SizedBox(height: 6));
    }

    widgets.add(TextField(
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      autocorrect: false,
      controller: controller,
      obscureText: obscure!,
      keyboardType: inputType,
      enabled: isEnabled,
      inputFormatters: [
        if (inputType == TextInputType.phone)
          phoneFormatter,
        if (maxLength != null)
          LengthLimitingTextInputFormatter(maxLength),
      ],
      maxLines: isTextArea! ? 3 : 1,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: error != null && error!
              ? Theme.of(context).colorScheme.error
              : Colors.grey,
        ),
        hintText: placeholder ?? hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            color: error != null && error!
                ? Theme.of(context).colorScheme.error
                : Colors.grey,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          size: 20,
        )
            : null,
      ),
    ));


    if (widgets.length == 1) {
      return widgets[0];
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets
    );
  }
}
