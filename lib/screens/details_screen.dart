import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/perfume.dart';
import '../models/cart_model.dart';
import '../widgets/app_drawer.dart';
import '../models/language_provider.dart';
import '../l10n/app_localizations.dart';

// The main background gradient colors
const Color kBgTopColor = Color(0xFFE5DDD9);    // A muted, warm grey-taupe
const Color kBgBottomColor = Color(0xFFF2ECE9); // Very light warm grey
const Color kSoftBrown = Color(0xFFB39288);     // Muted, earthy brown-grey
const Color kMutedMauve = Color(0xFFAC928B);    // The brownish-grey icon/text color
const Color kDeepEspresso = Color(0xFF4A1A24);  // The dark burgundy-brown for "Categories"
const Color kSearchFill = Color(0xFFEFE5E2);

class DetailsScreen extends StatefulWidget {
  final Perfume perfume;

  const DetailsScreen({super.key, required this.perfume});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top + 20;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am'; // <-- ADD THIS


    final List<String> currentGallery = widget.perfume.gallery.isNotEmpty
        ? widget.perfume.gallery
        : [widget.perfume.image];

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        onOrderHistory: _showOrderHistory,
        onAbout: _showAboutApp,
        onLogout: _handleLogout,
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double cardHeight = constraints.maxHeight * 0.68;
          String _getPerfumeDescription(String name) {
            // Check the active language code
            final isAmharic = Localizations.localeOf(context).languageCode == 'am';

            switch (name.toLowerCase()) {
              case "j'adore":
                return isAmharic
                    ? "ከጃስሚን፣ ያላንግ-ያላንግ እና የጽጌረዳ መዓዛዎች ጋር የተቀላቀለ ደማቅ የአበባ ስብስብ። የሴትነት ውበት መገለጫ።"
                    : "A radiant floral bouquet with sensual notes of jasmine, ylang-ylang, and rose. A signature of feminine elegance.";

              case "black opium":
                return isAmharic
                    ? "ከቡና፣ ቫኒላ እና ነጭ አበባዎች የተሰራ ደፋር እና ሱስ የሚያስይዝ መዓዛ። ጥልቅ ዘመናዊ እና ጠንካራ።"
                    : "A bold, addictive fragrance with coffee, vanilla, and white flowers. Deeply modern and intense.";

              case "daisy":
                return isAmharic
                    ? "ከዱር ፍራፍሬዎች እና ለስላሳ ነጭ ቫዮሌት ቅጠሎች የተሰራ ቀላል፣ ተጫዋች እና የወጣትነት የአበባ መዓዛ።"
                    : "Light, playful, and youthful floral scent with wild berries and soft white violet petals.";

              case "good girl":
                return isAmharic
                    ? "ለደፋር ንፅፅር ጥቁር ኮኮዋ እና ጣፋጭ ጃስሚን የሚያቀላቅል ባለሁለት ባህሪ መዓዛ።"
                    : "A dual-nature fragrance blending dark cocoa and sweet jasmine for a daring contrast.";

              default:
                return isAmharic
                    ? "ለሚያምር የስሜት ህዋሳት ልምድ ከከፍተኛ ጥራት ጥሬ ዕቃዎች የተሰራ የቅንጦት ሽቶ።"
                    : "A luxurious fragrance crafted with premium ingredients for an elegant sensory experience.";
            }
          }
          return Stack(
            children: [
              /// BASE LAYER (Brown Card & Bottom Contents)
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB39288),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: cardHeight),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      widget.perfume.name.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Text(
                                      // Call the helper method to dynamically pull the custom string setup for this unique perfume
                                      _getPerfumeDescription(widget.perfume.name),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "£${widget.perfume.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// ADD TO CART
                    GestureDetector(
                      onTap: () {
                        context.read<CartModel>().addItem(widget.perfume);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isAmharic ? "${widget.perfume.name} ተጨምሯል" : "${widget.perfume.name} added")),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_basket_outlined,
                                color: Color(0xFF5A1F2D), size: 22),
                            const SizedBox(width: 10),
                            Text(
                              isAmharic ? "ወደ ቅርጫት አስገባ" : "ADD TO BASKET",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5A1F2D),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// TOP IMAGE CARD (Contains the Title Reflection Effect)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: cardHeight,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(55),
                      bottomRight: Radius.circular(55),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 25,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: topPadding + 10),

                      /// REFLECTED BACKGROUND TITLE + FOREGROUND TITLE STACK
                      /// WATERMARK BACKGROUND TITLE + FOREGROUND TITLE STACK
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          /// 1. The Huge Faded background title (Shifted slightly upward)
                          Transform.translate(
                            offset: const Offset(0, -15), // Adjust the -15 to move it higher or lower
                            child: Opacity(
                              opacity: 0.05,
                              child: Text(
                                widget.perfume.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                  fontSize: 58,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5A1F2D),
                                ),
                              ),
                            ),
                          ),

                          /// 2. The Main Foreground Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              widget.perfume.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 26,
                                letterSpacing: 4,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5A1F2D),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// HERO SLIDER
                      Expanded(
                        child: Hero(
                          tag: widget.perfume.image,
                          child: PageView.builder(
                            controller: _pageController,
                            physics: currentGallery.length > 1
                                ? const BouncingScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            itemCount: currentGallery.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: Image.asset(
                                  currentGallery[index],
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      /// DOT INDICATORS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(currentGallery.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentPage == index ? 20 : 6,
                            height: 5,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? const Color(0xFF5A1F2D)
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              /// TOP ACTIONS (Back on Left, Menu on Right)
              Positioned(
                top: topPadding - 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// BACK BUTTON (Now First)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF5A1F2D),
                        size: 26,
                      ),
                    ),

                    /// MENU BUTTON (Now Second)
                    /// LANGUAGE SELECTION PILL (Replaced Hamburger Menu)
                    Consumer<LanguageProvider>(
                      builder: (context, provider, child) {
                        return TextButton.icon(
                          onPressed: () => provider.toggleLanguage(),
                          icon: const Icon(Icons.language, size: 18, color: Color(0xFF5A1F2D)),
                          label: Text(
                            isAmharic ? "EN" : "አማ",
                            style: const TextStyle(
                              color: Color(0xFF5A1F2D),
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
              ),
            ],
          );
        },
      ),
    );
  }
}