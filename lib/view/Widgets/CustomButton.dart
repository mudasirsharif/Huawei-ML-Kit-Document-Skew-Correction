import 'package:flutter/material.dart';
import 'dart:developer';

class CustomButton extends StatelessWidget {
  final String buttonLabel;
  final Function() onQueryChange;
  final bool disabled;

  CustomButton({this.onQueryChange, this.buttonLabel, this.disabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!disabled) onQueryChange();
      },
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              disabled ? Colors.grey : Colors.teal,
              disabled ? Colors.grey[200] : Colors.teal[200],
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(5, 5),
              blurRadius: 10,
            )
          ],
        ),
        child: Center(
          child: Text(
            buttonLabel,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
