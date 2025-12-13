import 'package:flutter/material.dart';

class WeatherTodayCard extends StatelessWidget {
  const WeatherTodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aujourd'hui",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Paris, France',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3A52),
                  ),
                ),
              ),
              const Icon(
                Icons.wb_cloudy_outlined,
                color: Color(0xFF00897B),
                size: 50,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Partiellement nuageux, quelques éclaircies',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              const Text(
                '18°',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B),
                  height: 1,
                ),
              ),
              const SizedBox(width: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Celsius',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Min 12°    Max 21°',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mise à jour il y a 5 min',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
              /*const Text(
                'Voir plus',
                style: TextStyle(
                  color: Color(0xFF00897B),
                  fontWeight: FontWeight.w600,
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
