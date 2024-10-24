import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_awal_flutter_fundamental/common/navigation.dart';
import 'package:submission_awal_flutter_fundamental/provider/add_review_provider.dart';
import 'package:submission_awal_flutter_fundamental/utils/constants.dart';
import 'package:submission_awal_flutter_fundamental/utils/helper.dart';
import 'package:submission_awal_flutter_fundamental/utils/result_state.dart';

class AddReviewScreen extends StatefulWidget {
  static const routeName = '/add_review_restaurant';

  final String idRestaurant;

  const AddReviewScreen({super.key, required this.idRestaurant});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  bool _isBtnEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void validateInput() {
    setState(() {
      _isBtnEnabled =
          _nameController.text.isNotEmpty && _reviewController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Navigator.pop(context, false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.navigate_before),
          ),
          title: const Text('Add Review'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.primaryPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.primaryPurple),
                    ),
                  ),
                  onChanged: (value) => validateInput(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    labelText: 'Reviews',
                    hintText: 'Enter your reviews',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.reviews),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.primaryPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.primaryPurple),
                    ),
                  ),
                  onChanged: (value) => validateInput(),
                ),
                const SizedBox(
                  height: 16,
                ),
                Consumer<AddReviewProvider>(
                  builder: (ctx, provider, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: _isBtnEnabled
                          ? () async {
                              await provider.addReview(
                                widget.idRestaurant,
                                _nameController.text,
                                _reviewController.text,
                              );
                              switch (provider.state) {
                                case ResultState.loading:
                                  setState(() {
                                    _isBtnEnabled = false;
                                  });
                                  debugPrint('LOADING..........');
                                  break;
                                case ResultState.hasData:
                                  debugPrint('HAS DATA..........');
                                  if (context.mounted) {
                                    Navigator.pop(context, true);
                                  }
                                  break;
                                case ResultState.noData:
                                  debugPrint('NO DATA..........');
                                  showToast(provider.message);
                                  break;
                                case ResultState.error:
                                  showToast(provider.message);
                                  debugPrint('ERROR..........');
                                  break;
                              }
                            }
                          : null,
                      child: const Text('Send'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
