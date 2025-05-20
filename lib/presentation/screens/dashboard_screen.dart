import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_data_provider.dart';
import '../../providers/navigation_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/clustering_view_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(localizations.dashboardTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF3F6FA),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 14,
              shadowColor: Color(0x1A000000),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 56),
                    const SizedBox(height: 20),
                    Text(
                      localizations.dashboardAppName,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF232B3B), letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.dashboardSlogan,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF8A94A6), fontWeight: FontWeight.w500, letterSpacing: 0.1),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6A7BFF), Color(0xFF9F5FFF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Color(0x336A7BFF), blurRadius: 8, offset: Offset(0, 3))],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            await Provider.of<PhotoDataProvider>(context, listen: false).loadPhotosFromDevice();
                            await Provider.of<ClusteringViewProvider>(context, listen: false).fetchPhotoGroups();
                            Provider.of<NavigationProvider>(context, listen: false).setPage(2);
                          },
                          child: Text(localizations.dashboardScanAndClean, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('上次扫描：', style: TextStyle(color: Color(0xFF8A94A6), fontSize: 13)),
                        Text('2024-06-01 14:23', style: TextStyle(color: Color(0xFF232B3B), fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('预计可优化：', style: TextStyle(color: Color(0xFF8A94A6), fontSize: 13)),
                        Text('1.2 GB', style: TextStyle(color: Color(0xFF6A7BFF), fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 