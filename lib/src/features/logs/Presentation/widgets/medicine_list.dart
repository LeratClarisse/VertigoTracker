import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/medicine.dart';

class MedicineListWidget extends StatefulWidget {
  final ValueChanged<List<Medicine>> onMedicinesSelected;
  final List<Medicine> initialSelectedMedicines;

  const MedicineListWidget({
    Key? key,
    required this.onMedicinesSelected,
    this.initialSelectedMedicines = const [],
  }) : super(key: key);

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
    selectedMedicines = List.from(widget.initialSelectedMedicines);
  }

  void _addNewMedicine() async {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un médicament'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Nom'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  final newMedicine = Medicine(id: DateTime.now().millisecondsSinceEpoch, name: name);
                  final box = await Hive.openBox<Medicine>('medicines');
                  await box.add(newMedicine);

                  setState(() {
                    selectedMedicines.add(newMedicine);
                  });

                  widget.onMedicinesSelected(selectedMedicines);
                }
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
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
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Médicaments pris:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addNewMedicine,
                    tooltip: 'Ajouter un médicament',
                  ),
                ],
              ),
              Text('Aucun médicament'),
            ],
          );
        } else {
          final medicineBox = snapshot.data!;
          // Ensure all initially selected medicines are displayed
          final allMedicines = [
            ...medicineBox.values,
            ...selectedMedicines.where((med) => !medicineBox.values.contains(med)),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Médicaments pris:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addNewMedicine,
                    tooltip: 'Ajouter un médicament',
                  ),
                ],
              ),
              Wrap(
                spacing: 8.0,
                children: allMedicines.map((medicine) {
                  final isSelected = selectedMedicines.contains(medicine);
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.0),
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
                        setState(() {
                          selectedMedicines.remove(medicine);
                        });

                        medicineBox.delete(medicine.key);
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
