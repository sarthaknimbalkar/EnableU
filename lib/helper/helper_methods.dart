import 'package:cloud_firestore/cloud_firestore.dart';

/// Formats a [Timestamp] into a string representation of the date.
///
/// The format is 'DD/MM/YYYY', where day and month are zero-padded.
String formatData(Timestamp timestamp) {
  // Convert the Timestamp to DateTime
  DateTime dateTime = timestamp.toDate();

  // Format the date components with zero padding
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  String year = dateTime.year.toString();

  // Construct the formatted date string
  return '$day/$month/$year';
}
