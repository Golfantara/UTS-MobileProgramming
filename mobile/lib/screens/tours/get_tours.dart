import 'package:flutter/material.dart';
import 'package:tour_app/screens/tours/create_tour.dart';

class GetTourScreen extends StatelessWidget {
  const GetTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:
              const Text('Daftar Tour', style: TextStyle(color: Colors.teal)),
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
          ],
        ));
  }
}
