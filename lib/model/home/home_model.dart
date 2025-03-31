import 'package:xml/xml.dart';

class DataModel {
  final List<Cust> customer; // List of customer objects
  final List<Loc> locations; // List of location objects
  final List<Contact> contacts; // List of contact objects

  DataModel(
      {required this.customer, required this.locations, required this.contacts});

  // Factory constructor to create a DataModel from XML
  factory DataModel.fromXml(XmlDocument xml) {
    // Parse customer from XML
    final customer = (xml.findAllElements('cst').map((element) {
      return Cust(
        customerId: element.findElements('id').single.text,
        customerName: element.findElements('nm').single.text,
        customerAddress: element.findElements('adr').single.text,
      );
    }).toList());

    // Parse locations from XML
    final locations = (xml.findAllElements('loc').map((element) {
      return Loc(
        id: element.findElements('id').single.text,
        name: element.findElements('nm').single.text,
        address: element.findElements('adr').single.text,
      );
    }).toList());

    return DataModel(customer: customer, locations: locations, contacts: []);
  }
}

// Customer class
class Cust {
  final String customerId; // city ID
  final String customerName; // city name
  final String customerAddress; // city name

  Cust(
      {required this.customerId,
      required this.customerName,
      required this.customerAddress});
}

// Location class
class Loc {
  final String id; // Location ID
  final String name; // Location name
  final String address; // Location address

  Loc({required this.id, required this.name, required this.address});
}

// Contact class (for future use if needed)
class Contact {
  // Define contact fields here if necessary
}
