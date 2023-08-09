import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  //A required string that specifies the label
  //text for the button.
  final String label;
  //A boolean indicating whether the button should occupy the full width
  //of its parent. Default value is false
  final bool fullWidth;
  //A boolean indicating whether
  //the button should occupy the full height of its parent. Default value is false.
  final bool fullHight;
  //The width of the button if fullWidth is false. Default value is 120.
  final double width;
  //The height of the button if fullHeight is false. Default value is 52.
  final double height;
  //A callback function that is triggered when the button is pressed.
  final void Function()? onPressed;
  //The background color of the button.
  final Color? color;
  //fontColor: The color of the button label.
  final Color? fontColor;
  //A boolean indicating whether the button should have a flat style (TextButton) or
  //a raised style (CupertinoButton). Default value is false.
  final bool flat;

  const PrimaryButton(this.label,
      {super.key,
      this.fullWidth = false,
      this.fullHight = false,
      this.width = 120,
      this.height = 52,
      this.flat = false,
      this.color,
      this.fontColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (flat) {
      return SizedBox(
        width: fullWidth ? MediaQuery.of(context).size.width : width,
        height: fullHight ? MediaQuery.of(context).size.height / 14 : height,
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: null,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side:
                    BorderSide(color: color ?? Colors.white),
              ),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.nunitoSans(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: fullWidth ? MediaQuery.of(context).size.width : width,
      height: fullHight ? MediaQuery.of(context).size.height / 14 : height,
      child: CupertinoButton(
        color: Colors.indigo,
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(15),
        padding: EdgeInsets.zero,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
            color: fontColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
