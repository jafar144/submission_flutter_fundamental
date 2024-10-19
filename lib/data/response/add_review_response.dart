import 'package:submission_awal_flutter_fundamental/data/response/detail_restaurant_response.dart';

class AddReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  AddReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory AddReviewResponse.fromJson(Map<String, dynamic> json) =>
      AddReviewResponse(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );
}
