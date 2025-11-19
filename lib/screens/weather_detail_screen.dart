import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/weather_today_card.dart';
import '../widgets/weather_day_item.dart';
import '../widgets/weather_detail_item.dart';

class WeatherDetailScreen extends StatelessWidget {
  const WeatherDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // ───────────────────────────────────────────────────────────
      // APPBAR
      // ───────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Météo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A52),
          ),
        ),
      ),

      // ───────────────────────────────────────────────────────────
      // BODY
      // ───────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 🟩 Carte météo du jour (widget séparé)
            const WeatherTodayCard(),

            const SizedBox(height: 30),

            // ─── Prévisions 7 jours ───
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Prévisions 7 jours',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A52),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  WeatherDayItem(
                    day: 'Lun',
                    icon: Icons.wb_cloudy_outlined,
                    tempHigh: '18°',
                    tempLow: '12°',
                    isSelected: true,
                  ),
                  SizedBox(width: 12),
                  WeatherDayItem(
                    day: 'Mar',
                    icon: Icons.cloud_outlined,
                    tempHigh: '17°',
                    tempLow: '11°',
                  ),
                  SizedBox(width: 12),
                  WeatherDayItem(
                    day: 'Mer',
                    icon: Icons.water_drop_outlined,
                    tempHigh: '15°',
                    tempLow: '10°',
                  ),
                  SizedBox(width: 12),
                  WeatherDayItem(
                    day: 'Jeu',
                    icon: Icons.cloud_outlined,
                    tempHigh: '16°',
                    tempLow: '9°',
                  ),
                  SizedBox(width: 12),
                  WeatherDayItem(
                    day: 'Ven',
                    icon: Icons.wb_sunny_outlined,
                    tempHigh: '20°',
                    tempLow: '13°',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ─── Détails météo ───
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Détail de la météo',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A52),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  Row(
                    children: [
                      Expanded(
                        child: WeatherDetailItem(
                          icon: Icons.air,
                          label: 'Vent',
                          value: '14 km/h',
                          subtitle: 'Direction Ouest',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: WeatherDetailItem(
                          icon: Icons.water_drop_outlined,
                          label: 'Humidité',
                          value: '62%',
                          subtitle: 'Ressenti légèrement humide',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: WeatherDetailItem(
                          icon: Icons.speed,
                          label: 'Pression',
                          value: '1018 hPa',
                          subtitle: 'Stable',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: WeatherDetailItem(
                          icon: Icons.thermostat_outlined,
                          label: 'Ressenti',
                          value: '17°',
                          subtitle: 'Léger vent, agréable',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // ───────────────────────────────────────────────────────────
      // BOTTOM NAVIGATION (standardisé)
      // ───────────────────────────────────────────────────────────
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
