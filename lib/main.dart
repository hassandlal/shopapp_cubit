import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop2_app/modules/login/shop_login_screen.dart';
import 'package:shop2_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop2_app/shared/bloc_observer.dart';
import 'package:shop2_app/shared/cubit/cubit.dart';
import 'package:shop2_app/shared/cubit/states.dart';
import 'package:shop2_app/shared/network/local/cashe_helper.dart';
import 'package:shop2_app/shared/network/remote/dio_helper.dart';
import 'package:shop2_app/shared/styles/themes.dart';
import 'layout/cubit/cubit.dart';
import 'layout/shop_layout.dart';
import 'shared/components/constants.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  if(onBoarding != null)
  {
    if(token != null) widget = ShopLayout();
    else widget = ShopLoginScreen();
  } else
  {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget
{
  // constructor
  // build
  final bool isDark;
  final Widget startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:ThemeMode.light,
           // AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}