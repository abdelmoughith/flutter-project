import 'package:flutter/material.dart';
import '../entities/green_project.dart';
import 'project_card.dart';

class ProjectHorizontalList extends StatelessWidget {
  final List<GreenProject> projects;

  const ProjectHorizontalList({
    super.key,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: projects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = projects[index];
          return ProjectCard(project: item, index: index);
        },
      ),
    );
  }
}
