import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: GitHubViewer());
  }
}

class GitHubViewer extends StatefulWidget {
  @override
  _GithubViewerState createState() => _GithubViewerState();
}

class _GithubViewerState extends State<GitHubViewer> {
  TextEditingController controller = TextEditingController();

  Map<String, dynamic>? userData;
  bool isLoading = false;
  String error = "";

  Future<void> fetchUser(String username) async {
    setState(() {
      isLoading = true;
      error = "";
    });

    try {
      final url = Uri.parse("https://api.github.com/users/$username");
      final response = await http.get(url);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          userData = data;
        });
      } else {
        setState(() {
          error = "User not found";
          userData = null;
        });
      }
    } catch (e) {
      setState(() {
        error = "Something went wrong!!";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GitHub Viewer")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "Enter GitHub username"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                fetchUser(controller.text);
              },
              child: Text("Search"),
            ),
            SizedBox(height: 20),

            if (isLoading) CircularProgressIndicator(),

            if (error.isNotEmpty) Text(error),

            if (userData != null) ...[
              Text("Name: ${userData!['name']}"),
              Text("Username: ${userData!['login']}"),
              Text("Followers: ${userData!['followers']}"),
              Text("Public Repos: ${userData!['public_repos']}"),
            ],
          ],
        ),
      ),
    );
  }
}
