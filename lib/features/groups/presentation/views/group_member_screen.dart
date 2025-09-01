import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/group_entity.dart';
import 'group_edit_screen.dart';

class GroupMemberScreen extends StatelessWidget {
  static const routeName = '/group-member-screen';
  final GroupEntity group;
  final List<UserEntity> members;

  const GroupMemberScreen({
    super.key,
    required this.group,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = group.admins.contains(
      FirebaseAuth.instance.currentUser!.uid,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, GroupEditScreen.routeName);
              },
              icon: const Icon(Iconsax.user_edit),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: group.members.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: members[index].photoUrl ?? '',
                        imageBuilder:
                            (context, imageProvider) =>
                                CircleAvatar(backgroundImage: imageProvider),
                        placeholder:
                            (context, url) => const CircleAvatar(
                              backgroundColor: Colors.grey,

                              child: CircularProgressIndicator(),
                            ),
                        errorWidget:
                            (context, url, error) =>
                                const CircleAvatar(child: Icon(Iconsax.user)),
                      ),
                      title: Text(members[index].name ?? 'No Name'),
                      subtitle: const Text('Admin'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isAdmin &&
                              !group.admins.contains(members[index].uId))
                            IconButton(
                              icon: const Icon(
                                Iconsax.user_tick,
                                color: Colors.green,
                              ),
                              onPressed: () {},
                            ),
                          if (isAdmin)
                            IconButton(
                              icon: const Icon(
                                Iconsax.trash,
                                color: Colors.red,
                              ),
                              onPressed: () {},
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
