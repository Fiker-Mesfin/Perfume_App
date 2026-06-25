import 'package:flutter/material.dart';

import '../models/perfume.dart';
import '../screens/details_screen.dart';

const Color kCardBrown = Color(0xFFC9AAA1);

class PerfumeCard extends StatelessWidget {
  final Perfume perfume;
  final bool isFocused;

  const PerfumeCard({
    super.key,
    required this.perfume,
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(
              perfume: perfume,
            ),
          ),
        );
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),

        width: 255,
        margin: const EdgeInsets.only(right: 20),

        decoration: BoxDecoration(
          gradient: isFocused
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFC9AAA1),
              Color(0xFFB08A80),
            ],
          )
              : null,

          color: isFocused ? null : Colors.white,


          borderRadius: BorderRadius.circular(26),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              /// TITLE
              Text(
                perfume.name.toUpperCase(),
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,

                  color: isFocused
                      ? Colors.white
                      : const Color(0xFF5A1F2D),
                ),
              ),

              const SizedBox(height: 8),

              /// IMAGE
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    if (isFocused)
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.28),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                    Hero(
                      tag: perfume.image,
                      child: Image.asset(
                        perfume.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // ========================================================
              // THE GAP FIX: Dynamic spacing based on focus state
              // Gives 28px of breathing room when focused, 12px when not.
              // ========================================================
              SizedBox(height: isFocused ? 28 : 12),

              /// SUBTITLE
              Text(
                perfume.subtitle.toUpperCase(),

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w500,

                  color: isFocused
                      ? Colors.white70
                      : Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 10),

              /// PRICE
              Text(
                "£${perfume.price.toStringAsFixed(0)}.00",

                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,

                  color: isFocused
                      ? Colors.white
                      : const Color(0xFF5A1F2D),
                ),
              ),

              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}