import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_homecare/route/app_routes.dart';
// import 'package:flutter_homecare/views/details/detail_products.dart';
// import 'package:flutter_homecare/views/poct.dart';
// import 'package:flutter_homecare/views/tenders.dart';

import '../const.dart';
// import '../utils.dart';
import '../main.dart';
// import '../views/browse_products.dart';
// import '../views/drugs.dart';
// import '../views/analysis.dart' as listAnalysis;
// import '../views/affair.dart' as listAffair;
// import '../views/news.dart' as listNews;
// import '../views/marketing_services.dart' as listMarketingServices;
// import '../views/service_request.dart' as listServiceRequest;

import '../AppLanguage.dart';
import '../app_localzations.dart';
import 'package:provider/provider.dart';
// import '../api.dart';
// import '../models/analysis_response.dart' as analysis;
// import '../models/affair_response.dart' as affair;
// import '../models/marketing_services_response.dart' as marketing_services;
// import '../models/service_request_response.dart' as service_request;

class Dashboard extends StatefulWidget {
  Dashboard({
    Key? key,
  }) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // final api = Api();
  // late analysis.AnalysisResponse analysisResponse;
  // late affair.AffairResponse affairResponse;
  // late marketing_services.MarketingServicesResponse marketingServicesResponse;
  // late service_request.ServiceRequestResponse serviceRequestResponse;
  // List<analysis.Data> datum = [];
  // List<affair.Data> datumAffair = [];
  // List<marketing_services.Data> datumMarketingServices = [];
  // List<service_request.Data> datumServiceRequest = [];
  int currentPage = 1;
  int limitItem = 3;
  String keyword = "";
  // bool hasMore = true;
  // bool isLoading = false;
  // bool isInitialLoad = true;
  late ScrollController _scrollController;
  bool _isScrolledToEnd = false;

  @override
  void initState() {
    super.initState();
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
    // getServiceRequest();
    // getMarketingServices();
    // getAnalysis();
    // getAffairs();
  }

  // Future<void> getServiceRequest({int page = 1}) async {
  //   final response = await api.fetchData(
  //       context, 'service-requests?page=$page&limit=$limitItem');
  //   print('Raw API Response Service Request: $response');
  //   try {
  //     if (response != null) {
  //       serviceRequestResponse =
  //           service_request.ServiceRequestResponse.fromJson(response);
  //       setState(() {
  //         if (page == 1) {
  //           datumServiceRequest = serviceRequestResponse.data ?? [];
  //         } else {
  //           datumServiceRequest.addAll(serviceRequestResponse.data ?? []);
  //         }
  //         currentPage = page;
  //         print('datumServiceRequest: $datumServiceRequest');
  //       });
  //     } else {
  //       Utils.showSnackBar(context, 'Failed to load data request service');
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar(context, e.toString());
  //   }
  // }

  // Future<void> getMarketingServices({int page = 1}) async {
  //   try {
  //     final response = await api.fetchData(
  //         context, 'marketing-services?page=$page&limit=$limitItem');
  //     print('Raw API Response Marketing: $response');

  //     if (response != null) {
  //       marketingServicesResponse =
  //           marketing_services.MarketingServicesResponse.fromJson(response);
  //       setState(() {
  //         if (page == 1) {
  //           datumMarketingServices = marketingServicesResponse.data ?? [];
  //         } else {
  //           datumMarketingServices.addAll(marketingServicesResponse.data ?? []);
  //         }
  //         currentPage = page;
  //       });
  //     } else {
  //       Utils.showSnackBar(context, 'Failed to load data');
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar(context, e.toString());
  //   }
  // }

  // Future<void> getAnalysis({int page = 1}) async {
  //   try {
  //     final response = await api.fetchData(
  //         context, 'cases-analysis?page=$page&limit=$limitItem');
  //     if (response != null) {
  //       analysisResponse = analysis.AnalysisResponse.fromJson(response);
  //       setState(() {
  //         if (page == 1) {
  //           datum = analysisResponse.data ?? [];
  //         } else {
  //           datum.addAll(analysisResponse.data ?? []);
  //         }
  //         currentPage = page;
  //       });
  //     } else {
  //       Utils.showSnackBar(context, 'Failed to load data');
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar(context, e.toString());
  //     // isLoading = false;
  //   }
  // }

  // Future<void> getAffairs({int page = 1}) async {
  //   try {
  //     final response = await api.fetchData(context,
  //         'gov-affairs?sort=created_at&order=desc&page=$page&limit=$limitItem');
  //     if (response != null) {
  //       affairResponse = affair.AffairResponse.fromJson(response);
  //       setState(() {
  //         if (page == datumAffair) {
  //           datumAffair = affairResponse.data ?? [];
  //         } else {
  //           datumAffair.addAll(affairResponse.data ?? []);
  //         }
  //         currentPage = page;
  //       });
  //     } else {
  //       Utils.showSnackBar(context, 'Failed to load data');
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar(context, e.toString());
  //     // isLoading = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguage>(
      builder: (context, appLanguage, child) {
        return Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.blue[0],
            // backgroundColor: Colors.white70,
            // backgroundColor: Colors.white
            //     .withOpacity(0.70), // Replace with your color and opacity
            // centerTitle: true,
            backgroundColor: Color(0xFF35C5CF),
            toolbarHeight: 200,
            elevation: 2,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        Const.banner,
                        fit: BoxFit.contain,
                        height: 25,
                      ),
                      Spacer(), // Menambahkan spacer untuk memisahkan logo dan CircleAvatar
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://example.com/path/to/image.jpg'), // Ganti dengan URL gambar Anda
                        // radius: ,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Live Longer & Live Healthier, Anna!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Jarak di bawah teks
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Color(0xFF35C5CF)),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText:
                                  'Chat With AI doctor for all your health question',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Color(0xFF35C5CF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 16.0),
              //   child: IconButton(
              //     icon: Icon(Icons.perm_identity),
              //     onPressed: () async {
              //       // bool isLoggedIn =
              //       //     await Utils.getSpBool(Const.IS_LOGED_IN) ?? false;
              //       // if (isLoggedIn == true) {
              //       //   // final back = await Navigator.push'cekMarketingServices : ' + (
              //       //   //   context,
              //       //   //   // MaterialPageRoute(builder: (context) => Submenu()),
              //       //   //   MaterialPageRoute(builder: (context) => SubmenuPage()),
              //       //   // );
              //       //   // if (back == 'back') {
              //       //   //   navbarVisibility(false);
              //       //   // }
              //       //   context.push(AppRoutes.submenu);
              //       // } else {
              //       //   context.push(AppRoutes.signIn);
              //       //   // await Navigator.push(
              //       //   //   context,
              //       //   //   MaterialPageRoute(builder: (context) => SignInPage()),
              //       //   // );
              //       // }
              //       // ;
              //     },
              //     // color: Colors.white,
              //   ),
              // )
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
          body: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
            color: Colors.white,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // SearchInputBox(),
                  // SizedBox(height: 20),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularIconWithTitle(
                        onTap: () {
                          // selectTab(1);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        iconPath:
                            'assets/icons/ic_tenders.png', // Replace with your actual image path
                        title:
                            AppLocalizations.of(context)!.translate('tenders'),
                        backgroundColor: Color(0xFFDCE3FD),
                        // iconColor: Colors.white,
                        titleColor: Colors.black,
                      ),
                      CircularIconWithTitle(
                        onTap: () {
                          // selectTab(2);
                        },
                        iconPath:
                            'assets/icons/ic_distributors.png', // Replace with your actual image path
                        title: AppLocalizations.of(context)!
                            .translate('distributors'),
                        backgroundColor: Color(0xFFFFE7E7),
                        // iconColor: Colors.white,
                        titleColor: Colors.black,
                      ),
                      CircularIconWithTitle(
                        onTap: () {
                          // selectTab(1);
                        },
                        iconPath:
                            'assets/icons/ic_products.png', // Replace with your actual image path
                        title:
                            AppLocalizations.of(context)!.translate('products'),
                        backgroundColor: Color(0xFFFCEEE1),
                        // iconColor: Colors.white,
                        titleColor: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // CircularIconWithTitle(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => Drugs()),
                      //     );
                      //   },
                      //   iconPath: 'assets/icons/ic_pharmacy.png',
                      //   title: AppLocalizations.of(context)!
                      //       .translate('e_pharmacy'),
                      //   backgroundColor: Color(0xFFF6EFC6),
                      //   // iconColor: Colors.white,
                      //   titleColor: Colors.black,
                      // ),
                      // CircularIconWithTitle(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => PoCT()),
                      //     );
                      //     // Utils.openPDFFromAssets(
                      //     //     context, 'assets/pdfs/content_service.pdf');
                      //   },
                      //   iconPath: 'assets/icons/ic_poct.png',
                      //   title: AppLocalizations.of(context)!.translate('poct'),
                      //   backgroundColor: Color(0xFFE3F3EA),
                      //   // iconColor: Colors.white,
                      //   titleColor: Colors.black,
                      // ),
                      // CircularIconWithTitle(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => listNews.News()),
                      //     );
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => WebViewActivity(
                      //     //         title: 'Events & News',
                      //     //         url: Const.URL_WEB + '/all-news'),
                      //     //   ),
                      //     // );
                      //   },
                      //   iconPath: 'assets/icons/ic_events.png',
                      //   title:
                      //       AppLocalizations.of(context)!.translate('events'),
                      //   backgroundColor: Color(0xFFD3F2FF),
                      //   // iconColor: Colors.white,
                      //   titleColor: Colors.black,
                      // ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     CircularIconWithTitle(
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   listServiceRequest.ServiceRequest()),
                  //         );
                  //       },
                  //       iconPath: 'assets/icons/ic_tenders.png',
                  //       title: AppLocalizations.of(context)!
                  //           .translate('marketing_services'),
                  //       backgroundColor: Color(0xFFF6EFC6),
                  //       // iconColor: Colors.white,
                  //       titleColor: Colors.black,
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('marketing_services'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, top: 16.0),
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => listMarketingServices
                              //           .MarketingServices()),
                              // );
                            },
                            child: Text(
                              'View All',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.grey,
                                // fontSize: 13,
                                fontFamily: 'Inter',
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 350,
                    // child: ListView.separated(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: datum.length,
                    //   itemBuilder: (context, index) {
                    //     if (index == datum.length) {
                    //       return Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //     final item = datum[index];
                    //     return Card(
                    //       color: Colors.white,
                    //       margin: EdgeInsets.all(8.0),
                    //       child: InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => listMarketingServices
                    //                     .MarketingServices()),
                    //           );
                    //         },
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(16.0),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Row(
                    //                 crossAxisAlignment: CrossAxisAlignment
                    //                     .start, // Align items vertically at the start
                    //                 children: [
                    //                   Expanded(
                    //                     child: Column(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       children: [
                    //                         SizedBox(height: 10),
                    //                         Text(
                    //                           Utils.fmtToDMY(item.createdAt),
                    //                           style: TextStyle(
                    //                             color: Color(0xFF514A6B),
                    //                             fontSize: 12,
                    //                             fontFamily: 'Open Sans',
                    //                             fontWeight: FontWeight.w400,
                    //                             height: 0,
                    //                           ),
                    //                         ),
                    //                         Text(
                    //                           Utils.trimString(item.title),
                    //                           overflow: TextOverflow.ellipsis,
                    //                           maxLines: 1,
                    //                           style: TextStyle(
                    //                             color: Color(0xFF150A33),
                    //                             fontSize: 14,
                    //                             fontFamily: 'Inter',
                    //                             fontWeight: FontWeight.w700,
                    //                           ),
                    //                         ),
                    //                         SizedBox(height: 5),
                    //                         Text(
                    //                           'Read More',
                    //                           style: TextStyle(
                    //                             color: Colors.blue,
                    //                             fontSize: 11,
                    //                             fontFamily: 'Open Sans',
                    //                             height: 0,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   separatorBuilder: (context, index) => SizedBox(height: 0),
                    // ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('breakthrough_case_studies'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding:
                      //         const EdgeInsets.only(right: 16.0, top: 16.0),
                      //     child: InkWell(
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   listAnalysis.Analysis()),
                      //         );
                      //       },
                      //       child: Text(
                      //         'View All',
                      //         textAlign: TextAlign.right,
                      //         style: TextStyle(
                      //           color: Colors.grey,
                      //           // fontSize: 13,
                      //           fontFamily: 'Inter',
                      //           height: 0,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Container(
                  //   height: 350,
                  //   child: ListView.separated(
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     itemCount: datum.length,
                  //     itemBuilder: (context, index) {
                  //       if (index == datum.length) {
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       }
                  //       final item = datum[index];
                  //       return Card(
                  //         color: Colors.white,
                  //         margin: EdgeInsets.all(8.0),
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     listAnalysis.DetailPage(item: item),
                  //               ),
                  //             );
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(16.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Row(
                  //                   crossAxisAlignment: CrossAxisAlignment
                  //                       .start, // Align items vertically at the start
                  //                   children: [
                  //                     if (item.image?.url != null)
                  //                       Image.network(
                  //                         item.image!.url!,
                  //                         width:
                  //                             50, // Adjust the width as needed
                  //                         height:
                  //                             50, // Adjust the height as needed
                  //                         fit: BoxFit
                  //                             .cover, // Adjust the fit as needed
                  //                       ),
                  //                     SizedBox(
                  //                         width:
                  //                             10), // Add some space between the image and the text
                  //                     Expanded(
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           SizedBox(height: 10),
                  //                           Text(
                  //                             Utils.fmtToDMY(item.createdAt),
                  //                             style: TextStyle(
                  //                               color: Color(0xFF514A6B),
                  //                               fontSize: 12,
                  //                               fontFamily: 'Open Sans',
                  //                               fontWeight: FontWeight.w400,
                  //                               height: 0,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             Utils.trimString(item.title),
                  //                             overflow: TextOverflow.ellipsis,
                  //                             maxLines: 1,
                  //                             style: TextStyle(
                  //                               color: Color(0xFF150A33),
                  //                               fontSize: 14,
                  //                               fontFamily: 'Inter',
                  //                               fontWeight: FontWeight.w700,
                  //                             ),
                  //                           ),
                  //                           SizedBox(height: 5),
                  //                           Text(
                  //                             'Read More',
                  //                             style: TextStyle(
                  //                               color: Colors.blue,
                  //                               fontSize: 11,
                  //                               fontFamily: 'Open Sans',
                  //                               height: 0,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     separatorBuilder: (context, index) => SizedBox(height: 0),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: Card(
                  //     child: ListTile(
                  //       leading: Icon(Icons.image),
                  //       title: Text('Item Recommended Tenders'),
                  //       subtitle: Text('Coming soon.'),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('medical_policy_affairs'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              // fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(right: 16.0),
                      //     child: InkWell(
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => listAffair.Affair()),
                      //         );
                      //       },
                      //       child: Text(
                      //         'View All',
                      //         textAlign: TextAlign.right,
                      //         style: TextStyle(
                      //           color: Colors.grey,
                      //           // fontSize: 13,
                      //           fontFamily: 'Inter',
                      //           height: 0,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Container(
                  //   height: 350,
                  //   child: ListView.separated(
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     itemCount: datumAffair.length,
                  //     itemBuilder: (context, index) {
                  //       if (index == datumAffair.length) {
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       }
                  //       final item = datumAffair[index];
                  //       return Card(
                  //         color: Colors.white,
                  //         margin: EdgeInsets.all(8.0),
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     listAffair.DetailPage(item: item),
                  //               ),
                  //             );
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(16.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Row(
                  //                   crossAxisAlignment: CrossAxisAlignment
                  //                       .start, // Align items vertically at the start
                  //                   children: [
                  //                     if (item.image?.url != null)
                  //                       Image.network(
                  //                         item.image!.url!,
                  //                         width:
                  //                             50, // Adjust the width as needed
                  //                         height:
                  //                             50, // Adjust the height as needed
                  //                         fit: BoxFit
                  //                             .cover, // Adjust the fit as needed
                  //                       ),
                  //                     SizedBox(
                  //                         width:
                  //                             10), // Add some space between the image and the text
                  //                     Expanded(
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           SizedBox(height: 10),
                  //                           Text(
                  //                             Utils.fmtToDMY(item.createdAt),
                  //                             style: TextStyle(
                  //                               color: Color(0xFF514A6B),
                  //                               fontSize: 12,
                  //                               fontFamily: 'Open Sans',
                  //                               fontWeight: FontWeight.w400,
                  //                               height: 0,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             Utils.trimString(item.title),
                  //                             overflow: TextOverflow.ellipsis,
                  //                             maxLines: 1,
                  //                             style: TextStyle(
                  //                               color: Color(0xFF150A33),
                  //                               fontSize: 14,
                  //                               fontFamily: 'Inter',
                  //                               fontWeight: FontWeight.w700,
                  //                             ),
                  //                           ),
                  //                           SizedBox(height: 5),
                  //                           Text(
                  //                             'Read More',
                  //                             style: TextStyle(
                  //                               color: Colors.blue,
                  //                               fontSize: 11,
                  //                               fontFamily: 'Open Sans',
                  //                               height: 0,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     separatorBuilder: (context, index) => SizedBox(height: 0),
                  //   ),
                  // ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('dashboard_list_service'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding:
                      //         const EdgeInsets.only(right: 16.0, top: 16.0),
                      //     child: InkWell(
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   listServiceRequest.ServiceRequest()),
                      //         );
                      //       },
                      //       child: Text(
                      //         'View All',
                      //         textAlign: TextAlign.right,
                      //         style: TextStyle(
                      //           color: Colors.grey,
                      //           // fontSize: 13,
                      //           fontFamily: 'Inter',
                      //           height: 0,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Container(
                  //   height: 350,
                  //   child: ListView.separated(
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     itemCount: datumServiceRequest.length,
                  //     itemBuilder: (context, index) {
                  //       if (index == datumServiceRequest.length) {
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       }
                  //       final item = datumServiceRequest[index];
                  //       return Card(
                  //         color: Colors.white,
                  //         margin: EdgeInsets.all(8.0),
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => listServiceRequest
                  //                       .ServiceRequestDetailPage(item: item)),
                  //             );
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(16.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Row(
                  //                   crossAxisAlignment: CrossAxisAlignment
                  //                       .start, // Align items vertically at the start
                  //                   children: [
                  //                     Expanded(
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           SizedBox(height: 10),
                  //                           Text(
                  //                             Utils.fmtToDMY(item.createdAt),
                  //                             style: TextStyle(
                  //                               color: Color(0xFF514A6B),
                  //                               fontSize: 12,
                  //                               fontFamily: 'Open Sans',
                  //                               fontWeight: FontWeight.w400,
                  //                               height: 0,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             Utils.trimString(item.title),
                  //                             overflow: TextOverflow.ellipsis,
                  //                             maxLines: 1,
                  //                             style: TextStyle(
                  //                               color: Color(0xFF150A33),
                  //                               fontSize: 14,
                  //                               fontFamily: 'Inter',
                  //                               fontWeight: FontWeight.w700,
                  //                             ),
                  //                           ),
                  //                           SizedBox(height: 5),
                  //                           Text(
                  //                             'Read More',
                  //                             style: TextStyle(
                  //                               color: Colors.blue,
                  //                               fontSize: 11,
                  //                               fontFamily: 'Open Sans',
                  //                               height: 0,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     separatorBuilder: (context, index) => SizedBox(height: 0),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: FloatingActionButton(
              onPressed: () {
                if (_isScrolledToEnd) {
                  // Scroll to the top of the list
                  _scrollController.animateTo(
                    0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 500),
                  );
                } else {
                  // Scroll to the end of the list
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 500),
                  );
                }
              },
              child: Icon(
                  _isScrolledToEnd ? Icons.arrow_upward : Icons.arrow_downward),
              tooltip: _isScrolledToEnd ? 'Scroll to Top' : 'Scroll to End',
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .endFloat, // Set the location of the FAB
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

  CircularIconWithTitle({
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
      child: Container(
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
            SizedBox(
                height: 8), // Add some space between the avatar and the title
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInputBox extends StatefulWidget {
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
      margin: EdgeInsets.fromLTRB(
          30.0, 20.0, 30.0, 10.0), // Set margin around the entire TextField
      child: ClipRRect(
        borderRadius: BorderRadius.only(
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
          // onSubmitted: (value) {
          //   // Handle search action here
          //   // print('Search submitted: $value');
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => BrowseProducts(keyword: value)),
          //   );
          // },
          decoration: InputDecoration(
            filled: true, // Enable filling the TextField with a color
            fillColor: Colors.grey[100], // Set the background color to grey
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
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
            // suffixIcon: IconButton(
            //   icon: Icon(Icons.clear),
            //   onPressed: () {
            //     _controller.clear();
            //   },
            // ),
          ),
        ),
      ),
    );
  }
}
