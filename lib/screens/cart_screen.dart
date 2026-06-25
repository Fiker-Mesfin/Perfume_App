import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {



    final cart = context.watch<CartModel>();
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';
    return Scaffold(


      backgroundColor: const Color(0xFFF7ECE9),

      appBar: AppBar(
        title: Text(isAmharic ? "የእኔ ቅርጫት" : "My Basket"),
        backgroundColor: Colors.transparent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// ITEMS
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,

                itemBuilder: (context, index) {


                  final item = cart.items[index];

                  return Container(

                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(25),
                    ),

                    child: Row(
                      children: [

                        /// IMAGE
                        SizedBox(
                          width: 80,
                          height: 80,

                          child: Image.asset(
                            item.image,
                          ),
                        ),

                        const SizedBox(width: 20),

                        /// INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(
                                item.name,

                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "£${item.price}",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// DELETE
                        IconButton(
                          onPressed: () {
                            cart.removeItem(item);
                          },

                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// TOTAL
            Container(

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: const Color(0xFFD0AFA7),
                borderRadius:
                BorderRadius.circular(30),
              ),

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,


                children: [

                  Text(
                    isAmharic ? "ጠቅላላ" : "Total",


                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    "£${cart.totalPrice.toStringAsFixed(0)}",

                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}