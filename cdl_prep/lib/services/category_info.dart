import 'package:cdl_prep/colour_scheme.dart';

Map<String, dynamic> getCategoryInfo(String name) {
  switch (name) {
    case 'Air Brakes':
      return {
        'img': 'assets/images/air-brakes 1.png',
        'color': kCategoryGreen,
      };
    case 'Combinations':
      return {
        'img': 'assets/images/Combinations 1.png',
        'color': kCategoryYellow,
      };
    case 'Doubles/Triples':
      return {
        'img': 'assets/images/Doubles-Triples 1.png',
        'color': kCategoryRed,
      };
    case 'General Commercial':
      return {
        'img': 'assets/images/general-commercial 1.png',
        'color': kCategoryBlue,
      };
    case 'Hazmat':
      return {
        'img': 'assets/images/Hazmat 1.png',
        'color': kCategoryYellow,
      };
    case 'Passenger':
      return {
        'img': 'assets/images/passenger 1.png',
        'color': kCategoryGreen,
      };
    case 'School Bus':
      return {
        'img': 'assets/images/school-bus 1.png',
        'color': kCategoryBlue,
      };
    case 'Tanks':
      return {
        'img': 'assets/images/tank 1.png',
        'color': kCategoryRed,
      };
    default:
      return {
        'img': 'assets/images/logo.png',
        'color': kCategoryGreen,
      };
  }
}
