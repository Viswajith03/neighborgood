import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neighborgood/pages/card/card.dart';
import 'package:neighborgood/pages/chat/chat.dart';
import 'package:neighborgood/pages/chat/chatscreen.dart';
import 'package:neighborgood/pages/dashboard/allusers.dart';
import 'package:neighborgood/pages/dashboard/dashboard.dart';
import 'package:neighborgood/pages/login/first_step.dart';
import 'package:neighborgood/pages/login/formai.dart';
import 'package:neighborgood/pages/login/registerscreentwo.dart';
import 'package:neighborgood/pages/login/second_step.dart';

import 'package:neighborgood/pages/misc/aboutus.dart';
import 'package:neighborgood/pages/misc/chatwithai.dart';
import 'package:neighborgood/pages/misc/infopage.dart';
import 'package:neighborgood/pages/profiles/addinfo.dart';
import 'package:neighborgood/pages/profiles/editpersonal.dart';
import 'package:neighborgood/pages/profiles/profile.dart';
import 'package:neighborgood/pages/login/registerscreen.dart';
import 'package:neighborgood/pages/misc/services.dart';
import 'package:neighborgood/pages/misc/splashscreen.dart';
import 'package:neighborgood/pages/home/landingpage.dart';
import 'package:neighborgood/pages/dashboard/altdashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'pages/find/findusers.dart';
import 'pages/friends/friendlist.dart';
import 'pages/friends/friendrequests.dart';
import 'pages/home/homepage.dart';
import 'pages/login/form.dart';
import 'pages/login/loginscreen.dart';
import 'components/navbar/navbar.dart';
import 'pages/profiles/userdetail.dart';
import 'pages/login/verify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return SplashScreen();
          },
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) {
            return AltDashboard();
          },
        ),
        GoRoute(
          path: '/navbar',
          builder: (context, state) {
            return NavBar();
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) {
            return LoginScreen();
          },
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) {
            return const RegisterScreen();
          },
        ),
        GoRoute(
          path: '/landingpage',
          builder: (context, state) {
            return LandingPage();
          },
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return ChatScreenPage(
              recipientId: extra?['recipientId'],
              recipientName: extra?['recipientName'],
              recipientImage: extra?['recipientImage'],
              recipientImageUrl: extra?['recipientImage'],
            );
          },
        ),
        GoRoute(
          path: '/friendrequests',
          builder: (context, state) => FriendRequestsScreen(),
        ),
        GoRoute(
          path: '/friendlist',
          builder: (context, state) => FriendsList(),
        ),
        GoRoute(
          path: '/userdetail',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return UserDetailPage(user: extra?['user']);
          },
        ),
        GoRoute(
          path: '/findusers',
          builder: (context, state) => FindUsersScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const UserProfile(),
        ),
        GoRoute(
          path: '/postcard',
          builder: (context, state) => PostcardPage(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesPage(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutUsPage(),
        ),
      ],
      errorPageBuilder: (context, state) {
        debugPrint('Error: ${state.error}');
        return const MaterialPage(
          child: Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
      },
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
