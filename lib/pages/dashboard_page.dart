import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import '../photo_manager/photo_data_model.dart';
import 'package:provider/provider.dart';
import '../photo_manager/album_page.dart';
import 'dart:developer' as developer;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _selectedFolder;
  bool _loading = false;

  Future<void> _pickFolder() async {
    developer.log('点击+号，准备选择文件夹');
    final path = await getDirectoryPath();
    developer.log('getDirectoryPath 返回: $path');
    if (path != null) {
      setState(() {
        _selectedFolder = path;
        _loading = true;
      });
      developer.log('开始读取文件夹图片: $path');
      await Provider.of<PhotoDataModel>(context, listen: false).loadPhotosFromFolder(path);
      setState(() => _loading = false);
      developer.log('读取完成，跳转到相册页面');
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AlbumPage()));
      }
    } else {
      developer.log('未选择文件夹');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('未选择文件夹')));
    }
  }

  Future<void> _pickFiles() async {
    developer.log('点击选择图片文件');
    final files = await openFiles(acceptedTypeGroups: [
      XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png', 'bmp', 'gif', 'webp', 'heic'])
    ]);
    developer.log('openFiles 返回: ${files.map((f) => f.path).toList()}');
    if (files.isNotEmpty) {
      setState(() => _loading = true);
      developer.log('开始加载图片文件');
      await Provider.of<PhotoDataModel>(context, listen: false).loadPhotosFromFiles(files.map((f) => f.path).toList());
      setState(() => _loading = false);
      developer.log('加载完成，跳转到相册页面');
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AlbumPage()));
      }
    } else {
      developer.log('未选择图片文件');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('未选择图片文件')));
    }
  }

  void _startScan() {
    developer.log('点击开始扫描');
    if (_selectedFolder != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AlbumPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    developer.log('DashboardPage build, _selectedFolder=$_selectedFolder, _loading=$_loading');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('相似照片清理', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('快速准确地查找相似或重复的照片，支持文件夹和图片文件选择', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: _pickFolder,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFFFFF7E0), Color(0xFFFFF3C0)]),
                  border: Border.all(color: Colors.orange.shade200, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.add, size: 48, color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('点击或拖拽添加文件夹', style: TextStyle(fontSize: 16, color: Colors.grey)),
            TextButton(
              onPressed: _pickFiles,
              child: const Text('选择图片文件', style: TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _selectedFolder != null && !_loading ? _startScan : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 56),
                backgroundColor: Colors.cyan.shade100,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text('开始扫描'),
            ),
            if (_loading) ...[
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
} 