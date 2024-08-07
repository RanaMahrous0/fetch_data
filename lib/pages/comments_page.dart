import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task8_adv/widgets/myTitle.dart';

class CommentsPage extends StatefulWidget {
  final int postId;
  const CommentsPage({required this.postId, super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  List comments = [];
  bool isLoadingComments = true;
  bool isLoadingPost = true;
  Map<String, dynamic> post = {};

  @override
  void initState() {
    getComments(widget.postId);
    getSinglePost(widget.postId);

    super.initState();
  }

  Future<void> getComments(int postId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/posts/$postId/comments'));
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

  Future<void> getSinglePost(int postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts/$postId'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.postId}'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: isLoadingComments
          ? onLoading()
          : commentsWidget(),
    );
  }

  Widget commentsWidget() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    title: Text(
                      post['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(post['body'] ?? ''),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Mytitle(title: 'Comments'),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    children: comments
                        .map((comment) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    comment['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(comment['body']),
                                  leading: const CircleAvatar(
                                    child: Center(
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
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
