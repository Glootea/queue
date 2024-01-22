import 'package:queue/data/encryprion.dart';
import 'package:queue/extension.dart';

class QrCodeData {
  static String toQrData(String tableID, int rowNumber, DateTime time) {
    return "https://queue-01-22.web.app/upload/${Encryption.encryct("&&&$tableID&&&$rowNumber&&&${time.toRecTime}")}";
  }

  static (String tableID, int rowNumber, DateTime time) fromQrData(String string) {
    final data = Encryption.decrypt(string.substring(string.lastIndexOf('/') + 1));
    final list = data.split("&&&");
    return (list[1], int.parse(list[2]), list[3].toRecDateTime);
  }
}
