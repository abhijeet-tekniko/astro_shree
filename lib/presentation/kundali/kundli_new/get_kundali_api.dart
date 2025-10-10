import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:intl/intl.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/endpoints.dart';
import '../../../core/network/response_handler.dart';
import 'kundli_details.dart';
import 'kundli_model.dart';

class GetKundliApi extends GetxController {
  final dio = DioClient().client;
  var isLoading = false.obs;
  var kundli = Rxn<KundliData>();



  Future<void> fetchKundli({
    required String name,
    required String dob,
    required String tob,
    required String address,
    String? language,
    String? gender
  }) async {
    isLoading(true);
    try {

      final response = await dio.post(
        EndPoints.kundli,
        data: {
          "name": name,
          "dob": dob,
          // "tob": timeOfBirth,
          "tob": tob,
          "place": address,
          "latitude": 19.0760,
          "longitude": 72.8777,
          "timezone": 5.5,
          "gender": gender ?? "male",
          "language": language ?? "en",
          "chartTypes": [
            "chalit",
            "SUN",
            "MOON",
            "D1",
            "D2",
            "D3",
            "D4",
            "D5",
            "D7",
            "D8",
            "D9",
            "D10",
            "D12",
            "D16",
            "D20",
            "D24",
            "D27",
            "D30",
            "D40",
            "D45",
            "D60"
          ],
          "sections": []
        },
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final result = KundliResponse.fromJson(response.data);
        kundli.value = result.data;
        print('DataKundli======'+kundli.toString());
        Get.off(() => KundliDetailsScreen());
      } else {
        print('⚠️ Error: ${response.statusCode}');
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: response.data['message'],
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: e.response?.data['message'],
      );
      print('❌ DioException: ${e.message}');
    } finally {
      isLoading(false);
    }
  }
}


String convertTo24HourFormat(String tob12h) {
  try {
    // Normalize the string: replace non-breaking space characters with normal space
    String normalizedTob = tob12h.replaceAll(RegExp(r'\s+'), ' ').trim();

    // You can also explicitly replace non-breaking space characters if needed
    normalizedTob = normalizedTob
        .replaceAll(String.fromCharCode(0x00A0), ' ')
        .replaceAll(String.fromCharCode(0x202F), ' ');

    final DateFormat inputFormat = DateFormat('h:mm a'); // e.g., "2:33 PM"
    final DateFormat outputFormat = DateFormat('HH:mm'); // e.g., "14:33"
    final DateTime dateTime = inputFormat.parse(normalizedTob);

    return outputFormat.format(dateTime);
  } catch (e) {
    print('Error parsing TOB: $e');
    return tob12h; // fallback to original
  }
}