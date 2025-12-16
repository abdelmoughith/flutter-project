import 'package:flutter/material.dart';
import '../entities/green_project.dart';
import '../theme/app_colors.dart';

class ProjectCard extends StatelessWidget {
  final GreenProject project;
  final int index;

  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
  });

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';
    return '${diff.inDays} d ago';
  }

  String _assetImageForIndex(int index, String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) return imageUrl;
    final assetIndex = index % 4;
    return 'assets/$assetIndex.png';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  _assetImageForIndex(index, project.imageUrl),
                  width: 140,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.transparentIcon,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.favorite_border,
                    color: AppColors.blackIcon,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.titre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textOnBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  project.typeEnergie,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.access_time_filled_sharp,
                        color: AppColors.primary, size: 12),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        _timeAgo(project.dateCreation),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
