import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/text_field_message.dart';
import '../../../../home/domain/entities/chat_room_entity.dart';
import '../../manager/chat_cubit/chat_message_cubit.dart';

class SendMessageField extends StatefulWidget {
  final ChatRoomEntity chatRoom;

  const SendMessageField({super.key, required this.chatRoom});

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

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final receiverId = widget.chatRoom.members.firstWhere(
      (id) => id != FirebaseAuth.instance.currentUser?.uid,
      orElse: () => '', // fallback in case of single-user room
    );

    context.read<ChatMessageCubit>().sendMessage(
      roomId: widget.chatRoom.id,
      receiverId: receiverId,
      message: message,
    );

    _messageController.clear();
  }
}
