import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/reusable_widgets/app_toast.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ProfileTileItem(
            leadingIcon: Icons.person_outline,
            title: AppStrings.editProfile,
            onTap: _dummyTap,
          ),
          ProfileTileItem(
            leadingIcon: Icons.lock_outline,
            title: AppStrings.changePassword,
            onTap: _dummyTap,
          ),
          _buildLanguageTile(context),
          ProfileTileItem(
            leadingIcon: Icons.security,
            title: AppStrings.security,
            onTap: () => _launchUrl(AppStrings.securityUrl),
          ),
          ProfileTileItem(
            leadingIcon: Icons.privacy_tip_outlined,
            title: AppStrings.privacyPolicy,
            onTap: () => _launchUrl(AppStrings.privacyPolicyUrl),
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
            onTap: _dummyTap,
          ),
        ],
      ),
    );
  }

  static void _dummyTap() {}

  Widget _buildLanguageTile(BuildContext context) {
    return ProfileTileItem(
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

class _LanguageSheetContent extends StatefulWidget {
  final Locale currentLocale;

  const _LanguageSheetContent({required this.currentLocale});

  @override
  State<_LanguageSheetContent> createState() => _LanguageSheetContentState();
}

class _LanguageSheetContentState extends State<_LanguageSheetContent> {
  late String _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.currentLocale.languageCode;
  }

  Future<void> _changeLanguage(String code) async {
    if (_selectedCode == code) return;
    setState(() {
      _selectedCode = code;
    });
    await context.setLocale(Locale(code));
    if (mounted) {
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
          _LanguageOptionCard(
            label: AppStrings.english,
            selected: _selectedCode == 'en',
            onTap: () => _changeLanguage('en'),
          ),
          const SizedBox(height: 10),
          _LanguageOptionCard(
            label: AppStrings.arabic,
            selected: _selectedCode == 'ar',
            onTap: () => _changeLanguage('ar'),
          ),
        ],
      ),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.orange.withAlpha(38) : AppColors.black,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.orange : AppColors.lightBlack,
              width: 1.5,
            ),
          ),
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
                  Icons.check_circle_rounded,
                  color: AppColors.orange,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
