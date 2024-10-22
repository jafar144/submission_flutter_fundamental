import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import 'package:submission_awal_flutter_fundamental/common/navigation.dart';
import 'package:submission_awal_flutter_fundamental/data/response/detail_restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/data/response/restaurant_response.dart';
import 'package:submission_awal_flutter_fundamental/provider/database_provider.dart';
import 'package:submission_awal_flutter_fundamental/provider/detail_restaurant_provider.dart';
import 'package:submission_awal_flutter_fundamental/ui/add_review_screen.dart';
import 'package:submission_awal_flutter_fundamental/utils/constants.dart';
import 'package:submission_awal_flutter_fundamental/utils/helper.dart';
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
  Object? resultFromAddReviewScreen;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void onResume() {
    debugPrint(resultFromAddReviewScreen.toString());
    if (resultFromAddReviewScreen == false) return;
    final currentContext = context;
    if (currentContext.mounted) {
      Provider.of<DetailRestaurantProvider>(currentContext, listen: false)
          .getDetailRestaurant(widget.idRestaurant);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: onResume,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<DetailRestaurantProvider>(
          builder: (context, provider, _) {
            if (provider.state == ResultState.loading &&
                provider.result == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.state == ResultState.noData ||
                provider.state == ResultState.error) {
              return Center(
                  child: Text(provider.message, textAlign: TextAlign.center));
            } else if (provider.state == ResultState.hasData) {
              return _buildDetailRestaurantScreen(
                  provider.result?.detailRestaurant as DetailRestaurant);
            } else {
              return Stack(
                children: [
                  _buildDetailRestaurantScreen(
                      provider.result?.detailRestaurant as DetailRestaurant),
                  Container(
                      color: const Color.fromARGB(25, 158, 158, 158),
                      child: const Center(child: CircularProgressIndicator())),
                ],
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                Navigation.back();
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ),
                          Consumer<DatabaseProvider>(
                            builder: (context, provider, child) {
                              return FutureBuilder(
                                future:
                                    provider.isFavorite(widget.idRestaurant),
                                builder: (context, snapshot) {
                                  var isFavorite = snapshot.data ?? false;
                                  return isFavorite
                                      ? CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: IconButton(
                                            onPressed: () {
                                              provider.deleteFavorite(
                                                widget.idRestaurant,
                                              );
                                            },
                                            icon: const Icon(Icons.favorite),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: IconButton(
                                            onPressed: () {
                                              provider.addFavorite(
                                                Restaurant.fromDetailRestaurant(
                                                  restaurant,
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.favorite_border),
                                          ),
                                        );
                                },
                              );
                            },
                          ),
                        ],
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
                        Tab(text: "Menu"),
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
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Foods',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: foods.length,
                                        itemBuilder: (context, index) {
                                          return _buildMenusItem(
                                              context, foods[index]);
                                        }),
                                  ),
                                ),
                                const Text(
                                  'Drinks',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: foods.length,
                                        itemBuilder: (context, index) {
                                          return _buildMenusItem(
                                              context, drinks[index]);
                                        }),
                                  ),
                                ),
                              ],
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
                                      onPressed: () async {
                                        resultFromAddReviewScreen =
                                            //     await Navigator.pushNamed(
                                            //   context,
                                            //   AddReviewScreen.routeName,
                                            //   arguments: restaurant.id,
                                            // );
                                            await Navigation.intentWithData(
                                          AddReviewScreen.routeName,
                                          restaurant.id,
                                        );
                                        if (!context.mounted) return;
                                        if (resultFromAddReviewScreen == true) {
                                          showToast(
                                              'Berhasil menambahkan review');
                                        }
                                      },
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
                                      final reversedReviews = restaurant
                                          .customerReviews.reversed
                                          .toList();
                                      return reviewItem(
                                        reversedReviews[index],
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

  Widget _buildMenusItem(BuildContext context, Category drink) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
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
      ),
    );
  }
}
