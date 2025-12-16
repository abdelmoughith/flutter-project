import 'package:flutter/material.dart';
import '../entities/green_project.dart';
import 'project_card.dart';

class ProjectGridList extends StatelessWidget {
  final List<GreenProject> projects;

  const ProjectGridList({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: projects.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,           // 2 columns
        mainAxisSpacing: 8,          // vertical spacing
        crossAxisSpacing: 4,         // smaller horizontal spacing
        childAspectRatio: 0.75,      // height/width ratio
      ),
      itemBuilder: (context, index) {
        final item = projects[index];
        return Center(
          child: ProjectCard(
            project: item,
            index: index,
          ),
        );
      },
    );
  }
}
