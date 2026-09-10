import 'package:flutter/material.dart';

import '../../services/offline_storage_service.dart';

class SavedWorksheetScreen extends StatefulWidget {
  const SavedWorksheetScreen({super.key});

  @override
  State<SavedWorksheetScreen> createState() =>
      _SavedWorksheetScreenState();
}

class _SavedWorksheetScreenState
    extends State<SavedWorksheetScreen> {
  Map<String, dynamic>? worksheet;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadWorksheet();
  }

  Future<void> loadWorksheet() async {
    final data =
        await OfflineStorageService.getWorksheet();

    if (!mounted) return;

    setState(() {
      worksheet = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Worksheet'),
      ),
      body: worksheet == null
          ? const Center(
              child: Text(
                'No saved worksheet available.',
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.offline_bolt),
                      SizedBox(width: 8),
                      Text(
                        'Available Offline',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildContent(worksheet!),
                ],
              ),
            ),
    );
  }

  Widget _buildContent(
    Map<String, dynamic> data,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
            bottom: 15,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                _formatTitle(entry.key),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatValue(entry.value),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatTitle(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                '${word.substring(1)}',
        )
        .join(' ');
  }

  String _formatValue(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString())
          .join('\n\n');
    }

    if (value is Map) {
      return value.entries
          .map(
            (e) => '${e.key}: ${e.value}',
          )
          .join('\n');
    }

    return value.toString();
  }
}
