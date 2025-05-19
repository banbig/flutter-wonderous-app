import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clustering_view_provider.dart';
import '../widgets/photo_group_widget.dart';

class ClusteringScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClusteringViewProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Scaffold(
            appBar: AppBar(title: Text('清理')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (provider.error != null) {
          return Scaffold(
            appBar: AppBar(title: Text('清理')),
            body: Center(child: Text(provider.error!)),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('清理')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('发现 ${provider.displayedGroups.length} 组照片'),
                    Row(
                      children: [
                        Text('智能选择'),
                        Switch(
                          value: provider.isSmartSelectEnabled,
                          onChanged: provider.setSmartSelectEnabled,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.displayedGroups.length,
                  itemBuilder: (context, index) {
                    final group = provider.displayedGroups[index];
                    return PhotoGroupWidget(
                      photoGroup: group,
                      selectedPhotoIds: provider.selectedPhotoIds,
                      onPhotoTap: provider.togglePhotoSelection,
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('已选 ${provider.selectedPhotoIds.length} 张'),
                ElevatedButton(
                  onPressed: null, // MVP4暂不实现清理
                  child: Text('立即清理'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 