import 'package:flutter/material.dart';

/// In-memory availability used by the demo until the API is connected.
class DoctorAvailability {
  const DoctorAvailability({
    required this.weekdays,
    required this.start,
    required this.end,
    this.slotMinutes = 30,
  });

  final Set<int> weekdays;
  final TimeOfDay start;
  final TimeOfDay end;
  final int slotMinutes;

  DoctorAvailability copyWith({
    Set<int>? weekdays,
    TimeOfDay? start,
    TimeOfDay? end,
    int? slotMinutes,
  }) => DoctorAvailability(
    weekdays: weekdays ?? this.weekdays,
    start: start ?? this.start,
    end: end ?? this.end,
    slotMinutes: slotMinutes ?? this.slotMinutes,
  );

  String get summary {
    const names = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    final days = [for (var day = 1; day <= 7; day++) if (weekdays.contains(day)) names[day - 1]];
    return '${days.join('، ')} | ${formatTime(start)} - ${formatTime(end)}';
  }

  static String formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

class DoctorAvailabilityStore {
  DoctorAvailabilityStore._();

  static DoctorAvailability current = const DoctorAvailability(
    weekdays: {1, 2, 3, 4, 6, 7},
    start: TimeOfDay(hour: 16, minute: 0),
    end: TimeOfDay(hour: 21, minute: 0),
  );

  static void save(DoctorAvailability value) => current = value;

  static List<String> slotsFor(DateTime date, Iterable<String> booked) {
    final availability = current;
    if (!availability.weekdays.contains(date.weekday)) return const [];
    final start = availability.start.hour * 60 + availability.start.minute;
    final end = availability.end.hour * 60 + availability.end.minute;
    final occupied = booked.toSet();
    final slots = <String>[];
    final now = DateTime.now();
    final currentMinute = now.hour * 60 + now.minute;
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    for (var minute = start; minute + availability.slotMinutes <= end; minute += availability.slotMinutes) {
      if (isToday && minute <= currentMinute) continue;
      final label = '${(minute ~/ 60).toString().padLeft(2, '0')}:${(minute % 60).toString().padLeft(2, '0')}';
      if (!occupied.contains(label)) slots.add(label);
    }
    return slots;
  }
}

class DoctorAvailabilityEditor extends StatefulWidget {
  const DoctorAvailabilityEditor({super.key, required this.value, required this.onChanged});

  final DoctorAvailability value;
  final ValueChanged<DoctorAvailability> onChanged;

  @override
  State<DoctorAvailabilityEditor> createState() => _DoctorAvailabilityEditorState();
}

class _DoctorAvailabilityEditorState extends State<DoctorAvailabilityEditor> {
  late DoctorAvailability _value = widget.value;
  static const _days = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];

  void _update(DoctorAvailability value) {
    setState(() => _value = value);
    widget.onChanged(value);
  }

  Future<void> _pickTime({required bool start}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: start ? _value.start : _value.end,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (picked == null) return;
    _update(_value.copyWith(start: start ? picked : null, end: start ? null : picked));
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('أيام العمل', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 7,
        runSpacing: 4,
        children: [
          for (var i = 0; i < _days.length; i++)
            FilterChip(
              label: Text(_days[i]),
              selected: _value.weekdays.contains(i + 1),
              onSelected: (selected) {
                final days = {..._value.weekdays};
                selected ? days.add(i + 1) : days.remove(i + 1);
                _update(_value.copyWith(weekdays: days));
              },
            ),
        ],
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: () => _pickTime(start: true), icon: const Icon(Icons.login), label: Text('من ${DoctorAvailability.formatTime(_value.start)}'))),
        const SizedBox(width: 10),
        Expanded(child: OutlinedButton.icon(onPressed: () => _pickTime(start: false), icon: const Icon(Icons.logout), label: Text('إلى ${DoctorAvailability.formatTime(_value.end)}'))),
      ]),
      const SizedBox(height: 8),
      DropdownButtonFormField<int>(
        value: _value.slotMinutes,
        decoration: const InputDecoration(labelText: 'مدة الكشف'),
        items: const [15, 20, 30, 45, 60].map((m) => DropdownMenuItem(value: m, child: Text('$m دقيقة'))).toList(),
        onChanged: (minutes) { if (minutes != null) _update(_value.copyWith(slotMinutes: minutes)); },
      ),
    ],
  );
}
