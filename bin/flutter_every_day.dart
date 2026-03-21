import 'dart:io';
import 'package:interact/interact.dart';
import 'package:path/path.dart' as p;

void main() async {
  print('');
  print(' Welcome to FlutterEveryDay ');
  print('-----------------------------------');

  final Map<String, String> apps = {
    'Day 01: GitHub Viewer (Dart http)': 'day01_github_viewer',
    'Day 02: Notes App (Hive DataBase)': 'day02_notes_app',
  };

  final appNames = apps.keys.toList();

  final selectionIndex = Select(
    prompt: 'Which mini-app do you want to build locally?',
    options: appNames,
  ).interact();

  final selectedAppName = appNames[selectionIndex];
  final targetFolder = apps[selectedAppName]!;
  final targetPath = 'mini_apps/$targetFolder';

  print('\nFetching $selectedAppName directly from Git...');

  final tempDir = await Directory.systemTemp.createTemp('flutter_every_day_');
  final repoUrl = 'https://github.com/VineetHegde/FlutterEveryDay.git';

  try {
    // clone ONLY the directory structure (no file contents downloaded yet)
    var result = await Process.run('git', [
      'clone', 
      '--filter=blob:none', 
      '--sparse', 
      repoUrl, 
      tempDir.path
    ]);
    
    if (result.exitCode != 0) throw Exception('Git clone failed: ${result.stderr}');

    //Git to ONLY download the files inside specific target folder
    result = await Process.run('git', [
      'sparse-checkout', 
      'set', 
      targetPath
    ], workingDirectory: tempDir.path);

    if (result.exitCode != 0) throw Exception('Sparse checkout failed: ${result.stderr}');

    //Locate the downloaded files
    final sourceAppDir = Directory(p.join(tempDir.path, 'mini_apps', targetFolder));
    
    if (!await sourceAppDir.exists()) {
      throw Exception('Could not find $targetFolder in the repository.');
    }

    //Move the pristine code to user's current directory
    final destAppDir = Directory(p.join(Directory.current.path, targetFolder));
    await copyDirectory(sourceAppDir, destAppDir);

    print('Generating native Android/iOS/Windows files...');

    // Generate Flutter platform folders
    final String flutterCommand = Platform.isWindows ? 'flutter.bat' : 'flutter';

    final createResult = await Process.run(
      flutterCommand, 
      ['create', '.'],
      workingDirectory: destAppDir.path,
      runInShell: true, 
    );

    if (createResult.exitCode != 0) {
      throw Exception('Failed to run flutter create: ${createResult.stderr}');
    }

    print(' Success!');
    print('\nTo run your app, type:');
    print('  cd $targetFolder');
    print('  flutter run\n');

  } catch (e) {
    print('\n Error: $e');
  } finally {
    // Clean up
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  }
}

Future<void> copyDirectory(Directory source, Directory destination) async {
  await destination.create(recursive: true);
  await for (var entity in source.list(recursive: false)) {
    if (entity is Directory) {
      var newDirectory = Directory(p.join(destination.path, p.basename(entity.path)));
      await newDirectory.create();
      await copyDirectory(entity.absolute, newDirectory);
    } else if (entity is File) {
      await entity.copy(p.join(destination.path, p.basename(entity.path)));
    }
  }
}
