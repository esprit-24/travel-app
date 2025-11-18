import 'package:flutter/material.dart';

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  String selectedFilter = "Tout";

  final filters = ["Tout", "Asiatique", "Local"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Restaurants",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher un restaurant...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),

            SizedBox(height: 15),

            // Filtres
            Row(
              children: filters.map((f) {
                final active = selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: active,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = f;
                      });
                    },
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: active ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Titre "Populaires"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Populaires",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("8 restaurants", style: TextStyle(color: Colors.grey)),
              ],
            ),

            SizedBox(height: 15),

            // Liste restaurants
            Expanded(
              child: ListView(
                children: [
                  restaurantCard(
                    "Hanami Sushi",
                    "Paris, France",
                    "4.5",
                    "Asiatique",
                    "https://i.imgur.com/9z3s7wW.jpeg",
                  ),
                  restaurantCard(
                    "Bistro du Marché",
                    "Lyon, France",
                    "5.0",
                    "Local",
                    "https://i.imgur.com/oYiTqum.jpeg",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget restaurantCard(
    String title,
    String city,
    String rating,
    String type,
    String imgUrl,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              imgUrl,
              width: 110,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(city, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        rating,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.circle, size: 6, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(type, style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
