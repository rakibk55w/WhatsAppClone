import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';
import 'package:whats_app_clone/features/status/controller/status_controller.dart';

import '../../../models/status_model.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<StatusModel>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/status-screen',
                      arguments: statusData,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(statusData.username),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(statusData.profilePic),
                      ),
                    ),
                  ),
                ),
                const Divider(color: AppColors.dividerColor, indent: 85),
              ],
            );
          },
        );
      },
    );
  }
}
