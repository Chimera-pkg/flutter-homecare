import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_cubit.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:m2health/features/schedule/presentation/widgets/date_override_form_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class DateSpecificHoursTab extends StatefulWidget {
  const DateSpecificHoursTab({super.key});

  @override
  State<DateSpecificHoursTab> createState() => _DateSpecificHoursTabState();
}

class _DateSpecificHoursTabState extends State<DateSpecificHoursTab> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<ProviderAvailabilityOverride> _selectedOverrides = [];

  void _onDaySelected(
      DateTime selectedDay, DateTime focusedDay, ScheduleState state) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedOverrides = state.overrides
          .where((o) => isSameDay(o.startDatetime, selectedDay))
          .toList();
    });
  }

  void _showAddOverrideDialog(BuildContext context, DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ScheduleCubit>(),
        child: DateOverrideFormDialog(selectedDate: selectedDate),
      ),
    );
  }

  // ADDED: Show edit dialog
  void _showEditOverrideDialog(BuildContext context,
      ProviderAvailabilityOverride scheduleOverride, DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ScheduleCubit>(),
        child: DateOverrideFormDialog(
          selectedDate: selectedDate,
          scheduleOverride: scheduleOverride,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) =>
                  _onDaySelected(selected, focused, state),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: Const.aqua,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Const.aqua.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
              eventLoader: (day) {
                return state.overrides
                    .where((o) => isSameDay(o.startDatetime, day))
                    .toList();
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMMM d, yyyy').format(_selectedDay),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _showAddOverrideDialog(context, _selectedDay),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Hours'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Const.aqua,
                      side: const BorderSide(color: Const.aqua),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: _selectedOverrides.isEmpty
                  ? const Center(
                      child: Text('No specific hours added for this date.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _selectedOverrides.length,
                      itemBuilder: (context, index) {
                        final scheduleOverride = _selectedOverrides[index];
                        return _OverrideChip(
                          scheduleOverride: scheduleOverride,
                          selectedDay: _selectedDay,
                          onEdit: () => _showEditOverrideDialog(
                            context,
                            scheduleOverride,
                            _selectedDay,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _OverrideChip extends StatelessWidget {
  final ProviderAvailabilityOverride scheduleOverride;
  final VoidCallback onEdit;
  final DateTime selectedDay;

  const _OverrideChip({
    required this.scheduleOverride,
    required this.onEdit,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final String startTime =
        DateFormat('HH:mm').format(scheduleOverride.startDatetime);
    final String endTime =
        DateFormat('HH:mm').format(scheduleOverride.endDatetime);

    return Card(
      elevation: 1,
      child: ListTile(
        title: Text('$startTime - $endTime'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context
                    .read<ScheduleCubit>()
                    .deleteOverrideRule(scheduleOverride.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
