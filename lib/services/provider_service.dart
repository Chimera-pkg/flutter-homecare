import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/models/provider.dart';
import 'package:m2health/models/service_config.dart';
import 'package:m2health/utils.dart';

class ProviderService {
  final Dio _dio;

  ProviderService(this._dio);

  /// Fetch available providers based on type (pharmacist or nurse)
  Future<List<Provider>> getAvailableProviders({
    required String providerType,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.get(
        Const.API_PROVIDERS_AVAILABLE,
        queryParameters: {
          'provider_type': providerType,
          'page': page,
          'limit': limit,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Provider.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load providers');
      }
    } catch (e) {
      print('Error fetching providers: $e');
      // Return mock data for development
      return _getMockProviders(providerType);
    }
  }

  /// Fetch service titles for a specific provider type
  Future<List<ServiceTitle>> getServiceTitles(String serviceType) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.get(
        '${Const.API_SERVICE_TITLES}/$serviceType',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ServiceTitle.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load service titles');
      }
    } catch (e) {
      print('Error fetching service titles: $e');
      // Return default services based on type
      if (serviceType == 'pharma') {
        return ServiceConfig.pharmacist().defaultServices;
      } else {
        return ServiceConfig.nurse().defaultServices;
      }
    }
  }

  /// Update service titles for a provider type
  Future<void> updateServiceTitles(
      String serviceType, List<ServiceTitle> services) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final servicesData = services.map((service) => service.toJson()).toList();

      await _dio.put(
        '${Const.API_SERVICE_TITLES}/$serviceType',
        data: {'services': servicesData},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('Error updating service titles: $e');
      throw Exception('Failed to update service titles: $e');
    }
  }

  /// Toggle favorite status for a provider
  Future<void> toggleFavorite({
    required int providerId,
    required String providerType,
    required bool isFavorite,
  }) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final userId = await Utils.getSpString(Const.USER_ID);

      if (isFavorite) {
        // Add to favorites
        await _dio.post(
          Const.API_FAVORITES,
          data: {
            'user_id': userId,
            'item_id': providerId,
            'item_type': providerType,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
      } else {
        // Remove from favorites
        await _dio.delete(
          '${Const.API_FAVORITES}/$providerId',
          queryParameters: {
            'user_id': userId,
            'item_type': providerType,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      throw Exception('Failed to update favorite status');
    }
  }

  /// Get favorite providers for a user
  Future<List<Provider>> getFavoriteProviders(String providerType) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final userId = await Utils.getSpString(Const.USER_ID);

      final response = await _dio.get(
        Const.API_FAVORITES,
        queryParameters: {
          'user_id': userId,
          'item_type': providerType,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((item) => Provider.fromJson(item['item'])).toList();
      } else {
        throw Exception('Failed to load favorite providers');
      }
    } catch (e) {
      print('Error fetching favorite providers: $e');
      return [];
    }
  }

  /// Mock data for development/testing
  List<Provider> _getMockProviders(String providerType) {
    return [
      Provider(
        id: 1,
        name: providerType == 'pharmacist'
            ? 'Dr. Khanza Deliva'
            : 'Nurse Sarah Johnson',
        avatar: 'https://placehold.co/100x100',
        experience: 10,
        rating: 4.5,
        about: 'Experienced ${providerType} with excellent patient care.',
        workingInformation: 'Monday - Friday, 08:00 AM - 21:00 PM',
        daysHour: 'Mon-Fri: 8AM-9PM',
        mapsLocation: 'Main Hospital',
        certification: 'Licensed ${providerType.toUpperCase()}',
        userId: 1,
        providerType: providerType,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Provider(
        id: 2,
        name: providerType == 'pharmacist'
            ? 'Dr. Ahmad Rahman'
            : 'Nurse Maria Garcia',
        avatar: 'https://placehold.co/100x100',
        experience: 8,
        rating: 4.8,
        about: 'Specialized ${providerType} with comprehensive care approach.',
        workingInformation: 'Monday - Saturday, 09:00 AM - 18:00 PM',
        daysHour: 'Mon-Sat: 9AM-6PM',
        mapsLocation: 'Community Clinic',
        certification: 'Licensed ${providerType.toUpperCase()}',
        userId: 2,
        providerType: providerType,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
