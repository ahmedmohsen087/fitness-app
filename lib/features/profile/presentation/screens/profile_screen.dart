import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/reusable_widgets/app_toast.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:fitness_app/features/profile/presentation/widgets/logout_dialog_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppBackgroundScaffold(
      imagePath: Assets.mainBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: BlocConsumer<GetProfileViewModel, GetProfileState>(
            listenWhen: (previous, current) =>
                previous.getProfileState.msg != current.getProfileState.msg,
            listener: _handleStateMessages,
            buildWhen: (previous, current) =>
                previous.getProfileState != current.getProfileState,
            builder: _buildStateContent,
          ),
        ),
      ),
    );
  }

  void _handleStateMessages(BuildContext context, GetProfileState state) {
    final profileState = state.getProfileState;
    if (!profileState.isLoading && profileState.msg != null) {
      AppToast.error(context, profileState.msg!);
    }
  }

  Widget _buildStateContent(BuildContext context, GetProfileState state) {
    final profileState = state.getProfileState;

    if (profileState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }

    if (profileState.msg != null && profileState.data == null) {
      return _buildRetryButton(context);
    }

    final user = profileState.data;
    if (user == null) {
      return _buildEmptyState();
    }

    return _buildProfileBody(context, user);
  }

  Widget _buildRetryButton(BuildContext context) {
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
          style: TextStyles.bodyRegular14.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        AppStrings.noProfileDataAvailable,
        style: TextStyles.bodyRegular14.copyWith(
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildProfileBody(BuildContext context, ProfileEntity user) {
    return SingleChildScrollView(
      child: Column(
        spacing: 32,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderWidget(
            imageUrl: user.photo,
            userName: '${user.firstName} ${user.lastName}',
            onBackPressed: () => Navigator.pop(context),
          ),
          _buildTilesList(context),
        ],
      ),
    );
  }

  Widget _buildTilesList(BuildContext context) {
    return Material(
      color: AppColors.lightBlack,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ProfileTileItem(
            leadingIcon: Icons.person_outline_rounded,
            title: AppStrings.editProfile,
            onTap: _dummyTap,
          ),
          _buildDivider(),
          ProfileTileItem(
            leadingIcon: Icons.sync_rounded,
            title: AppStrings.changePassword,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutsName.changePasswordScreen,
            ),
          ),
          _buildDivider(),
          _buildLanguageTile(context),
          _buildDivider(),
          ProfileTileItem(
            leadingIcon: Icons.settings_outlined,
            title: AppStrings.security,
            onTap: () => _launchUrl(AppStrings.securityUrl),
          ),
          _buildDivider(),
          ProfileTileItem(
            leadingIcon: Icons.shield_outlined,
            title: AppStrings.privacyPolicy,
            onTap: () => _launchUrl(AppStrings.privacyPolicyUrl),
          ),
          _buildDivider(),
          ProfileTileItem(
            leadingIcon: Icons.help_outline_rounded,
            title: AppStrings.help,
            onTap: () => _launchUrl(AppStrings.helpUrl),
          ),
          _buildDivider(),
          ProfileTileItem(
            leadingIcon: Icons.logout_rounded,
            title: AppStrings.logout,
            textColor: AppColors.orange,
            iconColor: AppColors.orange,
            onTap: () => LogoutDialog.show(context, getIt<LogoutViewModel>()),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: AppColors.placeHolder,
      height: 1,
      thickness: 0.2,
      indent: 52,
    );
  }

  static void _dummyTap() {}

  Widget _buildLanguageTile(BuildContext context) {
    final currentLang = context.locale.languageCode == 'ar'
        ? AppStrings.arabic
        : AppStrings.english;

    return ProfileTileItem(
      leadingIcon: Icons.language_rounded,
      title: AppStrings.language,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentLang,
            style: TextStyles.bodyRegular14.copyWith(
              color: AppColors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.orange,
            size: 22,
          ),
        ],
      ),
      onTap: () => _showLanguageBottomSheet(context),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final currentLocale = context.locale;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.lightBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _LanguageSheetContent(currentLocale: currentLocale),
    );
  }
}

class _LanguageSheetContent extends StatelessWidget {
  final Locale currentLocale;

  const _LanguageSheetContent({required this.currentLocale});

  Future<void> _selectLanguage(BuildContext context, String code) async {
    await context.setLocale(Locale(code));
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.placeHolder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.language,
            style: TextStyles.bodyRegular20.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _LanguageItemTile(
            label: AppStrings.english,
            selected: currentLocale.languageCode == 'en',
            onTap: () => _selectLanguage(context, 'en'),
          ),
          const Divider(
            color: AppColors.placeHolder,
            height: 1,
            thickness: 0.2,
          ),
          _LanguageItemTile(
            label: AppStrings.arabic,
            selected: currentLocale.languageCode == 'ar',
            onTap: () => _selectLanguage(context, 'ar'),
          ),
        ],
      ),
    );
  }
}

class _LanguageItemTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageItemTile({
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
              style: TextStyles.bodyRegular16.copyWith(
                color: selected ? AppColors.orange : AppColors.white,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(
                Icons.check_rounded,
                color: AppColors.orange,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
