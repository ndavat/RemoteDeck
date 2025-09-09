import 'package:xml/xml.dart';
import '../../domain/entities/roku_device.dart';

/// Represents a Roku device with data parsing capabilities.
/// Extends [RokuDevice] to be used in the domain layer.
class RokuDeviceModel extends RokuDevice {
  const RokuDeviceModel({
    required String id,
    required String ipAddress,
    required String name,
    required String model,
  }) : super(id: id, ipAddress: ipAddress, name: name, model: model);

  /// Creates a [RokuDeviceModel] from the SSDP discovery XML response.
  factory RokuDeviceModel.fromXml(XmlDocument xml, String location) {
    // The location URL from the SSDP header looks like: http://192.168.1.10:8060/
    // We can parse the IP address from it.
    final ipAddress = Uri.parse(location).host;

    return RokuDeviceModel(
      id: xml.findAllElements('UDN').first.text.replaceFirst('uuid:', ''),
      ipAddress: ipAddress,
      name: xml.findAllElements('friendlyName').first.text,
      model: xml.findAllElements('modelName').first.text,
    );
  }
}