import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/domain/entities/user_entity.dart';
import '../../../domain/entities/group_entity.dart';

class GroupMembersListView extends StatelessWidget {
  final GroupEntity group;

  final List<UserEntity> members;
  final bool isAdmin;
  const GroupMembersListView({
    super.key,
    required this.group,
    required this.members,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
            subtitle:
                group.admins.contains(members[index].uId)
                    ? const Text('Admin', style: TextStyle(color: Colors.green))
                    : Text('Member', style: TextStyle(color: Colors.grey[600])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isAdmin && !group.admins.contains(members[index].uId))
                  IconButton(
                    icon: const Icon(Iconsax.user_tick, color: Colors.green),
                    onPressed: () {},
                  )
                else if (isAdmin && group.admins.contains(members[index].uId))
                  IconButton(
                    icon: const Icon(Iconsax.user_remove, color: Colors.red),
                    onPressed: () {},
                  ),
                if (isAdmin)
                  IconButton(
                    icon: const Icon(Iconsax.trash, color: Colors.red),
                    onPressed: () {},
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
