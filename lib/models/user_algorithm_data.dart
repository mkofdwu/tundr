import 'package:tundr/constants/personal_info_fields.dart';
import 'package:tundr/enums/filter_method.dart';
import 'package:tundr/models/filter.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/registration_info.dart';

class UserAlgorithmData {
  bool asleep;
  bool showMeBoys;
  bool showMeGirls;
  int ageRangeMin;
  int ageRangeMax;
  Map<String, Filter> otherFilters;

  UserAlgorithmData({
    this.asleep,
    this.showMeBoys,
    this.showMeGirls,
    this.ageRangeMin,
    this.ageRangeMax,
    this.otherFilters,
  });

  factory UserAlgorithmData.fromMap(Map<String, dynamic> map) {
    final otherFilters = map['otherFilters'].map((name, value) {
      return MapEntry<String, Filter>(
        name,
        Filter(
          field: PersonalInfoField.fromMap(name, personalInfoFields[name]),
          options: value['options'],
          method: FilterMethod.values.elementAt(value['method']),
        ),
      );
    });
    return UserAlgorithmData(
      asleep: map['asleep'],
      showMeBoys: map['showMeBoys'],
      showMeGirls: map['showMeGirls'],
      ageRangeMin: map['ageRangeMin'],
      ageRangeMax: map['ageRangeMax'],
      otherFilters: otherFilters,
    );
  }

  factory UserAlgorithmData.register(RegistrationInfo info {
    return UserAlgorithmData(
      // TODO
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // TODO
    };
  }
}
