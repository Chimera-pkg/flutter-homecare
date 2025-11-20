import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

import 'package:m2health/const.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/features/profiles/data/models/screening_service.dart';

// Cubit for managing screening services
sealed class ScreeningServicesState extends Equatable {
  const ScreeningServicesState();
  @override
  List<Object> get props => [];
}

class ScreeningServicesInitial extends ScreeningServicesState {}

class ScreeningServicesLoading extends ScreeningServicesState {}

class ScreeningServicesLoaded extends ScreeningServicesState {
  final List<ScreeningServiceCategory> categories;
  const ScreeningServicesLoaded(this.categories);
  @override
  List<Object> get props => [categories];
}

class ScreeningServicesError extends ScreeningServicesState {
  final String message;
  const ScreeningServicesError(this.message);
  @override
  List<Object> get props => [message];
}

class ScreeningServicesCubit extends Cubit<ScreeningServicesState> {
  final Dio _dio = sl<Dio>(); // Assuming sl is properly configured for Dio

  ScreeningServicesCubit() : super(ScreeningServicesInitial());

  Future<Options> _getAuthorizedOptions() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<void> fetchCategories() async {
    try {
      emit(ScreeningServicesLoading());
      final response = await _dio.get(Const.API_SCREENING_SERVICE,
          options: await _getAuthorizedOptions());

      final categories = (response.data['data'] as List)
          .map(
              (categoryJson) => ScreeningServiceCategory.fromJson(categoryJson))
          .toList();
      emit(ScreeningServicesLoaded(categories));
    } catch (e) {
      emit(ScreeningServicesError(
          'Failed to fetch screening service categories: $e'));
    }
  }

  Future<void> addCategory(
      {required String name,
      String? description,
      required bool isPublished}) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'is_published': isPublished,
      };
      await _dio.post('${Const.API_ADMIN_SCREENING_SERVICES}/categories',
          data: data, options: await _getAuthorizedOptions());
      fetchCategories();
    } catch (e) {
      emit(ScreeningServicesError('Failed to add category: $e'));
    }
  }

  Future<void> updateCategory(
      {required int id,
      required String name,
      String? description,
      required bool isPublished}) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'is_published': isPublished,
      };
      await _dio.put(
          '${'${Const.API_ADMIN_SCREENING_SERVICES}/categories'}/$id',
          data: data,
          options: await _getAuthorizedOptions());
      fetchCategories();
    } catch (e) {
      emit(ScreeningServicesError('Failed to update category: $e'));
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _dio.delete(
          '${'${Const.API_ADMIN_SCREENING_SERVICES}/categories'}/$id',
          options: await _getAuthorizedOptions());
      fetchCategories();
    } catch (e) {
      emit(ScreeningServicesError('Failed to delete category: $e'));
    }
  }

  Future<void> addItem({
    required int categoryId,
    required String name,
    String? description,
    required double price,
    required bool isPublished,
  }) async {
    try {
      final data = {
        'screening_service_category_id': categoryId,
        'name': name,
        'description': description,
        'price': price,
        'is_published': isPublished,
      };
      await _dio.post('${Const.API_ADMIN_SCREENING_SERVICES}/items',
          data: data, options: await _getAuthorizedOptions());

      fetchCategories();
    } catch (e) {
      emit(ScreeningServicesError('Failed to add item: $e'));
    }
  }

  Future<void> updateItem({
    required int id,
    required String name,
    String? description,
    required double price,
    required bool isPublished,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'price': price,
        'is_published': isPublished,
      };
      await _dio.put('${Const.API_ADMIN_SCREENING_SERVICES}/items/$id',
          data: data, options: await _getAuthorizedOptions());
      fetchCategories();
    } catch (e) {
      emit(ScreeningServicesError('Failed to update item: $e'));
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _dio.delete('${Const.API_ADMIN_SCREENING_SERVICES}/items/$id',
          options: await _getAuthorizedOptions());
      fetchCategories();
    } catch (e) {
      emit(ScreeningServicesError('Failed to delete item: $e'));
    }
  }
}

class ManageHealthScreeningPage extends StatelessWidget {
  const ManageHealthScreeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Screening Services',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
      ),
      body: BlocProvider(
        create: (context) => ScreeningServicesCubit()..fetchCategories(),
        child: const ScreeningServiceList(),
      ),
    );
  }
}

class CategoryFormModal extends StatefulWidget {
  final ScreeningServiceCategory? category;
  const CategoryFormModal({super.key, this.category});

  @override
  State<CategoryFormModal> createState() => _CategoryFormModalState();
}

class _CategoryFormModalState extends State<CategoryFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late bool _isPublished;
  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.category?.description ?? '');
    _isPublished = widget.category?.isPublished ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;

      if (_isEditing) {
        context.read<ScreeningServicesCubit>().updateCategory(
              id: widget.category!.id!,
              name: name,
              description: description,
              isPublished: _isPublished,
            );
      } else {
        context.read<ScreeningServicesCubit>().addCategory(
              name: name,
              description: description,
              isPublished: _isPublished,
            );
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
            Text(_isEditing ? 'Edit Category' : 'Add New Category',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Name', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Name cannot be empty'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Published'),
              value: _isPublished,
              onChanged: (value) {
                setState(() {
                  _isPublished = value;
                });
              },
              activeThumbColor: Const.aqua,
              inactiveTrackColor: Colors.grey[200],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Const.aqua,
                foregroundColor: Colors.white,
              ),
              child: Text(_isEditing ? 'Save Changes' : 'Add Category'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ItemFormModal extends StatefulWidget {
  final ScreeningServiceItem? item;
  final int categoryId;

  const ItemFormModal({super.key, this.item, required this.categoryId});

  @override
  State<ItemFormModal> createState() => _ItemFormModalState();
}

class _ItemFormModalState extends State<ItemFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late bool _isPublished;
  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.item?.description ?? '');
    _priceController =
        TextEditingController(text: widget.item?.price.toString() ?? '');
    _isPublished = widget.item?.isPublished ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;

      if (_isEditing) {
        context.read<ScreeningServicesCubit>().updateItem(
              id: widget.item!.id!,
              name: name,
              description: description,
              price: price,
              isPublished: _isPublished,
            );
      } else {
        context.read<ScreeningServicesCubit>().addItem(
              categoryId: widget.categoryId,
              name: name,
              description: description,
              price: price,
              isPublished: _isPublished,
            );
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
            Text(_isEditing ? 'Edit Item' : 'Add New Item',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Name', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Name cannot be empty'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder()),
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
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Published'),
              value: _isPublished,
              onChanged: (value) {
                setState(() {
                  _isPublished = value;
                });
              },
              activeThumbColor: Const.aqua,
              inactiveTrackColor: Colors.grey[200],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Const.aqua,
                foregroundColor: Colors.white,
              ),
              child: Text(_isEditing ? 'Save Changes' : 'Add Item'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ScreeningServiceList extends StatefulWidget {
  const ScreeningServiceList({super.key});

  @override
  State<ScreeningServiceList> createState() => _ScreeningServiceListState();
}

class _ScreeningServiceListState extends State<ScreeningServiceList> {
  final Set<int> _expandedCategories = {};

  void _showCategoryFormModal(BuildContext context,
      {ScreeningServiceCategory? category}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ScreeningServicesCubit>(context),
        child: CategoryFormModal(category: category),
      ),
    );
  }

  void _showItemFormModal(BuildContext context,
      {required int categoryId, ScreeningServiceItem? item}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ScreeningServicesCubit>(context),
        child: ItemFormModal(item: item, categoryId: categoryId),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context,
      {required String title, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "$title"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                onConfirm();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ScreeningServicesCubit, ScreeningServicesState>(
        listener: (context, state) {
          if (state is ScreeningServicesError) {
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
          if (state is ScreeningServicesLoading ||
              state is ScreeningServicesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ScreeningServicesError) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ScreeningServicesCubit>().fetchCategories();
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
          if (state is ScreeningServicesLoaded) {
            if (state.categories.isEmpty) {
              return const Center(child: Text("No categories found."));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ScreeningServicesCubit>().fetchCategories();
              },
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    8.0, 8.0, 8.0, 120.0), // Extra bottom padding for FAB
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: ExpansionTile(
                      key: Key(category.id.toString()),
                      initiallyExpanded:
                          _expandedCategories.contains(category.id),
                      onExpansionChanged: (isExpanded) {
                        setState(() {
                          if (isExpanded) {
                            _expandedCategories.add(category.id!);
                          } else {
                            _expandedCategories.remove(category.id!);
                          }
                        });
                      },
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          if (category.isPublished == false)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                '(Draft)',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              ),
                            )
                        ],
                      ),
                      subtitle: category.description != null &&
                              category.description!.isNotEmpty
                          ? Text(category.description!)
                          : null,
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showCategoryFormModal(context, category: category);
                          } else if (value == 'delete') {
                            _showDeleteConfirmationDialog(
                              context,
                              title: category.name,
                              onConfirm: () => context
                                  .read<ScreeningServicesCubit>()
                                  .deleteCategory(category.id!),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      children: [
                        // List of items in the category
                        if (category.items.isNotEmpty)
                          ...category.items.map((item) => ListTile(
                                title: Row(
                                  children: [
                                    Expanded(child: Text(item.name)),
                                    if (item.isPublished == false)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '(Draft)',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey),
                                        ),
                                      )
                                  ],
                                ),
                                subtitle:
                                    Text('\$${item.price.toStringAsFixed(2)}'),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showItemFormModal(context,
                                          categoryId: category.id!, item: item);
                                    } else if (value == 'delete') {
                                      _showDeleteConfirmationDialog(
                                        context,
                                        title: item.name,
                                        onConfirm: () => context
                                            .read<ScreeningServicesCubit>()
                                            .deleteItem(item.id!),
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              )),
                        Center(
                          child: TextButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Item'),
                            style: TextButton.styleFrom(
                              foregroundColor: Const.aqua,
                            ),
                            onPressed: () => _showItemFormModal(context,
                                categoryId: category.id!),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryFormModal(context),
        tooltip: 'Add Category',
        foregroundColor: Colors.white,
        backgroundColor: Const.aqua,
        child: const Icon(Icons.add),
      ),
    );
  }
}
