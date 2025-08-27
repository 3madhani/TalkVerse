import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../../core/cubits/user_cubit/user_data_cubit.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../auth/presentation/views/widgets/custom_elevated_button.dart';
import '../../manager/profile_view_model.dart';
import 'profile_info_card.dart';
import 'profile_info_card_static.dart';
import 'profile_picture.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder:
          (context, viewModel, child) => Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: BlocConsumer<UserDataCubit, UserDataState>(
                listener: (context, state) {
                  if (state is UserDataError) {
                    AppSnackBar.showError(context, state.message);
                  }
                  if (state is UserDataLoaded) {
                    viewModel.setUser(state.user);
                  }
                  if (state is UserDataUpdated) {
                    AppSnackBar.showSuccess(context, state.message);
                  }
                },
                builder: (context, state) {
                  final user = state is UserDataLoaded ? state.user : null;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        /// Profile Picture
                        ProfilePicture(profilePictureUrl: user?.photoUrl ?? ""),
                        const SizedBox(height: 16),

                        /// Name Field
                        ProfileInfoCard(
                          icon: Iconsax.user_octagon,
                          label: 'Name',
                          controller:
                              user != null
                                  ? viewModel.nameController
                                  : TextEditingController(text: "Loading..."),
                          isEnabled: viewModel.enableName,
                          onEdit: viewModel.toggleEditName,
                        ),

                        /// About Field
                        ProfileInfoCard(
                          icon: Iconsax.information,
                          label: 'About',
                          controller:
                              user != null
                                  ? viewModel.aboutController
                                  : TextEditingController(text: "Loading..."),
                          isEnabled: viewModel.enableAbout,
                          onEdit: viewModel.toggleEditAbout,
                        ),

                        /// Email Info
                        ProfileInfoCardStatic(
                          icon: Iconsax.direct,
                          title: 'Email',
                          subtitle: user?.email ?? "Loading...",
                        ),

                        /// Join Date Info
                        ProfileInfoCardStatic(
                          icon: Iconsax.calendar_1,
                          title: 'Join Date',
                          subtitle: formatTimestampToDateString(
                            user!.createdAt!,
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// Save Button
                        CustomElevatedButton(
                          label: 'Save',
                          onPressed:
                              viewModel.enableName || viewModel.enableAbout
                                  ? () => viewModel.saveProfile(
                                    name: viewModel.nameController.text,
                                    about: viewModel.aboutController.text,
                                  )
                                  : null, // disable while loading
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
    );
  }

  String formatTimestampToDateString(String timestampString) {
    final timestamp = int.tryParse(timestampString);
    if (timestamp == null) return "Invalid date";
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return "${date.day}/${date.month}/${date.year}";
  }
}
