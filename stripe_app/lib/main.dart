import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/pages/home_page.dart';
import 'package:stripe_app/pages/pago_completo.dart';
import 'package:stripe_app/pages/tarjeta_page.dart';
import 'package:stripe_app/services/stripe_service.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // inicializamos stripe service
    new StripeService()..init();
    

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context)=>PagarBloc(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pagos app',
        initialRoute: "homepage",
        routes: {
          "homepage" : (_)=>HomePage(),
          "tarjetaPage": (_) => TarjetaPage(),
          "pagoPage"  : (_) => PagoPage()
        },
        theme: ThemeData.light().copyWith(
          primaryColor: Color(0xff284879),
          scaffoldBackgroundColor: Color(0xff21232a)
        ),
      ),
    );
  }
}