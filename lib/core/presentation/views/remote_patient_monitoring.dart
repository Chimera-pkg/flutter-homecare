import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';

class RemotePatientMonitoring extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Monitor My Vitals',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: TextStyle(fontSize: 18),
            ),
            Divider(color: Colors.grey),
            _buildVitalCard(
              context,
              'assets/icons/ic_heart.png',
              'Heart\nPerfomance',
              Colors.white, // Warna 9AE1FF dengan opasitas 25%
            ),
            _buildVitalCard(
              context,
              'assets/icons/ic_oxygen.png',
              'Blood Oxygen\nSaturation (SpO2)',
              Colors.white, // Warna 9AE1FF dengan opasitas 25%
            ),
            _buildVitalCard(
              context,
              'assets/icons/ic_blood.png',
              'Blood\nGlucose',
              Colors.white, // Warna 9AE1FF dengan opasitas 25%
            ),
            _buildVitalCard(
              context,
              'assets/icons/ic_bloodpressure.png',
              'Blood\nPressure',
              Colors.white, // Warna 9AE1FF dengan opasitas 25%
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          width: double.infinity,
          color: Const.tosca,
          child: Center(
            child: TextButton(
              onPressed: () {
                // Handle add new vital
              },
              child: Text(
                '+ Add New Vital',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVitalCard(BuildContext context, String iconPath, String title,
      Color backgroundColor) {
    return Card(
      color: backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 89,
                  height: 80,
                ),
                Spacer(),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Handle link device
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Const.tosca),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Link Device',
                    style: TextStyle(color: Const.tosca),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Handle add record
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Const.tosca),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add Record',
                    style: TextStyle(color: Const.tosca),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
