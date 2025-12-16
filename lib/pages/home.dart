import 'package:flutter/material.dart';
import 'package:practice/pages/profile_settings.dart';
import '../entities/green_project.dart';
import '../entities/financement_event.dart';
import '../services/project_service.dart';
import '../services/financement_service.dart';
import '../theme/app_colors.dart';
import '../utils/api_config.dart';
import '../widgets/financement_list.dart';
import '../widgets/project_horizontal_list.dart';
import 'create_project_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE2E8E2),
              Color(0xFFF4F4F4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(),
            const SizedBox(height: 15),
            const TitleSection(),
            const SizedBox(height: 15),
            const WidgetProjects(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: const InvestorWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- TopBar -----------------
class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.notifications, color: AppColors.blackIcon),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileSettings()),
            );
          },
          icon: Icon(Icons.settings, color: AppColors.blackIcon),
        ),
        const SizedBox(width: 16),
        // + icon to create a new project
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateProjectPage()),
            );
          },
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.green, // change color if needed
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }
}

// ----------------- Title Section -----------------
class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🌳', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
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
      ],
    );
  }
}

// ----------------- Projects -----------------
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

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late Future<List<GreenProject>> _greenProjectsFuture;

  @override
  void initState() {
    super.initState();
    _greenProjectsFuture = ProjectService(url: ApiConfig.allProjects).getAllProjects();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: FutureBuilder<List<GreenProject>>(
        future: _greenProjectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final greenProjects = snapshot.data ?? [];
          return ProjectHorizontalList(projects: greenProjects);
        },
      ),
    );
  }
}

// ----------------- Investors / Events -----------------
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
        const SizedBox(
          height: 320,
          child: FinancementList(),
        ),
      ],
    );
  }
}


class EventsList extends StatefulWidget {
  const EventsList({super.key});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  late Future<List<FinancementEvent>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = FinancementService(url: ApiConfig.allFinancements).getFinancements();// API call
  }

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';
    return '${diff.inDays} d ago';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FinancementEvent>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        final events = snapshot.data ?? [];
        return ListView.separated(
          itemCount: events.length,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final event = events[index];
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
                    child: Text('🌱'),
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
          },
        );
      },
    );
  }
}
