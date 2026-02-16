import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/Constants.dart';

class Utils {
  static void openImage(BuildContext context, String imageUrl) {
    Navigator.pushNamed(context, '/view_image', arguments: imageUrl);
  }

  static void errorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Colors.red,
      ),
    );
  }

  static void successMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Video uploaded successfully'),
        backgroundColor: Constants.themeColor,
        showCloseIcon: true,
        closeIconColor: Colors.white,
      ),
    );
  }

  static bool _isDialogVisible = false;
  static bool get isDialogVisible => _isDialogVisible;

  static void showErrorPopup(BuildContext context, String errorMessage) {
    if (_isDialogVisible) return;

    _isDialogVisible = true;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Dialog(
                insetPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19)),
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  height: 181,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          errorMessage,
                          maxLines: 4,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SimpleDialogOption(
                          onPressed: () {
                            _isDialogVisible = false;
                            Navigator.pop(dialogContext);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .25,
                            height: 43,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:Constants.themeColor,
                            ),
                            child: const Center(
                                child: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isDialogVisible = false;
    });
  }
}
