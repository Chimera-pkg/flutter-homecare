import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/home_health_screening/domain/entities/screening_service.dart';
import 'package:m2health/features/home_health_screening/presentation/bloc/services_list/screening_services_cubit.dart';

class ScreeningServicesSelectionPage extends StatefulWidget {
  final Function(List<ScreeningItem>) onNext;
  final List<ScreeningItem> initialSelection;

  const ScreeningServicesSelectionPage({
    super.key,
    required this.onNext,
    this.initialSelection = const [],
  });

  @override
  State<ScreeningServicesSelectionPage> createState() =>
      _ScreeningServicesSelectionPageState();
}

class _ScreeningServicesSelectionPageState
    extends State<ScreeningServicesSelectionPage> {
  final List<ScreeningItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.initialSelection);
    context.read<ScreeningServicesCubit>().loadServices();
  }

  void _toggleItem(ScreeningItem item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  double get _totalPrice =>
      _selectedItems.fold(0.0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Health Screening',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: BlocBuilder<ScreeningServicesCubit, ScreeningServicesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) return Center(child: Text(state.error!));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(category.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        ...category.items.map((item) => _buildItemCard(item)),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
              _buildBottomBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemCard(ScreeningItem item) {
    final isSelected = _selectedItems.contains(item);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Checkbox(
            value: isSelected,
            activeColor: Const.aqua,
            onChanged: (_) => _toggleItem(item),
          ),
          title: Text(
            item.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF35C5CF),
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(Icons.info_outline, color: Colors.grey.shade400),
          onTap: () => _toggleItem(item),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Estimated Budget",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text("\$${_totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _selectedItems.isEmpty
                  ? null
                  : () => widget.onNext(_selectedItems),
              style: ElevatedButton.styleFrom(
                backgroundColor: Const.aqua,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Book Appointment",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
