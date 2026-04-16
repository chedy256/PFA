import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/features/shared/card_widgets.dart';
import 'package:pfa/core/providers/internship_provider.dart';

class TeacherInternshipPage extends ConsumerStatefulWidget {
  const TeacherInternshipPage({super.key});

  @override
  ConsumerState<TeacherInternshipPage> createState() =>
      _TeacherInternshipPageState();
}

class _TeacherInternshipPageState extends ConsumerState<TeacherInternshipPage> {
  @override
  Widget build(BuildContext context) {
    final internshipsAsync = ref.watch(internshipsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Stages Supervisés'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Chercher un stage ou un étudiant',
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list_rounded),
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: internshipsAsync.when(
                    data: (internships) {
                      if (internships.isEmpty) {
                        return const Center(
                          child: Text("Aucun stage supervisé."),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: internships.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return intershipCard(
                            context,
                            viewType: InternshipCardViewType.teacher,
                            internship: internships[index],
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text('Erreur: $error')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
