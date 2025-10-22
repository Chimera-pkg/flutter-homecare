import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'package:m2health/const.dart';
import 'package:m2health/models/service_config.dart';
import 'package:m2health/utils.dart';

sealed class ServicesState extends Equatable {
  const ServicesState();
  @override
  List<Object> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceTitle> services;
  const ServicesLoaded(this.services);
  @override
  List<Object> get props => [services];
}

class ServicesError extends ServicesState {
  final String message;
  const ServicesError(this.message);
  @override
  List<Object> get props => [message];
}

class ServicesCubit extends Cubit<ServicesState> {
  final String serviceType;
  final Dio _dio = Dio();

  ServicesCubit(this.serviceType) : super(ServicesInitial()) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await Utils.getSpString(Const.TOKEN);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<void> fetchServices() async {
    try {
      emit(ServicesLoading());
      final response = await _dio.get(
        Const.API_SERVICE_TITLES,
        queryParameters: {'service_type': serviceType},
      );
      final services = (response.data as List)
          .map((serviceJson) => ServiceTitle.fromJson(serviceJson))
          .toList();
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError('Failed to fetch services: $e'));
    }
  }

  Future<void> addService(
      {required String title, required double price}) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'price': price,
        'serviceType': serviceType,
      });
      await _dio.post(Const.API_SERVICE_TITLES, data: formData);
      fetchServices();
    } catch (e) {
      emit(ServicesError('Failed to add service: $e'));
    }
  }

  Future<void> updateService(
      {required int id, required String title, required double price}) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'price': price,
        'serviceType': serviceType,
      });
      await _dio.put('${Const.API_SERVICE_TITLES}/$id', data: formData);
      fetchServices();
    } catch (e) {
      emit(ServicesError('Failed to update service: $e'));
    }
  }

  Future<void> deleteService(int id) async {
    try {
      await _dio.delete('${Const.API_SERVICE_TITLES}/$id');
      fetchServices();
    } catch (e) {
      emit(ServicesError('Failed to delete service: $e'));
    }
  }
}

class ManageServicesPage extends StatefulWidget {
  const ManageServicesPage({super.key});

  @override
  State<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> serviceTabs = [
    {'type': 'nurse', 'display': 'Nurse'},
    {'type': 'specialized_nurse', 'display': 'Specialized Nurse'},
    {'type': 'pharma', 'display': 'Pharmacist'},
    {'type': 'radiologist', 'display': 'Radiologist'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: serviceTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Services',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Const.aqua,
          indicatorColor: Const.aqua,
          tabs: serviceTabs.map((tab) => Tab(text: tab['display'])).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: serviceTabs.map((tab) {
          return BlocProvider(
            create: (context) => ServicesCubit(tab['type']!)..fetchServices(),
            child: ServiceListTab(serviceType: tab['type']!),
          );
        }).toList(),
      ),
    );
  }
}

class ServiceListTab extends StatelessWidget {
  final String serviceType;
  const ServiceListTab({super.key, required this.serviceType});

  void _showServiceFormModal(BuildContext context, {ServiceTitle? service}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ServicesCubit>(context),
        child: ServiceFormModal(service: service),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ServicesCubit, ServicesState>(
        listener: (context, state) {
          if (state is ServicesError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is ServicesLoading || state is ServicesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ServicesError) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ServicesCubit>().fetchServices();
              },
              child: ListView(
                children: [
                  Center(
                    child: Text(state.message, textAlign: TextAlign.center),
                  ),
                ],
              ),
            );
          }
          if (state is ServicesLoaded) {
            if (state.services.isEmpty) {
              return const Center(child: Text("No services found."));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ServicesCubit>().fetchServices();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.services.length,
                itemBuilder: (context, index) {
                  return ServiceCard(service: state.services[index]);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showServiceFormModal(context),
        tooltip: 'Add Service',
        foregroundColor: Colors.white,
        backgroundColor: Const.aqua,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceTitle service;
  const ServiceCard({super.key, required this.service});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "${service.title}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<ServicesCubit>().deleteService(service.id!);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ServicesCubit>(context),
        child: ServiceFormModal(service: service),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        title: Text(service.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Price: \$${service.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Const.aqua),
              onPressed: () => _showEditModal(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceFormModal extends StatefulWidget {
  final ServiceTitle? service;
  const ServiceFormModal({super.key, this.service});

  @override
  State<ServiceFormModal> createState() => _ServiceFormModalState();
}

class _ServiceFormModalState extends State<ServiceFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  bool get _isEditing => widget.service != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.service?.title ?? '');
    _priceController =
        TextEditingController(text: widget.service?.price.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;

      if (_isEditing) {
        context
            .read<ServicesCubit>()
            .updateService(id: widget.service!.id!, title: title, price: price);
      } else {
        context.read<ServicesCubit>().addService(title: title, price: price);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          right: 20,
          left: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isEditing ? 'Edit Service' : 'Add New Service',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: 'Title', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Title cannot be empty'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$',
                  border: OutlineInputBorder()),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price cannot be empty';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Const.aqua,
                foregroundColor: Colors.white,
              ),
              child: Text(_isEditing ? 'Save Changes' : 'Add Service'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
