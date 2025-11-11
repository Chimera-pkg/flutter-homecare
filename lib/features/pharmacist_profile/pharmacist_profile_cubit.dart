import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pharmacist_profile_state.dart';

class PharmacistProfileCubit extends Cubit<PharmacistProfileState> {
  PharmacistProfileCubit() : super(PharmacistProfileInitial());

  void loadProfile() {
    // Simulate loading profile data
    emit(PharmacistProfileLoaded(
      name: 'Dr. Khanza Deliva',
      role: 'Pharmacist',
      patients: '180+',
      experience: '10Y++',
      rating: '4.5',
      about:
          'Dr. Khanza Deliva is a highly experienced pharmacist with over 10 years of experience in the field. She has successfully treated over 180 patients and is known for her dedication and expertise.',
      workingInfo: 'Monday - Friday, 08.00 AM - 21.00 PM\nCaterpillar Hospital',
      certificates: List.generate(
          3,
          (index) => Certificate(
                title: 'Certificate Title $index',
                idNumber: '12345$index',
                issued: '2021',
              )),
      reviews: List.generate(
          3,
          (index) => Review(
                reviewer: 'Reviewer $index',
                text: 'Incremental review text...',
                rating: '4.5',
              )),
      imageUrl:
          'http://homecare-api.med-map.org/uploads/pharmacist-avatars/cm8mg6m9c0021h2p0c592c8cg.png',
    ));
  }
}
