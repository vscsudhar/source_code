class Countries {
  List<Country> countries;

  Countries({this.countries});
}

class Country {
  final String id;
  final String name;

  Country({this.id, this.name});
  @override toString() => '$name';

}

List<Country> countryList = [
  Country(id: "1", name: "Afghanistan"),
  Country(id: "2", name: "Bangladesh"),
  Country(id: "3", name: "Canada"),
  Country(id: "4", name: "Denmark"),
  Country(id: "5", name: "Ethiopia"),
  Country(id: "6", name: "Finland"),
  Country(id: "7", name: "Germany"),
  Country(id: "8", name: "Hungary"),
  Country(id: "9", name: "India"),
  Country(id: "10", name: "Jamaica"),
  Country(id: "11", name: "Kuwait"),
  Country(id: "12", name: "Lebanon"),
  Country(id: "13", name: "Maldives"),
  Country(id: "14", name: "United States of America"),
  Country(id: "15", name: "Zimbabwe"),
];

Country getCountryById(String id) =>
    countryList.firstWhere((country) => country.id == id);

Country getCountryByPartialName(String partial_name) =>
    countryList.firstWhere((country) => country.name == partial_name);

List<Country> getCountriesByPartialName(String partial_name) =>
    countryList.where((country) => country.name == partial_name).toList();
