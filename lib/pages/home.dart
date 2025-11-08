import 'package:flutter/material.dart';
import '../entities/event.dart';
import '../entities/green_project.dart';
import '../theme/app_colors.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea( // ✅ Avoid top notch overlap
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE2E8E2), // light green top
              Color(0xFFF4F4F4), // fade to lighter bottom
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Fixed top row (icons)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.notifications, color: AppColors.blackIcon),
                const SizedBox(width: 16),
                Icon(Icons.settings, color: AppColors.blackIcon),
                const SizedBox(width: 16),
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // ✅ Fixed title section
            const Text(
              '🌳',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Green Energy",
              style: TextStyle(
                color: AppColors.primaryLight,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Help us save the earth",
              style: TextStyle(
                color: AppColors.textOnBlack,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            WidgetProjects(),
            SizedBox(height: 20),

            // ✅ Expanded scrollable content (fills until bottom)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: const [
                    InvestorWidget(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvestorWidget extends StatelessWidget {
  const InvestorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Top investors",
              style: TextStyle(
                color: AppColors.textOnBlack,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.supervised_user_circle_outlined,
                color: AppColors.blackIcon, size: 20),
          ],
        ),
        const SizedBox(height: 10),

        // ✅ Scrollable inside available height
        SizedBox(
          height: 320,
          child: Events(),
        ),
      ],
    );
  }
}

class WidgetProjects extends StatelessWidget {
  const WidgetProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "LATEST PROJECTS",
              style: TextStyle(
                color: AppColors.textOnBlack,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(Icons.explore_outlined,
                color: AppColors.blackIcon, size: 20),
          ],
        ),
        const SizedBox(height: 20),
        const Projects(),
      ],
    );
  }
}

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final List<Event> events = [
    Event(description: 'Richard planted evergreen tree', time: '10:45 PM', emoji: '🌱'),
    Event(description: 'Monica planted palm tree', time: '09:30 AM', emoji: '🌴'),
    Event(description: 'Liam watered the bonsai tree', time: '02:15 PM', emoji: '🌿'),
    Event(description: 'Anastasia joined tree cleanup', time: '05:00 PM', emoji: '🍃'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: events.length,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (BuildContext context, int index) {
        final Event event = events[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.grayWidget,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.transparentIcon,
                child: Text(event.emoji),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textOnBlack,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time_filled_sharp,
                            color: AppColors.primaryLight, size: 12),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            event.time,
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
            ]
          ),
        );
      },
    );
  }
}

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final List<GreenProject> _greenProjects = [
    GreenProject(
      name: 'James',
      treeType: 'Planted evergreen tree',
      imageUrl: 'assets/0.png',
      date: '5h ago',
    ),
    GreenProject(
      name: 'Anastasia',
      treeType: 'Planted palm tree',
      imageUrl: 'assets/1.png',
      date: '12 min ago',
    ),
    GreenProject(
      name: 'Monica',
      treeType: 'Planted bonsai tree',
      imageUrl: 'assets/2.png',
      date: 'Yesterday',
    ),
    GreenProject(
      name: 'Liam',
      treeType: 'Planted oak tree',
      imageUrl: 'assets/3.png',
      date: 'Today',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _greenProjects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _greenProjects[index];
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
                        item.imageUrl,
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
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textOnBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.treeType,
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
                              item.date ?? '',
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
        },
      ),
    );
  }
}
