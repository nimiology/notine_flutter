import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? svg;
  final TextEditingController controller;
  final bool? enabled;
  final bool error;
  final bool isTitle;
  final bool multiLine;

  CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.svg,
      this.enabled,
      this.error = false,
      this.isTitle = false,
      this.multiLine = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme =
        isTitle ? theme.textTheme.titleLarge : theme.textTheme.bodyLarge;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              enabled: enabled,
              style: textTheme,
              keyboardType: TextInputType.multiline,
              maxLines: multiLine ? null : 1,
              maxLength: multiLine ? null : 30,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  counterText: '',
                  hintStyle: textTheme?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: error
                        ? theme.colorScheme.onError
                        : isTitle
                            ? theme.colorScheme.onBackground.withOpacity(0.8)
                            : theme.colorScheme.secondary,
                  ),
                  counterStyle: textTheme),
              cursorColor: error ? theme.colorScheme.error : null,
            ),
          ),
          if (svg != null)
            SvgPicture.asset(
              'assets/svg/$svg',
              width: 24,
              height: 24,
              color: error
                  ? theme.colorScheme.onError
                  : theme.colorScheme.onSecondary,
            )
        ],
      ),
    );
  }
}
