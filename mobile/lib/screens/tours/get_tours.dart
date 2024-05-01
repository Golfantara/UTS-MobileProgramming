import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_app/screens/tours/create_tour.dart';
import 'package:dio/dio.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tour_app/screens/tours/update_tour.dart';
import 'package:tour_app/services/services_tours.dart';

class GetTourScreen extends StatefulWidget {
  const GetTourScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GetTourScreenState createState() => _GetTourScreenState();
}

class _GetTourScreenState extends State<GetTourScreen> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);
  final ToursServices _toursServices = ToursServices();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  void deleteTour(dynamic id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _toursServices.deleteTour(id, prefs.getString('accessToken')!);
      _pagingController.refresh();
    } catch (error) {
      print('Terjadi kesalahan saat melakukan permintaan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(color: Colors.teal)),
      ),
      body: Column(
        children: [
          Center(
            heightFactor: 2,
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateTourScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  child: Text(
                    'Buat tour',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.75,
            child: Text('Daftar Tour',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.tealAccent[700])),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(() => _pagingController.refresh()),
              child: PagedListView<int, dynamic>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  itemBuilder: (context, item, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: FractionallySizedBox(
                          widthFactor: 0.75,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey[300]!,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Nama'),
                                          const SizedBox(width: 75),
                                          const Text(':'),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              item['name'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(children: [
                                        const Text('Provinsi'),
                                        const SizedBox(width: 63),
                                        const Text(':'),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Text(
                                          item['provinsi'],
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ]),
                                      const SizedBox(height: 5),
                                      Row(children: [
                                        const Text('Kabupaten/Kota'),
                                        const SizedBox(width: 10),
                                        const Text(':'),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Text(
                                          item['kabkot'],
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ]),
                                      const SizedBox(height: 5),
                                      Row(children: [
                                        const Text('latitude'),
                                        const SizedBox(width: 62),
                                        const Text(':'),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Text(
                                          item['latitude'],
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ]),
                                      const SizedBox(height: 5),
                                      Row(children: [
                                        const Text('Longtitude'),
                                        const SizedBox(width: 49),
                                        const Text(':'),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Text(
                                          item['longtitude'],
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ])
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Image.network(
                                  item['images'],
                                  height: 200,
                                ),
                                const SizedBox(height: 10),
                                FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: ElevatedButton(
                                    onPressed: () => {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const UpdateTourScreen(),
                                      ))
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.lightBlueAccent[400],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 12),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: OutlinedButton(
                                    onPressed: () => {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                                'Apakah Anda yakin ingin menghapus tour ini?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Tutup dialog
                                                },
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Tutup dialog
                                                  deleteTour(item[
                                                      'id']); // Panggil metode _deleteTour dengan id tour yang dipilih
                                                },
                                                child: const Text('Hapus'),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Rounded edges
                                      ),
                                      side: BorderSide(
                                          color: Colors
                                              .redAccent[400]!), // Teal border
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 36, vertical: 12),
                                      child: Text(
                                        'Hapus',
                                        style: TextStyle(
                                            color: Colors.redAccent[400]),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20)
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final dio = Dio();
      final url = 'http://localhost:8000/tours?page=$pageKey&page_size=5';
      final response = await dio.get(url,
          options: Options(headers: {
            'Authorization': 'Bearer ${prefs.getString('accessToken')}'
          }));
      final List<dynamic> data = response.data['data'];
      final isLastPage = data.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(data);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(data, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
