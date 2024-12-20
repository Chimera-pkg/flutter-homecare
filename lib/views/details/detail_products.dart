import 'package:go_router/go_router.dart';
import 'package:flutter_homecare/models/response_product_manual.dart';
import 'package:flutter_homecare/route/app_routes.dart';
import 'package:flutter_homecare/widgets/button_download.dart';
import 'package:flutter_homecare/views/profile.dart';
import '../../models/product.dart';
import '../../models/specification.dart';
import '../../models/clinical.dart';
import '../../const.dart';
import '../../widgets/slider_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

// multi language support
import '../../app_localzations.dart';

//start model
class Item {
  final String? name;
  final String? slug;
  final String? url;
  final int id;
  List<Tag>? tags;
  Manufacturer? manufacturer;
  Distributor? distributor;

  Item({
    required this.id,
    this.name,
    this.slug,
    this.url,
    this.tags,
    this.manufacturer,
    this.distributor,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    // print("cekJSONItem : '$json'");
    // print(json['thumbnail']['url']);
    return Item(
      name: json['name'],
      slug: json['slug'],
      url: json['thumbnail']['url'],
      id: json['id'],
      tags: List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
      manufacturer: json['manufacturer'] != null
          ? Manufacturer.fromJson(json['manufacturer'])
          : null,
      distributor: json['distributor'] != null
          ? Distributor.fromJson(json['distributor'])
          : null,
    );
  }
}

class DetailProducts extends StatefulWidget {
  final Item item;
  const DetailProducts({required this.item});

  @override
  _DetailProductsState createState() => _DetailProductsState();
}

class _DetailProductsState extends State<DetailProducts> {
  late ResponseProductManual productManual = ResponseProductManual();
  late Future<Product> itemDetails;
  late Future<List<Specification>> specs;
  late Future<List<Clinical>> clinicals;
  late List<String> imageUrls = [];

  // late AppLocalizations localizations;
  // Locale _locale = const Locale('zh');

  @override
  void initState() {
    super.initState();

    // debug lang
    // _locale = WidgetsBinding.instance.window.locale;
    // localizations = AppLocalizations(_locale);
    // localizations.load();

    itemDetails = fetchItemDetails(widget.item.id);
    specs = fetchSpec(widget.item.id);
    clinicals = fetchClinicals(widget.item.id);
    fetchProductManual(widget.item.id).then((manual) {
      setState(() {
        productManual = manual;
      });
    }).catchError((error) {
      print('Error fetching product manual: $error');
    });
  }

  Future<ResponseProductManual> fetchProductManual(int itemId) async {
    final apiUrl = '${Const.URL_API}/products/$itemId/user-manual';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      productManual = ResponseProductManual.fromJson(jsonData);
      if (productManual.file == null) {
        productManual.file = null;
      }
      return productManual;
    } else {
      productManual.file = null;
      return productManual;
    }
  }

  Future<List<Specification>> fetchSpec(int itemId) async {
    final apiUrl =
        '${Const.URL_API}/products/$itemId/specifications?page=1&limit=10';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> specsJson = jsonData['data'];
      return specsJson
          .map((specJson) => Specification.fromJson(specJson))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<Clinical>> fetchClinicals(int itemId) async {
    final apiUrl =
        '${Const.URL_API}/products/$itemId/clinical-applications?page=1&limit=10';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> itemsJson = jsonData['data'];
      return itemsJson.map((itemJson) => Clinical.fromJson(itemJson)).toList();
    } else {
      return [];
    }
  }

  Future<Product> fetchItemDetails(int itemId) async {
    final api_products = Const.API_PRODUCTS + '$itemId';
    // final api_products = Const.API_PRODUCTS + 'mc500';
    // print('cekUrl : $api_products');
    final response = await http.get(Uri.parse(api_products));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Map<String, dynamic> jsonMap = jsonData;
      // data = ProductDetails.fromJson(jsonData);
      // print('Product Name: ${data.name}');

      final List<dynamic> images = jsonData['media'];
      setState(() {
        imageUrls = images
            .where((media) => media['type'] == 'image')
            .map((image) => image['url'] as String)
            .toList();
      });
      // return json.decode(response.body);
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load item details');
    }
  }

  void _shareProduct() {
    final String productUrl =
        Const.URL_WEB + '/product-detail/${widget.item.slug}';
    Share.share(productUrl, subject: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Another Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'back');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.handshake),
            onPressed: () {
              context.push(AppRoutes.partnership, extra: widget.item.id);
              // context.push('/locations', extra: widget.item.id);
              // intent to partnership.dart
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => CountryCityDropdown()),
              // );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareProduct,
          ),
        ],
      ),
      // body: FutureBuilder<Product>(
      //   future: itemDetails,
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([itemDetails, specs, clinicals]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            // final item = snapshot.data!;
            final List<dynamic> results = snapshot.data!;
            final item = results[0];
            // final specs = results[1];
            final List<Specification> specifications =
                results[1] as List<Specification>;
            final List<Clinical> clinicals = results[2]
                as List<Clinical>; // Cast specs to List<Specification>
            // Print the result string
            // print(item.category.name);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      0, 0, 0, 60.0), // Adds bottom margin of 16.0
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SliderImages(images: imageUrls),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 11, 8, 0),
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: ShapeDecoration(
                            color: Color(0x334894FE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:
                                (item.tags != null && item.tags.isNotEmpty)
                                    ? item.tags.map<Widget>((tag) {
                                        if (tag is Tag) {
                                          return Text(
                                            tag.name!,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          );
                                        } else {
                                          return Text('Tag not found');
                                        }
                                      }).toList()
                                    : [Text('No tags available')],
                            // children: (item.tags).map((tag) {
                            //   return Text(
                            //     tag.name,
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: 14,
                            //       fontFamily: 'Inter',
                            //       fontWeight: FontWeight.w400,
                            //       height: 0,
                            //     ),
                            //   );
                            // }).toList(),
                          ),
                        ),
                      ),
                      // Title
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item.name,
                          style: TextStyle(
                            color: Color(0xFF18181B),
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                          .translate('category') +
                                      " : ",
                                  style: TextStyle(
                                    color: Color(0xFF757575),
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: item.category.name,
                                  style: TextStyle(
                                    color: Color(0xFF757575),
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(
                                      id: item.manufacturer != null
                                          ? item.manufacturer.userId
                                          : item.distributor.userId,
                                      type: item.manufacturer != null
                                          ? 'man'
                                          : 'dis'),
                                ),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: item.manufacturer != null
                                        ? AppLocalizations.of(context)!
                                                .translate('manufacturer') +
                                            " : "
                                        : AppLocalizations.of(context)!
                                                .translate('distributor') +
                                            " : ",
                                    style: TextStyle(
                                      color: Color(0xFF757575),
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item.manufacturer != null
                                        ? item.manufacturer.name
                                        : item.distributor.name,
                                    style: TextStyle(
                                      color: Color(0xFF4894FE),
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 13),
                        child: SizedBox(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                          .translate('product_details') +
                                      "\n",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                                TextSpan(
                                  text: item.description,
                                  style: TextStyle(
                                    color: Color(0xFF757575),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 13),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('product_specifications'),
                          style: TextStyle(
                            color: Color(0xFF18181B),
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('Name'),
                            ),
                            DataColumn(
                              label: Text('Value'),
                            ),
                          ],
                          rows: specifications
                              .map((spec) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(spec.name)),
                                      DataCell(Text(spec.value)),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('clinical_application'),
                          style: TextStyle(
                            color: Color(0xFF18181B),
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      HtmlWidget(clinicals[0].content ?? 'Not available'),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                    .translate('user_manual') +
                                " : ",
                            style: TextStyle(
                              color: Color(0xFF18181B),
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 10),
                          ButtonDownload(productManual: productManual),
                        ],
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            );
            // return Center(
            //   child: Text(
            //     'Details of Item ${item['id']}: ${item['name']}',
            //     style: TextStyle(fontSize: 24),
            //   ),
            // );
          }
        },
      ),
    );
  }
}
