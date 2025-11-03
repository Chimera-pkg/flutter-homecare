// import 'package:equatable/equatable.dart';
// import 'package:m2health/models/provider.dart';
// import 'package:m2health/models/service_config.dart';

// abstract class ProviderState extends Equatable {
//   const ProviderState();

//   @override
//   List<Object?> get props => [];
// }

// class ProviderInitial extends ProviderState {}

// class ProviderLoading extends ProviderState {}

// class ProvidersLoaded extends ProviderState {
//   final List<Provider> providers;
//   final List<ServiceTitle> serviceTitles;
//   final ServiceConfig config;
//   final bool hasMore;
//   final int currentPage;

//   const ProvidersLoaded({
//     required this.providers,
//     required this.serviceTitles,
//     required this.config,
//     this.hasMore = true,
//     this.currentPage = 1,
//   });

//   @override
//   List<Object?> get props =>
//       [providers, serviceTitles, config, hasMore, currentPage];

//   ProvidersLoaded copyWith({
//     List<Provider>? providers,
//     List<ServiceTitle>? serviceTitles,
//     ServiceConfig? config,
//     bool? hasMore,
//     int? currentPage,
//   }) {
//     return ProvidersLoaded(
//       providers: providers ?? this.providers,
//       serviceTitles: serviceTitles ?? this.serviceTitles,
//       config: config ?? this.config,
//       hasMore: hasMore ?? this.hasMore,
//       currentPage: currentPage ?? this.currentPage,
//     );
//   }
// }

// class ProviderError extends ProviderState {
//   final String message;
//   final String? errorCode;

//   const ProviderError({
//     required this.message,
//     this.errorCode,
//   });

//   @override
//   List<Object?> get props => [message, errorCode];
// }

// class ProviderFavoriteUpdated extends ProviderState {
//   final int providerId;
//   final bool isFavorite;

//   const ProviderFavoriteUpdated({
//     required this.providerId,
//     required this.isFavorite,
//   });

//   @override
//   List<Object?> get props => [providerId, isFavorite];
// }

// class ServiceTitlesUpdated extends ProviderState {
//   final List<ServiceTitle> serviceTitles;
//   final String serviceType;

//   const ServiceTitlesUpdated({
//     required this.serviceTitles,
//     required this.serviceType,
//   });

//   @override
//   List<Object?> get props => [serviceTitles, serviceType];
// }
