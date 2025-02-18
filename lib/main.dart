import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ovulation Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const OvulationCalculator(),
    );
  }
}

class OvulationCalculator extends StatefulWidget {
  const OvulationCalculator({super.key});

  @override
  State<OvulationCalculator> createState() => _OvulationCalculatorState();
}

class _OvulationCalculatorState extends State<OvulationCalculator> {
  DateTime? lastPeriodDate = DateTime.now();
  String cycleLength = '28';
  bool showResults = false;
  int currentCycle = 1;

  List<String> cycleLengths =
      List.generate(26, (index) => (20 + index).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ovulation Calculator'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: showResults ? _buildResults() : _buildInputForm(),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'First day of your last period',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: lastPeriodDate ?? DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2026),
                );
                if (date != null) {
                  setState(() {
                    lastPeriodDate = date;
                  });
                }
              },
              child: Text(
                '${lastPeriodDate!.year}-${lastPeriodDate!.month}-${lastPeriodDate!.day}',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'How long was your last cycle',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: cycleLength,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              items: cycleLengths.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('$value days'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  cycleLength = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (lastPeriodDate != null) {
                  setState(() {
                    showResults = true;
                    currentCycle = 1;
                  });
                }
              },
              child: const Text('See my fertile days'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final fertileStart = lastPeriodDate!
        .add(Duration(days: 9 + ((currentCycle - 1) * int.parse(cycleLength))));
    final fertileEnd = lastPeriodDate!.add(
        Duration(days: 14 + ((currentCycle - 1) * int.parse(cycleLength))));
    final dueDate = lastPeriodDate!.add(const Duration(days: 280));
    final currentPeriodDate = lastPeriodDate!
        .add(Duration(days: (currentCycle - 1) * int.parse(cycleLength)));

    return Card(
      elevation: 4,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cycle $currentCycle/6',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.water_drop, color: Colors.red),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Menstruation date'),
                          Text(
                              '${lastPeriodDate!.month}/${lastPeriodDate!.day}/${lastPeriodDate!.year}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.blue),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Fertile days'),
                          Text(
                              '${fertileStart.month}/${fertileStart.day}/${fertileStart.year} - '
                              '${fertileEnd.month}/${fertileEnd.day}/${fertileEnd.year}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.orange),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Expected due date'),
                          Text(
                              '${dueDate.month}/${dueDate.day}/${dueDate.year}'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2026, 12, 31),
                focusedDay: currentPeriodDate,
                currentDay: null,
                calendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(color: Colors.black),
                  weekendTextStyle: const TextStyle(color: Colors.black),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    bool isPeriodDay = day.year == currentPeriodDate.year &&
                        day.month == currentPeriodDate.month &&
                        day.day == currentPeriodDate.day;

                    bool isFertileDay = day.isAfter(
                            fertileStart.subtract(const Duration(days: 1))) &&
                        day.isBefore(fertileEnd.add(const Duration(days: 1)));

                    if (isPeriodDay) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else if (isFertileDay) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Row(
            //   children: [
            //     const Icon(Icons.calendar_month, color: Colors.orange),
            //     const SizedBox(width: 10),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text('Expected due date'),
            //         Text('${dueDate.month}/${dueDate.day}/${dueDate.year}'),
            //       ],
            //     ),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentCycle > 1)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentCycle--;
                            });
                          },
                          child: const Text('Prev Cycle'),
                        ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: currentCycle < 6
                            ? () {
                                setState(() {
                                  currentCycle++;
                                });
                              }
                            : null,
                        child: const Text('Next Cycle'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      setState(() {
                        showResults = false;
                        currentCycle = 1;
                        lastPeriodDate = DateTime.now();
                        cycleLength = '28';
                      });
                    },
                    child: const Text('Start Over'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
