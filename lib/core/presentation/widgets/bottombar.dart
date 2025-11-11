import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:m2health/features/profiles/presentation/profile_page.dart';
import 'package:m2health/features/appointment/pages/appointment_page.dart';
import 'package:m2health/core/presentation/views/dashboard.dart';
import 'package:m2health/core/presentation/views/favourites.dart';
import 'package:m2health/core/presentation/views/medical_store.dart';

class CustomBottomAppBar extends StatefulWidget {
  static final GlobalKey<_CustomBottomAppBarState> globalKey =
      GlobalKey<_CustomBottomAppBarState>();

  CustomBottomAppBar({Key? key}) : super(key: globalKey);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _resumedFromBackground = false;
  bool _showBottomBar = true;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 5, vsync: this, initialIndex: 1);
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      // Hide BottomBar on the third tab (index 2)
      _showBottomBar = tabController.index != 2;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumedFromBackground = true;
      print("onResume");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_resumedFromBackground) {
          _resumedFromBackground = false;
          return false; // Prevent default back button behavior
        } else {
          return true; // Allow default back button behavior
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: .0), // Adjust the bottom padding as needed
        child: Stack(
          children: [
            BottomBar(
              fit: StackFit.expand,
              icon: (width, height) => Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.grey, // Replace with your unselected color
                    size: width,
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(
                  20), // Adjust the border radius as needed
              duration: const Duration(seconds: 1),
              curve: Curves.decelerate,
              showIcon: true,
              width: MediaQuery.of(context).size.width * 0.8,
              barColor: Colors.white, // Replace with your bar color
              start: 2,
              end: 0,
              offset: 10,
              barAlignment: Alignment.bottomCenter,
              iconHeight: 35,
              iconWidth: 35,
              reverse: false,
              barDecoration: BoxDecoration(
                color: Colors.blue, // Replace with your current page color
                borderRadius: BorderRadius.circular(
                    20), // Adjust the border radius as needed
              ),
              iconDecoration: BoxDecoration(
                color: Colors.blue, // Replace with your current page color
                borderRadius: BorderRadius.circular(
                    20), // Adjust the border radius as needed
              ),
              hideOnScroll: true,
              scrollOpposite: false,
              onBottomBarHidden: () {},
              onBottomBarShown: () {},
              body: (context, controller) => TabBarView(
                controller: tabController,
                dragStartBehavior: DragStartBehavior.down,
                physics: const BouncingScrollPhysics(),
                children: [
                  Dashboard(),
                  AppointmentPage(),
                  MedicalStorePage(),
                  FavouritesPage(),
                  ProfilePage(), // Add your pages here
                ],
              ),
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.home_outlined)),
                  Tab(icon: Icon(Icons.calendar_month_outlined)),
                  Tab(icon: Icon(Icons.add_shopping_cart_outlined)),
                  Tab(icon: Icon(Icons.favorite_border_outlined)),
                  Tab(icon: Icon(Icons.person_outline)),
                ],
                indicatorColor: const Color(0xFF40E0D0), // Warna tosca
              ),
            ),
            if (!_showBottomBar)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 0, // Hide BottomBar by setting height to 0
                ),
              ),
          ],
        ),
      ),
    );
  }
}
