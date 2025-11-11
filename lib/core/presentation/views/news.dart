// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import '../models/affair_response.dart';
// import '../utils.dart';
// import '../api.dart';

// class News extends StatefulWidget {
//   @override
//   _NewsState createState() => _NewsState();
// }

// class _NewsState extends State<News> {
//   final api = Api();
//   late AffairResponse modelResponse;
//   List<Data> datum = [];
//   int currentPage = 1;
//   int limitItem = 10;
//   String keyword = "";
//   bool hasMore = true;
//   bool isLoading = false;
//   bool isInitialLoad = true;
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();
//   bool isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels ==
//             _scrollController.position.maxScrollExtent &&
//         hasMore &&
//         !isLoading) {
//       fetchData(page: currentPage + 1);
//     }
//   }

//   Future<void> fetchData({int page = 1}) async {
//     if (!hasMore || isLoading) return;

//     setState(() {
//       isLoading = true;
//       if (page == 1) {
//         isInitialLoad = true;
//       }
//     });

//     try {
//       // final response = await http.get(Uri.parse(
//       //     '${Const.URL_API}/distributor/lists?page=$page&limit=5&sort=created_at&order=desc&keyword=$keyword'));

//       final response = await api.fetchData(context,
//           'news?sort=created_at&order=desc&page=$page&limit=$limitItem&keyword=$keyword');

//       if (response != null) {
//         modelResponse = AffairResponse.fromJson(response);

//         setState(() {
//           if (page == 1) {
//             datum = modelResponse.data ?? [];
//           } else {
//             datum.addAll(modelResponse.data ?? []);
//           }
//           currentPage = page;
//           // hasMore = modelResponse.data.isNotEmpty;
//           hasMore = modelResponse.data?.length == limitItem;
//           isInitialLoad = false;
//         });
//       } else {
//         Utils.showSnackBar(
//             context, 'Failed to load data : ' + response.toString());
//       }
//     } catch (e) {
//       Utils.showSnackBar(context, e.toString());
//       // isLoading = false;
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _updateSearchKeyword(String newKeyword) {
//     setState(() {
//       keyword = newKeyword;
//       currentPage = 1;
//       datum = [];
//       hasMore = true;
//     });
//     fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: isSearching
//             ? TextField(
//                 controller: _searchController,
//                 autofocus: true,
//                 decoration: InputDecoration(
//                   hintText: 'Enter keyword ...',
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (value) {
//                   _updateSearchKeyword(value);
//                 },
//               )
//             : Text('Search Item'),
//         actions: [
//           isSearching
//               ? IconButton(
//                   icon: Icon(Icons.clear),
//                   onPressed: () {
//                     setState(() {
//                       isSearching = false;
//                       _searchController.clear();
//                       _updateSearchKeyword('');
//                     });
//                   },
//                 )
//               : IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     setState(() {
//                       isSearching = true;
//                     });
//                   },
//                 ),
//         ],
//       ),
//       body: isInitialLoad
//           ? Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: () => fetchData(page: 1),
//               child: Container(
//                 margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         'Latest News & Events',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w700,
//                           height: 0,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView.separated(
//                         controller: _scrollController,
//                         itemCount: datum.length + (hasMore ? 1 : 0),
//                         itemBuilder: (context, index) {
//                           if (index == datum.length) {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                           final item = datum[index];
//                           return Card(
//                             color: Colors.white,
//                             margin: EdgeInsets.all(8.0),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         DetailPage(item: item),
//                                   ),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment: CrossAxisAlignment
//                                           .start, // Align items vertically at the start
//                                       children: [
//                                         if (item.image?.url != null)
//                                           Image.network(
//                                             item.image!.url!,
//                                             width:
//                                                 50, // Adjust the width as needed
//                                             height:
//                                                 50, // Adjust the height as needed
//                                             fit: BoxFit
//                                                 .cover, // Adjust the fit as needed
//                                           ),
//                                         SizedBox(
//                                             width:
//                                                 10), // Add some space between the image and the text
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 Utils.fmtToDMY(item.createdAt),
//                                                 style: TextStyle(
//                                                   color: Color(0xFF514A6B),
//                                                   fontSize: 12,
//                                                   fontFamily: 'Open Sans',
//                                                   fontWeight: FontWeight.w400,
//                                                   height: 0,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 Utils.trimString(item.title),
//                                                 overflow: TextOverflow.ellipsis,
//                                                 maxLines: 1,
//                                                 style: TextStyle(
//                                                   color: Color(0xFF150A33),
//                                                   fontSize: 14,
//                                                   fontFamily: 'Inter',
//                                                   fontWeight: FontWeight.w700,
//                                                 ),
//                                               ),
//                                               SizedBox(height: 5),
//                                               Text(
//                                                 'Read More',
//                                                 style: TextStyle(
//                                                   color: Colors.blue,
//                                                   fontSize: 11,
//                                                   fontFamily: 'Open Sans',
//                                                   height: 0,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         separatorBuilder: (context, index) =>
//                             SizedBox(height: 0),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// class DetailPage extends StatelessWidget {
//   final Data item;

//   DetailPage({Key? key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: Text('Second Page'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         margin: EdgeInsets.only(bottom: 60),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               if (item.image?.url != null)
//                 Image.network(
//                   item.image?.url ?? '',
//                   width: MediaQuery.of(context)
//                       .size
//                       .width, // Set the width to full screen width
//                   height: 200, // Adjust the height as needed
//                   fit: BoxFit
//                       .cover, // Use BoxFit.cover to maintain the aspect ratio
//                 ),
//               Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       item.title ?? 'Not provided',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 20,
//                         fontFamily: 'Inter',
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.5,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Overview',
//                       style: TextStyle(
//                         color: Color(0xFF22212E),
//                         fontSize: 18,
//                         fontFamily: 'Inter',
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     Text(item.shortDescription ?? 'Not provided'),
//                     SizedBox(height: 20), // Add some space between sections
//                     Text(
//                       'About',
//                       style: TextStyle(
//                         color: Color(0xFF22212E),
//                         fontSize: 18,
//                         fontFamily: 'Inter',
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     HtmlWidget(
//                       item.content ?? 'Not provided',
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
