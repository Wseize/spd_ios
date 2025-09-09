import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spooding_exp_ios/20/view/courier.dart';

class AboutSpoodingExpressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About SpooDing Express',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade400,
      ),
      body: SingleChildScrollView(
        // Add SingleChildScrollView here
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to SpooDing Express!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'SpooDing Express is your local delivery app, providing quick and reliable delivery services right to your doorstep.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildFeatureItem('🚚 Fast Delivery'),
            _buildFeatureItem('🍽️ Wide Range of Restaurants'),
            _buildFeatureItem('🛍️ Shop from Local Stores'),
            // _buildFeatureItem('💳 Easy Payment Options'),
            _buildFeatureItem('📦 Real-Time Order Tracking'),
            SizedBox(height: 16),
            Text(
              'Send Courier Local:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Need to send a package locally? Use our courier service to deliver items quickly and efficiently!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoursierOrderScreen()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent, // Change color as desired
                    borderRadius:
                        BorderRadius.circular(30.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Send Courier Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Join us and enjoy the convenience of having your favorite food and products delivered to you in no time!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            Text(
              'Follow Us:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialMediaIcon(
                    'https://www.facebook.com/spoodingexpress',
                    FontAwesomeIcons.facebook,
                    'Facebook'),
                _buildSocialMediaIcon(
                    'https://www.instagram.com/spoodingexpress',
                    FontAwesomeIcons.instagram,
                    'Instagram'),
                _buildSocialMediaIcon(
                    'https://www.tiktok.com/@spooding_express',
                    FontAwesomeIcons.tiktok,
                    'TikTok'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green),
          SizedBox(width: 8),
          Expanded(child: Text(feature)),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcon(String url, IconData icon, String platform) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.orange.shade400),
        SizedBox(height: 5),
        Text(platform),
      ],
    );
  }
}
