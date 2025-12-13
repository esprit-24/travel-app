import 'package:flutter/material.dart';

class WeatherDayItem extends StatelessWidget {
  final String day;
  final IconData icon;
  final String tempHigh;
  final String tempLow;
  final bool isSelected;

  const WeatherDayItem({
    super.key,
    required this.day,
    required this.icon,
    required this.tempHigh,
    required this.tempLow,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF00897B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 26), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF1A3A52),
            ),
          ),
          const SizedBox(height: 12),
          Icon(
            icon,
            size: 32,
            color: isSelected ? Colors.white : const Color(0xFF00897B),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tempHigh,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF1A3A52),
                ),
              ),
              if (tempLow.isNotEmpty)
                Text(
                  " / $tempLow",
                  style: TextStyle(
                    color: isSelected ? Colors.white70 : Colors.grey.shade400,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
