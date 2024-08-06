import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  List comments = [];
  bool isLoadingPosts = true;
  bool isLoadingPost = true;
  bool isLoadingComments = true;

  @override
  void initState() {
    getPosts();
    getSinglePost();
    getComments();
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

  Future<void> getSinglePost() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts/1'));
      if (response.statusCode == 200) {
        setState(() {
          post = jsonDecode(response.body);
          isLoadingPost = false;
        });
        print(post);
      } else {
        throw Exception('failed to load post');
      }
    } catch (e) {
      setState(() {
        isLoadingPost = false;
      });
      print('error fetching post: $e');
    }
  }

  Future<void> getComments() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts/1/comments'));
      if (response.statusCode == 200) {
        setState(() {
          comments = jsonDecode(response.body);
          isLoadingComments = false;
        });
        print(comments.length);
      } else {
        throw Exception('failed to load comments');
      }
    } catch (e) {
      setState(() {
        isLoadingComments = false;
      });
      print('error in fetching comments :$e');
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
      body: getBody(),
    );
  }

  Widget getBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoadingPosts || isLoadingPost || isLoadingComments
          ? onLoading()
          : ListView(
              children: [
                const Mytitle(title: 'All Posts'),
                ...posts.map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(e['title']),
                        leading: CircleAvatar(
                          child: Center(
                            child: Text('P${e['id'].toString()}'),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                const Mytitle(title: 'Single Post'),
                ListTile(
                  title: Text(
                    post['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(post['body'] ?? ''),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Mytitle(title: 'Comments For Post 1'),
                ...comments.map((e) => ListTile(
                      title: Text(
                        e['name'],
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(e['body']),
                      leading: CircleAvatar(
                        child: Center(
                          child: Text('C${e['id'].toString()}'),
                        ),
                      ),
                    ))
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
