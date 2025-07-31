import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:chitchat/features/home/presentation/views/widgets/dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../manager/contacts_cubit/contacts_cubit.dart';
import '../../manager/home_view_model.dart';

class ContactCard extends StatelessWidget {
  final UserEntity contact;
  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return DismissibleCard(
      title: "Remove Contact",
      confirm: true,
      onDismiss: () async {
        await getIt<ContactsCubit>().deleteContact(contact.uId);
      },
      id: contact.uId,
      content: "contact",
      child: Card(
        elevation: 3,
        child: ListTile(
          leading: CircleAvatar(
            radius: 22,
            child: ClipOval(
              clipBehavior: Clip.antiAlias,
              child:
                  (contact.photoUrl != null && contact.photoUrl!.isNotEmpty)
                      ? CachedNetworkImage(
                        imageUrl: contact.photoUrl!,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                      )
                      : const Icon(
                        Iconsax.user,
                      ), // Fallback icon or asset image
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
            onPressed: () async {
              final cubit = getIt<ChatRoomCubit>();

              final result = await cubit.createChatRoom(email: contact.email);

              if (result) {
                HomeViewModel.goToChatTab(context);
              }
            },
          ),
        ),
      ),
    );
  }
}
