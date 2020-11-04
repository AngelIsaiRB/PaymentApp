import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class TotalPayButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pagarBloc = context.bloc<PagarBloc>().state;
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
             Text("${pagarBloc.montoPagar} ${pagarBloc.moneda}", style: TextStyle(fontSize: 20,), )
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
    return BlocBuilder<PagarBloc, PagarState>(
      builder: (context, state) {
       if (state.tarjetaActiva){
         return buildBtnTarjeta(context);         
       }
       else{
         return buildAppLeAndGooglePay(context);
       }
      },
    );
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
      onPressed: ()async {
        mostrarLoadinf(context);
        final stripeService = new StripeService();
        final pagarBloc= context.bloc<PagarBloc>().state;
        final mesAnio = pagarBloc.tarjeta.expiracyDate.split("/");

        final resp = await stripeService.pagarconTarjetaExistente(
          amount: pagarBloc.montopagarString, 
          currency: pagarBloc.moneda, 
          card: CreditCard(
            number: pagarBloc.tarjeta.cardNumber,
            expMonth: int.parse(mesAnio[0]),
            expYear: int.parse(mesAnio[1]),
             cvc: pagarBloc.tarjeta.cvv // no necesario 
          )
          );
        Navigator.pop(context);
            if (resp.ok){
              mostrarAlerta(context, "Tarjeta OK", "Todo correcto");
            }
            else{
              mostrarAlerta(context, "Algo salio mal", resp.msg);
            }



      },      
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