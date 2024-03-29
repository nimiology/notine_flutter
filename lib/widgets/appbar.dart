import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget {
  final bool back;
  final bool divider;
  final String title;
  final String? svgIcon;
  final VoidCallback? svgIconOnTapFunction;
  final VoidCallback? backFunction;
  final double horizontalPadding;

  const CustomAppBar({
    Key? key,
    this.back = false,
    this.divider = false,
    this.title = 'Notine',
    this.svgIcon,
    this.svgIconOnTapFunction,
    this.horizontalPadding = 20,
    this.backFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: divider ? 10 : 20),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: backFunction ??
                    () {
                      Navigator.pop(context);
                    },
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    'assets/svgs/chevron-left.svg',
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),
              Flexible(
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium),
              ),
              svgIcon != null
                  ? GestureDetector(
                      onTap: svgIconOnTapFunction,
                      child: SizedBox(
                        child: SvgPicture.asset(
                          'assets/svgs/$svgIcon',
                          width: 16,
                          height: 16,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        if (divider) const Divider()
      ],
    );
  }
}
