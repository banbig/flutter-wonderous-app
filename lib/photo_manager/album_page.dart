import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'photo_data_model.dart';
import 'photo_card_widget.dart';
import 'photo_preview_page.dart';

/// 相册页面，支持照片浏览、选中、批量删除
class AlbumPage extends StatelessWidget {
  const AlbumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhotoDataModel>(
      create: (_) {
        final model = PhotoDataModel();
        model.loadDevicePhotos();
        return model;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('相册'),
          actions: [
            Builder(
              builder: (context) {
                final model = Provider.of<PhotoDataModel>(context, listen: false);
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.select_all),
                      tooltip: '全选',
                      onPressed: () => model.selectAll(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: '删除选中',
                      onPressed: () {
                        if (model.selectedCount > 0) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('确认删除'),
                              content: Text('确定要删除选中的照片吗？'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    model.deleteSelected();
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('删除'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Consumer<PhotoDataModel>(
          builder: (context, model, _) {
            if (model.photos.isEmpty) {
              return const Center(child: Text('暂无照片'));
            }
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: model.photos.length,
                itemBuilder: (context, index) {
                  final photo = model.photos[index];
                  return PhotoCardWidget(
                    photo: photo,
                    onTap: () => model.toggleSelect(photo.id),
                    onPreview: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PhotoPreviewPage(
                            imageUrl: photo.url,
                            title: photo.name,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar: Consumer<PhotoDataModel>(
          builder: (context, model, _) {
            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('已选 ${model.selectedCount} 张, 共 ${model.selectedSize.toStringAsFixed(2)} MB'),
                    TextButton(
                      onPressed: model.selectedCount > 0 ? model.deleteSelected : null,
                      child: const Text('删除选中'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 