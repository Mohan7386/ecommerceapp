import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/controller/banner_controller.dart';
import 'package:ecommerce_app/view/carousel_filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarouselBannerSlider extends StatelessWidget {
  const CarouselBannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerProvider = Provider.of<BannerProvider>(context);
    final List<Map<String, dynamic>> banners = [
      {
        "title": "Flat 30% Off",
        "subtitle": "On all summer collection",
        "color1": Colors.purpleAccent,
        "color2": Colors.pinkAccent,
        "type": "discount",
        "value": 30,
      },
      {
        "title": "Buy 1 Get 1 Free",
        "subtitle": "Limited time offer",
        "color1": Colors.blueAccent,
        "color2": Colors.teal,
        "type": "offer",
      },
      {
        "title": "Mega Sale 50%",
        "subtitle": "Only Today",
        "color1": Colors.orange,
        "color2": Colors.red,
        "type": "discount",
        "value": 50,
      },
      {
        "title": "New Arrivals",
        "subtitle": "Check latest trends",
        "color1": Colors.green,
        "color2": Colors.lightGreen,
        "type": "new",
      },
    ];
    return Column(
      children: [
        // Banner Slider
        SizedBox(
          width: double.infinity,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                bannerProvider.changeIndex(index);
              },
            ),
            items: banners
                .map(
                  (banner) => Builder(
                    builder: (BuildContext context) => Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [banner["color1"], banner["color2"]],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner["title"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                banner["subtitle"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FilteredProductsScreen(
                                        type: banner["type"],
                                        value: banner["value"],
                                        title: banner["title"],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Shop Now",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: bannerProvider.currentIndex == index ? 20 : 10,
              height: 10,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: bannerProvider.currentIndex == index
                    ? Colors.blue
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.blue, // Set the border color here
                  width: 2.0, // Set the border width here
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
