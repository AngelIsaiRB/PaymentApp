import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TotalPayButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final width = MediaQuery.of(context).size.width;
   return Container(
     width: width,
     height: 100,
     padding: EdgeInsets.symmetric(horizontal: 15),
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.only(
         topLeft: Radius.circular(30),
         topRight: Radius.circular(30)
        )
     ),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [

         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [             
             Text("Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
             Text("255.89 USD", style: TextStyle(fontSize: 20,), )
           ],
         ),
         _BtnPay(),

       ],
     ),
   );
  }
}



class _BtnPay extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return true ?buildBtnTarjeta(context): buildAppLeAndGooglePay(context);
  }

  Widget buildBtnTarjeta(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 170,
      shape: StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: [
          Icon(FontAwesomeIcons.solidCreditCard, color: Colors.white,),           
          Text("  Pagar", style: TextStyle(color: Colors.white, fontSize: 22),),
        ],
      ),
      onPressed: (){},      
    );
  }

  Widget buildAppLeAndGooglePay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: [
          Platform.isAndroid
          ? Icon(FontAwesomeIcons.google, color: Colors.white,)
          : Icon(FontAwesomeIcons.apple, color: Colors.white,),          
          Text(" Pay", style: TextStyle(color: Colors.white, fontSize: 22),),
        ],
      ),
      onPressed: (){},      
    );
  }
}