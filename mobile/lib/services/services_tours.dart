import 'package:dio/dio.dart';
import '../utils/utils.dart';

class ToursServices {
  final Dio _dio = Dio();

  Future createTour(
      String name,
      String provinsi,
      String? provinsiId,
      String kabkot,
      String? kabkotId,
      String latitude,
      String longitude,
      dynamic images,
      String? accessToken) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'provinsi': provinsi,
        'provinsi_id': provinsiId,
        'kabkot': kabkot,
        'kabkot_id': kabkotId,
        'latitude': latitude,
        'longtitude': longitude,
        'images':
            await MultipartFile.fromFile(images.path, filename: 'image.jpg'),
      });

      final response = await _dio.post(
        Urls.baseUrl + Urls.tours,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response.data;
    } catch (error) {
      print('Terjadi kesalahan saat melakukan permintaan: $error');
      return null;
    }
  }

  Future deleteTour(dynamic id, String accessToken) async {
    try {
      await _dio.delete(
        '${Urls.baseUrl}${Urls.tours}/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } catch (error) {
      print('Terjadi kesalahan saat melakukan permintaan: $error');
    }
  }
}
