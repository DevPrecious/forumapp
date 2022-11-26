import 'package:flutter/material.dart';
import 'package:forumapp/models/post_model.dart';
import 'package:forumapp/views/widgets/input_widget.dart';
import 'package:get/get.dart';
import 'widgets/post_data.dart';
import 'package:forumapp/controllers/post_controller.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({super.key, required this.post});

  final PostModel post;

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final TextEditingController _commentController = TextEditingController();
  final PostController _postController = Get.put(PostController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postController.getComments(widget.post.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(widget.post.user!.name!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              PostData(
                post: widget.post,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 300,
                child: Obx(() {
                  return _postController.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: _postController.comments.value.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                _postController
                                    .comments.value[index].user!.name!,
                              ),
                              subtitle: Text(
                                _postController.comments.value[index].body!,
                              ),
                            );
                          });
                }),
              ),
              InputWidget(
                obscureText: false,
                hintText: 'Write a comment...',
                controller: _commentController,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                ),
                onPressed: () async {
                  await _postController.createComment(
                    widget.post.id,
                    _commentController.text.trim(),
                  );
                  _commentController.clear();
                  _postController.getComments(widget.post.id);
                },
                child: const Text('Comment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
