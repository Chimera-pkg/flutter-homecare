import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/get_medical_records.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_appointment_repository.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_add_on_services.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_appointment_form/nursing_appointment_form_bloc.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_services/nursing_services_bloc.dart';
import 'package:m2health/cubit/personal/personal_cubit.dart';
import 'package:m2health/cubit/nursing/personal/nursing_personal_cubit.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomics_cubit.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';
import 'package:m2health/cubit/pharmacogenomics/data/repositories/pharmacogenomics_repository_impl.dart';
import 'package:m2health/cubit/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource_impl.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/usecases/get_pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/usecases/crud_pharmacogenomics.dart';
import 'package:m2health/cubit/precision/precision_cubit.dart';
import 'package:m2health/cubit/profiles/domain/usecases/index.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/certificate_cubit.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:m2health/route/app_router.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/cubit/appointment/appointment_cubit.dart';
import 'package:m2health/cubit/appointment/provider_appointment_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:navbar_router/navbar_router.dart';

import 'const.dart';
import './AppLanguage.dart';
import './app_localzations.dart';
import 'package:provider/provider.dart';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

// nursing module
import 'package:m2health/cubit/nursingclean/domain/usecases/create_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_services.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_professionals.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/toggle_favorite.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/professional/professional_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(
    MultiBlocProvider(
      providers: [
        Provider<Dio>(
          create: (context) => sl<Dio>(),
        ),
        BlocProvider<PrecisionCubit>(
          create: (context) => PrecisionCubit(),
        ),
        BlocProvider(create: (context) => AppointmentCubit(sl<Dio>())),
        BlocProvider(create: (context) => ProviderAppointmentCubit(sl<Dio>())),
        BlocProvider(
            create: (context) => PersonalCubit()..loadPersonalDetails()),
        BlocProvider(
            create: (context) => NursingPersonalCubit()..loadPersonalDetails()),
        BlocProvider(
            create: (context) => ProfileCubit(
                  getProfileUseCase: sl<GetProfile>(),
                  updateProfileUseCase: sl<UpdateProfile>(),
                )),
        BlocProvider(
          create: (context) => CertificateCubit(
            createCertificateUseCase: sl<CreateCertificate>(),
            updateCertificateUseCase: sl<UpdateCertificate>(),
            deleteCertificateUseCase: sl<DeleteCertificate>(),
          ),
        ),
        // Pharmacogenomics Module Dependencies
        Provider<PharmacogenomicsRepository>(
          create: (context) => PharmacogenomicsRepositoryImpl(
            remoteDataSource: PharmacogenomicsRemoteDataSourceImpl(
              dio: sl<Dio>(),
            ),
          ),
        ),
        Provider<GetPharmacogenomics>(
          create: (context) => GetPharmacogenomics(
            context.read<PharmacogenomicsRepository>(),
          ),
        ),
        Provider<CreatePharmacogenomic>(
          create: (context) => CreatePharmacogenomic(
            context.read<PharmacogenomicsRepository>(),
          ),
        ),
        Provider<UpdatePharmacogenomic>(
          create: (context) => UpdatePharmacogenomic(
            context.read<PharmacogenomicsRepository>(),
          ),
        ),
        Provider<DeletePharmacogenomic>(
          create: (context) => DeletePharmacogenomic(
            context.read<PharmacogenomicsRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => PharmacogenomicsCubit(
            getPharmacogenomics: context.read<GetPharmacogenomics>(),
            createPharmacogenomic: context.read<CreatePharmacogenomic>(),
            updatePharmacogenomic: context.read<UpdatePharmacogenomic>(),
            deletePharmacogenomic: context.read<DeletePharmacogenomic>(),
          ),
        ),
        // Nursing Module Dependencies
        BlocProvider(
          create: (context) => NursingServicesBloc(
            getNursingServices: sl<GetNursingServices>(),
          ),
        ),
        BlocProvider(
          create: (context) => NursingCaseBloc(
            getNursingCase: sl<GetNursingCase>(),
            createNursingCase: sl<CreateNursingCase>(),
            getNursingAddOnServices: sl<GetNursingAddOnServices>(),
          ),
        ),
        BlocProvider(
          create: (context) => ProfessionalBloc(
            getProfessionals: sl<GetProfessionals>(),
            toggleFavorite: sl<ToggleFavorite>(),
          ),
        ),
        BlocProvider(
          create: (context) => NursingAppointmentFormBloc(
            appointmentRepository: sl<NursingAppointmentRepository>(),
            createNursingCase: sl<CreateNursingCase>(),
          ),
        ),
        // Medical Record Module
        BlocProvider(
            create: (context) =>
                MedicalRecordBloc(getMedicalRecords: sl<GetMedicalRecords>()))
      ],
      child: ChangeNotifierProvider(
        create: (context) => AppLanguage(),
        child: DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => MyApp(appLanguage: appLanguage),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;
  MyApp({super.key, required this.appLanguage});
  final List<Color> colors = [Colors.white];

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeLanguage(newLocale);
  }

  static void toggleBottomAppBar(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.toggleBottomAppBar();
  }

  static void showBottomAppBar(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.showBottomAppBar();
  }

  static void hideBottomAppBar(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.hideBottomAppBar();
  }
}

class _MyAppState extends State<MyApp> {
  late AppLocalizations localizations;
  Locale _locale = const Locale('zh');
  bool _showBottomAppBar = false;

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void toggleBottomAppBar() {
    setState(() {
      _showBottomAppBar = !_showBottomAppBar;
    });
  }

  void showBottomAppBar() {
    setState(() {
      _showBottomAppBar = true;
    });
  }

  void hideBottomAppBar() {
    setState(() {
      _showBottomAppBar = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _locale = WidgetsBinding.instance.window.locale;
    localizations = AppLocalizations(_locale);
    localizations.load();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppointmentCubit(sl<Dio>())),
        BlocProvider(
            create: (context) => PersonalCubit()..loadPersonalDetails()),
      ],
      child: AnimatedBuilder(
        animation: appSetting,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'm2health',
            theme: ThemeData(
              fontFamily: 'Poppins', // Set Poppins as the default font
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              cardTheme: const CardThemeData(
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
              ),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Const.tosca,
                selectionColor: Const.tosca.withValues(alpha: 0.4),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Const.tosca,
                    width: 1.5,
                  ),
                ),
              ),
              textTheme: const TextTheme(
                displayLarge: TextStyle(fontFamily: 'Poppins'),
                displayMedium: TextStyle(fontFamily: 'Poppins'),
                displaySmall: TextStyle(fontFamily: 'Poppins'),
                headlineLarge: TextStyle(fontFamily: 'Poppins'),
                headlineMedium: TextStyle(fontFamily: 'Poppins'),
                headlineSmall: TextStyle(fontFamily: 'Poppins'),
                titleLarge: TextStyle(fontFamily: 'Poppins'),
                titleMedium: TextStyle(fontFamily: 'Poppins'),
                titleSmall: TextStyle(fontFamily: 'Poppins'),
                bodyLarge: TextStyle(fontFamily: 'Poppins'),
                bodyMedium: TextStyle(fontFamily: 'Poppins'),
                bodySmall: TextStyle(fontFamily: 'Poppins'),
                labelLarge: TextStyle(fontFamily: 'Poppins'),
                labelMedium: TextStyle(fontFamily: 'Poppins'),
                labelSmall: TextStyle(fontFamily: 'Poppins'),
              ),
              scaffoldBackgroundColor: Colors.white,
              colorScheme:
                  ColorScheme.fromSeed(seedColor: Const.colorDashboard),
              useMaterial3: true,
            ),
            locale: DevicePreview.locale(context),
            builder: (context, child) {
              return Scaffold(
                body: Stack(
                  children: [
                    DevicePreview.appBuilder(context, child),
                  ],
                ),
                bottomNavigationBar: _showBottomAppBar ? BottomAppBar() : null,
              );
            },
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('id', 'ID'), // Indo
              Locale('zh', ''), // Chinese
            ],
            routerConfig: router,
          );
        },
      ),
    );
  }
}

AppSetting appSetting = AppSetting();
final List<Color> themeColorSeed = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.pink,
  Colors.indigo,
  Colors.brown,
  Colors.cyan,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.lime,
  Colors.amber,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.yellow,
  Colors.grey,
];

class AppSetting extends ChangeNotifier {
  bool isDarkMode;
  Color themeSeed = Colors.blue;

  AppSetting({this.isDarkMode = false});

  void changeThemeSeed(Color color) {
    themeSeed = color;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: navigationShell,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFloatingNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => navigationShell.goBranch(0),
            icon: const Icon(Icons.home_outlined),
            iconSize: 28,
            color: currentIndex == 0
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
          IconButton(
            onPressed: () => navigationShell.goBranch(1),
            icon: const Icon(Icons.calendar_month_outlined),
            iconSize: 28,
            color: currentIndex == 1
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
          IconButton(
            onPressed: () => navigationShell.goBranch(2),
            icon: const Icon(Icons.add_shopping_cart_outlined),
            iconSize: 28,
            color: currentIndex == 2
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
          IconButton(
            onPressed: () => navigationShell.goBranch(3),
            icon: const Icon(Icons.favorite_border_outlined),
            iconSize: 28,
            color: currentIndex == 3
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
          IconButton(
            onPressed: () => navigationShell.goBranch(4),
            icon: const Icon(Icons.person_outline),
            iconSize: 28,
            color: currentIndex == 4
                ? const Color(0xFF40E0D0)
                : const Color(0xFF8A96BC),
          ),
        ],
      ),
    );
  }
}
