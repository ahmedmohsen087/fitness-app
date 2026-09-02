import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/reusable_widgets/app_toast.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
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

  Future<void> _openEditProfile(ProfileResponseEntity profile) async {
    await Navigator.pushNamed(
      context,
      AppRoutsName.editProfileScreen,
      arguments: profile,
    );
    if (!mounted) return;
    context.read<GetProfileViewModel>().doEvent(const RefreshProfileEvent());
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
      imagePath: Assets.assetsImagesMainBackground,
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
                    color: AppColors.lightBlack.withAlpha(160),
                    borderRadius: BorderRadius.circular(24),
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 7,
                      separatorBuilder: (context, index) => const Divider(
                        color: AppColors.dividerColor,
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return ProfileTileItem(
                              leadingIcon: Assets.assetsIconsProfile,
                              title: AppStrings.editProfile,
                              onTap: () => _openEditProfile(user),
                            );
                          case 1:
                            return ProfileTileItem(
                              leadingIcon: Assets.assetsIconsCycleArrow,
                              title: AppStrings.changePassword,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutsName.changePasswordScreen,
                                );
                              },
                            );
                          case 2:
                            return ProfileTileItem(
                              leadingIcon: Assets.assetsIconsLanguage,
                              title: AppStrings.language,
                              titleWidget: RichText(
                                text: TextSpan(
                                  style: TextStyles.bodyRegular14.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(text: '${AppStrings.language} ('),
                                    TextSpan(
                                      text: context.locale.languageCode == 'ar'
                                          ? AppStrings.arabic
                                          : AppStrings.english,
                                      style: const TextStyle(
                                        color: AppColors.orange,
                                      ),
                                    ),
                                    const TextSpan(text: ')'),
                                  ],
                                ),
                              ),
                              onTap: () => _showLanguageBottomSheet(context),
                            );
                          case 3:
                            return ProfileTileItem(
                              leadingIcon: Assets.assetsIconsLockSetting,
                              title: AppStrings.security,
                              onTap: () => _launchUrl(AppStrings.securityUrl),
                            );
                          case 4:
                            return ProfileTileItem(
                              leadingIcon: Assets.assetsIconsSecurityWarning,
                              title: AppStrings.privacyPolicy,
                              onTap: () =>
                                  _launchUrl(AppStrings.privacyPolicyUrl),
                            );
                          case 5:
                            return ProfileTileItem(
                              leadingIcon: Assets.assetsIconsHelp,
                              title: AppStrings.help,
                              onTap: () => _launchUrl(AppStrings.helpUrl),
                            );
                          case 6:
                          default:
                            return ProfileTileItem(
                              leadingIcon: Assets.assetsIconsLogout,
                              title: AppStrings.logout,
                              textColor: AppColors.orange,
                              onTap: () {},
                            );
                        }
                      },
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
