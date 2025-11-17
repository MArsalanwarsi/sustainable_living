import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sustainable_living/admin/admin.dart';
import 'package:sustainable_living/admin/adminprofile.dart';
import 'package:sustainable_living/admin/ecoproducts.dart';
import 'package:sustainable_living/home/buynow.dart';
import 'package:sustainable_living/home/detailpage.dart';
import 'package:sustainable_living/home/mainchallanges.dart';
import 'package:sustainable_living/home/products.dart';
import 'package:sustainable_living/home/tracker.dart';
import 'package:sustainable_living/home/calculaotor.dart';
import 'package:sustainable_living/home/editpf.dart';
import 'package:sustainable_living/home/home.dart';
import 'package:sustainable_living/home/profile.dart';
import 'package:sustainable_living/home/whishlist.dart';
import 'package:sustainable_living/login.dart';
import 'package:sustainable_living/selection.dart';
import 'package:sustainable_living/signup.dart';
import 'package:sustainable_living/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        '/Selection': (context) => const SelectionScreen(),
        '/Login': (context) => const LoginScreen(),
        '/Signup': (context) => const SignUpScreen(),
        '/AdminDashboard': (context) => const AdminDashboard(),
        '/Home': (context) => const HomePage(),
        '/tracker': (context) => const TrackerHome(),
        '/calculator': (context) => const CarbonCalculatorScreen(),
        '/Profile': (context) => const ProfileScreen(),
        '/EditProfile': (context) => const EditProfileScreen(),
        '/Challenges': (context) => const EcoChallengesPage(),
        '/AdminProducts': (context) => const ManageEcoProductsScreen(),
        '/AdminProfile': (context) => const AdminProfileScreen(),
        '/Products': (context) => const EcoProducts(),
        '/ProductsDetails': (context) => const ProductDetailPage(),
        '/BuyNow': (context) => const BuyScreen(),
        '/Wishlist': (context) => const WishlistScreen(),
      },
    );
  }
}
