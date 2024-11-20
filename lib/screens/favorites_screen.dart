import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Restaurant>> _favorites;

  Future<List<Restaurant>> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorites') ?? [];
    final apiService = ApiService();
    final List<Restaurant> favoriteRestaurants = [];

    for (String id in favoriteIds) {
      try {
        final restaurant = await apiService.fetchRestaurantDetail(id);
        favoriteRestaurants.add(restaurant);
      } catch (e) {
        // Handle error if restaurant not found
      }
    }

    return favoriteRestaurants;
  }

  @override
  void initState() {
    super.initState();
    _favorites = _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: FutureBuilder<List<Restaurant>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final restaurant = favorites[index];
                return ListTile(
                  leading: Image.network(
                    'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(restaurant.name),
                  subtitle: Text(restaurant.city),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(restaurant: restaurant),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
