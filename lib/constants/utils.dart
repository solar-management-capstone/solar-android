import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnackBar(
  BuildContext context,
  String text, {
  Color color = Colors.blue,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: color,
    ),
  );
}

String formatCurrency(double value) {
  final vndCurrency = NumberFormat.currency(locale: 'vi_VN', decimalDigits: 3);
  return vndCurrency
      .format(value)
      .replaceAll('VND', 'đ')
      .replaceAll(',000', '');
}

String formatDateTime(String value) {
  DateTime dateTime = DateTime.parse(value);
  return DateFormat('hh:mm dd/MM/yyyy').format(dateTime);
}
