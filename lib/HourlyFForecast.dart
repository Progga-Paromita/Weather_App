import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {

  final String level;
  final String subLevel;
  final IconData icon;

  const HourlyForecast({
    super.key,
    required this.level,
    required this.subLevel,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF333338),
      elevation: 6,
      child: Container(
        width: 110,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              level,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Icon(icon, size: 32),
            Text(subLevel),
          ],
        ),
      ),
    );
  }
}
