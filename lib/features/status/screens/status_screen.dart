import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whats_app_clone/models/status_model.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.status});

  final StatusModel status;
  static const String routeName = '/status-screen';

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController storyController = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    initStoryPageItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: storyItems,
        controller: storyController,
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down || direction == Direction.up) {
            Navigator.pop(context);
          }
        },
        onComplete: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
          url: widget.status.photoUrl[i],
          controller: storyController,
          caption: Text(widget.status.username),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
