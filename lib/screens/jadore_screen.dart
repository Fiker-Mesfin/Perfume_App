import 'package:flutter/material.dart';

import '../data/perfume_data.dart';
import '../widgets/perfume_card.dart';

const Color kBg = Color(0xFFF7F1EE);
const Color kDeep = Color(0xFF4A1A24);

class JadoreScreen extends StatelessWidget {
  const JadoreScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final jadorePerfumes = perfumes.where((p) {
      return p.name.toLowerCase().contains("jadore") ||
          p.name.toLowerCase().contains("j'adore");
    }).toList();

    return Scaffold(
      backgroundColor: kBg,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [

            /// TOP SPACING
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),

            /// HORIZONTAL FEATURED CARDS
            SliverToBoxAdapter(
              child: SizedBox(
                height: 390,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20),

                  itemCount: jadorePerfumes.length,

                  itemBuilder: (context, index) {

                    return SizedBox(
                      width: 250,

                      child: PerfumeCard(
                        perfume: jadorePerfumes[index],
                        isFocused: true,
                      ),
                    );
                  },
                ),
              ),
            ),

            /// SPACE
            const SliverToBoxAdapter(
              child: SizedBox(height: 25),
            ),

            /// TWO CARDS PER ROW
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              sliver: SliverGrid(

                delegate: SliverChildBuilderDelegate(

                      (context, index) {

                    final perfume = perfumes[index];

                    return PerfumeCard(
                      perfume: perfume,
                      isFocused: false,
                    );
                  },

                  childCount: perfumes.length,
                ),

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,

                  mainAxisSpacing: 20,
                  crossAxisSpacing: 18,

                  childAspectRatio: 0.62,
                ),
              ),
            ),

            /// BOTTOM SPACE
            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }
}