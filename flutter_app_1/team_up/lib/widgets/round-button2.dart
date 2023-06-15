import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 52,
      ),
      
      child: CircleAvatar(
        radius: 41,
        //backgroundColor: Colors.green,
        
        //foregroundColor: Colors.black,
        child: Icon(
          icon,
          size: 47,
        ),
        
      ),
    );
  }
  
}
