import 'package:e_wallet/app/data/theme/theme_service.dart';
import 'package:e_wallet/app/data/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Customtooltip extends GetView {
  final String message;
  Customtooltip({required this.message});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      textStyle: GoogleFonts.roboto(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: ThemeService().theme == ThemeMode.light
              ? ColorResourcesLight.mainLIGHTColor
              : ColorResourcesDark.mainDARKColor),
      // triggerMode: TooltipTriggerMode.tap,
      margin: EdgeInsets.symmetric(horizontal: 15),
      enableFeedback: true,
      preferBelow: false,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(
              3.0,
              3.0,
            ),
            blurRadius: 5.0,
          ), //BoxShadow //BoxShadow
        ],
      ),
      child: CircleAvatar(
        radius: 8,
        backgroundColor: ThemeService().theme == ThemeMode.light
            ? ColorResourcesLight.mainTextHEADINGColor
            : Colors.white,
        child: FaIcon(
          FontAwesomeIcons.question,
          size: 10,
          color: ThemeService().theme == ThemeMode.light
              ? Colors.white
              : ColorResourcesLight.mainLIGHTAPPBARcolor,
        ),
      ),
    );
  }
}
