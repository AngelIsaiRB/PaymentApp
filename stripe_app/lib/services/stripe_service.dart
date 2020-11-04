

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stripe_app/models/payment_intent.dart';
import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_payment/stripe_payment.dart';


class StripeService {

  StripeService._privateContructor();

  static final StripeService _intance = StripeService._privateContructor();
  factory StripeService () => _intance;

  String _paymentUrl="https://api.stripe.com/v1/payment_intents";
  static String _secretKey = "sk_test_51HjV2AGnO9zLqRzAE92bmsddRYVBsZeN0GnvQr6xHNPiGhQkL19T7brYYPBEivCm1Lx3vcbOOHXvybIHt5U6mwhs00OQFuBx7H";
  String _apiKey ="pk_test_51HjV2AGnO9zLqRzAveffYP2hgpKIENEqKobJ4QpkGzUkTe5WjOyKYsr5BHn5dJzbTr4vgAsW85QoViWDFQoj4H2m00rnTXUa4V";

  final headearOptions= new Options(
    contentType: Headers.formUrlEncodedContentType,
    headers: {
      "Authorization": "Bearer ${StripeService._secretKey}"
    }
  );
  void init(){
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:this._apiKey,
        androidPayMode: "test",
        merchantId: "test"
        )
    );
  }

  Future<StripeCustomResponse> pagarconTarjetaExistente({
    @required String amount,
    @required String currency,
    @required CreditCard card,
  }) async{
    try {
      
      // crear intent
      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card)
      );
      final resp =await this._realizarPago(amount: amount, currency: currency, paymenMethod: paymentMethod);
     
      return resp;

    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }

  }

  Future<StripeCustomResponse> pagarConNuevaTarjeta({
    @required String amount,
    @required String currency,
  })async{
    try {
      
      // crear intent
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest()
      );
      final resp =await this._realizarPago(amount: amount, currency: currency, paymenMethod: paymentMethod);
     
      return resp;

    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }

  }

  Future pagarApplePayGooglePay({
    @required String amount,
    @required String currency,
  }) async{}

  Future<PaymentIntentResponse> _crearPaymentIntent({
    @required String amount,
    @required String currency,
  }) async{

    try {
      final dio= new Dio();
      final data={
        "amount":amount,
        "currency": currency
      };
      final resp=await dio.post(
        _paymentUrl,
        data: data,
        options: headearOptions
        );

        return PaymentIntentResponse.fromJson(resp.data);


    } catch (e) {
      print("error en intento ${e.toString()}");
      return PaymentIntentResponse(
        status: "400"
      );
    }

  }

  Future<StripeCustomResponse> _realizarPago({
    @required String amount,
    @required String currency,
    @required PaymentMethod paymenMethod,
  })async {
    // crear intent
    try {
      final paymentIntent = await this._crearPaymentIntent(amount: amount, currency: currency);
      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent.clientSecret,
          paymentMethodId: paymenMethod.id,          
          )
      );
      if(paymentResult.status=="succeeded"){
        return StripeCustomResponse(ok: true);
      }
      else{
        return StripeCustomResponse(ok: false,msg:"fallo ${paymentResult.status}");
      }


    } catch (e) {
      print(e.toString());
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  } 

}