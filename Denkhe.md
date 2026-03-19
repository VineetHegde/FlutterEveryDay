FlutterEveryDay/
├── bin/
│   └── flutter_every_day.dart    <-- Your CLI script
├── pubspec.yaml                  <-- ROOT PUBSPEC: ONLY has CLI dependencies (interact)
│
└── mini_apps/                    <-- Moved outside of lib/
    │
    ├── day01_github_viewer/
    │   ├── lib/
    │   │   └── main.dart         <-- Day 01 Dart code
    │   └── pubspec.yaml          <-- DAY 01 PUBSPEC: ONLY has Flutter & http
    │
    └── day02_hive_db/
        ├── lib/
        │   └── main.dart         <-- Day 02 Dart code
        └── pubspec.yaml          <-- DAY 02 PUBSPEC: ONLY has Flutter & hive