import 'package:flutter/material.dart';
import 'health_record_pdf.dart';

class HealthRecordSearchScreen extends StatefulWidget {
  const HealthRecordSearchScreen({Key? key}) : super(key: key);

  @override
  _HealthRecordSearchScreenState createState() =>
      _HealthRecordSearchScreenState();
}

class _HealthRecordSearchScreenState extends State<HealthRecordSearchScreen> {
  final TextEditingController _abdmIdController = TextEditingController();
  List<Map<String, dynamic>> _healthRecords = [];
  bool _isLoading = false;

  final List<Map<String, dynamic>> _mockData = [
    {
      "id": "1",
      "title": "Annual Health Checkup 2023",
      "date": "2023-10-01",
      "summary":
      "Comprehensive health checkup including blood tests, BMI, and blood pressure analysis.",
      "doctor": "Dr. Alice Williams",
      "pdfUrl": "https://example.com/pdf/annual-health-checkup-2023.pdf"
    },
    {
      "id": "2",
      "title": "Dental Consultation",
      "date": "2023-09-15",
      "summary": "Routine dental checkup, cavity filling, and cleaning.",
      "doctor": "Dr. John Smith",
      "pdfUrl": "https://example.com/pdf/dental-consultation.pdf"
    },
    {
      "id": "3",
      "title": "Eye Examination",
      "date": "2023-08-10",
      "summary": "Vision test and prescription for new glasses.",
      "doctor": "Dr. Emily Davis",
      "pdfUrl": "https://example.com/pdf/eye-examination.pdf"
    }
  ];

  void _searchHealthRecords() {
    setState(() {
      _isLoading = true;

      // Simulate a search by filtering records based on the entered ABDM ID
      final abdmId = _abdmIdController.text.trim();
      _healthRecords = _mockData
          .where((record) => record['id'].contains(abdmId))
          .toList();

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Health Records')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _abdmIdController,
              decoration: InputDecoration(
                labelText: 'Enter ABDM ID',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchHealthRecords,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (!_isLoading && _healthRecords.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _healthRecords.length,
                  itemBuilder: (context, index) {
                    final record = _healthRecords[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(record['title'] ?? 'No Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record['summary'] ?? 'No Summary Available',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text('Doctor: ${record['doctor'] ?? 'Unknown'}'),
                            Text('Date: ${record['date'] ?? 'Unknown Date'}'),
                          ],
                        ),
                        trailing: const Icon(Icons.picture_as_pdf),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HealthRecordPdfScreen(pdfUrl: record['pdfUrl']),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            if (!_isLoading && _healthRecords.isEmpty)
              const Text('No records found.'),
          ],
        ),
      ),
    );
  }
}
