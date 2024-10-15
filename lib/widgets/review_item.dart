import 'package:flutter/material.dart';
import 'package:submission_awal_flutter_fundamental/data/response/detail_restaurant_response.dart';

Widget reviewItem(CustomerReview review) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Text(review.name[0]),
                ),
                const SizedBox(width: 12),
                Text(
                  review.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              review.date,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(review.review),
      ],
    ),
  );
}
