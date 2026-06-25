import 'package:bloom_perfume/data/angel_data.dart';
import 'package:bloom_perfume/data/dior_data.dart';
import 'package:bloom_perfume/data/poison_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/jadore_data.dart';
import '../data/perfume_data.dart';
import '../models/cart_model.dart';
import '../models/perfume.dart';
import '../widgets/app_drawer.dart';
import '../widgets/category_chip.dart';
import '../widgets/perfume_card.dart';
import 'cart_screen.dart';
import '../models/language_provider.dart';
import '../l10n/app_localizations.dart';

// The main background gradient colors
// The main background gradient (Muted Taupe to Off-White)
const Color kBgTopColor = Color(0xFFE5DDD9);    // A muted, warm grey-taupe
const Color kBgBottomColor = Color(0xFFF2ECE9); // Very light warm grey
// The brownish/mauve card background from the image
const Color kSoftBrown = Color(0xFFB39288); // Muted, earthy brown-grey
// Neutral / Desaturated tones
const Color kMutedMauve = Color(0xFFAC928B);    // The brownish-grey icon/text color
const Color kDeepEspresso = Color(0xFF4A1A24);  // The dark burgundy-brown for "Categories"
const Color kSearchFill = Color(0xFFEFE5E2);    // The greyish-tan search bar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "ALL";
  final ScrollController _mainScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  String searchText = "";
  final PageController pageController = PageController(viewportFraction: 0.72);
  double currentPage = 0.0;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      pageController.addListener(() {

        if (!mounted) return;

        setState(() {
          currentPage =
          pageController.hasClients
              ? (pageController.page ?? 0.0)
              : 0.0;
        });

      });

    });
  }

  @override
  void dispose() {
    searchController.dispose();
    pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final isAmharic = Localizations.localeOf(context).languageCode == 'am'; // <-- ADD THIS



    List<Perfume> getActivePerfumes() {
      switch (selectedCategory) {
        case "J'ADORE":
          return jadorePerfumes;

        case "MISS Dior":
          return diorPerfumes;

        case "POISON":
          return poisonPerfumes;

        case "ANGEL":
          return angelPerfumes;

        default:
          return perfumes;
      }
    }
    final activePerfumes = getActivePerfumes();

    final filteredPerfumes = activePerfumes.where((perfume) {
      return perfume.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    final featuredPerfumes = filteredPerfumes.take(4).toList();
    final popularPerfumes = filteredPerfumes.skip(4).take(2).toList();
    final luxuryPerfumes = filteredPerfumes
        .where((p) =>
    !featuredPerfumes.contains(p) &&
        !popularPerfumes.contains(p))
        .toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        onOrderHistory: _showOrderHistory,
        onAbout: _showAboutApp,
        onLogout: _handleLogout,
      ),
      // REMOVED bottomNavigationBar from here to allow content to scroll behind it
      body: Stack(
        children: [
          /// 1. BACKGROUND GRADIENTS & SHAPES
          _buildBackgroundShapes(),

          /// 2. SCROLLABLE CONTENT
          CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              /// HEADER & CATEGORIES
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.zero,
                              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                              icon: const Icon(Icons.menu, size: 32, color: kDeepEspresso),
                            ),
                            Consumer<LanguageProvider>(
                              builder: (context, provider, child) {
                                return TextButton.icon(
                                  onPressed: () => provider.toggleLanguage(),
                                  icon: const Icon(Icons.language, size: 18, color: kDeepEspresso),
                                  label: Text(
                                    isAmharic ? "EN" : "አማ",
                                    style: const TextStyle(
                                      color: kDeepEspresso,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFF7ECE9),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Text(
                          // Change "Featured" to:
                          isAmharic ? "ልዩ ምርጫዎች" : "Featured",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.brown.shade300,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          // Change "Categories" to:
                          isAmharic ? "ምድቦች" : "Categories",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: kDeepEspresso,
                          ),
                        ),
                        const SizedBox(height: 35),
                        SizedBox(
                          height: 45,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            children: [
                              _buildCategoryChip(isAmharic ? "ሁሉም" : "ALL"),
                              _buildCategoryChip("J'ADORE"),
                              _buildCategoryChip("MISS Dior"),
                              _buildCategoryChip("POISON"),
                              _buildCategoryChip("ANGEL"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

    if (selectedCategory == "ALL" || selectedCategory == "ሁሉም")  ...[
                SliverToBoxAdapter(child: _sectionHeader(isAmharic ? "ልዩ ስብስቦች" : "Featured Collection")),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: _buildFeaturedPageView(featuredPerfumes),
                  ),
                ),
                SliverToBoxAdapter(child: _sectionHeader(isAmharic ? "ተወዳጅ" : "Popular")),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: _buildHorizontalPerfumeList(popularPerfumes),
                  ),
                ),
                SliverToBoxAdapter(child: _sectionHeader(isAmharic ? "የቅንጦት ስብስቦች" : "Luxury Collection")),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: _buildHorizontalPerfumeList(luxuryPerfumes),
                  ),
                ),
              ] else ...[
                /// CATEGORY LIST VIEW OVERLAY
                SliverToBoxAdapter(
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top: 45),
                        child: SizedBox(
                          height: 390,
                          child: CategoryPerfumeSlider(
                            filteredPerfumes: filteredPerfumes,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// SMALL WHITE LUXURY CARDS
                      const SizedBox(height: 22),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredPerfumes.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: 0.82,
                          ),
                          itemBuilder: (context, index) {
                            final perfume = filteredPerfumes[index];

                            final luxuryColors = [
                              const Color(0xFFF4ECE8),

                            ];

                            return GestureDetector(

                                onTap: () {
                                  _showPerfumeDetails(perfume);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(34),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFFFBF9),
                                        Color(0xFFF3E5DF),
                                        Color(0xFFE3CFC7),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFB39288).withValues(alpha: 0.12),
                                        blurRadius: 25,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),


                                  /// TITLE
                                  Text(
                                    perfume.name.toUpperCase(),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: kDeepEspresso,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      height: 1.05,
                                      letterSpacing: 0.5,
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  /// IMAGE
                                  Expanded(
                                    child: Center(
                                      child: Opacity(
                                        opacity: 0.95,
                                        child: Image.asset(
                                          perfume.image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  /// DESCRIPTION
                                  Text(
                                    isAmharic ? "የቅንጦት መዓዛ" : "Luxury Essence",
                                    textAlign: TextAlign.center,
                                    // style setup...
                                  ),

                                  const SizedBox(height: 6),

                                  /// PRICE
                                  Text(
                                    "\£${perfume.price.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      color: kDeepEspresso,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                                ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              /// IMPORTANT: Extra bottom padding so the list content doesn't get
              /// permanently stuck underneath the floating navigation bar.
              const SliverToBoxAdapter(child: SizedBox(height: 130)),
            ],
          ),

          /// 3. FLOATING BOTTOM FLOATING NAV BAR DOCK
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // Adds a smooth white fade behind the floating island dock to blend with the UI edge
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    kBgBottomColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: _buildBottomNavBar(cart),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Quick clean-up helper for category item creation
  Widget _buildCategoryChip(String title) {
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = title),
      child: CategoryChip(
        title: title,
        selected: selectedCategory == title,
      ),
    );
  }
  Widget _buildCustomDrawer() {
    return Drawer(
      backgroundColor: kBgTopColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 40, color: kDeepEspresso),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Fiker",
                  style: TextStyle(
                    color: kDeepEspresso,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          _drawerItem(Icons.history, "Order History", onTap: _showOrderHistory),
          _drawerItem(Icons.info_outline, "About App", onTap: _showAboutApp),

          const Spacer(),

          _drawerItem(Icons.logout, "Logout", onTap: _handleLogout),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: kMutedMauve),
      title: Text(
        title,
        style: const TextStyle(
          color: kDeepEspresso,
          letterSpacing: 1,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
    );
  }
  void _showPerfumeDetails(Perfume perfume) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFF7ECE9),
            borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                perfume.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A1A24),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                AppLocalizations.of(context)!.perfumeDescription,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF5A1F2D),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "£${perfume.price}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A1A24),
                    ),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(
                        perfume.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5A1F2D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showOrderHistory() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kBgBottomColor,
        title: Text(localizations.orderHistory),
        content: Text(localizations.noOrdersYet),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.close),
          ),
        ],
      ),
    );
  }

  void _showAboutApp() {
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kBgBottomColor,
        title: Text(isAmharic ? "ስለ ብሉም ሽቶ" : "About Bloom Perfume"),
        content: Text(
          isAmharic
              ? "ብሉም ሽቶ የቅንጦት መዓዛዎችን የመገበያያ መተግበሪያ ነው።\n\n"
              "እንደ Dior, J'adore, Poison, እና Angel ካሉ ታዋቂ የሽቶ አምራቾች በጥንቃቄ የተመረጡ ስብስቦችን ይቃኙ።\n\n"
              "ከውበት እና ከቀላልነት ጋር የተሰራ።"
              : "Bloom Perfume is a luxury fragrance shopping experience.\n\n"
              "Explore curated collections from iconic perfume houses like Dior, J'adore, Poison, and Angel.\n\n"
              "Designed with elegance and simplicity in mind.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isAmharic ? "ዝጋ" : "Close"),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kBgBottomColor,
        title: Text(isAmharic ? "ውጣ" : "Logout"),
        content: Text(isAmharic ? "በእርግጠኝነት መውጣት ይፈልጋሉ?" : "Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isAmharic ? "ሰርዝ" : "Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isAmharic ? "በተሳካ ሁኔታ ወጥተዋል" : "Logged out successfully",
                  ),
                ),
              );
            },
            child: Text(isAmharic ? "ውጣ" : "Logout"),
          ),
        ],
      ),
    );
  }
  /// HELPER WIDGETS
  Widget _buildRefinedBackgroundShapes() {
    return Stack(
      children: [
        // Top Right soft glow
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Mid-left organic curve
        Positioned(
          top: 300,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              color: const Color(0xFFE8DAD6).withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildBackgroundShapes() {
    return Stack(
      children: [
        // Base warm taupe layer
        Positioned.fill(
          child: Container(
            color: const Color(0xFFE5DDD9),
          ),
        ),

        // Dramatic white illuminated scoop
        Positioned.fill(
          child: ClipPath(
            clipper: BackgroundCurveClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFFFEFD).withValues(alpha: 0.10),
                    const Color(0xFFFFFCFB).withValues(alpha: 0.22),
                    const Color(0xFFF8F3F0).withValues(alpha: 0.45),
                  ],
                  stops: const [0.0, 0.58, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5A1F2D),
        ),
      ),
    );
  }
  Widget _buildFeaturedPageView(List filteredPerfumes) {
    return SizedBox(
      height: 390,
      child: PageView.builder(
        controller: pageController,
        itemCount: filteredPerfumes.length,
        clipBehavior: Clip.none,
        padEnds: false,
        itemBuilder: (context, index) {
          final perfume = filteredPerfumes[index];
          final difference = (currentPage - index).abs();
          final scale = (1 - (difference * 0.12)).clamp(0.82, 1.0).toDouble();

          return Transform.scale(
            scale: scale,
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(
                top: scale < 0.95 ? 35 : 0,
                bottom: 25,
                right: 15,
              ),
              child: Opacity(
                opacity: scale.clamp(0.7, 1.0),
                child: PerfumeCard(
                perfume: perfume,
                isFocused: difference < 0.5,
              ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildHorizontalPerfumeList(List perfumes) {
    final PageController sectionController = PageController(
      viewportFraction: 0.75, // Adjust this to control how much of the next card shows
    );

    return SizedBox(
        height: 390,

        child: Padding(
          padding: const EdgeInsets.only(right: 25),

          child: PageView.builder(
            controller: sectionController,
            itemCount: perfumes.length,
            clipBehavior: Clip.none,
            padEnds: false,
       // THIS IS THE KEY: It removes the leading/trailing empty space
        itemBuilder: (context, index) {
          final perfume = perfumes[index];

          return AnimatedBuilder(
            animation: sectionController,
            builder: (context, child) {
              double pageValue = 0.0;
              if (sectionController.hasClients) {
                pageValue = sectionController.page ?? 0.0;
              }

              final difference = (pageValue - index).abs();
              final scale = (1 - (difference * 0.12)).clamp(0.82, 1.0);

              return Transform.scale(
                scale: scale,
                // Alignment.centerLeft ensures the first card stays pinned to the left
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.only(
                    top: scale < 0.95 ? 35 : 0,
                    bottom: 25,
                    // Reduce right margin so cards feel closer
                    right: 15,
                  ),
                  child: Opacity(
                    opacity: scale.clamp(0.7, 1.0),
                    child: PerfumeCard(
                      perfume: perfume,
                      isFocused: difference < 0.5,
                    ),
                  ),
                ),
              );
            },
          );
        },
          ),
        ),
    );
  }

  Widget _buildBottomNavBar(CartModel cart) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              // Using a warm brownish-tan tint with a slightly higher opacity for depth
              color: const Color(0xFFB39288).withOpacity(0.35),
              // A wide blur gives it that soft, airbrushed glow effect from the image
              blurRadius: 35,
              // A tiny bit of spread helps push the color out evenly
              spreadRadius: 2,
              // Slight downward offset to keep the glow grounded
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(child: _buildSearchBar()),
            const SizedBox(width: 16),
            _buildCartIcon(cart),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) {
                    // Add it right where you build the profile modal text
                    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
                    return Container(
                      height: 320,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(35),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            const CircleAvatar(
                              radius: 35,
                              backgroundColor: Color(0xFFF2ECE9),
                              child: Icon(
                                Icons.person,
                                size: 35,
                                color: kDeepEspresso,
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              "Fiker Mesfin",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: kDeepEspresso,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              isAmharic ? "የቅንጦት ሽቶ ሰብሳቢ" : "Luxury Fragrance Collector",
                              style: TextStyle(
                                color: Colors.brown.shade300,
                                fontSize: 16,
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.person_outline,
                size: 28,
                color: kSoftBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSearchBar() {
    // Add it right where you build the profile modal text
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7ECE9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFFB39288)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() => searchText = value),
              decoration: InputDecoration(
                hintText: isAmharic ? "ፈልግ..." : "Search...",
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Color(0xFFB39288), fontSize: 17),
              ),
              style: const TextStyle(color: Color(0xFF5A1F2D), fontSize: 17, fontWeight: FontWeight.w800,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartIcon(CartModel cart) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.shopping_basket_outlined, size: 30, color: Color(0xFFB39288)),
          if (cart.items.isNotEmpty)
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Color(0xFF5A1F2D), shape: BoxShape.circle),
                child: Text(
                  cart.items.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

}
class BackgroundCurveClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();

    // Lower start = more spacing below category chips
    double startY = 280;

    path.moveTo(0, startY);

    // Luxury delayed smooth scoop
    path.cubicTo(
      size.width * 0.8, startY - 2,         // almost flat beginning
      size.width * 0.82, size.height * 0.92,
      size.width, size.height * 0.78,       // elegant finish
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
class CategoryPerfumeSlider extends StatefulWidget {
  final List filteredPerfumes;

  const CategoryPerfumeSlider({super.key, required this.filteredPerfumes});

  @override
  State<CategoryPerfumeSlider> createState() => _CategoryPerfumeSliderState();
}

class _CategoryPerfumeSliderState extends State<CategoryPerfumeSlider> {
  late PageController _categoryPageController;
  double _currentCategoryPage = 0.0;

  @override
  void initState() {
    super.initState();
    // Slightly reduced the viewport fraction to 0.73 so the second card peeks
    // in perfectly when the first card has padding on its left side.
    _categoryPageController = PageController(viewportFraction: 0.73);
    _categoryPageController.addListener(() {
      if (!mounted) return;
      setState(() {
        _currentCategoryPage = _categoryPageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _categoryPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _categoryPageController,
      itemCount: widget.filteredPerfumes.length,
      clipBehavior: Clip.none,
      padEnds: false,
      itemBuilder: (context, index) {
        final perfume = widget.filteredPerfumes[index];
        final difference = (_currentCategoryPage - index).abs();
        final bool isFocused = difference < 0.5;
        final scale = (1 - (difference * 0.04)).clamp(0.96, 1.0);

        // Check if it's the very first card in the carousel
        final bool isFirstCard = index == 0;

        return Transform.scale(
          scale: scale,
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            // THE FIX: If it's the first card, add 24px padding on the left to match the screen edge!
            margin: EdgeInsets.only(
              left: isFirstCard ? 24 : 0,
              right: 14, // Spacing between individual cards
            ),
            child: PerfumeCard(
              perfume: perfume,
              isFocused: isFocused,
            ),
          ),
        );
      },
    );
  }
}
