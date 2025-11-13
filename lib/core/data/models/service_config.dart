class ServiceTitle {
  final int? id;
  final String title;
  final double price;
  final String serviceType; // 'pharma' or 'nurse'

  ServiceTitle({
    this.id,
    required this.title,
    required this.price,
    required this.serviceType,
  });

  factory ServiceTitle.fromJson(Map<String, dynamic> json) {
    return ServiceTitle(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      serviceType: json['service_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'price': price,
      'service_type': serviceType,
    };
  }

  ServiceTitle copyWith({
    int? id,
    String? title,
    double? price,
    String? serviceType,
  }) {
    return ServiceTitle(
      id: id,
      title: title ?? '',
      price: price ?? 0.0,
      serviceType: serviceType ?? '',
    );
  }
}

class ServiceConfig {
  final String type; // 'pharmacist' or 'nurse'
  final String displayName;
  final String apiEndpoint;
  final List<ServiceTitle> defaultServices;

  ServiceConfig({
    required this.type,
    required this.displayName,
    required this.apiEndpoint,
    required this.defaultServices,
  });

  static ServiceConfig pharmacist() {
    return ServiceConfig(
      type: 'pharmacist',
      displayName: 'Pharmacist Services',
      apiEndpoint: '/v1/providers/available?provider_type=pharmacist',
      defaultServices: [
        ServiceTitle(
          title: 'Medication Review',
          price: 15.0,
          serviceType: 'pharma',
        ),
        ServiceTitle(
          title: 'Prescription Consultation',
          price: 10.0,
          serviceType: 'pharma',
        ),
        ServiceTitle(
          title: 'Medication Management Plan',
          price: 25.0,
          serviceType: 'pharma',
        ),
        ServiceTitle(
          title: 'Drug Therapy Analysis',
          price: 20.0,
          serviceType: 'pharma',
        ),
        ServiceTitle(
          title: 'Follow-up Therapy',
          price: 15.0,
          serviceType: 'pharma',
        ),
      ],
    );
  }

  static ServiceConfig nurse() {
    return ServiceConfig(
      type: 'nurse',
      displayName: 'Nursing Services',
      apiEndpoint: '/v1/providers/available?provider_type=nurse',
      defaultServices: [
        ServiceTitle(
          title: 'Medical Escort',
          price: 20.0,
          serviceType: 'nurse',
        ),
        ServiceTitle(
          title: 'Inject',
          price: 15.0,
          serviceType: 'nurse',
        ),
        ServiceTitle(
          title: 'Blood Glucose Check',
          price: 10.0,
          serviceType: 'nurse',
        ),
        ServiceTitle(
          title: 'Medication Administration',
          price: 12.0,
          serviceType: 'nurse',
        ),
        ServiceTitle(
          title: 'NGT Feeding',
          price: 18.0,
          serviceType: 'nurse',
        ),
        ServiceTitle(
          title: 'Oral Suctioning',
          price: 16.0,
          serviceType: 'nurse',
        ),
        ServiceTitle(
          title: 'Wound Care',
          price: 25.0,
          serviceType: 'nurse',
        ),
      ],
    );
  }

  static ServiceConfig radiologist() {
    return ServiceConfig(
      type: 'radiologist',
      displayName: 'Radiologist Services',
      apiEndpoint: '/v1/providers/available?provider_type=radiologist',
      defaultServices: [
        ServiceTitle(
          title: 'Image Analysis & Interpretation',
          price: 150.0,
          serviceType: 'radiologist',
        ),
        ServiceTitle(
          title: 'CT Scan Review',
          price: 200.0,
          serviceType: 'radiologist',
        ),
        ServiceTitle(
          title: 'MRI Scan Analysis',
          price: 250.0,
          serviceType: 'radiologist',
        ),
        ServiceTitle(
          title: 'X-Ray Examination',
          price: 100.0,
          serviceType: 'radiologist',
        ),
        ServiceTitle(
          title: 'Ultrasound Analysis',
          price: 120.0,
          serviceType: 'radiologist',
        ),
        ServiceTitle(
          title: 'Mammography Review',
          price: 180.0,
          serviceType: 'radiologist',
        ),
        ServiceTitle(
          title: 'PET Scan Interpretation',
          price: 300.0,
          serviceType: 'radiologist',
        ),
        ServiceTitle(
          title: '3D Reconstruction Analysis',
          price: 220.0,
          serviceType: 'radiologist',
        ),
        ServiceTitle(
          title: 'Contrast Study Review',
          price: 160.0,
          serviceType: 'radiologist',
        ),
        ServiceTitle(
          title: 'Second Opinion Consultation',
          price: 100.0,
          serviceType: 'radiologist',
        ),
      ],
    );
  }
}
