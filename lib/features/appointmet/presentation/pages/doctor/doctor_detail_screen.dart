
import 'package:flutter/material.dart';
import 'package:xplor/features/appointmet/presentation/pages/doctor/doctor.dart';
import 'package:xplor/utils/common_top_header.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(  preferredSize: const Size.fromHeight(100),    child: CommonTopHeader(    title: doctor.name,    isTitleOnly: false,    dividerColor: Colors.grey,     onBackButtonPressed: () => Navigator.of(context).pop(),  ),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:   Image.network(doctor.imageUrl ,height: 200,),
            ),
            SizedBox(height: 16.0),
            Text(
              doctor.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor.specialty,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            const Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'About'),
                        Tab(text: 'Work Experience'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // About Tab Content
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(' Dr. Doe is a highly skilled and compassionate General Surgeon with over 14 years of experience in providing exceptional surgical care. Known for his expertise in abdominal and laparoscopic surgery, Dr. D has dedicated his career to helping patients achieve better health through both surgical intervention and patient education. With a passion for improving lives and a meticulous approach to patient care, '
                                'he consistently strives for excellence in every aspect of his practice. Dr. Doe believes in the power of clear communication and patient-centered care. He takes the time to thoroughly discuss treatment options with his patients, ensuring they understand the risks, benefits, and expected outcomes of any procedure. His warm and approachable nature allows patients to feel comfortable and confident in their treatment decisions. Dr. Doe is also committed to staying '
                                'at the forefront of medical advancements, regularly attending seminars and continuing medical education courses'
                                ' to refine his skills and knowledge.'),
                          ),
                          // Work Experience Tab Content


                                Text(
                                  'Current Position:\n'
                                'Consultant General Surgeon\nSt. Mary\'s Hospital, New York\nJune 2015 – Present\n'
                                  'Perform routine and complex surgical procedures, specializing in abdominal, colorectal, and laparoscopic surgeries.\n'
                                      'Lead a multidisciplinary surgical team, overseeing patient care before, during, and after surgery to ensure the best possible outcomes.\n'
                                      'Provide comprehensive pre-operative and post-operative care, including consultation and patient education on recovery.\n'
                                      'Actively involved in the surgical training of junior residents and medical students, providing mentorship and hands-on guidance.\n'
                                      'Coordinate with anesthesiologists, nurses, and other specialists to develop customized surgical plans for each patient.\n'
                                      'Participate in weekly case review meetings to discuss complex cases and improve surgical techniques.\n'
                                      'Previous Position:'
                                      'General Surgery Resident\nCity General Hospital, Boston\nJuly 2010 – June 2015\n'
                                  ,
                                  style: TextStyle(fontSize: 16),
                                ),

                          // Ratings Tab Content

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}