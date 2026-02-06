import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportPage extends StatefulWidget {
  const HelpAndSupportPage({super.key});

  @override
  State<HelpAndSupportPage> createState() => _HelpAndSupportPageState();
}

class _HelpAndSupportPageState extends State<HelpAndSupportPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Getting Started',
    'Workouts',
    'Account',
    'Technical',
  ];

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I start my first workout?',
      'answer':
          'Navigate to the Home screen, tap on any workout card, and follow the guided exercises. You can adjust difficulty and duration in settings.',
      'category': 'Getting Started',
      'icon': FontAwesomeIcons.dumbbell,
    },
    {
      'question': 'How does the streak system work?',
      'answer':
          'Complete at least one workout per day to maintain your streak. Your streak counter updates automatically when you finish a workout session.',
      'category': 'Getting Started',
      'icon': FontAwesomeIcons.fire,
    },
    {
      'question': 'Can I create custom workouts?',
      'answer':
          'Yes! Go to the Workout Builder in the menu, select exercises from our library, set your reps and sets, and save your custom routine.',
      'category': 'Workouts',
      'icon': FontAwesomeIcons.circlePlus,
    },
    {
      'question': 'How do I track my progress?',
      'answer':
          'Visit the Progress tab to see detailed statistics, body measurements, workout history, and visual charts of your fitness journey.',
      'category': 'Workouts',
      'icon': FontAwesomeIcons.chartLine,
    },
    
    {
      'question': 'Can I sync across multiple devices?',
      'answer':
          'Yes, all your data is saved to the cloud. Simply log in with the same account on any device to access your workouts and progress.',
      'category': 'Account',
      'icon': FontAwesomeIcons.cloudArrowUp,
    },
    {
      'question': 'The app is running slowly, what should I do?',
      'answer':
          'Try clearing the app cache in settings, ensure you have the latest version installed, and restart your device. Contact support if issues persist.',
      'category': 'Technical',
      'icon': FontAwesomeIcons.gauge,
    },
    {
      'question': 'How do I enable notifications?',
      'answer':
          'Go to device settings and enable no battery restrictions for Fitness Dude.',
      'category': 'Technical',
      'icon': FontAwesomeIcons.bell,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredFaqs {
    return _faqs.where((faq) {
      final matchesCategory =
          _selectedCategory == 'All' || faq['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          faq['question'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq['answer'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: Stack(
        children: [
        
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 3),
              decoration: BoxDecoration(
                color:  const Color.fromARGB(255, 27, 27, 27),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.all(25.w),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Header Section
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              'Help & Support',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontFamily: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                ).fontFamily,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'We\'re here to help you succeed',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontFamily: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w500,
                                ).fontFamily,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            _buildWelcomeCard(),
                            SizedBox(height: 24.h),
                            _buildSearchBar(),
                            SizedBox(height: 20.h),
                            _buildCategoryFilter(),
                            SizedBox(height: 24.h),
                            Text(
                              'Frequently Asked Questions',
                              style: GoogleFonts.oswald(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 3,
                              width: 50.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.purpleAccent,
                                    Colors.deepPurple,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),

                      // FAQ List
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final faq = _filteredFaqs[index];
                            return _buildFAQCard(faq, index);
                          },
                          childCount: _filteredFaqs.length,
                        ),
                      ),

                      // Contact Section
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Text(
                              'Still Need Help?',
                              style: GoogleFonts.oswald(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 3,
                              width: 50.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFE53935),
                                    Color(0xFFB11226),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            _buildContactOptions(),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purpleAccent.withOpacity(0.2),
                Colors.deepPurple.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.purpleAccent.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purpleAccent.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.handshakeAngle,
                  color: Colors.purpleAccent,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How can we help?',
                      style: GoogleFonts.oswald(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Search below or browse our FAQs',
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 8, 13, 30),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.purpleAccent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Search for answers...',
              hintStyle: GoogleFonts.manrope(
                color: Colors.white38,
                fontSize: 15.sp,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.purpleAccent,
                size: 24.sp,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white54,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 42.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Colors.deepPurple,
                                Colors.purpleAccent,
                              ],
                            )
                          : null,
                      color: isSelected
                          ? null
                          : const Color.fromARGB(255, 10, 18, 46),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? Colors.purpleAccent.withOpacity(0.5)
                            : Colors.purpleAccent.withOpacity(0.15),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQCard(Map<String, dynamic> faq, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 8, 13, 30),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.purpleAccent.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purpleAccent.withOpacity(0.2),
                          Colors.deepPurple.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.purpleAccent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: FaIcon(
                      faq['icon'],
                      color: Colors.purpleAccent,
                      size: 18.sp,
                    ),
                  ),
                  title: Text(
                    faq['question'],
                    style: GoogleFonts.manrope(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  iconColor: Colors.purpleAccent,
                  collapsedIconColor: Colors.white54,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1,
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Text(
                            faq['answer'],
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              color: Colors.white70,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purpleAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.purpleAccent.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  size: 14.sp,
                                  color: Colors.purpleAccent,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  faq['category'],
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.sp,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactOptions() {
    final contactMethods = [
      {
        'title': 'Email Support',
        'subtitle': 'urfitnessdude@gmail.com',
        'icon': FontAwesomeIcons.envelope,
        'color': Colors.purpleAccent,
      },
      {
        'title': 'Join our Discord',
        'subtitle': 'discord.gg/fitnessdude',
        'icon': FontAwesomeIcons.discord,
        'color': Colors.cyanAccent,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.1,
      ),
      itemCount: contactMethods.length,
      itemBuilder: (context, index) {
        final method = contactMethods[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                try {
                  if (method['title'] == 'Email Support') {
                    final Uri emailUrl = Uri.parse('mailto:urfitnessdude@gmail.com');
                    if (await canLaunchUrl(emailUrl)) {
                      await launchUrl(emailUrl);
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No email app found'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else if (method['title'] == 'Join our Discord') {
                    final Uri discordUrl = Uri.parse('https://discord.gg/8YrtqP3a3V');
                    if (await canLaunchUrl(discordUrl)) {
                      await launchUrl(discordUrl, mode: LaunchMode.externalApplication);
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Cannot open Discord link'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              borderRadius: BorderRadius.circular(20.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (method['color'] as Color).withOpacity(0.15),
                          (method['color'] as Color).withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: (method['color'] as Color).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: (method['color'] as Color).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: FaIcon(
                            method['icon'] as IconData,
                            color: method['color'] as Color,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          method['title'] as String,
                          style: GoogleFonts.oswald(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          method['subtitle'] as String,
                          style: GoogleFonts.manrope(
                            fontSize: 9.sp,
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showContactDialog(Map<String, dynamic> method) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 10, 18, 46).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: (method['color'] as Color).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (method['color'] as Color).withOpacity(0.2),
                            (method['color'] as Color).withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        method['icon'] as IconData,
                        color: method['color'] as Color,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      method['title'] as String,
                      style: GoogleFonts.oswald(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      method['subtitle'] as String,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Coming Soon!',
                      style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        color: Colors.white60,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: method['color'] as Color,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: GoogleFonts.manrope(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
