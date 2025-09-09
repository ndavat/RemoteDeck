import 'package:xml/xml.dart';
import '../../domain/entities/app_channel.dart';

class AppChannelModel extends AppChannel {
  const AppChannelModel({
    required String id,
    required String name,
    required String type,
    required String version,
  }) : super(id: id, name: name, type: type, version: version);

  factory AppChannelModel.fromXmlElement(XmlElement element) {
    return AppChannelModel(
      id: element.getAttribute('id')!,
      name: element.text,
      type: element.getAttribute('type')!,
      version: element.getAttribute('version')!,
    );
  }
}