import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/firebase_options.dart';
import 'package:maccave/src/community.dart';
import 'package:maccave/src/cummunityscreen/cummunityedit.dart';
import 'package:maccave/src/cummunityscreen/cummunityreading.dart';
import 'package:maccave/src/cummunityscreen/cummunitywriting.dart';
import 'package:maccave/src/defaultinsidescreen/inicischeck.dart';
import 'package:maccave/src/feed.dart';
import 'package:maccave/src/feedinsidescreen/drinkitemscreen.dart';
import 'package:maccave/src/feedinsidescreen/entrylistscreen.dart';
import 'package:maccave/src/galleryscreen/galleryreading.dart';
import 'package:maccave/src/galleryscreen/gallerywriting.dart';
import 'package:maccave/src/galleryscreen/gelleryedit.dart';
import 'package:maccave/src/galleryscreen/imgpickerex.dart';
import 'package:maccave/src/gallrey.dart';
import 'package:maccave/src/infoinsidescreen/announcement.dart';
import 'package:maccave/src/infoinsidescreen/askquestions.dart';
import 'package:maccave/src/infoinsidescreen/infopolicy.dart';
import 'package:maccave/src/infoinsidescreen/mycontent.dart';
import 'package:maccave/src/infoinsidescreen/mydrinklist.dart';
import 'package:maccave/src/infoinsidescreen/oneononeinquiry.dart';
import 'package:maccave/src/infoinsidescreen/serviceconditions.dart';
import 'package:maccave/src/infoinsidescreen/useredit.dart';
import 'package:maccave/src/infomation.dart';
import 'package:maccave/src/defaultinsidescreen/register.dart';
import 'package:maccave/src/maccavemain.dart';
import 'package:maccave/src/raffle.dart';
import 'package:maccave/widgets/mainnavigation.dart';

enum ScreenTransitionType { fade, slide, none }

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _defaultRoute = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MacCaveMainScreen();
      },
      redirect: (context, state) async {
        bool redirect = false;
        if (FirebaseAuth.instance.currentUser != null) {
          redirect = true;
        }
        return redirect ? '/feed' : null;
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'privacychack',
          path: 'privacychack',
          pageBuilder: (context, state) {
            return MacCaveCustomTransitionPage(
                mainChild: InicisCheckScreen(
                  social: state.extra! as Function,
                ),
                type: ScreenTransitionType.slide);
          },
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainBottomNavigation(
          key: state.pageKey,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/feed',
          pageBuilder: (context, state) {
            return MacCaveCustomTransitionPage(
              key: state.pageKey,
              mainChild: const FeedScreen(),
              type: ScreenTransitionType.fade,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              name: 'drinkitem',
              path: 'drink/:id/:title',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: DrinkItemScreen(
                    id: state.params['id']!,
                    title: state.params['title']!,
                  ),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              name: 'entrylist',
              path: 'entrylist',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: const EntryListScreen(),
                  type: ScreenTransitionType.slide,
                );
              },
            )
          ],
        ),
        GoRoute(
          path: '/community',
          pageBuilder: (context, state) {
            return MacCaveCustomTransitionPage(
              key: state.pageKey,
              mainChild: const CommunityScreen(),
              type: ScreenTransitionType.fade,
            );
          },
          routes: [
            GoRoute(
              path: 'writing',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: const CummunityWriting(),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              name: 'cummunityread',
              path: 'reding/:id',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: CummunityReading(id: state.params['id']!),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              name: 'cummunityeidt',
              path: 'edit/:id',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: CummunityEdit(id: state.params['id']!),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: 'userinfo',
          path: '/userinfo',
          pageBuilder: (context, state) {
            return MacCaveCustomTransitionPage(
              key: state.pageKey,
              mainChild: const UserInFoScreen(),
              type: ScreenTransitionType.fade,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'announcement',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: const AnnouncementScreen(),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              path: 'askquestions',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: const AskQuestionsScreen(),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              path: 'oneononeinquiry',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: const OneOnOneInquiryScreen(),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              path: 'serviceconditions',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: const ServiceConditionsScreen(),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              path: 'infopolicy',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: const InfoPolicyScreen(),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              name: "useredit",
              path: 'edit/:id',
              pageBuilder: (context, state) {
                print(state);
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: UserEditScreen(id: state.params['id']!),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              name: 'mycontents',
              path: 'mycontents/:id',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  mainChild: MyContentScreen(id: state.params['id']!),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              name: 'mydrinklist',
              path: 'mydrinklist/:id',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  mainChild: MyDrinkList(id: state.params['id']!),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/raffle',
          pageBuilder: (context, state) {
            return MacCaveCustomTransitionPage(
                key: state.pageKey,
                mainChild: const RaffleScreen(),
                type: ScreenTransitionType.fade);
          },
        ),
        GoRoute(
          path: '/gallery',
          pageBuilder: (context, state) {
            return MacCaveCustomTransitionPage(
              key: state.pageKey,
              mainChild: const GalleryScreen(),
              type: ScreenTransitionType.fade,
            );
          },
          routes: [
            GoRoute(
              path: 'writing',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: const GalleryWriting(),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              name: 'galleryreading',
              path: 'reading/:id',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: GalleryReading(id: state.params['id']!),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
            GoRoute(
              name: 'galleryeidt',
              path: 'edit/:id',
              pageBuilder: (context, state) {
                return MacCaveCustomTransitionPage(
                  key: state.pageKey,
                  mainChild: GalleryEdit(id: state.params['id']!),
                  type: ScreenTransitionType.slide,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      routerConfig: _defaultRoute,
      // builder: (context, child) => MacCaveMainScreen(),
    );
  }
}

class MacCaveCustomTransitionPage extends CustomTransitionPage {
  MacCaveCustomTransitionPage(
      {super.key, required this.mainChild, required this.type})
      : super(
            child: mainChild,
            transitionsBuilder: (context, animation, secondaryAnimation,
                    child) =>
                type == ScreenTransitionType.fade
                    ? CustomFadeTransition(animation: animation, child: child)
                    : type == ScreenTransitionType.slide
                        ? CustomSlideTransition(
                            animation: animation, child: child)
                        : CustomNoTransition(
                            animation: animation, child: child));
  final Widget mainChild;
  final ScreenTransitionType type;
}

class CustomSlideTransition extends SlideTransition {
  CustomSlideTransition(
      {super.key, required this.animation, required this.child})
      : super(
            position: animation.drive(
              Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(
                CurveTween(curve: Curves.ease),
              ),
            ),
            child: child);
  final Animation<double> animation;
  final Widget child;
}

class CustomFadeTransition extends FadeTransition {
  const CustomFadeTransition({
    super.key,
    required this.animation,
    required this.child,
  }) : super(
          opacity: animation,
          child: child,
        );
  final Animation<double> animation;
  final Widget child;
}

class CustomNoTransition extends SlideTransition {
  CustomNoTransition({super.key, required this.animation, required this.child})
      : super(
            position: animation.drive(
              Tween<Offset>(begin: const Offset(0.0, 0.0), end: Offset.zero)
                  .chain(
                CurveTween(curve: Curves.ease),
              ),
            ),
            child: child);
  final Animation<double> animation;
  final Widget child;
}
