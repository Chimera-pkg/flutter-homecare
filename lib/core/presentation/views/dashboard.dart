import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_state.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../const.dart';
import '../../../AppLanguage.dart';
import '../../../app_localzations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? userName;
  int currentPage = 1;
  int limitItem = 3;
  String keyword = "";
  late ScrollController _scrollController;
  bool _isScrolledToEnd = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    context.read<ProfileCubit>().loadProfile();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _isScrolledToEnd = true;
          });
        } else {
          setState(() {
            _isScrolledToEnd = false;
          });
        }
      });
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'User';
    });
    debugPrint('Username loaded: $userName');
  }

  final List<Map<String, String>> services = [
    {'image': 'assets/icons/ilu_physio.webp', 'name': 'Physiotherapy'},
    {
      'image': 'assets/icons/ilu_remote_monitoring.png',
      'name': 'Remote Patient Monitoring'
    },
    {
      'image': 'assets/icons/ilu_ocuTherapy.webp',
      'name': 'Occupational\nTherapy'
    },
    {'image': 'assets/icons/ilu_health.png', 'name': 'Health Risk\nAssessment'},
    {'image': 'assets/icons/ilu_dietitian.webp', 'name': 'Dietitian Services'},
    {'image': 'assets/icons/ilu_sleep.png', 'name': 'Sleep & Mental\nHealth'},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguage>(
      builder: (context, appLanguage, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 180,
            elevation: 2,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8EF4E8),
                    Color(0xFF35C5CF)
                  ], // Gradasi warna dari kiri ke kanan
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(
                      30), // Membuat border radius di bagian bawah
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Warna shadow
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // Posisi shadow
                  ),
                ],
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  Widget avatarWidget;
                  String displayName = userName ?? 'User';
                  String? avatarUrl;

                  if (state is PatientProfileLoaded) {
                    displayName = state.profile.name.isNotEmpty
                        ? state.profile.name
                        : userName ?? 'User';
                    avatarUrl = state.profile.avatar;
                  } else if (state is ProfessionalProfileLoaded) {
                    displayName = state.profile.name != null &&
                            state.profile.name!.isNotEmpty
                        ? state.profile.name!
                        : userName ?? 'User';
                    avatarUrl = state.profile.avatar;
                  } else {
                    displayName = userName ?? 'User';
                    avatarUrl = null;
                  }

                  if (avatarUrl != null && avatarUrl.isNotEmpty) {
                    avatarWidget = Image.network(
                      avatarUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 56,
                          height: 56,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // Default avatar
                    avatarWidget = Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            Const.banner,
                            fit: BoxFit.contain,
                            height: 36,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              context.go(AppRoutes.profile);
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: avatarWidget,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            if (state is ProfileLoading) ...[
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Loading...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ] else
                              Expanded(
                                child: Text(
                                  "Live Longer & Live Healthier, $displayName!",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/ic_doctor.png',
                              width: 24,
                              height: 24,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText:
                                      "Chat With AI doctor for all your health questions",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF8A96BC), fontSize: 11),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
            color: Colors.white,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, right: 24, left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('services'),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Color(0xFF232F55),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RectangularIconWithTitle(
                              onTap: () {
                                context.push(AppRoutes.pharmaServices);
                              },
                              iconPath: 'assets/icons/ic_pharma_service.png',
                              title: AppLocalizations.of(context)!
                                  .translate('pharmacist_services2'),
                              backgroundColor:
                                  const Color.fromRGBO(142, 244, 220, 0.4),
                              titleColor: Colors.black,
                            ),
                            RectangularIconWithTitle(
                              onTap: () {
                                context.push(AppRoutes.nursingServices);
                              },
                              iconPath: 'assets/icons/ic_nurse.png',
                              title: AppLocalizations.of(context)!
                                  .translate('home_nursing'),
                              backgroundColor:
                                  const Color.fromRGBO(154, 225, 255, 0.35),
                              titleColor: Colors.black,
                            ),
                            RectangularIconWithTitle(
                              onTap: () {
                                context.push(AppRoutes.diabeticCare);
                              },
                              iconPath: 'assets/icons/ic_diabetic.png',
                              title: AppLocalizations.of(context)!
                                  .translate('diabetic_care'),
                              backgroundColor:
                                  const Color.fromRGBO(142, 244, 220, 0.4),
                              titleColor: Colors.black,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RectangularIconWithTitle(
                              onTap: () {
                                context.push(AppRoutes.homeHealthScreening);
                              },
                              iconPath:
                                  'assets/icons/ic_home_health_screening.png',
                              title: AppLocalizations.of(context)!
                                  .translate('home_screening'),
                              backgroundColor:
                                  const Color.fromRGBO(178, 140, 255, 0.2),
                              titleColor: Colors.black,
                            ),
                            RectangularIconWithTitle(
                              onTap: () {
                                context.push(AppRoutes.precisionNutrition);
                              },
                              iconPath:
                                  'assets/icons/ic_precision_nutrition.webp',
                              title: AppLocalizations.of(context)!
                                  .translate('precision_nutrition'),
                              backgroundColor:
                                  const Color.fromRGBO(154, 225, 255, 0.33),
                              titleColor: Colors.black,
                            ),
                            RectangularIconWithTitle(
                              onTap: () {
                                context.push(AppRoutes.secondOpinionMedical);
                              },
                              iconPath: 'assets/icons/ic_2nd_opinion.png',
                              title: AppLocalizations.of(context)!
                                  .translate('2nd_opinion'),
                              backgroundColor:
                                  const Color.fromRGBO(178, 140, 255, 0.2),
                              titleColor: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  // Card(
                  //   color: Colors.white,
                  //   margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: ListTile(
                  //     title: const Text('Health Profile',
                  //         style: TextStyle(
                  //             fontSize: 18, color: Color(0xFF35C5CF))),
                  //     subtitle: Text(userName ?? 'User'),
                  //     trailing: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         TextButton(
                  //           onPressed: () {
                  //             context.go(AppRoutes.profile);
                  //           },
                  //           child: const Text('View all',
                  //               style: TextStyle(
                  //                   fontSize: 14, color: Colors.black)),
                  //         ),
                  //         IconButton(
                  //           icon: const Icon(Icons.more_vert),
                  //           onPressed: () {
                  //             // Handle more options action
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  const Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Color.fromRGBO(244, 244, 244, 1),
                          thickness: 8,
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, right: 24, left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .translate('allied_services'),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Color(0xFF232F55),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        const SizedBox(height: 28),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 0,
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  if (services[index]['name'] ==
                                      'Remote Patient Monitoring') {
                                    context.push(
                                        AppRoutes.remotePatientMonitoring);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          title: const Text('Coming Soon'),
                                          content: const Text(
                                              'This feature will be available soon!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              247, 248, 248, 1),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          services[index]['image']!,
                                          height: 72,
                                          width: 111,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      services[index]['name']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircularIconWithTitle extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color backgroundColor;
  // final Color iconColor;
  final Color titleColor;
  final VoidCallback onTap;

  const CircularIconWithTitle({
    super.key,
    required this.iconPath,
    required this.title,
    required this.backgroundColor,
    // required this.iconColor,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40, // Adjust the radius as needed
            backgroundColor: backgroundColor,
            child: Image.asset(
              iconPath,
              width: 50, // Adjust the size as needed
              height: 50, // Adjust the size as needed
              // color: iconColor.withOpacity(1.0), // Use withOpacity to control opacity
            ),
          ),
          const SizedBox(
              height: 8), // Add some space between the avatar and the title
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class RectangularIconWithTitle extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final VoidCallback onTap;

  const RectangularIconWithTitle({
    super.key,
    required this.iconPath,
    required this.title,
    required this.backgroundColor,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: const Color.fromRGBO(247, 248, 248, 1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 50,
                height: 50,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: titleColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                // height: 13.25 / 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchInputBox extends StatefulWidget {
  const SearchInputBox({super.key});

  @override
  _SearchInputBoxState createState() => _SearchInputBoxState();
}

class _SearchInputBoxState extends State<SearchInputBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          30.0, 20.0, 30.0, 10.0), // Set margin around the entire TextField
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft:
              Radius.circular(50.0), // Adjust these values for the oval shape
          topRight:
              Radius.circular(50.0), // Adjust these values for the oval shape
          bottomLeft:
              Radius.circular(50.0), // Adjust these values for the oval shape
          bottomRight:
              Radius.circular(50.0), // Adjust these values for the oval shape
        ),
        child: TextField(
          controller: _controller, // Assign the controller to the TextField

          decoration: InputDecoration(
            filled: true, // Enable filling the TextField with a color
            fillColor: Colors.grey[100], // Set the background color to grey
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Handle search action here
                print('Search submitted: ${_controller.text}');
              },
            ),
            hintText: 'Search...',
            border: InputBorder.none, // Remove border
            focusedBorder: InputBorder.none, // Remove border when focused
            enabledBorder: InputBorder.none, // Remove border when enabled
            errorBorder:
                InputBorder.none, // Remove border when there's an error
            disabledBorder: InputBorder.none, // Remove border when disabled
          ),
        ),
      ),
    );
  }
}
