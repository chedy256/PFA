import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/teacher.dart';

class SubmitInternshipPage extends ConsumerStatefulWidget {
  const SubmitInternshipPage({super.key});

  @override
  ConsumerState<SubmitInternshipPage> createState() =>
      _SubmitInternshipPageState();
}

class _SubmitInternshipPageState extends ConsumerState<SubmitInternshipPage> {
  final _formKey = GlobalKey<FormState>();

  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final List<Teacher> _selectedTeachers = [];
  //example teachers, in real app this should come from backend
  Teacher t1 = Teacher(
    id: 'TI001',
    firstName: 'NAFFAA',
    lastName: 'HAFFAR',
    email: 'naffaa.haffar@univ-isimm.tn',
    department: 'Informatique',
  );
  Teacher t2 = Teacher(
    id: 'TI002',
    firstName: 'MOKHTAR',
    lastName: 'BOUZID',
    email: 'mokhtar.bouzid@univ-isimm.tn',
    department: 'Informatique',
  );
  Teacher t3 = Teacher(
    id: 'TI003',
    firstName: 'ABDELKADER',
    lastName: 'BOUZID',
    email: 'abdelkader.bouzid@univ-isimm.tn',
    department: 'Informatique',
  );
  Teacher t4 = Teacher(
    id: 'TI004',
    firstName: 'HOUSSAM',
    lastName: 'BEN HAMOUDA',
    email: 'houssam.benhamouda@univ-isimm.tn',
    department: 'Informatique',
  );

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner les dates')),
        );
        return;
      }

      if (_selectedTeachers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sélectionnez au moins un enseignant')),
        );
        return;
      }

      //TODO: submit the internship to backend

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Stage soumis avec succès')));
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? DateTime.now()
          : (_startDate != null ? _startDate! : DateTime.now()),
      firstDate: isStart
          ? DateTime(2025)
          : (_startDate != null ? _startDate! : DateTime(2025)),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final availableTeachers = [t1, t2, t3, t4];

    return Scaffold(
      appBar: AppBar(title: const Text('Soumettre un stage')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'entreprise',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(
                  labelText: 'Poste',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      child: Column(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.date_range),
                          const SizedBox(height: 4),
                          Text(
                            _startDate == null
                                ? 'Date début'
                                : '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}',
                          ),
                        ],
                      ),
                      onPressed: () => _selectDate(context, true),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      child: Column(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.date_range),
                          const SizedBox(height: 4),
                          Text(
                            _endDate == null
                                ? 'Date fin'
                                : '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}',
                          ),
                        ],
                      ),
                      onPressed: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Text(
                'Choisissez votre encadrant (Max 3):', //TODO: not final
                style: theme.textTheme.titleMedium,
              ),
              Wrap(
                spacing: 8,
                children: availableTeachers.map((teacher) {
                  final isSelected = _selectedTeachers.contains(teacher);
                  return FilterChip(
                    label: Text('${teacher.firstName} ${teacher.lastName}'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          if (_selectedTeachers.length < 3) {
                            _selectedTeachers.add(teacher);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Vous pouvez sélectionner au maximum 3 enseignants',
                                ),
                              ),
                            );
                          }
                        } else {
                          _selectedTeachers.remove(teacher);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Soumettre'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
