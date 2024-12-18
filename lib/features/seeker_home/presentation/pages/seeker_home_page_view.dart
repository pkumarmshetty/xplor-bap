// import 'dart:convert';
//
// // import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:xplor/features/appointmet/presentation/pages/doctor/appointment_screen.dart';
// import '../../../../config/routes/path_routing.dart';
// import '../../../../utils/common_top_header.dart';
// import '../../../appointmet/domain/entities/CreateAppointmentArgs.dart';
// import '../../../appointmet/presentation/pages/doctor/doctor.dart';
// import '../../../profile/presentation/bloc/seeker_profile_bloc/seeker_profile_bloc.dart';
//
// class SeekerHomePageView extends StatefulWidget {
//   const SeekerHomePageView({super.key});
//
//   @override
//   State<SeekerHomePageView> createState() => _SeekerHomePageViewState();
// }
//
// class _SeekerHomePageViewState extends State<SeekerHomePageView> {
//   List<dynamic> _healthRecords = [];
//   List<dynamic> _healthRecordsFilter = [];
//   bool _isLoading = false;
//   String _errorMessage = '';
//   String _searchQuery = "";
//   String? _selectedSpecialist;
//   String? _selectedHospital;
//   bool _isSpecialistSelected = false;
//   bool _isHospitalSelected = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchHealthRecords();
//   }
//
//   Future<void> _fetchHealthRecords() async {
//     final url = Uri.parse(
//         'https://testspar.dpgongcp.com/registry/api/v1/Hospital/search'); // Replace with actual API endpoint
//
//     setState(() {
//       _isLoading = true; // Set loading to true while fetching data
//     });
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           "filters": {},
//         }),
//       );
//
//       setState(() {
//         _isLoading = false; // Set loading to false after receiving the response
//       });
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//
//         // Assuming 'data' contains the health records
//         final List<dynamic> records = responseData['data'] ?? [];
//         print("ok............................................................");
//         print(records);
//         setState(() {
//           _healthRecords = records;
//         });
//         setState(() {
//           _healthRecordsFilter = records;
//         });
//
//       } else {
//         setState(() {
//           _errorMessage =
//           'Failed to load health records: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error fetching health records: $e';
//       });
//     }
//   }
//   void _applyFilters() {
//     if (_selectedSpecialist != null || _selectedHospital != null) {
//       setState(() {
//         _healthRecords = _healthRecordsFilter.where((record) {
//           bool matchesSpecialist = _selectedSpecialist == null ||
//               record['doctorSpecialization'] == _selectedSpecialist;
//           bool matchesHospital = _selectedHospital == null ||
//               record['hospitalName'] == _selectedHospital;
//
//           return matchesSpecialist && matchesHospital;
//         }).toList();
//       });
//     } else {
//       // If no filters are selected, reset the health records to the filtered list
//       setState(() {
//         _healthRecords = _healthRecordsFilter;
//       });
//     }
//   }
//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent, // Make background transparent
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
//             padding: const EdgeInsets.all(15.0),
//             decoration: BoxDecoration(
//               color: Colors.white, // Set the background color of the dialog to white
//               borderRadius: BorderRadius.circular(10), // Set the border radius to 20% of the container
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Filter',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 16),
//                 // Specialist Dropdown
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFF1581BF)),
//                     borderRadius: BorderRadius.circular(10), // Border color
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: DropdownButton<String>(
//                       value: _selectedSpecialist,
//                       hint: Text('Select Specialist'),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedSpecialist = newValue;
//                           // Don't apply filters here, just update the selected value
//                         });
//                       },
//                       isExpanded: true, // Makes the dropdown fill the width
//                       items: _healthRecords.isNotEmpty
//                           ? _healthRecords
//                           .map<DropdownMenuItem<String>>((record) {
//                         return DropdownMenuItem<String>(
//                           value: record['doctorSpecialization'],
//                           child: Text(record['doctorSpecialization'] ?? 'Specialist'),
//                         );
//                       }).toList()
//                           : [],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//
//                 // Hospital Dropdown
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFF1581BF)),
//                     borderRadius: BorderRadius.circular(10),
//                     // Border color
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: DropdownButton<String>(
//                       value: _selectedHospital,
//                       hint: Text('Select Hospital'),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedHospital = newValue;
//                           // Don't apply filters here, just update the selected value
//                         });
//                       },
//                       isExpanded: true, // Makes the dropdown fill the width
//                       items: _healthRecords.isNotEmpty
//                           ? _healthRecords
//                           .map<DropdownMenuItem<String>>((record) {
//                         return DropdownMenuItem<String>(
//                           value: record['hospitalName'],
//                           child: Text(record['hospitalName'] ?? 'Hospital'),
//                         );
//                       }).toList()
//                           : [],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//
//                 // Apply Filter Button (No border radius)
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _applyFilters(); // Apply the filters when the button is pressed
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF1581BF), // Filter button color
//                       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10), // No border radius for the button
//                       ),
//                     ),
//                     child: Text(
//                       'Apply Filter',
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(91),  // Adjust height as needed
//         child: CommonTopHeader(
//           title: 'HOME',
//           isTitleOnly: false,
//           dividerColor: Colors.grey, // Use appropriate color
//           onBackButtonPressed: () => Navigator
//
//         ),
//       ),
//
//
//       body: Container(
//         color: Colors.grey[200], // Set the background color to light gray
//         child: Column(
//           children: [
//             // Search Bar for searching doctor by name
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(50)),
//                     // Border radius for rounded corners
//
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color.fromRGBO(202, 197, 197, 0.5),
//                         // Shadow color with some opacity
//                         blurRadius: 6.0,
//                         // Blur radius for a soft shadow
//                         offset: Offset(
//                             0, 2), // Shadow offset, slightly downward
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     onChanged: (query) {
//                       setState(() {
//                         _searchQuery = query;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       labelText: 'Search by Doctor Name',
//                       prefixIcon: Icon(Icons.search),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xFF1581BF), // Bottom border color when not focused
//                           width: 2.0, // Border width
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(7.0),
//                         // Border radius for the focused state
//                         borderSide: const BorderSide(
//                           // Border color when focused
//                           // width: 2.0, // Border width when focused
//                         ),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   )
//
//               ),
//             ),
//             // Filter Button (added below search bar)
//             Align(
//               alignment: Alignment.centerLeft, // Align the button to the left side
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16.0, top: 0, bottom: 0),
//                 child: ElevatedButton(
//                   onPressed: _showFilterDialog, // Open filter dialog on press
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     side: BorderSide(color: Color(0xFF1581BF)),
//                     padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Smaller padding for smaller button
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min, // Ensure the button doesn't take up extra space
//                     children: [
//                       Icon(
//                         Icons.filter_list, // Filter icon
//                         color: Color(0xFF1581BF),
//                         size: 20, // Icon size
//                       ),
//                       SizedBox(width: 8), // Space between icon and text
//                       Text(
//                         'Filter',
//                         style: TextStyle(
//                           color: Color(0xFF1581BF),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // If loading show a progress indicator, else show records or error
//             _isLoading
//                 ? const CircularProgressIndicator() // Show loading indicator while fetching data
//                 : _errorMessage.isNotEmpty
//                 ? Text(
//               _errorMessage,
//               style: const TextStyle(fontSize: 18, color: Colors.red),
//             ) // Show error message
//                 : Expanded(
//               child: BlocBuilder<SeekerProfileBloc, SeekerProfileState>(
//                   builder: (context, state) {
//                     return ListView.builder(
//                       itemCount: _healthRecords.length,
//                       itemBuilder: (context, index) {
//                         var record = _healthRecords[index];
//
//                         // If search query is not empty, filter records by doctor name
//                         if (_searchQuery.isNotEmpty &&
//                             !(record['doctorName'] ?? '')
//                                 .toLowerCase()
//                                 .contains(_searchQuery.toLowerCase())) {
//                           return const SizedBox
//                               .shrink(); // Skip this record if it doesn't match search query
//                         }
//
//                         return Card(
//                           color: Colors.white,
//                           // Set the card background color to white
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 15),
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             // Reduced padding for smaller card
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Doctor's Photo and Name in Row
//                                 InkWell(
//                                 onTap: () {
//                                   Navigator.pushNamed(context,
//                                       Routes.doctorDetail, arguments: Doctor(name:record['doctorName'] ?? '', specialty:record['doctorSpecialization'] ??
//                                       '', imageUrl:record['doctorPhoto'] ?? '', hospital:record['hospitalName'] ??
//                                       'Hospital Name'));
//                               },
//                              child:    Row(
//                                   children: [
//                                     // Left side: Doctor's Photo (with square and border radius)
//                                     Container(
//                                       width: 70, // Reduced size for the image
//                                       height: 70, // Reduced size for the image
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         // Border radius for rounded corners
//                                         image: DecorationImage(
//                                           image: NetworkImage(
//                                               record['doctorPhoto'] ?? ''),
//                                           fit: BoxFit.fill,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 16),
//                                     // Add space between the photo and the text
//
//                                     // Right side: Doctor Info (Doctor's Name and Specialization)
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           Text(
//                                             record['doctorName'] ?? 'N/A',
//                                             style: TextStyle(
//                                               fontSize: 18, // Reduced text size
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           SizedBox(height: 5),
//                                           Text(
//                                             record['doctorSpecialization'] ??
//                                                 'Specialization',
//                                             style: TextStyle(fontSize: 14,
//                                                 color: Colors
//                                                     .grey), // Smaller size
//                                           ),
//                                           SizedBox(height: 5),
//                                           Divider(
//                                             thickness: 1,
//                                             color: Color(0xFF1581BF),
//                                           ),
//                                           SizedBox(height: 5),
//                                           Text(
//                                             record['hospitalName'] ??
//                                                 'Hospital Name',
//                                             style: TextStyle(
//                                                 fontSize: 14), // Smaller size
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//
//                                 ),
//                                 ),
//                                 SizedBox(height: 10),
//
//                                 // Full-width Button with Green Border and Text
//                                 Container(
//                                   width: double.infinity,
//                                   // Makes the button stretch across the card width
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       // Handle button press
//                                       var selectedDoctor=_healthRecords[index];
//                                       Navigator.pushNamed(context,
//                                           Routes.createAppointmentsPage, arguments: CreateAppointmentArgs(state.userData!, record["osid"]));
//                                       // Navigator.pushNamed(context,
//                                       //     Routes.createAppointmentsPage, arguments:Doctor(name: selectedDoctor['doctorName'] ?? '', specialty: selectedDoctor['doctorSpecialization'] ??
//                                       //         'Specialization', hospital: selectedDoctor['hospitalName'] ??
//                                       //         'Hospital Name', imageUrl: selectedDoctor['doctorPhoto'] ?? '') ,);
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.white,
//                                       // Set background color to white
//                                       side: BorderSide(color: Color(0xFF1581BF)),
//                                       // Set border color to green
//                                       padding: EdgeInsets.all(12),
//                                       // Padding inside the button
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(
//                                             6), // Border radius for button
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       'Book Appointment',
//                                       style: TextStyle(
//                                         color: Color(0xFF1581BF) // Set text color to green
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:xplor/features/appointmet/presentation/pages/doctor/appointment_screen.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../utils/common_top_header.dart';
import '../../../appointmet/domain/entities/CreateAppointmentArgs.dart';
import '../../../appointmet/presentation/pages/doctor/doctor.dart';
import '../../../profile/presentation/bloc/seeker_profile_bloc/seeker_profile_bloc.dart';

class SeekerHomePageView extends StatefulWidget {
  const SeekerHomePageView({super.key});

  @override
  State<SeekerHomePageView> createState() => _SeekerHomePageViewState();
}

class _SeekerHomePageViewState extends State<SeekerHomePageView> {
  List<dynamic> _healthRecords = [];
  List<dynamic> _healthRecordsFilter = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = "";
  String? _selectedSpecialist;
  String? _selectedHospital;

  @override
  void initState() {
    super.initState();
    _fetchHealthRecords();
  }

  Future<void> _fetchHealthRecords() async {
    final url = Uri.parse(
        'https://testspar.dpgongcp.com/registry/api/v1/Hospital/search');

    setState(() {
      _isLoading = true;
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
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> records = responseData['data'] ?? [];

        setState(() {
          _healthRecords = records;
          _healthRecordsFilter = records;
        });
      } else {
        setState(() {
          _errorMessage =
          'Failed to load health records: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching health records: $e';
      });
    }
  }

  void _applyFilters() {
    if (_selectedSpecialist != null || _selectedHospital != null) {
      setState(() {
        _healthRecords = _healthRecordsFilter.where((record) {
          bool matchesSpecialist = _selectedSpecialist == null ||
              record['doctorSpecialization'] == _selectedSpecialist;
          bool matchesHospital = _selectedHospital == null ||
              record['hospitalName'] == _selectedHospital;

          return matchesSpecialist && matchesHospital;
        }).toList();
      });

    } else {
      setState(() {
        _healthRecords = _healthRecordsFilter;
      });
    }
    setState(() {
      _selectedSpecialist=null;
      _selectedHospital =null;
    });
  }

  void _showFilterDialog() {
    // Create local variables to track selection within the dialog
    String? localSelectedSpecialist = _selectedSpecialist;
    String? localSelectedHospital = _selectedHospital;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter dialogSetState) {
              // Get unique specialists and hospitals
              final uniqueSpecialists = _healthRecordsFilter
                  .map<String>((record) => record['doctorSpecialization'] ?? '')
                  .where((specialist) => specialist.isNotEmpty)
                  .toSet()
                  .toList();

              final uniqueHospitals = _healthRecordsFilter
                  .map<String>((record) => record['hospitalName'] ?? '')
                  .where((hospital) => hospital.isNotEmpty)
                  .toSet()
                  .toList();

              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.85,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Filter',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),

                      // Specialist Dropdown
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF1581BF)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton<String>(
                            value: localSelectedSpecialist,
                            hint: Text('Select Specialist'),
                            onChanged: (String? newValue) {
                              dialogSetState(() {
                                localSelectedSpecialist = newValue;
                              });
                            },
                            isExpanded: true,
                            items: uniqueSpecialists.map<
                                DropdownMenuItem<String>>((String specialist) {
                              return DropdownMenuItem<String>(
                                value: specialist,
                                child: Text(specialist),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Hospital Dropdown
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF1581BF)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton<String>(
                            value: localSelectedHospital,
                            hint: Text('Select Hospital'),
                            onChanged: (String? newValue) {
                              dialogSetState(() {
                                localSelectedHospital = newValue;
                              });
                            },
                            isExpanded: true,
                            items: uniqueHospitals.map<
                                DropdownMenuItem<String>>((String hospital) {
                              return DropdownMenuItem<String>(
                                value: hospital,
                                child: Text(hospital),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Apply Filter Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Update the class-level variables when Apply is pressed
                            setState(() {
                              _selectedSpecialist = localSelectedSpecialist;
                              _selectedHospital = localSelectedHospital;
                            });
                            Navigator.pop(context);
                            _applyFilters();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1581BF),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Apply Filter',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }
  Future<void> _refreshData() async {
    // Simulate a delay for demonstration
    await _fetchHealthRecords();
    // Here, you would typically fetch new data from a server or database
    // Trigger a UI update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(91), // Adjust height as needed
        child: CommonTopHeader(
            title: 'HOME',
            isTitleOnly: false,
            dividerColor: Colors.grey, // Use appropriate color
            onBackButtonPressed: () => Navigator

        ),
      ),


      body: Container(
        color: Colors.grey[200], // Set the background color to light gray
        child: Column(
          children: [
            // Search Bar for searching doctor by name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    // Border radius for rounded corners

                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(202, 197, 197, 0.5),
                        // Shadow color with some opacity
                        blurRadius: 6.0,
                        // Blur radius for a soft shadow
                        offset: Offset(
                            0, 2), // Shadow offset, slightly downward
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
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF1581BF),
                          // Bottom border color when not focused
                          width: 2.0, // Border width
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        // Border radius for the focused state
                        borderSide: const BorderSide(
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
            // Filter Button (added below search bar)

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 0, bottom: 0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _showFilterDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFF1581BF)),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: Color(0xFF1581BF),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Filter',
                            style: TextStyle(
                              color: Color(0xFF1581BF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: _refreshData, // Add onPressed for refresh button
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFF1581BF)),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Color(0xFF1581BF),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Refresh',
                            style: TextStyle(
                              color: Color(0xFF1581BF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   // Align the button to the left side
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 16.0, top: 0, bottom: 0),
            //     child: ElevatedButton(
            //       onPressed: _showFilterDialog, // Open filter dialog on press
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.white,
            //         side: BorderSide(color: Color(0xFF1581BF)),
            //         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            //         // Smaller padding for smaller button
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(6),
            //         ),
            //       ),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         // Ensure the button doesn't take up extra space
            //         children: [
            //           Icon(
            //             Icons.filter_list, // Filter icon
            //             color: Color(0xFF1581BF),
            //             size: 20, // Icon size
            //           ),
            //           SizedBox(width: 8), // Space between icon and text
            //           Text(
            //             'Filter',
            //             style: TextStyle(
            //               color: Color(0xFF1581BF),
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //
            //         ],
            //
            //       ),
            //     ),
            //   ),
            // ),
            // If loading show a progress indicator, else show records or error
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator while fetching data
                : _errorMessage.isNotEmpty
                ? Text(
              _errorMessage,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ) // Show error message
                : Expanded(
              child: BlocBuilder<SeekerProfileBloc, SeekerProfileState>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: _healthRecords.length,
                      itemBuilder: (context, index) {
                        var record = _healthRecords[index];

                        // If search query is not empty, filter records by doctor name
                        if (_searchQuery.isNotEmpty &&
                            !(record['doctorName'] ?? '')
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase())) {
                          return const SizedBox
                              .shrink(); // Skip this record if it doesn't match search query
                        }

                        return Card(
                          color: Colors.white,
                          // Set the card background color to white
                          margin: const EdgeInsets.symmetric(
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
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        Routes.doctorDetail, arguments: Doctor(
                                            name: record['doctorName'] ?? '',
                                            specialty: record['doctorSpecialization'] ??
                                                '',
                                            imageUrl: record['doctorPhoto'] ??
                                                '',
                                            hospital: record['hospitalName'] ??
                                                'Hospital Name'));
                                  },
                                  child: Row(
                                    children: [
                                      // Left side: Doctor's Photo (with square and border radius)
                                      Container(
                                        width: 70,
                                        // Reduced size for the image
                                        height: 70,
                                        // Reduced size for the image
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              5),
                                          // Border radius for rounded corners
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                record['doctorPhoto'] ?? ''),
                                            fit: BoxFit.fill,
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
                                              record['doctorName'] ?? 'N/A',
                                              style: TextStyle(
                                                fontSize: 18,
                                                // Reduced text size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              record['doctorSpecialization'] ??
                                                  'Specialization',
                                              style: TextStyle(fontSize: 14,
                                                  color: Colors
                                                      .grey), // Smaller size
                                            ),
                                            SizedBox(height: 5),
                                            Divider(
                                              thickness: 1,
                                              color: Color(0xFF1581BF),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              record['hospitalName'] ??
                                                  'Hospital Name',
                                              style: TextStyle(
                                                  fontSize: 14), // Smaller size
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                  ),
                                ),
                                SizedBox(height: 10),

                                // Full-width Button with Green Border and Text
                                Container(
                                  width: double.infinity,
                                  // Makes the button stretch across the card width
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Handle button press
                                      var selectedDoctor = _healthRecords[index];
                                      Navigator.pushNamed(context,
                                          Routes.createAppointmentsPage,
                                          arguments: CreateAppointmentArgs(
                                              state.userData!, record["osid"]));
                                      // Navigator.pushNamed(context,
                                      //     Routes.createAppointmentsPage, arguments:Doctor(name: selectedDoctor['doctorName'] ?? '', specialty: selectedDoctor['doctorSpecialization'] ??
                                      //         'Specialization', hospital: selectedDoctor['hospitalName'] ??
                                      //         'Hospital Name', imageUrl: selectedDoctor['doctorPhoto'] ?? '') ,);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      // Set background color to white
                                      side: BorderSide(
                                          color: Color(0xFF1581BF)),
                                      // Set border color to green
                                      padding: EdgeInsets.all(12),
                                      // Padding inside the button
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            6), // Border radius for button
                                      ),
                                    ),
                                    child: const Text(
                                      'Book Appointment',
                                      style: TextStyle(
                                          color: Color(
                                              0xFF1581BF) // Set text color to green
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}