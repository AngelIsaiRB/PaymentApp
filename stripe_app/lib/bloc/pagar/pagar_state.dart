part of 'pagar_bloc.dart';

@immutable
class PagarState  {

  final double montoPagar;
  final String moneda;
  final bool tarjetaActiva;
  final TarjetaCredito tarjeta;

  PagarState({
    this.montoPagar=375, 
    this.moneda="USD", 
    this.tarjetaActiva =false, 
    this.tarjeta
  });

  PagarState copywith({
    final double montoPagar,
  final String moneda,
  final bool tarjetaActiva,
  final TarjetaCredito tarjeta,
  })=>PagarState(
    montoPagar  : montoPagar     ?? this.montoPagar,
    moneda       : moneda        ?? this.moneda,
    tarjetaActiva: tarjetaActiva ?? this.tarjetaActiva,
    tarjeta      : tarjeta       ?? this.tarjeta,
  );

  String get montopagarString => "${(this.montoPagar*100).floor()}";


}
