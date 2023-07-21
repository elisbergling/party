class LocationInfo {
  double latitude;
  double longitude;
  String address;
  String country;
  String postalCode;

  LocationInfo({
    required this.address,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
  });
}
