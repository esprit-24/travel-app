import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/destination_model.dart';
import '../providers/user_provider.dart';
import '../providers/destination_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/destination_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/weather_card.dart';
import '../config/api_config.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final destinationsAsync = ref.watch(destinationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // 🔹 APPBAR
      // ============================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        // ⬅️ PHOTO USER
        leading: Consumer(
          builder: (context, ref, _) {
            final userAsync = ref.watch(userProvider);

            return userAsync.when(
              loading: () => Padding(
                padding: const EdgeInsets.only(left: 15),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              error: (_, __) =>
              const Icon(Icons.error, color: Colors.red),
              data: (user) {
                String photoUrl;

                if (user != null &&
                    user.photoUrl != null &&
                    user.photoUrl!.isNotEmpty) {
                  final baseImageUrl =
                  ApiConfig.baseUrl.replaceAll('/index.php', '');
                  photoUrl =
                  "$baseImageUrl/${user.photoUrl}?v=${DateTime.now().millisecondsSinceEpoch}";
                } else {
                  photoUrl =
                  "https://images.unsplash.com/photo-1544005313-94ddf0286df2";
                }

                return GestureDetector(
                  onTap: () => context.go('/profil'),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade300,
                      child: ClipOval(
                        child: Image.network(
                          photoUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.person,
                              size: 22,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),

        title: const Text(
          'Travel App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3A52),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => context.go('/notifications'),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF1A3A52),
                ),
              ),
            ),
          ),
        ],
      ),

      // ============================================================
      // 🔹 BODY
      // ============================================================
      body: SafeArea(
        child: destinationsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (err, _) => Center(
            child: Text("Erreur : $err"),
          ),
          data: (destinations) {
            // 🔥 TRI PAR NOTE
            final sorted = [...destinations]
              ..sort((a, b) => b.rating.compareTo(a.rating));
            final topTwo = sorted.take(2).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // 🔎 RECHERCHE
                  GestureDetector(
                    onTap: () => context.go('/search'),
                    child: AbsorbPointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText:
                            "Rechercher un vol, hôtel, destination...",
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // FILTRES
                  Row(
                    children: [
                      Expanded(
                        child: FilterChipWidget(
                          label: 'Tout',
                          isSelected: _selectedFilter == 0,
                          onTap: () =>
                              setState(() => _selectedFilter = 0),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilterChipWidget(
                          label: 'Hôtels',
                          isSelected: _selectedFilter == 1,
                          onTap: () {
                            setState(() => _selectedFilter = 1);
                            context.go('/hotels');
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilterChipWidget(
                          label: 'Restaurants',
                          isSelected: _selectedFilter == 2,
                          onTap: () {
                            setState(() => _selectedFilter = 2);
                            context.go('/restaurants');
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Destinations populaires',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: List.generate(topTwo.length, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: index == 0 ? 16 : 0),
                          child: DestinationCard(
                            destination: topTwo[index],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Météo du jour',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),
                  const WeatherCard(),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
