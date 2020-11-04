import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/data/tarjetas.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/tarjeta_page.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class HomePage extends StatelessWidget {

  final stripeservice = new StripeService();
  @override
  Widget build(BuildContext context) {

    // ignore: close_sinks
    final pagobloc = context.bloc<PagarBloc>();

    final size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagar"),
        centerTitle: true,
        actions: [
          IconButton(
          icon: Icon(Icons.add), 
          onPressed: ()async {
            mostrarLoadinf(context);
            // mostrarLoadinf(context);
            // await Future.delayed(Duration(seconds:1));
            // Navigator.pop(context);
            final response =await  stripeservice.pagarConNuevaTarjeta(
              amount: pagobloc.state.montopagarString, 
              currency: pagobloc.state.moneda
            );
            Navigator.pop(context);
            if (response.ok){
              mostrarAlerta(context, "Tarjeta OK", "Todo correcto");
            }
            else{
              mostrarAlerta(context, "Algo salio mal", response.msg);
            }

          }
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            width: size.width,
            height: size.height,
            top: 200,                      
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.8
              ),
              physics: BouncingScrollPhysics(),
              itemCount: tarjetas.length,
              itemBuilder: (_,i){
                final tarjeta=tarjetas[i];
                return GestureDetector(
                  onTap: (){
                    pagobloc.add(OnSeleccionarTarjeta(tarjeta));
                    Navigator.push(context, navegarFadeIn(context, TarjetaPage()));
                  },
                  child: Hero(
                    tag: tarjeta.cardNumber,
                    child: CreditCardWidget(
                    cardNumber: tarjeta.cardNumberHidden,
                    expiryDate: tarjeta.expiracyDate,
                    cardHolderName: tarjeta.cardHolderName,
                    cvvCode: tarjeta.cvv,
                    showBackView: false,                    
                    ),
                  ),
                );
              }
              
              ),
          ),
          Positioned(
            bottom: 0,
            child: TotalPayButtom(),
          )
        ],
      )
    );
  }
}