class EndPoints {

  // static String base = "http://167.71.232.245:8968/";
  // static String imageBaseUrl = "http://167.71.232.245:8968/";
  static String base = "http://167.71.232.245:4856/";
  static String imageBaseUrl = "http://167.71.232.245:4856/";
  static String path = "/api/user";

  ///Authentication
  static String signUp = "$path/signUp";
  static String verifyOTP = "$path/verifyOtp";
  static String profile = "$path/profile";

  /// HomePageEndopints
  static String blog = "$path/blog";
  static String news = "$path/news";
  static String privacyPolicy = "$path/privacyPolicy?type=user";
  static String aboutUs = "$path/aboutUs?type=user";
  static String termCondition = "$path/termCondition?type=user";
  static String testimonial = "$path/testimonial";
  static String astrologers = "$path/asterologer";
  static String liveAsterologer = "$path/liveAsterologer";
  static String mySession = "$path/mySession";
  static String activeSession = "$path/activeSession";
  static String chatSession = "$path/chatSession";
  static String notRespond = "$path/notRespond";
  static String sessionMessage = "$path/sessionMessage";
  static String rechargePlan = "$path/rechargePlan";
  static String wallet = "$path/wallet";
  static String speciality = "$path/speciality";
  static String transaction = "$path/transaction";
  static String banner = "$path/banner?platform=app";
  static String universalSearch = "$path/universalSearch?search=";


  ///productList
  static String category = "$path/category";
  static String product = "$path/product";
  static String shipping = "$path/shipping";
  static String giftCard = "$path/giftCard";
  static String sentGiftCard = "$path/sentGiftCard";
  static String productTransaction = "$path/productTransaction";

  ///horoscope

  static String dailyHoroscope = "$path/dailyHoroscope";
  static String tomorrowHoroscope = "$path/tomorrowHoroscope";
  static String monthlyHoroscope = "$path/monthlyHoroscope";


  ///pooja
  static String pooja = "$path/pooja";
  static String poojaAstrologer = "$path/poojaAstrologer";
  static String poojaTransaction = "$path/poojaTransaction";



  ///kundali
  static String kundli = "$path/kundli";
  /// Panchang
  static String panchang = "$path/panchang";
  static String kundliMatching = "$path/matchKundli";
  ///member
  static String requestMember = "$path/requestMember";
  static String kundliMember = "$path/kundliMember";

  static String notifyAstrologer = "$path/notifyAstrologer";
  static String rating = "$path/rating";
  static String astrologerRating = "$path/astrologerRating";

  ///pincode
  static String pincode = "$path/pincode?pincode=";
}