import 'dart:io';

import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/core/widgets/app_snack_bar.dart';
import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:chitchat/features/groups/domain/entities/group_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/home/domain/entities/chat_room_entity.dart';
import '../constants/backend/backend_end_points.dart';
import '../cubits/chat_cubit/chat_message_cubit.dart';
import 'text_field_message.dart';

class SendMessageField extends StatefulWidget {
  final ChatRoomEntity? chatRoom;
  final GroupEntity? group;
  final UserEntity user;

  const SendMessageField({
    super.key,
    this.chatRoom,
    this.group,
    required this.user,
  });

  @override
  State<SendMessageField> createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  final TextEditingController _messageController = TextEditingController();
  bool isSendEnabled = false;

  @override
  Widget build(BuildContext context) {
    return TextfieldMessage(
      controller: _messageController,
      isSendEnabled: isSendEnabled,
      onPressedSend: isSendEnabled ? _sendMessage : null,
      onPressedImage: () => _pickAndUploadImage(context),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  void _onMessageChanged() {
    final isEnabled = _messageController.text.trim().isNotEmpty;
    if (isSendEnabled != isEnabled) {
      setState(() => isSendEnabled = isEnabled);
    }
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (widget.chatRoom != null) {
          if (context.mounted) {
            final receiverId = widget.chatRoom!.members.firstWhere(
              (id) => id != FirebaseAuth.instance.currentUser?.uid,
              orElse: () => '', // fallback in case of single-user room
            );
            getIt<ChatMessageCubit>().sendMessage(
              user: widget.user,
              collectionPath: BackendEndPoints.chatRooms,
              roomId: widget.chatRoom!.id,
              receiverId: receiverId,
              image: File(image.path),
              messageType: 'image',
            );
          }
        } else if (widget.group != null) {
          getIt<ChatMessageCubit>().sendMessage(
            user: widget.user,
            collectionPath: BackendEndPoints.groups,
            roomId: widget.group!.id,
            receiverId: widget.group!.id,
            image: File(image.path),
            messageType: 'image',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showWarning(context, "Failed to pick image: $e");
      }
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    if (widget.chatRoom != null) {
      final receiverId = widget.chatRoom!.members.firstWhere(
        (id) => id != FirebaseAuth.instance.currentUser?.uid,
        orElse: () => '', // fallback in case of single-user room
      );

      getIt<ChatMessageCubit>().sendMessage(
        user: widget.user,
        collectionPath: BackendEndPoints.chatRooms,
        roomId: widget.chatRoom!.id,
        receiverId: receiverId,
        message: message,
      );
    } else if (widget.group != null) {
      getIt<ChatMessageCubit>().sendMessage(
        user: widget.user,
        collectionPath: BackendEndPoints.groups,
        roomId: widget.group!.id,
        receiverId: widget.group!.id,
        message: message,
      );
    }

    _messageController.clear();
  }
}
