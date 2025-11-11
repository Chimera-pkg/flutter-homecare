// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:m2health/cubit/provider/provider_cubit.dart';
// import 'package:m2health/cubit/provider/provider_state.dart';
// import 'package:m2health/models/service_config.dart';
// import 'package:m2health/widgets/provider_card.dart';
// import 'package:m2health/services/provider_service.dart';
// import 'package:dio/dio.dart';

// class SearchPage extends StatefulWidget {
//   final String serviceType; // "pharmacist" or "nurse"

//   const SearchPage({Key? key, required this.serviceType}) : super(key: key);

//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   late ProviderCubit _providerCubit;

//   @override
//   void initState() {
//     super.initState();
//     _initializeProvider();
//   }

//   void _initializeProvider() {
//     final config = widget.serviceType == 'pharmacist'
//         ? ServiceConfig.pharmacist()
//         : ServiceConfig.nurse();

//     final providerService = ProviderService(Dio());
//     // _providerCubit = ProviderCubit(providerService, config);
//     _providerCubit.loadProviders();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _providerCubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _providerCubit,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             '${widget.serviceType == 'pharmacist' ? 'Pharmacist' : 'Nurse'} Search',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           elevation: 0,
//         ),
//         body: Column(
//           children: [
//             // Search Bar
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               color: Colors.grey[50],
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: (query) {
//                   _providerCubit.searchProviders(query);
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Search ${widget.serviceType}s...',
//                   prefixIcon: const Icon(Icons.search),
//                   suffixIcon: _searchController.text.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () {
//                             _searchController.clear();
//                             _providerCubit.searchProviders('');
//                           },
//                         )
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//             ),

//             // Filter Controls
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _showFilterDialog(),
//                       icon: const Icon(Icons.filter_list),
//                       label: const Text('Filters'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[100],
//                         foregroundColor: Colors.black87,
//                         elevation: 0,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _showSortDialog(),
//                       icon: const Icon(Icons.sort),
//                       label: const Text('Sort'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[100],
//                         foregroundColor: Colors.black87,
//                         elevation: 0,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 8),

//             // Providers List
//             Expanded(
//               child: BlocBuilder<ProviderCubit, ProviderState>(
//                 builder: (context, state) {
//                   if (state is ProviderLoading) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (state is ProvidersLoaded) {
//                     if (state.providers.isEmpty) {
//                       return EmptyProvidersWidget(
//                         providerType: widget.serviceType,
//                         onRetry: () =>
//                             _providerCubit.loadProviders(refresh: true),
//                       );
//                     }

//                     return RefreshIndicator(
//                       onRefresh: () async {
//                         await _providerCubit.loadProviders(refresh: true);
//                       },
//                       child: ListView.builder(
//                         padding: const EdgeInsets.all(16),
//                         itemCount:
//                             state.providers.length + (state.hasMore ? 1 : 0),
//                         itemBuilder: (context, index) {
//                           if (index == state.providers.length) {
//                             // Load more indicator
//                             _providerCubit.loadMoreProviders();
//                             return const Padding(
//                               padding: EdgeInsets.all(16.0),
//                               child: Center(
//                                 child: CircularProgressIndicator(),
//                               ),
//                             );
//                           }

//                           final provider = state.providers[index];
//                           return ProviderCard(
//                             provider: provider,
//                             // config: state.config,
//                             onTap: () => _navigateToProviderDetail(provider),
//                             // onFavoriteChanged: (isFavorite) {
//                             //   _providerCubit.toggleFavorite(provider);
//                             // },
//                           );
//                         },
//                       ),
//                     );
//                   } else if (state is ProviderError) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.error_outline,
//                             size: 64,
//                             color: Colors.red[300],
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Error loading ${widget.serviceType}s',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             state.message,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: () =>
//                                 _providerCubit.loadProviders(refresh: true),
//                             child: const Text('Retry'),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   return const SizedBox();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Filter Options'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               title: const Text('Rating 4+ only'),
//               trailing: Switch(
//                 value: false,
//                 onChanged: (value) {
//                   if (value) {
//                     _providerCubit.filterByRating(4.0);
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             ListTile(
//               title: const Text('Experience 5+ years'),
//               trailing: Switch(
//                 value: false,
//                 onChanged: (value) {
//                   // if (value) {
//                   //   _providerCubit.filterByExperience(5);
//                   // }
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             ListTile(
//               title: const Text('Show Favorites Only'),
//               trailing: Switch(
//                 value: false,
//                 onChanged: (value) {
//                   if (value) {
//                     _providerCubit.loadFavoriteProviders();
//                   } else {
//                     _providerCubit.loadProviders(refresh: true);
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _providerCubit.loadProviders(refresh: true);
//               Navigator.pop(context);
//             },
//             child: const Text('Clear Filters'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSortDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Sort By'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               title: const Text('Name (A-Z)'),
//               onTap: () {
//                 _providerCubit.sortProviders('name_asc');
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Name (Z-A)'),
//               onTap: () {
//                 _providerCubit.sortProviders('name_desc');
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Rating (High to Low)'),
//               onTap: () {
//                 _providerCubit.sortProviders('rating_desc');
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Experience (High to Low)'),
//               onTap: () {
//                 _providerCubit.sortProviders('experience_desc');
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _navigateToProviderDetail(provider) {
//     // Navigate to provider detail page
//     // You can implement this based on your existing navigation pattern
//     print('Navigate to provider detail: ${provider.name}');
//   }
// }
