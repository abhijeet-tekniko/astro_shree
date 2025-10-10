import 'package:astro_shree_user/presentation/aboutUs_screen/aboutUs_screen.dart';
import 'package:astro_shree_user/presentation/blog_screen/blog_detailed_screen.dart';
import 'package:astro_shree_user/presentation/blog_screen/blog_list_screen.dart';
import 'package:astro_shree_user/presentation/daily_horoscope_screen/daily_horoscope.dart';
import 'package:astro_shree_user/presentation/home_screen/home_screen.dart';
import 'package:astro_shree_user/presentation/otp_screen/otp_screen.dart';
import 'package:astro_shree_user/presentation/privacy_screen/privacy_screen.dart';
import 'package:astro_shree_user/presentation/profile_screen/profile_screen.dart';
import 'package:astro_shree_user/presentation/signUp_screen/sign_up_screen.dart';
import 'package:astro_shree_user/presentation/support_screen/support_screen.dart';
import 'package:astro_shree_user/presentation/term_screen/term_screen.dart';
import 'package:astro_shree_user/presentation/transaction_screen/transaction_screen.dart';
import 'package:astro_shree_user/presentation/wallet_screen/wallet_screen.dart';
import 'package:flutter/material.dart';

import '../presentation/chat_session_screen.dart';
import '../presentation/e_pooja/pooja_transaction_list.dart';
import '../presentation/signUp_screen/signUp_form.dart';
import '../splash_screen.dart';


class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String otpScreen = '/otp_screen';
  static const String homeScreen = '/home_screen';
  static const String newSignUpScreen = '/new_signup_screen';
  static const String termScreen = '/term_screen';
  static const String privacyScreen = '/privacy_screen';
  static const String aboutUsScreen = '/aboutUs_screen';
  static const String blogListScreen = '/blogList_screen';
  static const String blogDetailedScreen = '/blog_detail';
  static const String profileScreen = '/profile';
  static const String supportScreen = '/support';
  static const String transactionScreen = '/transaction';
  static const String poojaTransactionScreen = '/poojaTransaction';
  static const String walletScreen = '/wallet';
  static const String chatSession = '/chatSession';
  static const String dailyHoroscopeScreen = '/dailyHoroscope';


  static Map<String, WidgetBuilder> get routes {
    return {
      splashScreen: (context) => const SplashScreen(),
      signUpScreen: (context) => const SignUPScreen(),
      otpScreen: (context) => const OTPScreen(mobileNumber: '',),
      homeScreen: (context) => const HomeScreen(),
      newSignUpScreen: (context) => const NewSignUpScreen(),
      termScreen: (context) => const TermsScreen(),
      privacyScreen: (context) => const PrivacyPolicyScreen(),
      aboutUsScreen: (context) => const AboutUsScreen(),
      blogListScreen: (context) =>  BlogListScreen(),
      profileScreen: (context) => const ProfileScreen(),
      supportScreen: (context) => const SupportScreen(),
      transactionScreen: (context) =>  TransactionScreen(),
      poojaTransactionScreen: (context) =>  PoojaTransactionListScreen(),
      walletScreen: (context) => const WalletScreen(),
      chatSession: (context) =>  ChatSessionsScreen(),
      dailyHoroscopeScreen: (context) => const DailyHoroscopeScreen(),
    };
  }
}