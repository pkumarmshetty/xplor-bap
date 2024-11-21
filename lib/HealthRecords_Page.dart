

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class HealthRecordsPage extends StatefulWidget {
  @override
  _HealthRecordsPageState createState() => _HealthRecordsPageState();
}

class _HealthRecordsPageState extends State<HealthRecordsPage> {
  List<Map<String, dynamic>> dataList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("init state");
    _fetchHealthRecords();
  }

  Future<void> _fetchHealthRecords() async {
    final url = Uri.parse('https://testfr1.dpgongcp.com/registry/api/v1/Appointment/search'); // Replace with actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers like authorization tokens if needed
          // 'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
        body: json.encode({
          'offset': 0,
          'limit': 500,
          'filters': {},
        }),
      );
      print("pavan,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      if (response.statusCode == 200) {
        print("pavan,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
        print(response);

        final Map<String, dynamic> responseData = json.decode(response.body);

        // Adjust this parsing based on your actual API response structure
        final List<dynamic> records = responseData['data'] ?? [];
        print(records);
        setState(() {
          var data = records.map((record) => {
            'name': record['patientName'] ?? 'N/A',
            'description': record['appointmentDate'] ?? 'N/A',
            'url': record['link'] ?? '#',
          }).toList();
          print("data");
          print(data);
          dataList = data;
          _isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to load health records: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching health records: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to launch the URL in the browser
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            title: const Text(
              'Health Records',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.blue,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3.0),
                bottomRight: Radius.circular(3.0),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(7.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Link')),
            ],
            rows: dataList
                .map(
                  (data) => DataRow(
                cells: [
                  DataCell(
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        data['name'],
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        data['description'],
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchURL(data['url']);
                        },
                        child: Text(
                          data['url'],
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}