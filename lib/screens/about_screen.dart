import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/gradient_background.dart';
import '../widgets/mafatlal_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: _buildContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Text(
              AppStrings.aboutUs,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildCompanyHeader(),
            const SizedBox(height: 32),
            _buildAboutSection(),
            const SizedBox(height: 24),
            _buildMissionSection(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildSocialLinks(context),
            const SizedBox(height: 32),
            _buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Column(
      children: [
        const MafatlalLogo(size: 80),
        const SizedBox(height: 16),
        const Text(
          AppStrings.companyName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Established 1905',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryTeal.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.primaryTeal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                AppStrings.aboutMafatlal,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.companyDescription,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryTeal.withOpacity(0.1),
            AppColors.primaryBlue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.flag_outlined,
                  color: AppColors.primaryTeal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                AppStrings.ourMission,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.missionStatement,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final stats = [
      {'value': '100+', 'label': 'Years'},
      {'value': '50+', 'label': 'Products'},
      {'value': '1000+', 'label': 'Schools'},
      {'value': '500+', 'label': 'Corporates'},
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  stat['value']!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: AppColors.primaryTeal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['label']!,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Connect With Us',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Icons.language,
              label: 'Website',
              color: AppColors.primaryTeal,
              onTap: () => _launchUrl(context, 'https://www.mafatlal.com'),
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              icon: Icons.facebook,
              label: 'Facebook',
              color: const Color(0xFF1877F2),
              onTap: () => _launchUrl(context, 'https://facebook.com/mafatlal'),
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              icon: Icons.camera_alt,
              label: 'Instagram',
              color: const Color(0xFFE4405F),
              onTap: () =>
                  _launchUrl(context, 'https://instagram.com/mafatlal'),
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              icon: Icons.business,
              label: 'LinkedIn',
              color: const Color(0xFF0A66C2),
              onTap: () => _launchUrl(
                  context, 'https://linkedin.com/company/mafatlal'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Poppins',
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Mafatlal Visualizer',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Version 1.0.0',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins',
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\u00a9 2024 Mafatlal Industries Ltd. All rights reserved.',
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'Poppins',
            color: Colors.grey.shade400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open link'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
