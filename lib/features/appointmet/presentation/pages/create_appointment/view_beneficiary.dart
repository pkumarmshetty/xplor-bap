// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../../../../../utils/common_top_header.dart';
// //
// // class Beneficiary {
// //   final String name;
// //   final String relationship;
// //   final int age;
// //
// //   Beneficiary({
// //     required this.name,
// //     required this.relationship,
// //     required this.age,
// //   });
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'name': name,
// //       'relationship': relationship,
// //       'age': age,
// //     };
// //   }
// //
// //   factory Beneficiary.fromMap(Map<String, dynamic> map) {
// //     return Beneficiary(
// //       name: map['name'] ?? '',
// //       relationship: map['relationship'] ?? '',
// //       age: map['age'] ?? 0,
// //     );
// //   }
// //
// //   String toJson() => json.encode(toMap());
// //
// //   factory Beneficiary.fromJson(String jsonStr) =>
// //       Beneficiary.fromMap(json.decode(jsonStr));
// // }
// //
// // class ViewBeneficiaryPage extends StatefulWidget {
// //   const ViewBeneficiaryPage({Key? key}) : super(key: key);
// //
// //   @override
// //   _ViewBeneficiaryPageState createState() => _ViewBeneficiaryPageState();
// // }
// //
// // class _ViewBeneficiaryPageState extends State<ViewBeneficiaryPage> {
// //   List<Beneficiary> _beneficiaries = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadBeneficiaries();
// //   }
// //
// //   Future<void> _loadBeneficiaries() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
// //
// //     if (beneficiariesJson != null) {
// //       setState(() {
// //         _beneficiaries = beneficiariesJson
// //             .map((jsonStr) => Beneficiary.fromJson(jsonStr))
// //             .toList();
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: PreferredSize(
// //         preferredSize: Size.fromHeight(100), // Adjust height as needed
// //         child: CommonTopHeader(
// //           title: 'View Beneficiaries',
// //           isTitleOnly: false,
// //           dividerColor: Colors.grey, // Use appropriate color
// //           onBackButtonPressed: () => Navigator.of(context).pop(),
// //         ),
// //       ),
// //       body: Container(
// //         color: Colors.white, // Set background color to white
// //         child: _beneficiaries.isEmpty
// //             ? Center(child: Text('No beneficiaries added yet.'))
// //             : ListView.builder(
// //           itemCount: _beneficiaries.length,
// //           itemBuilder: (context, index) {
// //             final beneficiary = _beneficiaries[index];
// //             return Card(
// //               child: ListTile(
// //                 title: Text('${beneficiary.name}'),
// //                 subtitle: Text(
// //                     'Relationship: ${beneficiary.relationship}, Age: ${beneficiary.age}'),
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../../../../../utils/common_top_header.dart'; // Assuming this is your CommonTopHeader widget
// //
// // class Beneficiary {
// //   final String name;
// //   final String relationship;
// //   final int age;
// //
// //   Beneficiary({
// //     required this.name,
// //     required this.relationship,
// //     required this.age,
// //   });
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'name': name,
// //       'relationship': relationship,
// //       'age': age,
// //     };
// //   }
// //
// //   factory Beneficiary.fromMap(Map<String, dynamic> map) {
// //     return Beneficiary(
// //       name: map['name'] ?? '',
// //       relationship: map['relationship'] ?? '',
// //       age: map['age'] ?? 0,
// //     );
// //   }
// //
// //   String toJson() => json.encode(toMap());
// //
// //   factory Beneficiary.fromJson(String jsonStr) =>
// //       Beneficiary.fromMap(json.decode(jsonStr));
// // }
// //
// // class ViewBeneficiaryPage extends StatefulWidget {
// //   const ViewBeneficiaryPage({Key? key}) : super(key: key);
// //
// //   @override
// //   _ViewBeneficiaryPageState createState() => _ViewBeneficiaryPageState();
// // }
// //
// // class _ViewBeneficiaryPageState extends State<ViewBeneficiaryPage> {
// //   List<Beneficiary> _beneficiaries = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadBeneficiaries();
// //   }
// //
// //   Future<void> _loadBeneficiaries() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
// //
// //     if (beneficiariesJson != null) {
// //       setState(() {
// //         _beneficiaries = beneficiariesJson
// //             .map((jsonStr) => Beneficiary.fromJson(jsonStr))
// //             .toList();
// //       });
// //     }
// //   }
// //
// //   Future<void> _deleteBeneficiary(int index) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
// //
// //     if (beneficiariesJson != null && index >= 0 && index < beneficiariesJson.length) {
// //       beneficiariesJson.removeAt(index);
// //       prefs.setStringList('beneficiaries', beneficiariesJson);
// //
// //       setState(() {
// //         _beneficiaries.removeAt(index);
// //       });
// //     }
// //   }
// //
// //   void _showEditPopup(int index) {
// //     final beneficiary = _beneficiaries[index];
// //     TextEditingController nameController = TextEditingController(text: beneficiary.name);
// //     TextEditingController relationshipController = TextEditingController(text: beneficiary.relationship);
// //     TextEditingController ageController = TextEditingController(text: beneficiary.age.toString());
// //
// //     showDialog(
// //       context: context,
// //
// //       builder: (context) => AlertDialog(
// //         title: const Text('Edit Beneficiary'),
// //         backgroundColor: Colors.white,
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               controller: nameController,
// //               decoration: const InputDecoration(labelText: 'Name'),
// //             ),
// //             TextField(
// //               controller: relationshipController,
// //               decoration: const InputDecoration(labelText: 'Relationship'),
// //             ),
// //             TextField(
// //               controller: ageController,
// //               keyboardType: TextInputType.number,
// //               decoration: const InputDecoration(labelText: 'Age'),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Cancel'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               _updateBeneficiary(index, Beneficiary(
// //                 name: nameController.text,
// //                 relationship: relationshipController.text,
// //                 age: int.tryParse(ageController.text) ?? 0, // Handle invalid age input
// //               ));
// //               Navigator.pop(context);
// //             },
// //             child: const Text('Save'),
// //
// //           ),
// //         ],
// //       ),
// //
// //     );
// //   }
// //
// //   Future<void> _updateBeneficiary(int index, Beneficiary updatedBeneficiary) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
// //
// //     if (beneficiariesJson != null && index >= 0 && index < beneficiariesJson.length) {
// //       beneficiariesJson[index] = updatedBeneficiary.toJson();
// //       prefs.setStringList('beneficiaries', beneficiariesJson);
// //
// //       setState(() {
// //         _beneficiaries[index] = updatedBeneficiary;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: PreferredSize(
// //         preferredSize: const Size.fromHeight(100),
// //         child: CommonTopHeader(
// //           title: 'View Beneficiaries',
// //           isTitleOnly: false,
// //           dividerColor: Colors.grey,
// //           onBackButtonPressed: () => Navigator.of(context).pop(),
// //         ),
// //       ),
// //       body: Container(
// //         color: Colors.white,
// //         child: _beneficiaries.isEmpty
// //             ? Center(child: const Text('No beneficiaries added yet.'))
// //             : ListView.builder(
// //           itemCount: _beneficiaries.length,
// //           itemBuilder: (context, index) {
// //             final beneficiary = _beneficiaries[index];
// //             return Card(
// //               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add margin for the card
// //               color: Colors.white,  // Set the card background color to white
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,  // Align content to the left
// //                 children: [
// //                   ListTile(
// //                     title: Text(
// //                       '${beneficiary.name}',
// //                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Consistent font style and line height
// //                     ),
// //                     subtitle: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,  // Align items to the left
// //                       children: [
// //                         Text(
// //                           'Relationship: ${beneficiary.relationship}',
// //                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Same font style and line height
// //                         ),
// //                         // Add Age below Relationship in the same column
// //                         Text(
// //                           'Age: ${beneficiary.age}',  // Display Age directly below Relationship
// //                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Same font style and line height
// //                         ),
// //
// //                       ],
// //                     ),
// //                     trailing: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         IconButton(
// //                           icon: const Icon(Icons.edit),
// //                           color: Color(0xFF1581BF),
// //                           onPressed: () => _showEditPopup(index),
// //                         ),
// //                         IconButton(
// //                           icon: const Icon(Icons.delete),
// //                           color: Color(0xFF1581BF),
// //                           onPressed: () => _deleteBeneficiary(index),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //
// //
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:xplor/features/appointmet/presentation/pages/create_appointment/add_beneficiary.dart';
//
// import '../../../../../utils/common_top_header.dart'; // Assuming this is your CommonTopHeader widget
//
// class Beneficiary {
//   final String name;
//   final String relationship;
//   final int age;
//   final String _abhaId; // Add _abhaId field
//
//   Beneficiary({
//     required this.name,
//     required this.relationship,
//     required this.age,
//     required String abhaId, // Added _abhaId to constructor
//   }) : _abhaId = abhaId; // Initialize _abhaId
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'relationship': relationship,
//       'age': age,
//       'abhaId': _abhaId, // Include _abhaId in the map
//     };
//   }
//
//   factory Beneficiary.fromMap(Map<String, dynamic> map) {
//     return Beneficiary(
//       name: map['name'] ?? '',
//       relationship: map['relationship'] ?? '',
//       age: map['age'] ?? 0,
//       abhaId: map['abhaId'] ?? '', // Get _abhaId from the map
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory Beneficiary.fromJson(String jsonStr) =>
//       Beneficiary.fromMap(json.decode(jsonStr));
// }
//
// class ViewBeneficiaryPage extends StatefulWidget {
//   const ViewBeneficiaryPage({Key? key}) : super(key: key);
//
//   @override
//   _ViewBeneficiaryPageState createState() => _ViewBeneficiaryPageState();
// }
//
// class _ViewBeneficiaryPageState extends State<ViewBeneficiaryPage> {
//   List<Beneficiary> _beneficiaries = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBeneficiaries();
//   }
//
//   Future<void> _loadBeneficiaries() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
//
//     if (beneficiariesJson != null) {
//       setState(() {
//         _beneficiaries = beneficiariesJson
//             .map((jsonStr) => Beneficiary.fromJson(jsonStr))
//             .toList();
//       });
//     }
//   }
//
//   Future<void> _deleteBeneficiary(int index) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
//
//     if (beneficiariesJson != null && index >= 0 && index < beneficiariesJson.length) {
//       beneficiariesJson.removeAt(index);
//       prefs.setStringList('beneficiaries', beneficiariesJson);
//
//       setState(() {
//         _beneficiaries.removeAt(index);
//       });
//     }
//   }
//
//   void _showEditPopup(int index) {
//     final beneficiary = _beneficiaries[index];
//     TextEditingController nameController = TextEditingController(text: beneficiary.name);
//     TextEditingController relationshipController = TextEditingController(text: beneficiary.relationship);
//     TextEditingController ageController = TextEditingController(text: beneficiary.age.toString());
//     TextEditingController abhaIdController = TextEditingController(text: beneficiary._abhaId); // Add ABHA ID controller
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Beneficiary'),
//         backgroundColor: Colors.white,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: relationshipController,
//               decoration: const InputDecoration(labelText: 'Relationship'),
//             ),
//             TextField(
//               controller: ageController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: 'Age'),
//             ),
//             TextField(
//               controller: abhaIdController, // Add text field for ABHA ID
//               decoration: const InputDecoration(labelText: 'ABHA ID'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//             style: TextButton.styleFrom(
//               foregroundColor: Color(0xFF1581BF), // Set text color
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               _updateBeneficiary(index, Beneficiary(
//                 name: nameController.text,
//                 relationship: relationshipController.text,
//                 age: int.tryParse(ageController.text) ?? 0, // Handle invalid age input
//                 abhaId: abhaIdController.text, // Use ABHA ID value
//               ));
//               Navigator.pop(context);
//             },
//             child: const Text('Save'),
//             style: TextButton.styleFrom(
//               foregroundColor: Color(0xFF1581BF), // Set text color
//             ),
//           ),
//         ],
//
//
//       ),
//     );
//   }
//
//   Future<void> _updateBeneficiary(int index, Beneficiary updatedBeneficiary) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
//
//     if (beneficiariesJson != null && index >= 0 && index < beneficiariesJson.length) {
//       beneficiariesJson[index] = updatedBeneficiary.toJson();
//       prefs.setStringList('beneficiaries', beneficiariesJson);
//
//       setState(() {
//         _beneficiaries[index] = updatedBeneficiary;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(100),
//         child: CommonTopHeader(
//           title: 'View Beneficiaries',
//           isTitleOnly: false,
//           dividerColor: Colors.grey,
//           onBackButtonPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: _beneficiaries.isEmpty
//             ? Center(child: const Text('No beneficiaries added yet.'))
//             : ListView.builder(
//           itemCount: _beneficiaries.length,
//           itemBuilder: (context, index) {
//             final beneficiary = _beneficiaries[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add margin for the card
//               color: Colors.white,  // Set the card background color to white
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,  // Align content to the left
//                 children: [
//                   ListTile(
//                     title: Text(
//                       '${beneficiary.name}',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Consistent font style and line height
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,  // Align items to the left
//                       children: [
//                         Text(
//                           'Relationship: ${beneficiary.relationship}',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Same font style and line height
//                         ),
//                         // Add Age below Relationship in the same column
//                         Text(
//                           'Age: ${beneficiary.age}',  // Display Age directly below Relationship
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Same font style and line height
//                         ),
//                         // Display ABHA ID
//                         Text(
//                           'ABHA ID: ${beneficiary._abhaId}',  // Display ABHA ID below Age
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Same font style and line height
//                         ),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit),
//                           color: Color(0xFF1581BF),
//                           onPressed: () => _showEditPopup(index),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           color: Color(0xFF1581BF),
//                           onPressed: () => _deleteBeneficiary(index),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: Implement navigation to Add Beneficiary page
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddBeneficiaryPage(),
//             ),
//           );
//
//
//           print('Add Beneficiary button pressed');
//         },
//         backgroundColor: Color(0xFF1581BF),
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//
//     );
//   }
// }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:xplor/features/appointmet/presentation/pages/create_appointment/add_beneficiary.dart'; // Assuming this is your AddBeneficiaryPage
//
// import '../../../../../utils/common_top_header.dart'; // Assuming this is your CommonTopHeader widget
//
// // Beneficiary model with ABHA ID
// class Beneficiary {
//   final String name;
//   final String relationship;
//   final int age;
//   final String _abhaId; // Add _abhaId field
//
//   Beneficiary({
//     required this.name,
//     required this.relationship,
//     required this.age,
//     required String abhaId, // Added _abhaId to constructor
//   }) : _abhaId = abhaId; // Initialize _abhaId
//
//   // Convert Beneficiary to Map
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'relationship': relationship,
//       'age': age,
//       'abhaId': _abhaId, // Include _abhaId in the map
//     };
//   }
//
//   // Create Beneficiary from Map
//   factory Beneficiary.fromMap(Map<String, dynamic> map) {
//     return Beneficiary(
//       name: map['name'] ?? '',
//       relationship: map['relationship'] ?? '',
//       age: map['age'] ?? 0,
//       abhaId: map['abhaId'] ?? '', // Get _abhaId from the map
//     );
//   }
//
//   // Convert Beneficiary to JSON
//   String toJson() => json.encode(toMap());
//
//   // Create Beneficiary from JSON string
//   factory Beneficiary.fromJson(String jsonStr) =>
//       Beneficiary.fromMap(json.decode(jsonStr));
// }
//
// class ViewBeneficiaryPage extends StatefulWidget {
//   const ViewBeneficiaryPage({Key? key}) : super(key: key);
//
//   @override
//   _ViewBeneficiaryPageState createState() => _ViewBeneficiaryPageState();
// }
//
// class _ViewBeneficiaryPageState extends State<ViewBeneficiaryPage> {
//   List<Beneficiary> _beneficiaries = [];
//
//   // Load beneficiaries from SharedPreferences
//   @override
//   void initState() {
//     super.initState();
//     _loadBeneficiaries();
//   }
//
//   Future<void> _loadBeneficiaries() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
//
//     if (beneficiariesJson != null) {
//       setState(() {
//         _beneficiaries = beneficiariesJson
//             .map((jsonStr) => Beneficiary.fromJson(jsonStr))
//             .toList();
//       });
//     }
//   }
//
//   // Delete a beneficiary from SharedPreferences and update UI
//   Future<void> _deleteBeneficiary(int index) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
//
//     if (beneficiariesJson != null && index >= 0 && index < beneficiariesJson.length) {
//       beneficiariesJson.removeAt(index);
//       prefs.setStringList('beneficiaries', beneficiariesJson);
//
//       setState(() {
//         _beneficiaries.removeAt(index);
//       });
//     }
//   }
//
//   // Show edit popup for a beneficiary
//   void _showEditPopup(int index) {
//     final beneficiary = _beneficiaries[index];
//     TextEditingController nameController = TextEditingController(text: beneficiary.name);
//     TextEditingController relationshipController = TextEditingController(text: beneficiary.relationship);
//     TextEditingController ageController = TextEditingController(text: beneficiary.age.toString());
//     TextEditingController abhaIdController = TextEditingController(text: beneficiary._abhaId); // Add ABHA ID controller
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Beneficiary'),
//         backgroundColor: Colors.white,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: relationshipController,
//               decoration: const InputDecoration(labelText: 'Relationship'),
//             ),
//             TextField(
//               controller: ageController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: 'Age'),
//             ),
//             TextField(
//               controller: abhaIdController, // Add text field for ABHA ID
//               decoration: const InputDecoration(labelText: 'ABHA ID'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//             style: TextButton.styleFrom(
//               foregroundColor: Color(0xFF1581BF), // Set text color
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               _updateBeneficiary(index, Beneficiary(
//                 name: nameController.text,
//                 relationship: relationshipController.text,
//                 age: int.tryParse(ageController.text) ?? 0, // Handle invalid age input
//                 abhaId: abhaIdController.text, // Use ABHA ID value
//               ));
//               Navigator.pop(context);
//             },
//             child: const Text('Save'),
//             style: TextButton.styleFrom(
//               foregroundColor: Color(0xFF1581BF), // Set text color
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Update a beneficiary in SharedPreferences and update UI
//   Future<void> _updateBeneficiary(int index, Beneficiary updatedBeneficiary) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');
//
//     if (beneficiariesJson != null && index >= 0 && index < beneficiariesJson.length) {
//       beneficiariesJson[index] = updatedBeneficiary.toJson();
//       prefs.setStringList('beneficiaries', beneficiariesJson);
//
//       setState(() {
//         _beneficiaries[index] = updatedBeneficiary;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(100),
//         child: CommonTopHeader(
//           title: 'View Beneficiaries',
//           isTitleOnly: false,
//           dividerColor: Colors.grey,
//           onBackButtonPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: _beneficiaries.isEmpty
//             ? Center(child: const Text('No beneficiaries added yet.'))
//             : ListView.builder(
//           itemCount: _beneficiaries.length,
//           itemBuilder: (context, index) {
//             final beneficiary = _beneficiaries[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add margin for the card
//               color: Colors.white,  // Set the card background color to white
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,  // Align content to the left
//                 children: [
//                   ListTile(
//                     title: Text(
//                       '${beneficiary.name}',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Consistent font style and line height
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,  // Align items to the left
//                       children: [
//                         Text(
//                           'Relationship: ${beneficiary.relationship}',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Same font style and line height
//                         ),
//                         // Add Age below Relationship in the same column
//                         Text(
//                           'Age: ${beneficiary.age}',  // Display Age directly below Relationship
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Same font style and line height
//                         ),
//                         // Display ABHA ID
//                         Text(
//                           'ABHA ID: ${beneficiary._abhaId}',  // Display ABHA ID below Age
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),  // Same font style and line height
//                         ),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit),
//                           color: Color(0xFF1581BF),
//                           onPressed: () => _showEditPopup(index),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           color: Color(0xFF1581BF),
//                           onPressed: () => _deleteBeneficiary(index),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to Add Beneficiary page
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddBeneficiaryPage(),
//             ),
//           );
//           print('Add Beneficiary button pressed');
//         },
//         backgroundColor: Color(0xFF1581BF),
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/features/appointmet/presentation/pages/create_appointment/add_beneficiary.dart';

import '../../../../../utils/common_top_header.dart';

class Beneficiary {
  final String name;
  final String relationship;
  final int age;
  final String _abhaId;

  Beneficiary({
    required this.name,
    required this.relationship,
    required this.age,
    required String abhaId,
  }) : _abhaId = abhaId;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relationship': relationship,
      'age': age,
      'abhaId': _abhaId,
    };
  }

  factory Beneficiary.fromMap(Map<String, dynamic> map) {
    return Beneficiary(
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      age: map['age'] ?? 0,
      abhaId: map['abhaId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Beneficiary.fromJson(String jsonStr) =>
      Beneficiary.fromMap(json.decode(jsonStr));
}

class ViewBeneficiaryPage extends StatefulWidget {
  const ViewBeneficiaryPage({Key? key}) : super(key: key);

  @override
  _ViewBeneficiaryPageState createState() => _ViewBeneficiaryPageState();
}

class _ViewBeneficiaryPageState extends State<ViewBeneficiaryPage> {
  List<Beneficiary> _beneficiaries = [];

  @override
  void initState() {
    super.initState();
    _loadBeneficiaries();
  }

  Future<void> _loadBeneficiaries() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');

    if (beneficiariesJson != null) {
      setState(() {
        _beneficiaries = beneficiariesJson
            .map((jsonStr) => Beneficiary.fromJson(jsonStr))
            .toList();
      });
    }
  }

  Future<void> _deleteBeneficiary(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');

    if (beneficiariesJson != null && index >= 0 && index < beneficiariesJson.length) {
      beneficiariesJson.removeAt(index);
      prefs.setStringList('beneficiaries', beneficiariesJson);

      setState(() {
        _beneficiaries.removeAt(index);
      });
    }
  }

  void _showEditPopup(int index) {
    final beneficiary = _beneficiaries[index];
    TextEditingController nameController = TextEditingController(text: beneficiary.name);
    TextEditingController relationshipController = TextEditingController(text: beneficiary.relationship);
    TextEditingController ageController = TextEditingController(text: beneficiary.age.toString());
    TextEditingController abhaIdController = TextEditingController(text: beneficiary._abhaId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Beneficiary'),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: relationshipController,
              decoration: const InputDecoration(labelText: 'Relationship'),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: abhaIdController,
              decoration: const InputDecoration(labelText: 'ABHA ID'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF1581BF),
            ),
          ),
          TextButton(
            onPressed: () {
              _updateBeneficiary(index, Beneficiary(
                name: nameController.text,
                relationship: relationshipController.text,
                age: int.tryParse(ageController.text) ?? 0,
                abhaId: abhaIdController.text,
              ));
              Navigator.pop(context);
            },
            child: const Text('Save'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF1581BF),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateBeneficiary(int index, Beneficiary updatedBeneficiary) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? beneficiariesJson = prefs.getStringList('beneficiaries');

    if (beneficiariesJson != null && index >= 0 && index < beneficiariesJson.length) {
      beneficiariesJson[index] = updatedBeneficiary.toJson();
      prefs.setStringList('beneficiaries', beneficiariesJson);

      setState(() {
        _beneficiaries[index] = updatedBeneficiary;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CommonTopHeader(
          title: 'View Beneficiaries',
          isTitleOnly: false,
          dividerColor: Colors.grey,
          onBackButtonPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _beneficiaries.isEmpty
            ? Center(child: const Text('No beneficiaries added yet.'))
            : ListView.builder(
          itemCount: _beneficiaries.length,
          itemBuilder: (context, index) {
            final beneficiary = _beneficiaries[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      '${beneficiary.name}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Relationship: ${beneficiary.relationship}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        Text(
                          'Age: ${beneficiary.age}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        Text(
                          'ABHA ID: ${beneficiary._abhaId}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Color(0xFF1581BF),
                          onPressed: () => _showEditPopup(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Color(0xFF1581BF),
                          onPressed: () => _deleteBeneficiary(index),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to Add Beneficiary page and reload the list after returning
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBeneficiaryPage(),
            ),
          );

          // Reload the beneficiaries list when returning from AddBeneficiaryPage
          _loadBeneficiaries();
        },
        backgroundColor: Color(0xFF1581BF),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

