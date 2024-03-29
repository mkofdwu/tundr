import 'package:tundr/enums/personal_info_type.dart';

class PersonalInfoField {
  String name;
  String prompt;
  PersonalInfoType type;
  dynamic options;

  PersonalInfoField({this.name, this.prompt, this.type, this.options});

  factory PersonalInfoField.fromMap(String name, Map<String, dynamic> map) {
    return PersonalInfoField(
      name: name,
      prompt: map['prompt'],
      type: PersonalInfoType.values[map['type']],
      options: map['options'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prompt': prompt,
      'type': PersonalInfoType.values.indexOf(type),
      'options': options,
    };
  }
}
