import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/financement_event.dart';
import '../services/financement_service.dart';
import '../utils/api_config.dart';
import '../widgets/financement_card.dart';

class FinancementList extends StatefulWidget {
  final String? url; // optional url
  const FinancementList({super.key, this.url});

  @override
  State<FinancementList> createState() => _FinancementListState();
}

class _FinancementListState extends State<FinancementList> {
  late Future<List<FinancementEvent>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _loadFinancements();
  }

  // Load financements and return Future<void> for refresh
  Future<void> _loadFinancements() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token'); // get token if exists

    setState(() {
      _eventsFuture = FinancementService(
        url: widget.url ?? ApiConfig.allFinancements,
        token: token,
      ).getFinancements();
    });
  }

  // Pull-to-refresh handler
  Future<void> _refresh() async {
    await _loadFinancements();
    await _eventsFuture; // wait for updated data
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
        if (events.isEmpty) return const Center(child: Text('No financements yet'));

        // Wrap ListView in RefreshIndicator for pull-to-refresh
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            itemCount: events.length,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final event = events[index];
              return FinancementCard(event: event, index: index);
            },
          ),
        );
      },
    );
  }
}
