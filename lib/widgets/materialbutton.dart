import 'package:flutter/material.dart';

class GlobalButtons{
  Widget materialButton(String? text,void Function()? function,{double spacing = 5,required Color bckgrndColor, Color textColor = Colors.white, String icon = "", double radius = 1000, double fontsize = 16}){
    return MaterialButton(
      height: 55,
      color: bckgrndColor,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           icon == "" ? Container() : Image(
              width: 25,
              image: AssetImage(icon),
            ),
            SizedBox(
              width: spacing,
            ),
            Text(text!,style: TextStyle(fontSize: fontsize,fontFamily: "AppFontStyle",color: textColor),textAlign: TextAlign.center,),
          ],
        ),
      ),
      onPressed: function,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
final GlobalButtons globalButtons = new GlobalButtons();