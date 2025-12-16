import 'package:flutter/material.dart';
import '../entities/financement_event.dart';
import '../theme/app_colors.dart';
import 'dart:math';

class FinancementCard extends StatelessWidget {
  final FinancementEvent event;
  final int index;

  const FinancementCard({
    super.key,
    required this.event,
    required this.index,
  });

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';
    return '${diff.inDays} d ago';
  }

  // ------------------ Emoji List ------------------
  static const List<String> emojis = [
    '🌱', // seedling
    '🌿', // herb
    '🌳', // tree
    '🌴', // palm tree
    '🌾', // grass
    '🌵', // cactus
    '🍀', // clover
    '🌻', // sunflower
    '🌹', // flower
    '🌼', // blossom
    '🌞', // sun
    '💧', // water drop
    '⚡', // lightning / energy
    '🔥', // fire / energy
    '🌎', // earth
    '🌍', // earth
    '🌏', // earth
    '☀️', // sun
    '💡', // light / energy
    '🛠️', // tools / green tech
    '🚴‍♂️', // eco transport
    '🛶', // eco transport / water
    '🌊', // water / wave
    '🍃', // leaves
    '🍂', // autumn leaves
  ];

  // Get a random emoji for each card
  String _randomEmoji(int index) {
    final random = Random(index); // deterministic
    return emojis[random.nextInt(emojis.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grayWidget,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Emoji instead of profile/image
          CircleAvatar(
            backgroundColor: AppColors.transparentIcon,
            child: Text(_randomEmoji(index), style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textOnBlack,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time_filled_sharp,
                        color: AppColors.primaryLight, size: 12),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        _timeAgo(event.dateFinancement),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.primaryLight,
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
          Container(
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
        ],
      ),
    );
  }
}
