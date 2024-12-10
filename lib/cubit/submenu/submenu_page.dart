import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_homecare/app_localzations.dart';
import 'package:flutter_homecare/const.dart';
import 'package:flutter_homecare/route/app_routes.dart';
import 'package:flutter_homecare/utils.dart';
import 'submenu_cubit.dart';
import 'package:flutter_homecare/views/service_request.dart' as listServiceRequest;

import 'package:shared_preferences/shared_preferences.dart';

class SubmenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmenuCubit()..loadProfileData(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            BlocBuilder<SubmenuCubit, SubmenuState>(
              builder: (context, state) {
                if (state is SubmenuLoaded) {
                  return GestureDetector(
                    onTap: () async {
                      final role = await Utils.getSpString(Const.ROLE);
                      print('cekRole: $role');
                      if (role != 'admin') {
                        context.push(AppRoutes.profile);
                      } else {
                        Utils.showSnackBar(context,
                            'Admin account only can change in the admin panel.');
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  state.profile?.user.username ??
                                      state.username,
                                  style: TextStyle(fontSize: 16)),
                              Text(state.profile?.name ?? 'Company not set',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600])),
                            ],
                          ),
                          SizedBox(width: 10),
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(state.profile?.logo?.url ?? ''),
                            radius: 30,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Exit'),
                      content: Text('Are you sure you want to exit?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () => context.pop(),
                        ),
                        TextButton(
                          child: Text('Exit'),
                          onPressed: () async {
                            await Utils.clearSp();
                            context.go(AppRoutes.home);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<SubmenuCubit, SubmenuState>(
          builder: (context, state) {
            if (state is SubmenuLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SubmenuLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: CardsLayout(
                      partnership_management: AppLocalizations.of(context)!
                          .translate('partnership_management'),
                      policy: AppLocalizations.of(context)!
                          .translate('privacy_policy'),
                      service_request: AppLocalizations.of(context)!
                          .translate('service_request'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 200.0),
                      child: FloatingActionButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('company_id');
                          log('Cleared company_id');

                          final userId = await Utils.getSpString(Const.USER_ID);
                          if (userId != null) {
                            context.push(AppRoutes.service_request, extra: 0);
                          } else {
                            Fluttertoast.showToast(msg: 'Please login first');
                            context.go(AppRoutes.signIn);
                          }
                        },
                        child: Icon(Icons.post_add),
                      ),
                    ),
                  ),
                ],
              );
              // return CardsLayout(
              //   partnership_management: AppLocalizations.of(context)!
              //       .translate('partnership_management'),
              //   // report: AppLocalizations.of(context)!
              //   //     .translate('market_study_report'),
              //   // event: AppLocalizations.of(context)!
              //   //     .translate('product_launch_event'),
              //   // design: AppLocalizations.of(context)!
              //   //     .translate('product_brochure_design'),
              //   policy:
              //       AppLocalizations.of(context)!.translate('privacy_policy'),
              // );
            } else if (state is SubmenuError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class CardsLayout extends StatelessWidget {
  final partnership_management, policy, service_request;
  // final String report, event, design, policy;

  CardsLayout(
      {required this.partnership_management,
      //   required this.report,
      // required this.event,
      // required this.design,
      required this.service_request,
      required this.policy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        children: <Widget>[
          InkWell(
            onTap: () => context.push(AppRoutes.partnership_list),
            child: _buildCard(Const.submenu_event, partnership_management),
          ),
          // _buildCard(Const.submenu_report, report),
          // _buildCard(Const.submenu_event, event),
          // _buildCard(Const.submenu_design, design),
          InkWell(
            onTap: () => Utils.launchURL(context, Const.URL_PRIVACY),
            child: _buildCard(Const.submenu_privacy, policy),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => listServiceRequest.ServiceRequest(),
                ),
              );
            },
            child: _buildCard(Const.submenu_report, service_request),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String imagePath, String text) {
    return Card(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.black12, width: 1),
      ),
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(imagePath, fit: BoxFit.contain, height: 30),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(text,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
