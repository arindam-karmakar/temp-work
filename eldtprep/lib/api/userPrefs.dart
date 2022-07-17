// ignore_for_file: unnecessary_new, file_names

import 'package:eldtprep/models/dataModels.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future setLastUserType(String typeOfUser) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('lastUserType', typeOfUser);

    // ignore: deprecated_member_use
    return prefs.commit();
  }

  Future<String> getLastUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString('lastUserType').toString();

    return type;
  }

  Future saveSchool(CdlSchool school) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('schoolId', school.schoolId);
    prefs.setString('name', school.name);
    prefs.setString('phone', school.phone);
    prefs.setString('image', school.image);
    prefs.setString('address', school.address);
    prefs.setString('city', school.city);
    prefs.setString('state', school.state);
    prefs.setString('country', school.country);
    prefs.setString('slotTime', school.slotTime);
    prefs.setString('schoolTimeFrom', school.schoolTimeFrom);
    prefs.setString('schoolTimeTo', school.schoolTimeTo);

    // ignore: deprecated_member_use
    return prefs.commit();
  }

  Future updatePicPath(String image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('image', image);

    // ignore: deprecated_member_use
    return prefs.commit();
  }

  Future getSchool() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int schoolId = prefs.getInt('schoolId') as int;
    String name = prefs.getString('name').toString();
    String phone = prefs.getString('phone').toString();
    String image = prefs.getString('image').toString();
    String address = prefs.getString('address').toString();
    String city = prefs.getString('city').toString();
    String state = prefs.getString('state').toString();
    String country = prefs.getString('country').toString();
    String slotTime = prefs.getString('slotTime').toString();
    String schoolTimeFrom = prefs.getString('schoolTimeFrom').toString();
    String schoolTimeTo = prefs.getString('schoolTimeTo').toString();

    return CdlSchool(
      schoolId: schoolId,
      name: name,
      phone: phone,
      image: image,
      address: address,
      city: city,
      state: state,
      country: country,
      slotTime: slotTime,
      schoolTimeFrom: schoolTimeFrom,
      schoolTimeTo: schoolTimeTo,
    );
  }

  Future removeSchool() async {}

  Future saveUser(CdlUser user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('name', user.name);
    prefs.setString('phone', user.phone);
    prefs.setInt('userId', user.userid);
    prefs.setString('userState', user.cdlState.state);
    prefs.setInt('userStateId', user.cdlState.stateid);
    prefs.setString('userCountry', user.cdlState.country);
    prefs.setInt('userStateStatus', user.cdlState.status);

    // ignore: deprecated_member_use
    return prefs.commit();
  }

  Future<CdlUser> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String name = prefs.getString('name').toString();
    String phone = prefs.getString('phone').toString();
    int userid = prefs.getInt('userId')!.toInt();
    String state = prefs.getString('userState').toString();
    int stateid = prefs.getInt('userStateId')!.toInt();
    String country = prefs.getString('userCountry').toString();
    int status = prefs.getInt('userStateStatus')!.toInt();

    return CdlUser(
      name: name,
      phone: phone,
      userid: userid,
      cdlState: CdlState(
        stateid: stateid,
        country: country,
        state: state,
        status: status,
      ),
    );
  }

  Future removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('name');
    prefs.remove('phone');
    prefs.remove('userId');
    prefs.remove('userState');
    prefs.remove('userStateId');
    prefs.remove('userCountry');
    prefs.remove('userStateStatus');
  }
}

class CdlSchoolProvider extends ChangeNotifier {
  CdlSchool _school = new CdlSchool(
    schoolId: 0,
    name: "name",
    phone: "phone",
    image: "image",
    address: "address",
    city: "city",
    state: "state",
    country: "country",
    slotTime: "slotTime",
    schoolTimeFrom: "schoolTimeFrom",
    schoolTimeTo: "schoolTimeTo",
  );

  CdlSchool get school => _school;

  void setSchool(CdlSchool cdlSchool) {
    _school = cdlSchool;
    notifyListeners();
  }
}

class CdlUserProvider extends ChangeNotifier {
  CdlUser _user = new CdlUser(
    name: 'name',
    phone: 'phone',
    userid: 0,
    cdlState: CdlState(
      stateid: 0,
      country: 'country',
      state: 'state',
      status: 0,
    ),
  );

  CdlUser get user => _user;

  void setUser(CdlUser cdlUser) {
    _user = cdlUser;
    notifyListeners();
  }
}
