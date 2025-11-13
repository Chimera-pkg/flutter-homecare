// import 'package:flutter/material.dart';
// import 'package:m2health/models/provider.dart';
// import 'package:m2health/views/search/professional_details.dart';

// class ProviderCard extends StatelessWidget {
//   final Provider provider;
//   final VoidCallback? onTap;
//   final VoidCallback? onFavoriteToggle;
//   final bool showFavoriteButton;
//   final bool isFavorite;

//   const ProviderCard({
//     Key? key,
//     required this.provider,
//     this.onTap,
//     this.onFavoriteToggle,
//     this.showFavoriteButton = true,
//     this.isFavorite = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         // onTap: onTap ?? () => _navigateToDetails(context),
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               // Provider Avatar
//               Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundImage: provider.avatar.isNotEmpty
//                         ? NetworkImage(provider.avatar)
//                         : null,
//                     backgroundColor: Colors.grey[300],
//                     child: provider.avatar.isEmpty
//                         ? Icon(
//                             provider.providerType == 'pharmacist'
//                                 ? Icons.local_pharmacy
//                                 : Icons.local_hospital,
//                             size: 30,
//                             color: Colors.grey[600],
//                           )
//                         : null,
//                   ),
//                   if (provider.isAvailable)
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         width: 12,
//                         height: 12,
//                         decoration: const BoxDecoration(
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(width: 16),

//               // Provider Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             provider.displayName,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         if (showFavoriteButton)
//                           IconButton(
//                             onPressed: onFavoriteToggle,
//                             icon: Icon(
//                               isFavorite
//                                   ? Icons.favorite
//                                   : Icons.favorite_border,
//                               color: isFavorite ? Colors.red : Colors.grey,
//                               size: 20,
//                             ),
//                             constraints: const BoxConstraints(),
//                             padding: EdgeInsets.zero,
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       provider.providerType.toUpperCase(),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         _buildInfoChip(
//                           icon: Icons.star,
//                           label: provider.displayRating,
//                           color: Colors.amber,
//                         ),
//                         const SizedBox(width: 8),
//                         _buildInfoChip(
//                           icon: Icons.work,
//                           label: provider.displayExperience,
//                           color: Colors.blue,
//                         ),
//                       ],
//                     ),
//                     if (provider.about.isNotEmpty) ...[
//                       const SizedBox(height: 8),
//                       Text(
//                         provider.about,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ],
//                 ),
//               ),

//               // Navigation Arrow
//               Icon(
//                 Icons.chevron_right,
//                 color: Colors.grey[400],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 12,
//             color: color,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // void _navigateToDetails(BuildContext context) {
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (context) => ProfessionalDetailsPage(
//   //         professional: provider.toJson(),
//   //         serviceType:
//   //             provider.providerType == 'pharmacist' ? 'Pharma' : 'Nurse',
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// class ProviderLoadingCard extends StatelessWidget {
//   const ProviderLoadingCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 16,
//                     color: Colors.grey[300],
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: 100,
//                     height: 12,
//                     color: Colors.grey[300],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Container(
//                         width: 60,
//                         height: 20,
//                         color: Colors.grey[300],
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         width: 60,
//                         height: 20,
//                         color: Colors.grey[300],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EmptyProvidersWidget extends StatelessWidget {
//   final String providerType;
//   final VoidCallback? onRetry;

//   const EmptyProvidersWidget({
//     Key? key,
//     required this.providerType,
//     this.onRetry,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             providerType == 'pharmacist'
//                 ? Icons.local_pharmacy
//                 : Icons.local_hospital,
//             size: 64,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No ${providerType}s available',
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Please try again or check back later',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//           if (onRetry != null) ...[
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: onRetry,
//               child: const Text('Retry'),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
