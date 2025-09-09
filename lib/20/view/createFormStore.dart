import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/controller.dart';

class CreateFormStore extends StatelessWidget {
  final FormController controller = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'SPOODING',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Pacifico',
                  color: Colors.orange.shade400,
                ),
              ),
              TextSpan(
                text: ' Express',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Store Form',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                controller.name.value = value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
              onChanged: (value) {
                controller.phoneNumber.value = value;
              },
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.submitStoreForm(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
