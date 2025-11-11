import 'package:flutter/material.dart';

class MedicalStorePage extends StatefulWidget {
  @override
  _MedicalStorePageState createState() => _MedicalStorePageState();
}

class _MedicalStorePageState extends State<MedicalStorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Medical Store',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Icon(Icons.sort),
                SizedBox(width: 5),
                Text('Sort'),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF40E0D0), // Warna tosca
          tabs: [
            Tab(text: 'Homecare Consumable'),
            Tab(text: 'Point of Care Testing'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildProductGrid(homecareConsumable: true),
          buildProductGrid(homecareConsumable: false),
        ],
      ),
    );
  }

  Widget buildProductGrid({required bool homecareConsumable}) {
    if (homecareConsumable) {
      return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: 6, // Number of items for homecare consumable
        itemBuilder: (context, index) {
          return buildProductCard(index, homecareConsumable: true);
        },
      );
    } else {
      return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: 6, // Number of items for point of care testing
        itemBuilder: (context, index) {
          return buildProductCard(index, homecareConsumable: false);
        },
      );
    }
  }

  Widget buildProductCard(int index, {required bool homecareConsumable}) {
    List<String> homecareImages = [
      'assets/images/store_mask.png',
      'assets/images/store_syringe.png',
      'assets/images/store_glove.png',
      'assets/images/store_oxygen.png',
      'assets/images/store_blood.png',
      'assets/images/store_tube.png',
    ];

    List<String> homecareDescriptions = [
      'Disposable 3 pty class 1',
      'Syringe  ',
      'SwiftGrip Disposable',
      'B-Type (10 L) Oxygen',
      'Blood Glucose Meter',
      '5ml PP Tube Disposable',
    ];

    List<String> homecarePrices = [
      '\$35',
      '\$10',
      '\$15',
      '\$50',
      '\$20',
      '\$5',
    ];

    List<String> pocImages = [
      'assets/images/store_biochemist.png',
      'assets/images/store_seamaty.png',
      'assets/images/store_hematology.png',
      'assets/images/store_flurolit.png',
      'assets/images/store_urinalysis.png',
      'assets/images/store_poct.png',
    ];

    List<String> pocDescriptions = [
      'COVID-19 Rapid Test Kit',
      'Blood Glucose Monitoring System',
      'Digital Thermometer',
      'Finger Pulse Oximeter',
      'Portable ECG Monitor',
      'Urine Test Strips',
    ];

    List<String> pocPrices = [
      '\$25',
      '\$30',
      '\$10',
      '\$20',
      '\$100',
      '\$15',
    ];

    List<String> images = homecareConsumable ? homecareImages : pocImages;
    List<String> descriptions =
        homecareConsumable ? homecareDescriptions : pocDescriptions;
    List<String> prices = homecareConsumable ? homecarePrices : pocPrices;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                images[index],
                width: double.infinity,
                height: 175,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // Handle favorite action
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  descriptions[index],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 5),
                Text(
                  prices[index],
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
