class AddressModel {
  String houseName;
  String city;
  String landMark;
  String pincode;

  AddressModel(
      {required this.houseName,
      required this.city,
      required this.landMark,
      required this.pincode});

  factory AddressModel.fromMap(Map<String, dynamic> addresses) {
    return AddressModel(
      houseName: addresses['houseName'],
      city: addresses['city'],
      landMark: addresses['landMark'],
      pincode: addresses['pincode'],
    );
  }
}
