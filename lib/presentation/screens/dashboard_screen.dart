import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_data_provider.dart';
import '../../providers/navigation_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.dashboardTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FlutterLogo(size: 80),
              const SizedBox(height: 24),
              Text(
                localizations.dashboardAppName,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                localizations.dashboardSlogan,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await Provider.of<PhotoDataProvider>(context, listen: false).loadPhotosFromDevice();
                    Provider.of<NavigationProvider>(context, listen: false).setPage(2); // 跳转到清理页
                  },
                  child: Text(localizations.dashboardScanAndClean, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 32),
              Text(localizations.dashboardLastScan("2024-06-01 14:23"), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(localizations.dashboardOptimizable("1.2 GB"), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
} 