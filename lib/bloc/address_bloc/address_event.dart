part of 'address_bloc.dart';

@immutable
abstract class AddressEvent {}

class OnAddAddressEvent extends AddressEvent {
  final String houseName;
  final String landMark;
  final String city;
  final String pincode;

  OnAddAddressEvent(
      {required this.houseName,
      required this.landMark,
      required this.city,
      required this.pincode});
}

class OnEditAddressEvent extends AddressEvent {
  final String addressId;
  final String houseName;
  final String landMark;
  final String city;
  final String pincode;

  OnEditAddressEvent(
      {required this.addressId,
      required this.houseName,
      required this.landMark,
      required this.city,
      required this.pincode});
}

class OnDeleteAddressEvent extends AddressEvent {
  final String addressId;

  OnDeleteAddressEvent({required this.addressId});
}

class OnSelectAddressForCheckOut extends AddressEvent {

}
