import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactCard extends StatelessWidget {
  final UserEntity contact;
  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          child: ClipOval(
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: contact.photoUrl ?? '',
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => const CircularProgressIndicator(
                    constraints: BoxConstraints(maxHeight: 16, maxWidth: 16),
                  ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        title: Text(
          contact.name ?? 'Unknown User',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(contact.email, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Iconsax.message),
          onPressed: () {},
        ),
      ),
    );
  }
}
