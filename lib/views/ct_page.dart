import 'dart:io';

import 'package:flutter/material.dart';

import '../functions/image_picker.dart';
import '../functions/httpRequest.dart';

class CTPage extends StatefulWidget {
  @override
  _CTPageState createState() => _CTPageState();
}

class _CTPageState extends State<CTPage> {
  File pickedImage;
  ImgPicker imgPicker = ImgPicker();
  HttpOperations httpOperations = HttpOperations();

  void showErrDialog(msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An Error Occurd'),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okk'))
        ],
      ),
    );
  }

  void imagepickerFn() async {
    try {
      File selectedimg = await imgPicker.selctImg();
      setState(() {
        pickedImage = selectedimg;
      });
    } catch (e) {
      showErrDialog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CT Prdictor'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20)),
              child: (pickedImage != null)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        pickedImage,
                        fit: BoxFit.cover,
                      ))
                  : Center(
                      child: Text('no image selected'),
                    ),
            ),
            TextButton.icon(
                onPressed: imagepickerFn,
                icon: Icon(Icons.image),
                label: Text("Select Image")),
            ElevatedButton.icon(
              onPressed: (pickedImage == null)
                  ? null
                  : () {
                      httpOperations.PostRequest(
                          image: pickedImage, urlEndpoint: 'predict_ct');
                    },
              icon: Icon(Icons.analytics_outlined),
              label: Text("Predict"),
            ),
          ],
        ),
      ),
    );
  }
}
