import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_app/services/services_province.dart';
import 'package:tour_app/services/services_regency.dart';

class UpdateTourScreen extends StatefulWidget {
  const UpdateTourScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateTourScreenState createState() => _UpdateTourScreenState();
}

class _UpdateTourScreenState extends State<UpdateTourScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  String? province;
  String? regency;
  File? _image;
  final picker = ImagePicker();
  final ProvincesService _provincesService = ProvincesService();
  final RegencyService _regencyService = RegencyService();
  List<Map<String, String>> provincesData = [];
  List<Map<String, String>> regenciesData = [];

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  Future<void> _fetchProvinces() async {
    final data = await _provincesService.getProvinces();

    if (data != null) {
      setState(() {
        provincesData = List<Map<String, String>>.from(data.map((item) {
          return Map<String, String>.from(item as Map<String, dynamic>);
        }));
      });
    }
  }

  Future<void> _fetchRegencies(String provinceId) async {
    final data = await _regencyService.getRegencies(provinceId);

    if (data != null) {
      setState(() {
        regenciesData = List<Map<String, String>>.from(data.map((item) {
          return Map<String, String>.from(item as Map<String, dynamic>);
        }));
      });
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> showOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();

                getImageFromGallery();
              },
            ),
            ListTile(
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();

                getImageFromCamera();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Buat Tour', style: TextStyle(color: Colors.teal)),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Masukan nama tour',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: province,
                    hint: const Text('Pilih Provinsi'),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.teal,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        province = newValue!;
                      });
                      _fetchRegencies(newValue!);
                    },
                    items: provincesData.map((Map<String, String> province) {
                      return DropdownMenuItem<String>(
                        value: province['id'],
                        child: Text(province['name']!),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: DropdownButton<String>(
                      isExpanded: true,
                      value: regency,
                      hint: const Text('Pilih Kota/Kabupaten'),
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.teal,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          regency = newValue!;
                        });
                      },
                      items: regenciesData.map((Map<String, String> regency) {
                        return DropdownMenuItem<String>(
                          value: regency['id'],
                          child: Text(regency['name']!),
                        );
                      }).toList()),
                ),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: TextField(
                    controller: latitude,
                    decoration: const InputDecoration(
                      labelText: 'Masukan Latitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: TextField(
                    controller: longitude,
                    decoration: const InputDecoration(
                      labelText: 'Masukan longitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: OutlinedButton(
                    onPressed: () {
                      showOptions(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded edges
                      ),
                      side: const BorderSide(color: Colors.teal), // Teal border
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                      child: Text(
                        'Ambil gambar',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: _image == null
                      ? Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",
                          height: 200,
                        )
                      : Image.file(
                          _image!,
                          height: 200,
                        ),
                ),
                const SizedBox(height: 15),
                FractionallySizedBox(
                    widthFactor: 0.7,
                    child: ElevatedButton(
                        onPressed: () async {
                          print(
                              "Latitude: ${latitude.text} Longitude: ${longitude.text} Image: ${_image} Name: ${name.text}  Provinsi: ${province} Kabkot: ${regency}");
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          child: Text(
                            'Simpan perubahan data',
                            style: TextStyle(color: Colors.white),
                          ),
                        ))),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ));
  }
}
