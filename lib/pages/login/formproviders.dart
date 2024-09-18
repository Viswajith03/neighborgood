class FormModel {
  bool walking = false;
  String walkingSpeed = '';
  bool running = false;
  String runningType = '';
  bool dog = false;
  String dogWalks = '';
  bool gardening = false;
  bool swimming = false;
  String swimmingPlace = '';
  bool coffeeTea = false;
  String coffeeTeaPlace = '';
  bool art = false;
  String artType = '';
  bool foodGathering = false;
  String foodGatheringType = '';
  bool sports = false;
  String sportsType = '';
  bool movies = false;
  String movieType = '';
  bool shopping = false;
  String shoppingType = '';
  bool happyHours = false;
  String happyHoursType = '';
  bool rides = false;
  String ridesType = '';
  bool childcare = false;
  String childcareType = '';
  bool eldercare = false;
  String eldercareType = '';
  bool petcare = false;
  String petcareType = '';
  bool repairAdvice = false;
  String repairAdviceType = '';
  bool tutoring = false;
  String tutoringType = '';

  Map<String, dynamic> toJson() {
    return {
      'walking': walking,
      'walkingSpeed': walkingSpeed,
      'running': running,
      'runningType': runningType,
      'dog': dog,
      'dogWalks': dogWalks,
      'gardening': gardening,
      'swimming': swimming,
      'swimmingPlace': swimmingPlace,
      'coffeeTea': coffeeTea,
      'coffeeTeaPlace': coffeeTeaPlace,
      'art': art,
      'artType': artType,
      'foodGathering': foodGathering,
      'foodGatheringType': foodGatheringType,
      'sports': sports,
      'sportsType': sportsType,
      'movies': movies,
      'movieType': movieType,
      'shopping': shopping,
      'shoppingType': shoppingType,
      'happyHours': happyHours,
      'happyHoursType': happyHoursType,
      'rides': rides,
      'ridesType': ridesType,
      'childcare': childcare,
      'childcareType': childcareType,
      'eldercare': eldercare,
      'eldercareType': eldercareType,
      'petcare': petcare,
      'petcareType': petcareType,
      'repairAdvice': repairAdvice,
      'repairAdviceType': repairAdviceType,
      'tutoring': tutoring,
      'tutoringType': tutoringType,
    };
  }

  FormModel();
}
