import 'package:intl/intl.dart';

String formatRelativeDate(String isoDate) {
  final date = DateTime.parse(isoDate).toLocal();
  final now = DateTime.now();

  final difference = now.difference(date).inDays;
  if (difference == 0) return "Hoy";
  if (difference == 1) return "Ayer";
  return "${difference} días atrás";
}
