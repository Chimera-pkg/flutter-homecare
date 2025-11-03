// import 'package:bloc/bloc.dart';
// import 'package:m2health/models/provider.dart';
// import 'package:m2health/models/service_config.dart';
// import 'package:m2health/services/provider_service.dart';
// import 'provider_state.dart';

// class ProviderCubit extends Cubit<ProviderState> {
//   final ProviderService _providerService;
//   final ServiceConfig _config;

//   ProviderCubit({
//     required ProviderService providerService,
//     required ServiceConfig config,
//   })  : _providerService = providerService,
//         _config = config,
//         super(ProviderInitial());

//   /// Load providers and service titles for the current service type
//   Future<void> loadProviders({bool refresh = false}) async {
//     try {
//       if (refresh || state is ProviderInitial) {
//         emit(ProviderLoading());
//       }

//       // Load providers and service titles concurrently
//       final futures = await Future.wait([
//         _providerService.getAvailableProviders(
//           providerType: _config.type,
//           page: 1,
//           limit: 20,
//         ),
//         _providerService.getServiceTitles(
//           _config.type == 'pharmacist' ? 'pharma' : 'nurse',
//         ),
//       ]);

//       final providers = futures[0] as List<Provider>;
//       final serviceTitles = futures[1] as List<ServiceTitle>;

//       emit(ProvidersLoaded(
//         providers: providers,
//         serviceTitles: serviceTitles,
//         config: _config,
//         hasMore: providers.length >= 20,
//         currentPage: 1,
//       ));
//     } catch (e) {
//       emit(ProviderError(
//         message:
//             'Failed to load ${_config.displayName.toLowerCase()}: ${e.toString()}',
//         errorCode: 'LOAD_PROVIDERS_ERROR',
//       ));
//     }
//   }

//   /// Load more providers (pagination)
//   Future<void> loadMoreProviders() async {
//     final currentState = state;
//     if (currentState is! ProvidersLoaded || !currentState.hasMore) return;

//     try {
//       final newProviders = await _providerService.getAvailableProviders(
//         providerType: _config.type,
//         page: currentState.currentPage + 1,
//         limit: 20,
//       );

//       emit(currentState.copyWith(
//         providers: [...currentState.providers, ...newProviders],
//         hasMore: newProviders.length >= 20,
//         currentPage: currentState.currentPage + 1,
//       ));
//     } catch (e) {
//       emit(ProviderError(
//         message: 'Failed to load more providers: ${e.toString()}',
//         errorCode: 'LOAD_MORE_ERROR',
//       ));
//     }
//   }

//   /// Search providers by name or specialization
//   Future<void> searchProviders(String query) async {
//     final currentState = state;
//     if (currentState is! ProvidersLoaded) return;

//     if (query.isEmpty) {
//       await loadProviders(refresh: true);
//       return;
//     }

//     try {
//       final filteredProviders = currentState.providers
//           .where((provider) =>
//               provider.name.toLowerCase().contains(query.toLowerCase()) ||
//               provider.about.toLowerCase().contains(query.toLowerCase()) ||
//               provider.certification
//                   .toLowerCase()
//                   .contains(query.toLowerCase()))
//           .toList();

//       emit(currentState.copyWith(providers: filteredProviders));
//     } catch (e) {
//       emit(ProviderError(
//         message: 'Failed to search providers: ${e.toString()}',
//         errorCode: 'SEARCH_ERROR',
//       ));
//     }
//   }

//   /// Toggle favorite status for a provider
//   Future<void> toggleFavorite(Provider provider) async {
//     try {
//       final currentState = state;
//       if (currentState is! ProvidersLoaded) return;

//       // Optimistically update UI
//       final updatedProviders = currentState.providers.map((p) {
//         if (p.id == provider.id) {
//           // Create a new provider instance with updated favorite status
//           // Note: This would require adding isFavorite field to Provider model
//           return p;
//         }
//         return p;
//       }).toList();

//       emit(currentState.copyWith(providers: updatedProviders));

//       // Make API call
//       await _providerService.toggleFavorite(
//         providerId: provider.id,
//         providerType: provider.providerType,
//         isFavorite: true, // This should be determined by current state
//       );

//       emit(ProviderFavoriteUpdated(
//         providerId: provider.id,
//         isFavorite: true, // This should be the new state
//       ));
//     } catch (e) {
//       // Revert optimistic update on error
//       await loadProviders();
//       emit(ProviderError(
//         message: 'Failed to update favorite status: ${e.toString()}',
//         errorCode: 'FAVORITE_ERROR',
//       ));
//     }
//   }

//   /// Update service titles for the current service type
//   Future<void> updateServiceTitles(List<ServiceTitle> serviceTitles) async {
//     try {
//       final serviceType = _config.type == 'pharmacist' ? 'pharma' : 'nurse';

//       await _providerService.updateServiceTitles(serviceType, serviceTitles);

//       emit(ServiceTitlesUpdated(
//         serviceTitles: serviceTitles,
//         serviceType: serviceType,
//       ));

//       // Reload the current state with updated service titles
//       final currentState = state;
//       if (currentState is ProvidersLoaded) {
//         emit(currentState.copyWith(serviceTitles: serviceTitles));
//       }
//     } catch (e) {
//       emit(ProviderError(
//         message: 'Failed to update service titles: ${e.toString()}',
//         errorCode: 'UPDATE_SERVICES_ERROR',
//       ));
//     }
//   }

//   /// Get favorite providers
//   Future<void> loadFavoriteProviders() async {
//     try {
//       emit(ProviderLoading());

//       final favoriteProviders =
//           await _providerService.getFavoriteProviders(_config.type);
//       final serviceTitles = await _providerService.getServiceTitles(
//         _config.type == 'pharmacist' ? 'pharma' : 'nurse',
//       );

//       emit(ProvidersLoaded(
//         providers: favoriteProviders,
//         serviceTitles: serviceTitles,
//         config: _config,
//         hasMore: false,
//         currentPage: 1,
//       ));
//     } catch (e) {
//       emit(ProviderError(
//         message: 'Failed to load favorite providers: ${e.toString()}',
//         errorCode: 'LOAD_FAVORITES_ERROR',
//       ));
//     }
//   }

//   /// Filter providers by rating
//   void filterByRating(double minRating) {
//     final currentState = state;
//     if (currentState is! ProvidersLoaded) return;

//     final filteredProviders = currentState.providers
//         .where((provider) => provider.rating >= minRating)
//         .toList();

//     emit(currentState.copyWith(providers: filteredProviders));
//   }

//   /// Sort providers by different criteria
//   void sortProviders(String sortBy) {
//     final currentState = state;
//     if (currentState is! ProvidersLoaded) return;

//     final sortedProviders = [...currentState.providers];

//     switch (sortBy) {
//       case 'name':
//         sortedProviders.sort((a, b) => a.name.compareTo(b.name));
//         break;
//       case 'rating':
//         sortedProviders.sort((a, b) => b.rating.compareTo(a.rating));
//         break;
//       case 'experience':
//         sortedProviders.sort((a, b) => b.experience.compareTo(a.experience));
//         break;
//       default:
//         break;
//     }

//     emit(currentState.copyWith(providers: sortedProviders));
//   }
// }
