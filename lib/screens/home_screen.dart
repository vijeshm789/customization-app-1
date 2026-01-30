import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/mafatlal_logo.dart';
import '../widgets/gradient_background.dart';
import '../widgets/home_menu_card.dart';
import 'collections_screen.dart';
import 'saved_designs_screen.dart';
import 'support_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': AppStrings.collections,
      'icon': Icons.collections_bookmark_rounded,
      'color': const Color(0xFF0D9488),
      'screen': const CollectionsScreen(),
    },
    {
      'title': AppStrings.saved,
      'icon': Icons.bookmark_rounded,
      'color': const Color(0xFF0891B2),
      'screen': const SavedDesignsScreen(),
    },
    {
      'title': AppStrings.support,
      'icon': Icons.support_agent_rounded,
      'color': const Color(0xFF10B981),
      'screen': const SupportScreen(),
    },
    {
      'title': AppStrings.aboutUs,
      'icon': Icons.info_rounded,
      'color': const Color(0xFF6366F1),
      'screen': const AboutScreen(),
    },
  ];

  // Placeholder banner colors for demo
  final List<Color> _bannerColors = [
    const Color(0xFF0D9488),
    const Color(0xFF0891B2),
    const Color(0xFF10B981),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildMenuGrid(),
                      const SizedBox(height: 24),
                      _buildBannerCarousel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const MafatlalLogoWithText(
            logoSize: 50,
            showTagline: true,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        final item = _menuItems[index];
        return HomeMenuCard(
          title: item['title'],
          icon: item['icon'],
          color: item['color'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item['screen']),
            );
          },
        );
      },
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _bannerColors.length,
          options: CarouselOptions(
            height: 160,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return _buildBannerItem(index);
          },
        ),
        const SizedBox(height: 12),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildBannerItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _bannerColors[index],
            _bannerColors[index].withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _bannerColors[index].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -30,
            child: Icon(
              Icons.auto_awesome,
              size: 150,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getBannerTitle(index),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getBannerSubtitle(index),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBannerTitle(int index) {
    switch (index) {
      case 0:
        return 'New Collection';
      case 1:
        return 'Premium Fabrics';
      case 2:
        return 'School Uniforms';
      default:
        return 'Explore';
    }
  }

  String _getBannerSubtitle(int index) {
    switch (index) {
      case 0:
        return 'Discover our latest fabric designs';
      case 1:
        return 'Quality materials for every occasion';
      case 2:
        return 'Customize your school\'s look';
      default:
        return 'Find your perfect fabric';
    }
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _bannerColors.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentBannerIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentBannerIndex == index
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
