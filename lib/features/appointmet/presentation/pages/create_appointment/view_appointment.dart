

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../utils/common_top_header.dart';
import '../../../../on_boarding/domain/entities/user_data_entity.dart';
class ViewAppointment extends StatefulWidget {
  final UserDataEntity? userData;

  /// Constructor for SeekerEditProfile.
  const ViewAppointment({super.key, required this.userData});

  @override
  _ViewAppointmentState createState() => _ViewAppointmentState();
}

class _ViewAppointmentState extends State<ViewAppointment> {
  List<Map<String, dynamic>> dataList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("init state");
    _fetchHealthRecords();
  }

  Future<void> _fetchHealthRecords() async {
    final url = Uri.parse('https://testspar.dpgongcp.com/registry/api/v1/Appointment/search'); // Replace with actual API endpoint

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
          'filters': {
            "mobile": {
              "eq": widget.userData?.phoneNumber
            }
          },
        }),
      );
      print("ok,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      if (response.statusCode == 200) {
        print("ok,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),  // Adjust height as needed
        child: CommonTopHeader(
          title: 'Health Details',
          isTitleOnly: false,
          dividerColor: Colors.grey, // Use appropriate color
          onBackButtonPressed: () => Navigator.of(context).pop(),
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
                    InkWell(
                      onTap: () {
                        // Navigate to WebViewPage when name is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(url: data['url']!),
                          ),
                        );
                      },
                      child: Text(
                        "Appointment Link",
                        style: TextStyle(
                          color: Colors.blue, // Indicate link by color
                          decoration: TextDecoration.underline, // Underline text
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



class WebViewPage extends StatefulWidget {
  final String url;
  WebViewPage({required this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print("Loading: $url");
          },
          onPageFinished: (String url) {
            print("Finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            print("Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url)); // Load the URL passed from DataTablePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView'),
      ),
      body: WebViewWidget(controller: _controller), // Display the WebView
    );
  }
}