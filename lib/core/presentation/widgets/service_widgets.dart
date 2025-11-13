import 'package:flutter/material.dart';
import 'package:m2health/core/data/models/service_config.dart';

class ServiceSelectionCard extends StatelessWidget {
  final Map<String, String> service;
  final VoidCallback onTap;
  final Color color;

  const ServiceSelectionCard({
    Key? key,
    required this.service,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 243,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  service['description'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 5),
                      const Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF35C5CF),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        'assets/icons/ic_play.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (service['imagePath'] != null)
              Positioned(
                bottom: -25,
                right: -20,
                child: ClipRect(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Image.asset(
                      service['imagePath']!,
                      width: 185,
                      height: 139,
                      fit: BoxFit.contain,
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

class ServiceSelectionGrid extends StatelessWidget {
  final List<Map<String, String>> services;
  final Function(int, Map<String, String>) onServiceTap;
  final String serviceType;

  const ServiceSelectionGrid({
    Key? key,
    required this.services,
    required this.onServiceTap,
    required this.serviceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final color = Color(int.parse('0xFF${service['color'] ?? 'B28CFF'}'));

        return ServiceSelectionCard(
          service: service,
          onTap: () => onServiceTap(index, service),
          color: color,
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
    );
  }
}

class SearchableProviderList extends StatefulWidget {
  final Widget child;
  final Function(String) onSearch;
  final VoidCallback? onFilterTap;

  const SearchableProviderList({
    Key? key,
    required this.child,
    required this.onSearch,
    this.onFilterTap,
  }) : super(key: key);

  @override
  State<SearchableProviderList> createState() => _SearchableProviderListState();
}

class _SearchableProviderListState extends State<SearchableProviderList> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: widget.onSearch,
            decoration: InputDecoration(
              hintText: 'Search providers...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.onFilterTap != null
                  ? IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: widget.onFilterTap,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),

        // Provider List
        Expanded(child: widget.child),
      ],
    );
  }
}
