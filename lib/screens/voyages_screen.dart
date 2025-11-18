import 'package:flutter/material.dart';

class TripsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: Text(
          "Voyages",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Icon(Icons.tune, color: Colors.black),
          SizedBox(width: 15),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Rechercher un voyage...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today_outlined),
                ],
              ),
            ),

            SizedBox(height: 15),

            // Disponible Chip
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(
                  "Disponibles",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),

            SizedBox(height: 15),

            // Liste voyages
            Expanded(
              child: ListView(
                children: [
                  tripCard(
                    "Rome",
                    "Italie",
                    "https://i.imgur.com/9xqC7P7.jpeg",
                  ),
                  tripCard(
                    "New York",
                    "États-Unis",
                    "https://i.imgur.com/6Qn9UQ6.jpeg",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Accueil",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Recherche"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Voyages"),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Budget"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
      ),
    );
  }

  Widget tripCard(String title, String country, String imgUrl) {
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              imgUrl,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                Text(country, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    label: Text("Voir détails"),
                    icon: Icon(Icons.visibility),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
