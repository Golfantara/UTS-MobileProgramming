import 'package:flutter/material.dart';
import 'package:tour_app/screens/tours/create_tour.dart';
import 'package:tour_app/screens/tours/update_tour.dart';

class GetTourScreen extends StatelessWidget {
  const GetTourScreen({super.key});

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
            FractionallySizedBox(
              widthFactor: 0.75,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey[300]!,
                    )),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Nama'),
                                SizedBox(width: 75),
                                Text(':'),
                                SizedBox(width: 10),
                                Text('Jakarta'),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(children: [
                              Text('Provinsi'),
                              SizedBox(width: 63),
                              Text(':'),
                              SizedBox(width: 10),
                              Text('Jawa Barat'),
                            ]),
                            SizedBox(height: 5),
                            Row(children: [
                              Text('Kabupaten/Kota'),
                              SizedBox(width: 10),
                              Text(':'),
                              SizedBox(width: 10),
                              Text('Cilacap'),
                            ]),
                            SizedBox(height: 5),
                            Row(children: [
                              Text('Latitude'),
                              SizedBox(width: 62),
                              Text(':'),
                              SizedBox(width: 10),
                              Text('131231asdads23'),
                            ]),
                            SizedBox(height: 5),
                            Row(children: [
                              Text('Longitude'),
                              SizedBox(width: 49),
                              Text(':'),
                              SizedBox(width: 10),
                              Text('13123123'),
                            ])
                          ],
                        )),
                    const SizedBox(height: 10),
                    Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",
                      height: 200,
                    ),
                    const SizedBox(height: 10),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: OutlinedButton(
                        onPressed: () => {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Rounded edges
                          ),
                          side: BorderSide(
                              color: Colors.redAccent[400]!), // Teal border
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 12),
                          child: Text(
                            'Hapus',
                            style: TextStyle(color: Colors.redAccent[400]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                          onPressed: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdateTourScreen(),
                                ))
                              },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ));
  }
}
