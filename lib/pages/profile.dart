import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/green_project.dart';
import '../services/project_service.dart';
import '../services/user_service.dart';
import '../utils/api_config.dart';
import '../widgets/project_grid_list.dart';
import '../widgets/financement_list.dart';
import '../theme/app_colors.dart';
import 'profile_settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late TabController _tabController;
  String username = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUsername();
  }
  void _loadUsername() async {
    try {
      final fetchedUsername = await fetchUsername();
      setState(() {
        username = fetchedUsername;
      });
    } catch (e) {
      // handle error, optionally set a default username
      setState(() {
        username = 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileSettings()),
              );
            },
          ),
        ],
        elevation: 1,
      ),
      body: Column(
        children: [
          // ---------- PROFILE HEADER ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, size: 50, color: AppColors.textOnPrimary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCounter("Posts", "24"),
                      _buildCounter("Followers", "382"),
                      _buildCounter("Following", "210"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---------- USERNAME & BIO ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username.isEmpty ? 'Loading...' : username,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Eco energy engineer • Mobile developer 🌱",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ---------- EDIT PROFILE & SHARE ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Edit Profile",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Share Profile",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ---------- TABS ----------
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),

          // ---------- TAB VIEWS ----------
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Grid of projects
                FutureBuilder<List<GreenProject>>(
                  future: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('jwt_token');
                    return ProjectService(url: ApiConfig.myProjects, token: token).getAllProjects();
                  }(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final projects = snapshot.data ?? [];
                    return ProjectGridList(projects: projects);
                  },
                ),

                // Tab 2: Vertical list of financement events (like Home page)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: FinancementList(url: ApiConfig.myFinancements),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
