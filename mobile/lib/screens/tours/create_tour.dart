import 'package:flutter/material.dart';

class CreateTourScreen extends StatefulWidget {
  const CreateTourScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateTourScreenState createState() => _CreateTourScreenState();
}

class _CreateTourScreenState extends State<CreateTourScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  String? dropdownValue;
  // File? image;

  // Future pickImage() async {W
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     setState(() => this.image = imageTemp);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Buat Tour', style: TextStyle(color: Colors.teal)),
      ),
      body: Center(
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
                value: dropdownValue,
                hint: const Text('Pilih Provinsi'),
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: Colors.teal,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: DropdownButton<String>(
                value: dropdownValue,
                hint: const Text('Pilih Kota/Kabupaten'),
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: Colors.teal,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
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
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const LoginScreen(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded edges
                  ),
                  side: const BorderSide(color: Colors.teal), // Teal border
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  child: Text(
                    'Ambil dari kamera',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: OutlinedButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const LoginScreen(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded edges
                  ),
                  side: const BorderSide(color: Colors.teal), // Teal border
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  child: Text(
                    'Ambil dari gallery',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
