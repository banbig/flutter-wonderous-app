import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/dashboard_page.dart';
import 'photo_manager/photo_data_model.dart';
import 'dart:developer' as developer;
import 'package:file_picker/file_picker.dart';

void main() {
  print('main() 启动');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    developer.log('MyApp build');
    return ChangeNotifierProvider(
      create: (_) => PhotoDataModel(),
      child: MaterialApp(
        title: '智能照片管理',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF6F7F9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: const DashboardPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class FilePickerTestPage extends StatelessWidget {
  const FilePickerTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    developer.log('FilePickerTestPage build');
    return Scaffold(
      appBar: AppBar(title: const Text('file_picker 测试')),
      body: Center(
        child: ElevatedButton(
          child: const Text('选择文件夹'),
          onPressed: () async {
            developer.log('点击按钮');
            try {
              String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
              developer.log('选择结果: $selectedDirectory');
              if (selectedDirectory == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('未选择文件夹')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('选择了: $selectedDirectory')));
              }
            } catch (e, stack) {
              developer.log('选择文件夹异常: $e', error: e, stackTrace: stack);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('异常: $e')));
            }
          },
        ),
      ),
    );
  }
}
