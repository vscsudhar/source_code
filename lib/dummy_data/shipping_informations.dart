class ShippingInformation {
  String id;
  String address;
  String city;
  String postal_code;
  String phone;
  String country_id;
  String country_name;

  ShippingInformation(
      { this.id, this.address, this.city, this.postal_code, this.phone, this.country_id, this.country_name});
}

String default_shipping = "3";

List<ShippingInformation> shippingInformationList = [
  ShippingInformation(id: "1",
      address: "13th Street. 47 W 13th St, New York, NY 10011",
      city: "New York City",
      postal_code: "70025685",
      phone: "+1 222 330568",
      country_id: "14",
      country_name: "United States of America"),
  ShippingInformation(id: "2",
      address: "13th Street. 47 W 13th St, New York, NY 10011",
      city: "New York City",
      postal_code: "70025685",
      phone: "+1 222 330568",
      country_id: "15",
      country_name: "Zimbabwe"),
  ShippingInformation(id: "3",
      address: "13th Street. 47 W 13th St, New York, NY 10011",
      city: "New York City",
      postal_code: "70025685",
      phone: "+1 222 330568",
      country_id: "2",
      country_name: "Bangladesh"),
  ShippingInformation(id: "4",
      address: "13th Street. 47 W 13th St, New York, NY 10011",
      city: "New York City",
      postal_code: "70025685",
      phone: "+1 222 330568",
      country_id: "9",
      country_name: "India"),
];
