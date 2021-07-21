import 'package:intl/intl.dart';

String poundsFormat(dynamic weight) {
  NumberFormat poundsFormat;
  if (weight is int) {
    poundsFormat = NumberFormat('#,##0 lbs');
  } else if (weight is double) {
    poundsFormat = NumberFormat('#,##0.00 lbs');
  } else {
    throw Exception('Unexpected weight type');
  }
  return poundsFormat.format(weight);
}

String gallonsFormat(dynamic volume) {
  NumberFormat gallonsFormat;
  if (volume is int) {
    gallonsFormat = NumberFormat('#,##0 gal');
  } else if (volume is double) {
    gallonsFormat = NumberFormat('#,##0.00 gal');
  } else {
    throw Exception('Unexpected volume type');
  }
  return gallonsFormat.format(volume);
}
