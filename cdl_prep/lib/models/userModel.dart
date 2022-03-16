import 'package:cdl_prep/models/dataModels.dart';

class CdlSchool {
  int schoolId;
  String name, phone, image, address, city, state, country;
  String slotTime, schoolTimeFrom, schoolTimeTo;

  CdlSchool({
    required this.schoolId,
    required this.name,
    required this.phone,
    required this.image,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.slotTime,
    required this.schoolTimeFrom,
    required this.schoolTimeTo,
  });

  factory CdlSchool.fromJson(Map json) {
    return CdlSchool(
      schoolId: json['userid'],
      name: json['schoolname'],
      phone: json['phone'],
      image: json['img'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      slotTime: json['slottime'],
      schoolTimeFrom: json['schooltimefrom'],
      schoolTimeTo: json['schooltimeto'],
    );
  }
}

class CdlStudent {
  int enrollId;
  String name, phone, image, cityState;
  CdlState cdlState;
  String testSchedule, preTripReady, skillReady, roadReady, paymentStatus;

  CdlStudent({
    required this.enrollId,
    required this.name,
    required this.phone,
    required this.image,
    required this.cityState,
    required this.cdlState,
    required this.testSchedule,
    required this.preTripReady,
    required this.skillReady,
    required this.roadReady,
    required this.paymentStatus,
  });

  factory CdlStudent.fromJson(Map json) {
    return CdlStudent(
      enrollId: json['enrollid'],
      name: json['name'],
      phone: json['phone'],
      image: json['img'],
      cityState: json['city'] + ", " + json['state'],
      cdlState: CdlState.fromJson(json['cdlstate']),
      testSchedule: json['testschedule'],
      preTripReady: json['pretrip'],
      skillReady: json['skillready'],
      roadReady: json['roadready'],
      paymentStatus: json['paymentstatus'],
    );
  }
}

class CdlUser {
  String name, phone;
  int userid;
  CdlState cdlState;

  CdlUser({
    required this.name,
    required this.phone,
    required this.userid,
    required this.cdlState,
  });

  factory CdlUser.fromJson(Map json) {
    return CdlUser(
      name: json['username'],
      phone: json['phone'],
      userid: json['userid'],
      cdlState: CdlState.fromJson(json['cdlstate']),
    );
  }
}

enum UserStatus {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut,
}
