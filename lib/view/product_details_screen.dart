import 'package:ecommerce_app/controller/favorite_provider.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/widgets/product_details_list_slider.dart';
import 'package:ecommerce_app/view/widgets/sizeSelector.dart';
import 'package:ecommerce_app/view/widgets/detailimage_slider.dart';
import 'package:ecommerce_app/view/widgets/product.dart';
import 'package:ecommerce_app/view/widgets/rating_widget.dart';
import 'package:ecommerce_app/view/widgets/star_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentImageIndex = 0;
  final PageController _controller = PageController();
  int selectedColor =0;

  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);
    final favProvider = FavoriteProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              favProvider.toggleFavorite(widget.product);
            },
            icon: Icon(
              favProvider.isExist(widget.product)
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: Colors.red,
            ),
          ),
        ],
        // back button
        title: Text(
          'Product Details',
          style: AppTextStyle.withColor(Colors.black87, AppTextStyle.h3),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // detail image Slider
                    MyDetailImageSlider(
                      controller: _controller,
                      images: widget.product.images,
                      onChange: (index) {
                        setState(() {
                          currentImageIndex = index;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:widget.product.images.length,
                        itemBuilder: (context, index) {
                          return  ProductDetailsListSlider(
                            image: widget.product.images[index],
                            onTap: () {
                              setState(() {
                                currentImageIndex = index;
                              });_controller.jumpToPage(index);
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.product.images.length, (index) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: currentImageIndex == index ? 20 : 10,
                            height: 10,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: currentImageIndex == index
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
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.product.title, style: AppTextStyle.h3),
                          SizedBox(height: 10),
                          Text(
                            widget.product.category,
                            style: AppTextStyle.bodyMedium,
                          ),
                          SizedBox(height: 10),
                         StarWidget(product:widget.product ),
                         // RatingWidget(rating: 4.5, reviewCount: 128),
                          Row(
                            children: [
                              Text(
                                '\$${widget.product.price.toStringAsFixed(2)}',
                                style: AppTextStyle.h3,
                              ),
                              SizedBox(width: 10),
                              if (widget.product.oldPrice != null)
                                Text(
                                  '\$${widget.product.oldPrice!.toStringAsFixed(2)}',
                                  style:
                                      AppTextStyle.withColor(
                                        Colors.grey,
                                        AppTextStyle.bodySmall,
                                      ).copyWith(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text('Select Size', style: AppTextStyle.h3),
                          SizedBox(height: 10),
                          const SizeSelector(),
                          SizedBox(height: 10),
                          _selectedColor(context),
                          Text('Description', style: AppTextStyle.h3),
                          SizedBox(height: 10),
                          Text(
                            widget.product.description,
                            style: AppTextStyle.bodyMedium,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ButtonSection
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    //  side: BorderSide(color: Colors.blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context.read<CartProvider>().addToCart(widget.product);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Added to Cart")));
                  },
                  child: Text(
                    'Add to Cart',
                    style: AppTextStyle.withColor(
                      Colors.black,
                      AppTextStyle.buttonMedium,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    // side: BorderSide(color: Colors.blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Buy Now',
                    style: AppTextStyle.withColor(
                      Colors.black,
                      AppTextStyle.buttonMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedColor(BuildContext context) {
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Color",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(
              children: List.generate(colors.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors[index],
                      border: selectedColor == index
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                    ),
                    child: CircleAvatar(
                      backgroundColor: colors[index],
                      radius: 10,
                    ),
                  ),
                );
              }),
            ),
          ]
      ),
    );
  }
}