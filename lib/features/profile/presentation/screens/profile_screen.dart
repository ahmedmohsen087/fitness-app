import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/reusable_widgets/app_toast.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:fitness_app/features/profile/presentation/widgets/profile_header_widet.dart';
import 'package:fitness_app/features/profile/presentation/widgets/profile_tile_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetProfileViewModel>().doEvent(const RefreshProfileEvent());
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        AppToast.error(context, AppStrings.couldNotLaunchLink);
      }
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final currentLocale = context.locale;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.lightBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.language,
                style: TextStyles.bodyRegular16.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              _LanguageOption(
                label: AppStrings.english,
                selected: currentLocale.languageCode == 'en',
                onTap: () {
                  context.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Colors.white12, height: 1),
              _LanguageOption(
                label: AppStrings.arabic,
                selected: currentLocale.languageCode == 'ar',
                onTap: () {
                  context.setLocale(const Locale('ar'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;

    return AppBackgroundScaffold(
      imagePath: Assets.mainBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: BlocConsumer<GetProfileViewModel, GetProfileState>(
          listener: (context, state) {
            final profileState = state.getProfileState;
            if (!profileState.isLoading && profileState.msg != null) {
              AppToast.error(context, profileState.msg!);
            }
          },
          builder: (context, state) {
            final profileState = state.getProfileState;

            if (profileState.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              );
            }

            if (profileState.msg != null && profileState.data == null) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<GetProfileViewModel>().doEvent(
                          const RefreshProfileEvent(),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                  ),
                  child: Text(
                    AppStrings.retry,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }

            final user = profileState.data;

            if (user == null) {
              return Center(
                child: Text(
                  AppStrings.noProfileDataAvailable,
                  style: TextStyles.bodyRegular14.copyWith(
                    color: AppColors.white,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                spacing: 32,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeaderWidget(
                    imageUrl: user.photo,
                    userName: '${user.firstName} ${user.lastName}',
                  ),
                  Material(
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlack,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ProfileTileItem(
                            leadingIcon: Icons.person_outline,
                            title: AppStrings.editProfile,
                            onTap: () {},
                          ),
                          ProfileTileItem(
                            leadingIcon: Icons.lock_outline,
                            title: AppStrings.changePassword,
                            onTap: () {},
                          ),
                          ProfileTileItem(
                            leadingIcon: Icons.language,
                            title: AppStrings.language,
                            trailing: Text(
                              context.locale.languageCode == 'ar'
                                  ? AppStrings.arabic
                                  : AppStrings.english,
                              style: TextStyles.bodyRegular14.copyWith(
                                color: AppColors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () => _showLanguageBottomSheet(context),
                          ),
                          ProfileTileItem(
                            leadingIcon: Icons.security,
                            title: AppStrings.security,
                            onTap: () => _launchUrl(AppStrings.securityUrl),
                          ),
                          ProfileTileItem(
                            leadingIcon: Icons.privacy_tip_outlined,
                            title: AppStrings.privacyPolicy,
                            onTap: () =>
                                _launchUrl(AppStrings.privacyPolicyUrl),
                          ),
                          ProfileTileItem(
                            leadingIcon: Icons.help_outline,
                            title: AppStrings.help,
                            onTap: () => _launchUrl(AppStrings.helpUrl),
                          ),
                          ProfileTileItem(
                            leadingIcon: Icons.logout,
                            title: AppStrings.logout,
                            textColor: AppColors.orange,
                            iconColor: AppColors.orange,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyles.bodyRegular14.copyWith(
                color: selected ? AppColors.orange : Colors.grey,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(
                Icons.check_rounded,
                color: AppColors.orange,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
