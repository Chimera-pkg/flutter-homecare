import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/const.dart';

// Data model for a pharmacist. Using a class improves type safety and maintainability.
class Pharmacist {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;
  bool isFavorite;

  Pharmacist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.isFavorite,
  });

  // Factory constructor to create a Pharmacist from JSON data.
  // This encapsulates the parsing logic.
  factory Pharmacist.fromJson(Map<String, dynamic> item) {
    final pharmacistData = item['item'] as Map<String, dynamic>?;
    return Pharmacist(
      id: item['item_id'] as int,
      name: pharmacistData?['name'] as String? ?? 'Unknown Pharmacist',
      imageUrl: pharmacistData?['avatar'] as String? ?? '',
      rating: (pharmacistData?['rating'] as num? ?? 0.0).toDouble(),
      isFavorite: item['highlighted'] == 1,
    );
  }
}

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Pharmacist> _pharmacists = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isAuthenticated = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoritePharmacists();
  }

  // Fetches favorite pharmacists from the API.
  Future<void> _fetchFavoritePharmacists() async {
    try {
      final userId = await Utils.getSpString(Const.USER_ID);
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await Dio().get(
        Const.API_FAVORITES,
        queryParameters: {
          'user_id': userId,
          'item_type': 'pharmacist',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data['data'] != null) {
        final data = List<Map<String, dynamic>>.from(response.data['data']);
        setState(() {
          _pharmacists = data.map((item) => Pharmacist.fromJson(item)).toList();
          _isLoading = false;
          _isAuthenticated = true;
        });
      } else {
        throw Exception('Failed to load favorite pharmacists');
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error fetching data: ${e.toString()}';
        });
      }
    }
  }

  // Updates the favorite status of a pharmacist.
  Future<void> _updateFavoriteStatus(int pharmacistId, bool isFavorite) async {
    try {
      final userId = await Utils.getSpString(Const.USER_ID);
      final token = await Utils.getSpString(Const.TOKEN);
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      if (isFavorite) {
        await dio.post(
          Const.API_FAVORITES,
          data: {
            'user_id': userId,
            'item_id': pharmacistId,
            'item_type': 'pharmacist',
            'highlighted': 1,
          },
        );
      } else {
        await dio.delete(
          Const.API_FAVORITES,
          data: {
            'user_id': userId,
            'item_id': pharmacistId,
            'item_type': 'pharmacist',
          },
        );
      }
    } catch (e) {
      // Re-throw the exception to be handled by the caller.
      throw Exception('Failed to update favorite status: $e');
    }
  }

  // Toggles the favorite status and handles UI updates.
  Future<void> _toggleFavorite(Pharmacist pharmacist) async {
    final originalFavoriteStatus = pharmacist.isFavorite;
    final pharmacistId = pharmacist.id;

    // Optimistic UI update for better user experience.
    setState(() {
      pharmacist.isFavorite = !originalFavoriteStatus;
      if (!pharmacist.isFavorite) {
        _pharmacists.removeWhere((p) => p.id == pharmacistId);
      }
    });

    try {
      await _updateFavoriteStatus(pharmacistId, !originalFavoriteStatus);
    } catch (e) {
      // If the API call fails, revert the change and show an error message.
      setState(() {
        // Add the pharmacist back if they were removed
        if (!originalFavoriteStatus) {
          // To prevent adding it back if it's already there for some reason
          if (!_pharmacists.any((p) => p.id == pharmacistId)) {
            // This is tricky without knowing the original position.
            // For simplicity, we'll just refetch. A better implementation
            // might involve inserting it back at the original index.
            _fetchFavoritePharmacists();
          }
        } else {
          pharmacist.isFavorite = originalFavoriteStatus;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Favourites',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  // Builds the body of the scaffold, handling loading, error, and data states.
  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Authentication Required'),
              content: const Text(
                'Your session has expired or you are not logged in. Please sign in to continue.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Sign In'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.go(AppRoutes.signIn);
                  },
                ),
              ],
            );
          },
        );
      });
      return const SizedBox.shrink();
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }

    if (_pharmacists.isEmpty) {
      return const Center(
        child: Text('You have no favorite professionals yet.'),
      );
    }

    return ListView.builder(
      itemCount: _pharmacists.length,
      itemBuilder: (context, index) {
        final pharmacist = _pharmacists[index];
        return _PharmacistCard(
          pharmacist: pharmacist,
          onToggleFavorite: () => _toggleFavorite(pharmacist),
        );
      },
    );
  }
}

// A dedicated widget for displaying a single pharmacist card.
// This improves readability and reusability.
class _PharmacistCard extends StatelessWidget {
  final Pharmacist pharmacist;
  final VoidCallback onToggleFavorite;

  const _PharmacistCard({
    Key? key,
    required this.pharmacist,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 10),
            Expanded(
              child: _buildPharmacistInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: pharmacist.imageUrl.isNotEmpty
              ? NetworkImage(pharmacist.imageUrl)
              : null,
          radius: 30,
          child: pharmacist.imageUrl.isEmpty
              ? const Icon(Icons.person, size: 30)
              : null,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPharmacistInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pharmacist.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text('Pharmacist'),
        Row(
          children: [
            TextButton(
              onPressed: () {
                // TODO: Implement navigation to professional profile page.
              },
              child: const Text(
                'Appointment',
                style: TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: Icon(
                pharmacist.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: const Color(0xFF35C5CF),
              onPressed: onToggleFavorite,
            ),
          ],
        ),
      ],
    );
  }
}
