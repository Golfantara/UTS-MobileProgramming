import 'package:dio/dio.dart';
import '../utils/utils.dart';

class ToursServices {
  final Dio _dio = Dio();

  Future CreateTour(
      String name,
      String provinsi,
      String kabkot,
      String latitude,
      String longtitude,
      dynamic images,
      String? accessToken) async {
    try {
      final response = await _dio.post(
        Urls.baseUrl + Urls.tours,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          'name': name,
          'provinsi': provinsi,
          'kabkot': kabkot,
          'latitude': latitude,
          'longitude': longtitude,
          'images': images,
        },
      );
      final jsonData = response.data;
      return jsonData;
    } catch (error) {
      print('Terjadi kesalahan saat melakukan permintaan: $error');
      return null;
    }
  }
}
