import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/gradient_background.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
              AppStrings.support,
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
            _buildHeader(),
            const SizedBox(height: 32),
            _buildContactOptions(context),
            const SizedBox(height: 32),
            _buildFAQSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.support_agent_rounded,
            size: 64,
            color: AppColors.primaryTeal,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'How can we help you?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We\'re here to assist you with any questions or concerns.',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContactOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          icon: Icons.chat_bubble_rounded,
          title: AppStrings.whatsappSupport,
          subtitle: AppStrings.supportPhone,
          color: const Color(0xFF25D366),
          onTap: () => _launchWhatsApp(context),
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          icon: Icons.email_rounded,
          title: AppStrings.emailSupport,
          subtitle: AppStrings.supportEmail,
          color: const Color(0xFFEA4335),
          onTap: () => _launchEmail(context),
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          icon: Icons.phone_rounded,
          title: 'Call Us',
          subtitle: AppStrings.supportPhone,
          color: AppColors.primaryTeal,
          onTap: () => _launchPhone(context),
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'How do I select fabrics for my design?',
        'answer':
            'Go to Collections, browse categories and folders, then tap on fabrics to select them. You can select up to 10 fabrics.',
      },
      {
        'question': 'Can I add my school/company logo?',
        'answer':
            'Yes! In the Visualizer screen, tap the "Logo" button to upload and position your logo on the uniform.',
      },
      {
        'question': 'How do I export my design?',
        'answer':
            'Tap the share icon in the Visualizer screen. You can save to your device or share via WhatsApp, Email, etc.',
      },
      {
        'question': 'What resolution options are available?',
        'answer':
            'You can export your designs in 2K, 4K, or 8K resolution for high-quality prints.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...faqs.map((faq) => _buildFAQItem(faq)),
      ],
    );
  }

  Widget _buildFAQItem(Map<String, String> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          faq['question']!,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Text(
            faq['answer']!,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Poppins',
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final url = Uri.parse('https://wa.me/919876543210');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showError(context, 'Could not open WhatsApp');
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final url = Uri.parse('mailto:${AppStrings.supportEmail}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showError(context, 'Could not open email app');
    }
  }

  Future<void> _launchPhone(BuildContext context) async {
    final url = Uri.parse('tel:+919876543210');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showError(context, 'Could not open phone app');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
