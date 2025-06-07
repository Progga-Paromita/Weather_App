import 'package:flutter/material.dart';

class Additional_Info_Items extends StatelessWidget {
  final IconData icon;
  final String tittle;
  final String subTittle;

  const Additional_Info_Items({
    super.key,
    required this.icon,
    required this.tittle,
    required this.subTittle,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon, size: 45),
        Text(tittle, style: TextStyle(fontSize: 18)),
        Text(subTittle, style: TextStyle(fontSize: 25)),
      ],
    );
  }
}
