import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task8_adv/pages/comments_page.dart';
import 'package:task8_adv/widgets/myTitle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  List posts = [];
  Map<String, dynamic> post = {};

  bool isLoadingPosts = true;

  @override
  void initState() {
    getPosts();

    super.initState();
  }

  Future<void> getPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));
      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body);
          isLoadingPosts = false;
        });
        print(posts.length);
      } else {
        throw Exception('failed to load posts');
      }
    } catch (e) {
      setState(() {
        isLoadingPosts = false;
      });
      print('error in fetching posts :$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: getPostsWidget(),
    );
  }

  Widget getPostsWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoadingPosts
          ? onLoading()
          : ListView(
              children: [
                ...posts.map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        CommentsPage(postId: e['id'])));
                          },
                          title: Text(e['title']),
                          leading: CircleAvatar(
                            child: Center(
                              child: Text('P${e['id'].toString()}'),
                            ),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }

  Widget onLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
