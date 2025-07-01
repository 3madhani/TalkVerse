import 'package:chitchat/core/widgets/app_snack_bar.dart';
import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/presentation/views/widgets/custom_elevated_button.dart';
import '../../../../auth/presentation/views/widgets/custom_text_field.dart';

class BodyOfFloatingActionButton extends StatefulWidget {
  const BodyOfFloatingActionButton({super.key});

  @override
  State<BodyOfFloatingActionButton> createState() =>
      _BodyOfFloatingActionButtonState();
}

class _BodyOfFloatingActionButtonState
    extends State<BodyOfFloatingActionButton> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: BlocConsumer<ChatRoomCubit, ChatRoomState>(
        listener: (context, state) {
          if (state is ChatRoomSuccess) {
            context.read<ChatRoomCubit>().listenToUserChatRooms(
              FirebaseAuth.instance.currentUser!.uid,
            );
            Navigator.of(context).pop(); // Close bottom sheet
            if (state.message.contains("already exists")) {
              AppSnackBar.showWarning(context, state.message);
            } else {
              AppSnackBar.showSuccess(context, state.message);
            }
          } else if (state is ChatRoomError) {
            Navigator.of(context).pop(); // Close bottom sheet
            AppSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enter Friend Email',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton.filled(
                      onPressed: () {
                        // Handle scan barcode action
                      },
                      icon: const Icon(Iconsax.scan_barcode),
                    ),
                  ],
                ),
                CustomTextField(
                  label: 'Email',
                  prefixIcon: Iconsax.direct,
                  controller: emailController,
                ),
                const SizedBox(height: 18),
                CustomElevatedButton(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  label:
                      state is ChatRoomLoading ? 'Creating...' : 'Create Chat',
                  onPressed:
                      state is ChatRoomLoading
                          ? null
                          : () {
                            if (formKey.currentState!.validate()) {
                              context.read<ChatRoomCubit>().createChatRoom(
                                email: emailController.text.trim(),
                              );
                            }
                          },
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
