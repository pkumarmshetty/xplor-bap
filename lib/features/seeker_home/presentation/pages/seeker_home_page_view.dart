

import 'dart:convert';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:xplor/features/seeker_home/presentation/pages/routes.dart';

import '../../../../config/routes/path_routing.dart';
class SeekerHomePageView extends StatefulWidget {
  const SeekerHomePageView({super.key});

  @override
  State<SeekerHomePageView> createState() => _SeekerHomePageViewState();
}

class _SeekerHomePageViewState extends State<SeekerHomePageView> {
  List<dynamic> _healthRecords = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchHealthRecords();
  }

  Future<void> _fetchHealthRecords() async {
    final url = Uri.parse('https://testspar.dpgongcp.com/registry/api/v1/Hospital/search'); // Replace with actual API endpoint

    setState(() {
      _isLoading = true; // Set loading to true while fetching data
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "filters": {},
        }),
      );

      setState(() {
        _isLoading = false; // Set loading to false after receiving the response
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Assuming 'data' contains the health records
        final List<dynamic> records = responseData['data'] ?? [];
        print("ok............................................................");
        print(records);
        setState(() {
          _healthRecords = records;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load health records: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching health records: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Center(
          child: Text(
            "Home",
            style: TextStyle(color: Colors.green), // Green text color for the title
          ),
        ),
        backgroundColor: Color(0xFFFefefe), // Light gray background color
        centerTitle: true, // Ensures the title is centered
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(3), // Border radius for the bottom
          ),
        ),
        toolbarHeight: kToolbarHeight + 5, // Increases the height of the AppBar by 5px
        elevation: 0, // Set to 0 to avoid shadow
      ),


      body: Container(
        color: Colors.grey[200], // Set the background color to light gray
        child: Column(
          children: [
            // Search Bar for searching doctor by name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)), // Border radius for rounded corners

                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(202, 197, 197, 0.5), // Shadow color with some opacity
                      blurRadius: 6.0, // Blur radius for a soft shadow
                      offset: Offset(0, 2), // Shadow offset, slightly downward
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search by Doctor Name',
                    prefixIcon: Icon(Icons.search),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0), // Border radius for the focused state
                      borderSide: BorderSide(
                        // Border color when focused
                        // width: 2.0, // Border width when focused
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                )

              ),
            ),

            // If loading show a progress indicator, else show records or error
            _isLoading
                ? CircularProgressIndicator() // Show loading indicator while fetching data
                : _errorMessage.isNotEmpty
                ? Text(
              _errorMessage,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ) // Show error message
                : Expanded(
              child: ListView.builder(
                itemCount: _healthRecords.length,
                itemBuilder: (context, index) {
                  var record = _healthRecords[index];

                  // If search query is not empty, filter records by doctor name
                  if (_searchQuery.isNotEmpty &&
                      !(record['doctorName'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase())) {
                    return SizedBox.shrink(); // Skip this record if it doesn't match search query
                  }

                  return Card(
                    color: Colors.white, // Set the card background color to white
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // Reduced padding for smaller card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Doctor's Photo and Name in Row
                          Row(
                            children: [
                              // Left side: Doctor's Photo (with square and border radius)
                              Container(
                                width: 70, // Reduced size for the image
                                height: 70, // Reduced size for the image
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5), // Border radius for rounded corners
                                  image: DecorationImage(
                                    image: NetworkImage(record['doctorPhoto'] ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16), // Add space between the photo and the text

                              // Right side: Doctor Info (Doctor's Name and Specialization)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record['doctorName'] ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 18, // Reduced text size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      record['doctorSpecialization'] ?? 'Specialization',
                                      style: TextStyle(fontSize: 14, color: Colors.grey), // Smaller size
                                    ),
                                    SizedBox(height: 5),
                                    Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      record['hospitalName'] ?? 'Hospital Name',
                                      style: TextStyle(fontSize: 14), // Smaller size
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          // Full-width Button with Green Border and Text
                          Container(
                            width: double.infinity, // Makes the button stretch across the card width
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button press
                                Navigator.pushNamed(context, Routes.createAppointmentsPage);
                              },
                              child: Text(
                                'Book Appointment',
                                style: TextStyle(
                                  color: Colors.green, // Set text color to green
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Set background color to white
                                side: BorderSide(color: Colors.green), // Set border color to green
                                padding: EdgeInsets.all(12), // Padding inside the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6), // Border radius for button
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
