import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
// <<<<<<< HEAD
// import '../../../../../utils/common_top_header.dart';
// =======
 import 'package:xplor/features/multi_lang/domain/mappers/profile/profile_keys.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
// import 'package:xplor/utils/app_colors.dart';
// import 'package:xplor/utils/app_dimensions.dart';
// import 'package:xplor/utils/common_top_header.dart';
// import 'package:xplor/utils/extensions/string_to_string.dart';
// import 'package:xplor/utils/widgets/app_background_widget.dart';
// >>>>>>> bad12244bfd1bff507cd13801c52fed72e3050de
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/common_top_header.dart';
import '../../../../../utils/widgets/app_background_widget.dart';
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
  Map<String, dynamic> doctorData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("init state");
    _fetchHealthRecords();
    _fetchHospitalRecords();
  }

  Future<void> _fetchHospitalRecords() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://testspar.dpgongcp.com/registry/api/v1/Hospital/search'); // Replace with actual API endpoint

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
      print("ok,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      if (response.statusCode == 200) {
        print("ok,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
        print(response);

        final Map<String, dynamic> responseData = json.decode(response.body);

        // Adjust this parsing based on your actual API response structure
        final List<dynamic> records = responseData['data'] ?? [];
        print(records);
        setState(() {
          doctorData = {for (var item in records) item["osid"]: item};
          _isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to load hospital records: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching hospital records: $e');
    }
  }

  Future<void> _fetchHealthRecords() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://testspar.dpgongcp.com/registry/api/v1/Appointment/search'); // Replace with actual API endpoint

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
            "mobile": {"eq": widget.userData?.phoneNumber}
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
          dataList = records
              .map((record) => {
                    'name': record['patientName'] ?? 'N/A',
                    'appointmentDate': record['appointmentDate'] ?? 'N/A',
                    'link': record['link'] ?? '#',
                    'doctorOsid': record['doctorOsid'] ?? '#',
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to load health records: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching health records: $e');

    }
  }

  @override
  Widget build(BuildContext context) {
    print(_isLoading);
    return Scaffold(

      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100),  // Adjust height as needed
      //   child: CommonTopHeader(
      //     title: 'Health Details',
      //     isTitleOnly: false,
      //     dividerColor: Colors.grey, // Use appropriate color
      //     onBackButtonPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),

      backgroundColor: Colors.white,

      body: _isLoading
          ? Text("loading") : AppBackgroundDecoration(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                CommonTopHeader(
                  title: ProfileKeys.appointment.stringToString,
                  isTitleOnly: false,
                  dividerColor: AppColors.checkBoxDisableColor,
                  onBackButtonPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                    child: dataList.length == 0 ? Container() : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.medium,
                            vertical: AppDimensions.large),
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          print("datalist");
                          print(index);
                          var record = dataList[index];
                          var doctor = doctorData[record["doctorOsid"]];
                          return Card(
                            color: Colors.white,
                            // Set the card background color to white
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              // Reduced padding for smaller card
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
                                          borderRadius: BorderRadius.circular(5),
                                          // Border radius for rounded corners
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                doctor['doctorPhoto'] ?? ''),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      // Add space between the photo and the text

                                      // Right side: Doctor Info (Doctor's Name and Specialization)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              doctor['doctorName'] ?? 'N/A',
                                              style: TextStyle(
                                                fontSize: 18, // Reduced text size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              doctor['doctorSpecialization'] ??
                                                  'Specialization',
                                              style: TextStyle(fontSize: 14,
                                                  color: Colors
                                                      .grey), // Smaller size
                                            ),
                                            SizedBox(height: 5),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              doctor['hospitalName'] ??
                                                  'Hospital Name',
                                              style: TextStyle(
                                                  fontSize: 14), // Smaller size
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Appointment Time: " + record['appointmentDate'] ??
                                                  'Hospital Name',
                                              style: TextStyle(
                                                  fontSize: 14), // Smaller size
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10),

                                  // Full-width Button with Green Border and Text
                                  Container(
                                    width: double.infinity,
                                    // Makes the button stretch across the card width
                                    child: ElevatedButton(

                                      onPressed: () {
                                        isFutureAppointment(record) ? null :
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WebViewPage(url: record['link']!),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        // Set background color to white
                                        side: BorderSide(color: isFutureAppointment(record) ? Colors.red : Colors.green),
                                        // Set border color to green
                                        padding: EdgeInsets.all(12),
                                        // Padding inside the button
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              6), // Border radius for button
                                        ),
                                      ),
                                      child: Text(
                                        isFutureAppointment(record) ? 'Upcoming Appointment' : 'Join Appointment',
                                        style: TextStyle(
                                          color: isFutureAppointment(record) ? Colors.red : Colors.green, // Set text color to green
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isFutureAppointment(Map<String, dynamic> record) => DateTime.parse(record["appointmentDate"]).isAfter(DateTime.now());

  Widget build1(BuildContext context) {
    return DataTable(
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
                      "Link",
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
      ..loadRequest(
          Uri.parse(widget.url)); // Load the URL passed from DataTablePage
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
