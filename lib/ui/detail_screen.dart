import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:submission_awal_flutter_fundamental/data/api/api_service.dart';
import 'package:submission_awal_flutter_fundamental/data/response/detail_restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/provider/detail_restaurant_provider.dart';
import 'package:submission_awal_flutter_fundamental/ui/add_review_screen.dart';
import 'package:submission_awal_flutter_fundamental/utils/constants.dart';
import 'package:submission_awal_flutter_fundamental/utils/result_state.dart';
import 'package:submission_awal_flutter_fundamental/widgets/review_item.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String idRestaurant;

  const DetailScreen({super.key, required this.idRestaurant});

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
    return ChangeNotifierProvider<DetailRestaurantProvider>(
      create: (_) => DetailRestaurantProvider(
        widget.idRestaurant,
        apiService: ApiService(),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<DetailRestaurantProvider>(
          builder: (context, provider, _) {
            switch (provider.state) {
              case ResultState.loading:
                return const Center(child: CircularProgressIndicator());
              case ResultState.hasData:
                return _buildDetailRestaurantScreen(
                    provider.result.detailRestaurant);
              case ResultState.noData:
                return const Center(child: Text('No Data'));
              case ResultState.error:
                return Center(
                  child: Text(
                    provider.message,
                    textAlign: TextAlign.center,
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailRestaurantScreen(DetailRestaurant restaurant) {
    final foods = restaurant.menus.foods;
    final drinks = restaurant.menus.drinks;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Image.network(
                    Constants.imgUrlMedium + restaurant.pictureId,
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                  ),
                ],
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
                              restaurant.rating.toString(),
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
                      height: 18,
                    ),
                    Text(
                      restaurant.name,
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
                            '${restaurant.city}, ${restaurant.address}',
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
                      height: 20,
                    ),
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: "About"),
                        Tab(text: "Makanan"),
                        Tab(text: "Review"),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 36.0),
                            child: RawScrollbar(
                              child: ScrollConfiguration(
                                behavior: const ScrollBehavior()
                                    .copyWith(overscroll: false),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text(restaurant.description),
                                    ],
                                  ),
                                ),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Reviews",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        AddReviewScreen.routeName,
                                        arguments: restaurant.id,
                                      ),
                                      child: const Text(
                                        "Add reviews",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xff5d48c8),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ScrollConfiguration(
                                  behavior: const ScrollBehavior()
                                      .copyWith(overscroll: false),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        restaurant.customerReviews.length,
                                    itemBuilder: (context, index) {
                                      return reviewItem(
                                        restaurant.customerReviews[index],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildDrinksItem(BuildContext context, Category drink) {
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
