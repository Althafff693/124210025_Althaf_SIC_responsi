import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  DetailsScreen({required this.restaurant});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  /// Mengecek apakah restoran ini ada di daftar favorit
  void _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      isFavorite = favorites.contains(widget.restaurant.id);
    });
  }

  /// Menambahkan atau menghapus restoran dari favorit
  void _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    if (isFavorite) {
      favorites.remove(widget.restaurant.id);
      prefs.setStringList('favorites', favorites);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from favorites'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      favorites.add(widget.restaurant.id);
      prefs.setStringList('favorites', favorites);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to favorites'),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar utama restoran
            Stack(
              children: [
                Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/${widget.restaurant.pictureId}',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          widget.restaurant.rating.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Informasi Restoran
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_city, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(widget.restaurant.city, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(widget.restaurant.address, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),

            // Deskripsi Restoran
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.restaurant.description,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
            ),

            // Tombol Favorit
            Center(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: ElevatedButton.icon(
      onPressed: _toggleFavorite,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
      ),
      label: Text(isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isFavorite ? Colors.red : Theme.of(context).primaryColor,
        foregroundColor: Colors.white, // Untuk warna teks
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
