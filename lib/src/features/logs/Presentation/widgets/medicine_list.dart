import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/medicine.dart';

class MedicineListWidget extends StatefulWidget {
  final ValueChanged<List<Medicine>> onMedicinesSelected;

  const MedicineListWidget({Key? key, required this.onMedicinesSelected}) : super(key: key);

  @override
  _MedicineListWidgetState createState() => _MedicineListWidgetState();
}

class _MedicineListWidgetState extends State<MedicineListWidget> {
  late Future<Box<Medicine>> _medicineBoxFuture;
  List<Medicine> selectedMedicines = [];

  @override
  void initState() {
    super.initState();
    _medicineBoxFuture = Hive.openBox<Medicine>('medicines');
  }

  void _addNewMedicine() async {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Medicine'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter medicine name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  final newMedicine = Medicine(id: DateTime.now().millisecondsSinceEpoch, name: name);
                  final box = await Hive.openBox<Medicine>('medicines');
                  await box.add(newMedicine); // Add new medicine to the box

                  setState(() {
                    // Automatically select the new medicine
                    selectedMedicines.add(newMedicine);
                  });

                  // Notify parent widget with the updated selection
                  widget.onMedicinesSelected(selectedMedicines);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<Medicine>>(
      future: _medicineBoxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Medicine button
              Row(
                children: [
                  Text('Medicines Taken:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addNewMedicine,
                    tooltip: 'Add Medicine',
                  ),
                ],
              ),
              Text('No medicines available.'),
            ],
          );
        } else {
          final medicineBox = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Medicine button
              Row(
                children: [
                  Text('Medicines Taken:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addNewMedicine,
                    tooltip: 'Add Medicine',
                  ),
                ],
              ),
              // Medicine list
              Wrap(
                spacing: 8.0,
                children: medicineBox.values.map((medicine) {
                  final isSelected = selectedMedicines.contains(medicine);
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.0), // Add space between chips
                    child: InputChip(
                      label: Text(medicine.name),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedMedicines.add(medicine);
                          } else {
                            selectedMedicines.remove(medicine);
                          }
                        });
                        widget.onMedicinesSelected(selectedMedicines);
                      },
                      onDeleted: () {
                        // Remove from selectedMedicines
                        setState(() {
                          selectedMedicines.remove(medicine);
                        });

                        // Delete from the Hive box
                        medicineBox.delete(medicine.key);

                        // Notify the parent widget about the updated selection
                        widget.onMedicinesSelected(selectedMedicines);
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }
      },
    );
  }
}
