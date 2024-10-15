import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_awal_flutter_fundamental/data/api/api_service.dart';
import 'package:submission_awal_flutter_fundamental/provider/search_provider.dart';
import 'package:submission_awal_flutter_fundamental/utils/result_state.dart';
import 'package:submission_awal_flutter_fundamental/widgets/card_restaurant.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchProvider = SearchProvider(apiService: ApiService());
    return ChangeNotifierProvider<SearchProvider>(
      create: (_) => searchProvider,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SearchBar(
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                  elevation: const WidgetStatePropertyAll(1),
                  controller: _searchController,
                  hintText: 'Search restaurant or menu',
                  hintStyle: const WidgetStatePropertyAll(
                    TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  textStyle: const WidgetStatePropertyAll(
                    TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: [
                    IconButton(
                      onPressed: () => searchProvider
                          .searchRestaurant(_searchController.text),
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child:
                      Consumer<SearchProvider>(builder: (context, provider, _) {
                    switch (provider.state) {
                      case ResultState.loading:
                        return const Center(child: CircularProgressIndicator());
                      case ResultState.hasData:
                        return ScrollConfiguration(
                          behavior: const ScrollBehavior()
                              .copyWith(overscroll: false),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return cardRestaurant(
                                  context, provider.results[index]);
                            },
                            itemCount: provider.results.length,
                          ),
                        );
                      case ResultState.noData:
                        return Center(
                            child: Text(
                          provider.message,
                          textAlign: TextAlign.center,
                        ));
                      case ResultState.error:
                        return Center(
                            child: Text(
                          provider.message,
                          textAlign: TextAlign.center,
                        ));
                    }
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
