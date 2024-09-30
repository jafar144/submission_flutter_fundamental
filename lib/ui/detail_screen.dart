import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:submission_awal_flutter_fundamental/model/restaurant_response.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  const DetailScreen({super.key, required this.restaurant});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Drink> foods = widget.restaurant.menus.foods;
    final List<Drink> drinks = widget.restaurant.menus.drinks;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.restaurant.pictureId,
              fit: BoxFit.cover,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "images/percent.svg",
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "10% OFF",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(0xFF00b30f),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'images/star.svg',
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            widget.restaurant.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    widget.restaurant.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'images/clock.svg',
                            width: 12,
                            height: 12,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Text(
                              "25 mins",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text("•"),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'images/dollar.svg',
                            width: 12,
                            height: 12,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Text(
                              "\$\$\$",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 1,
                      ),
                      SvgPicture.asset(
                        'images/location.svg',
                        height: 12,
                        width: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          widget.restaurant.city,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "About"),
                      Tab(text: "Makanan"),
                      Tab(text: "Minuman"),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        RawScrollbar(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 14.0,
                                    bottom: 24.0,
                                  ),
                                  child: Text(
                                    "About",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(widget.restaurant.description),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / .3),
                            shrinkWrap: true,
                            children: List.generate(foods.length, (index) {
                              return _buildDrinksItem(context, foods[index]);
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / .3),
                            shrinkWrap: true,
                            children: List.generate(drinks.length, (index) {
                              return _buildDrinksItem(context, drinks[index]);
                            }),
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
    );
  }

  Widget _buildDrinksItem(BuildContext context, Drink drink) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFF5d48c8),
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Text(
            drink.name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
