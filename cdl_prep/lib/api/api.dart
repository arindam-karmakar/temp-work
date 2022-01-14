import 'dart:convert';

import 'package:cdl_prep/api/httpHandle.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WebApi {
  final String _apiKey = 'ak8nui95ml00a12rw5in55gs';
  final String _baseUrl = 'www.cdlprepapp.com';

  final String _getCategoryListPath = 'api/getcategorylist';
  final String _sendOtpPath = 'api/sendotpviaphone';
  final String _changePasswordPath = 'api/changepswd';
  //final String _profilePictureUpdatePath = 'api/profilepicupdate';
  final String _getStateListPath = 'api/getstatelist';
  final String _getQuestionPath = 'api/quesbystatecategory';
  final String _setScorePath = 'api/setscorebyuser';
  final String _validatePhonePath = 'api/validatephone';
  final String _preTripPath = 'api/getenrollbypretrip';
  final String _skillPath = 'api/getenrollbyskillready';
  final String _roadPath = 'api/getenrollbyroadready';
  final String _enrolledToSchoolPath = 'api/getenrolllist';
  final String _enrollStudentPath = 'api/addenroll';
  final String _enrollSetSlotPath = 'api/setslotbyenroll';
  final String _enrollGetSlotPath = 'api/getslotbyenroll';
  final String _getUserIdPath = 'api/userbyphone';
  final String _getSlotByDatePath = 'api/getslotbyschool';
  final String _setNotifPath = 'api/setnotification';
  final String _getNotifPath = 'api/getnotification';
  final String _editNotifPath = 'api/editnotification';
  final String _notifCountPath = 'api/notificationcount';
  final String _markNotifPath = 'api/readnotification';

  HandleHTTP httpHandler = new HandleHTTP();

  Future<List<CdlCategory>> getCategories() async {
    final _url = Uri.http(
      _baseUrl,
      _getCategoryListPath,
      {
        'apikey': _apiKey,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      List<CdlCategory> listOfCategories = (response['response'] as List)
          .map((e) => CdlCategory.fromJson(e))
          .toList();
      return listOfCategories;
    } else {
      return [
        CdlCategory.fromJson({
          'categoryid': 0,
          'name': "null",
          'status': 0,
        })
      ];
    }
  }

  Future<String> getOtpByPhone(String phoneNumber) async {
    final _url = Uri.https(
      _baseUrl,
      _sendOtpPath,
      {
        'phone': "1" + phoneNumber,
        'apikey': _apiKey,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      return response['response']['otp'].toString().trim();
    } else {
      return "Error ${response['statusCode']}";
    }
  }

  Future<String> changePassword(String phone, String newPassword) async {
    final _url = Uri.http(
      _baseUrl,
      _changePasswordPath,
      {
        'phone': phone,
        'apikey': _apiKey,
        'newpassword': newPassword,
      },
    );

    final response = await httpHandler.getData(_url);

    return response['responseMessage'];
  }

  Future<List<CdlState>> getStates() async {
    final _url = Uri.http(
      _baseUrl,
      _getStateListPath,
      {
        'apikey': _apiKey,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      List<CdlState> listOfStates = (response['response'] as List)
          .map((e) => CdlState.fromJson(e))
          .toList();
      return listOfStates;
    } else {
      return [
        CdlState(
          stateid: 0,
          country: "null",
          state: "null",
          status: 0,
        )
      ];
    }
  }

  Future<List<CdlQuestions>> getQuestions(
      String categoryId, String stateId) async {
    List<CdlQuestions> listOfQuestions = [];
    final _url = Uri.http(
      _baseUrl,
      _getQuestionPath,
      {
        'apikey': _apiKey,
        'category': categoryId,
        'state': stateId,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      listOfQuestions = (response['response'] as List)
          .map((e) => CdlQuestions.fromJson(e))
          .toList();
      return listOfQuestions;
    } else {
      listOfQuestions = [
        CdlQuestions(
          question: 'null',
          correctAnswer: 'null',
          optA: 'optA',
          optB: 'optB',
          optC: 'optC',
        ),
      ];
      return listOfQuestions;
    }
  }

  Future<String> setUserScore(
    String userId,
    String categoryId,
    int totalanswer,
    int wronganswer,
    int rightanswer,
  ) async {
    final _url = Uri.http(
      _baseUrl,
      _setScorePath,
      {
        'apikey': _apiKey,
        'user': userId,
        'category': categoryId,
        'state': "1",
        'totalanswer': totalanswer.toString(),
        'wronganswer': wronganswer.toString(),
        'rightanswer': rightanswer.toString(),
      },
    );

    final response = await httpHandler.getData(_url);

    return response['responseMessage'];
  }

  Future<bool> checkPhone(String phone) async {
    final _url = Uri.http(
      _baseUrl,
      _validatePhonePath,
      {
        'phone': phone,
        'apikey': _apiKey,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS")
      return true;
    else
      return false;
  }

  Future<dynamic> getUserDetails(String phone) async {
    final _url = Uri.https(
      _baseUrl,
      _getUserIdPath,
      {
        'phone': phone,
        'apikey': _apiKey,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS")
      return response['response']['userid'].toString();
    else
      return false;
  }

  Future<String> checkLoginAccount(String phone) async {
    final _url = Uri.http(
      _baseUrl,
      _validatePhonePath,
      {
        'phone': phone,
        'apikey': _apiKey,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "ERROR")
      return response['response'];
    else
      return "false";
  }

  Future<List<CdlStudent>> getPreTrip(int schoolId) async {
    final _url = Uri.http(
      _baseUrl,
      _preTripPath,
      {
        'apikey': _apiKey,
        'pretrip': "yes",
        'userid': schoolId.toString(),
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      final List<CdlStudent> listOfStudent = (response['response'] as List)
          .map((e) => CdlStudent.fromJson(e))
          .toList();

      return listOfStudent;
    } else {
      return [];
    }
  }

  Future<List<CdlStudent>> getSkill(int schoolId) async {
    final _url = Uri.http(
      _baseUrl,
      _skillPath,
      {
        'apikey': _apiKey,
        'skillready': "yes",
        'userid': schoolId.toString(),
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      final List<CdlStudent> listOfStudent = (response['response'] as List)
          .map((e) => CdlStudent.fromJson(e))
          .toList();

      return listOfStudent;
    } else {
      return [];
    }
  }

  Future<List<CdlStudent>> getRoad(int schoolId) async {
    final _url = Uri.http(
      _baseUrl,
      _roadPath,
      {
        'apikey': _apiKey,
        'roadready': "yes",
        'userid': schoolId.toString(),
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      final List<CdlStudent> listOfStudent = (response['response'] as List)
          .map((e) => CdlStudent.fromJson(e))
          .toList();

      return listOfStudent;
    } else {
      return [];
    }
  }

  Future<List<CdlStudent>> getEnroll(int schoolId) async {
    final _url = Uri.http(
      _baseUrl,
      _enrolledToSchoolPath,
      {
        'apikey': _apiKey,
        'userid': schoolId.toString(),
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      final List<CdlStudent> listOfStudent = (response['response'] as List)
          .map((e) => CdlStudent.fromJson(e))
          .toList();

      return listOfStudent;
    } else {
      return [
        CdlStudent(
          enrollId: 0,
          name: "name",
          phone: "phone",
          image: "null",
          cityState: "cityState",
          cdlState: CdlState(
            stateid: 0,
            country: "country",
            state: "state",
            status: 0,
          ),
          testSchedule: "testSchedule",
          preTripReady: "preTripReady",
          skillReady: "skillReady",
          roadReady: "roadReady",
          paymentStatus: "paymentStatus",
        ),
      ];
    }
  }

  Future<String> addEnroll(
    String name,
    String phone,
    String address,
    String city,
    String state,
    String country,
    String pretrip,
    String skillready,
    String roadready,
    String cdlstate,
    String paymentstatus,
    String testschedulestatus,
    String testschedule,
    String createdby,
    String img,
  ) async {
    final _url = Uri.https(
      _baseUrl,
      _enrollStudentPath,
      {
        'apikey': _apiKey,
        'name': name,
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'pretrip': pretrip,
        'skillready': skillready,
        'roadready': roadready,
        'cdlstate': cdlstate,
        'paymentstatus': paymentstatus,
        'testschedulestatus': testschedulestatus,
        'testschedule': testschedule,
        'createdby': createdby,
      },
    );

    var request = http.MultipartRequest('POST', _url)
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
      })
      ..files.add(new http.MultipartFile(
        'img',
        File(img).readAsBytes().asStream(),
        (await File(img).length()),
        filename: img.split("/").last,
      ));

    String resp = await httpHandler.multipartRequest(request);
    return resp;
  }

  Future<http.Response> getProfilePic(String profilePicPath) async {
    final _url = Uri.https(_baseUrl, profilePicPath);
    //http.Response response;

    var request = http.MultipartRequest('GET', _url)
      ..headers.addAll({'Accept': '*/*'});

    try {
      var response = await http.Response.fromStream(await request.send());
      // response = await http.get(_url);
      return response;
    } catch (e) {
      var response = http.Response('null', 400);
      return response;
    }
  }

  Future<bool> setSlot(
    //String slotdate,
    String slotto,
    String slotfrom,
    String userid,
    String enrollid,
    String enrollPhone,
    String schoolName,
  ) async {
    final _url = Uri.https(
      _baseUrl,
      _enrollSetSlotPath,
      {
        'apikey': _apiKey,
        //'slotdate': slotdate,
        'slotto': slotto,
        'slotfrom': slotfrom,
        'userid': userid,
        'enrollid': enrollid,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == 'SUCCESS') {
      int slotId = response['response']['slotid'];

      var isReg = await getUserDetails(enrollPhone);

      if (isReg != false)
        await setNotifications(
          "Pending",
          slotId.toString(),
          isReg.toString(),
          userid,
          schoolName,
        );

      return true;
    } else
      return false;
  }

  Future<List<CdlSlot>> getSlot(String enrollId) async {
    final _url = Uri.http(
      _baseUrl,
      _enrollGetSlotPath,
      {
        'apikey': _apiKey,
        'enrollid': enrollId,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == 'SUCCESS') {
      List<CdlSlot> slots = (response['response'] as List)
          .map((e) => CdlSlot.fromJson(e))
          .toList();

      return slots;
    } else
      return [];
  }

  Future<List<CdlSlot>> getSlotByDate(
    String userId,
    String date,
  ) async {
    final _url = Uri.https(
      _baseUrl,
      _getSlotByDatePath,
      {
        'apikey': _apiKey,
        'userid': userId,
        'date': date,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == 'SUCCESS') {
      List<CdlSlot> listOfSlots = (response['response'] as List)
          .map((e) => CdlSlot.fromJson(e))
          .toList();

      for (var i = 0; i < listOfSlots.length; i++) {
        for (var j = 0; j < listOfSlots.length - 1; j++) {
          if (listOfSlots[j].from.compareTo(listOfSlots[j + 1].from) > 0) {
            CdlSlot temp = listOfSlots[j];
            listOfSlots[j] = listOfSlots[j + 1];
            listOfSlots[j + 1] = temp;
          }
        }
      }

      return listOfSlots;
    } else
      return [];
  }

  Future<List<Map<String, dynamic>>> createSlots(
    CdlSchool school,
    DateTime date,
  ) async {
    List<Map<String, dynamic>> availableSlots = [];

    List<CdlSlot> slotsByDate = await getSlotByDate(
      school.schoolId.toString(),
      DateFormat('yyyy-MM-dd', 'en_US').format(date),
    );

    List<String> bookedSlots = [];

    for (var i = 0; i < slotsByDate.length; i++) {
      bookedSlots.add(DateFormat('HH:mm', 'en_US').format(slotsByDate[i].from));
    }

    int count = ((DateTime.parse(
                    "${DateFormat('yyyy-MM-dd', 'en_US').format(date)} ${school.schoolTimeTo.replaceAll(RegExp(r'%3A'), ':')}")
                .difference(DateTime.parse(
                    "${DateFormat('yyyy-MM-dd', 'en_US').format(date)} ${school.schoolTimeFrom.replaceAll(RegExp(r'%3A'), ':')}"))
                .inMinutes) /
            int.parse(school.slotTime))
        .round();

    DateTime startTime = DateTime.parse(
        "${DateFormat('yyyy-MM-dd', 'en_US').format(date)} ${school.schoolTimeFrom.replaceAll(RegExp(r'%3A'), ':')}");

    for (int i = 0; i < count; i++) {
      availableSlots.add({
        'start': startTime,
        'end': startTime.add(Duration(minutes: int.parse(school.slotTime))),
        'available': (bookedSlots
                .contains(DateFormat('HH:mm', 'en_US').format(startTime)))
            ? false
            : true,
      });

      startTime = startTime.add(Duration(minutes: int.parse(school.slotTime)));
    }

    return availableSlots;
  }

  Future<List<CdlStudent>> getTestDate(
    int schoolId,
    DateTime date,
  ) async {
    List<CdlStudent> listOfStudents = await getEnroll(schoolId);
    List<CdlStudent> testToday = [];

    for (var i = 0; i < listOfStudents.length; i++) {
      if (listOfStudents[i].testSchedule.split(" ")[0] ==
          DateFormat('yyyy-MM-dd', 'en_US').format(date)) {
        testToday.add(listOfStudents[i]);
      }
    }

    for (var j = 0; j < testToday.length - 1; j++) {
      if (DateTime.parse(testToday[j].testSchedule)
              .compareTo(DateTime.parse(testToday[j + 1].testSchedule)) >
          0) {
        CdlStudent temp = testToday[j];
        testToday[j] = testToday[j + 1];
        testToday[j + 1] = temp;
      }
    }

    return testToday;
  }

  Future<String> setNotifications(
    String notificationstatus,
    String slotid,
    String userid,
    String createdby,
    String notifierName,
  ) async {
    final _url = Uri.https(
      _baseUrl,
      _setNotifPath,
      {
        'apikey': _apiKey,
        'notificationstatus': notificationstatus,
        'slotid': slotid,
        'userid': userid,
        'createdby': createdby,
        'remark': notifierName,
      },
    );

    final response = await httpHandler.getData(_url);

    return response['responseMessage'] as String;
  }

  Future<List<CdlNotification>> getNotifications(String userid) async {
    final _url = Uri.https(
      _baseUrl,
      _getNotifPath,
      {
        'apikey': _apiKey,
        'userid': userid,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == 'SUCCESS') {
      List<CdlNotification> listOfNotif = (response['response'] as List)
          .map((e) => CdlNotification.fromJson(e))
          .toList();

      return listOfNotif;
    } else
      return [];
  }

  Future<String> editNotifications(
    String notificationstatus,
    String modifiedby,
    String remark,
    String notificationid,
  ) async {
    final _url = Uri.https(
      _baseUrl,
      _editNotifPath,
      {
        'apikey': _apiKey,
        'notificationstatus': notificationstatus,
        'modifiedby': modifiedby,
        'remark': remark,
        'notificationid': notificationid,
      },
    );

    final response = await httpHandler.getData(_url);

    return response['responseMessage'] as String;
  }

  Future<int> getNotifCount(String userid) async {
    final _url = Uri.https(
      _baseUrl,
      _notifCountPath,
      {
        'apikey': _apiKey,
        'userid': userid,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == 'SUCCESS')
      return response['response'] as int;
    else
      return 0;
  }

  Future<void> markNotif(List<CdlNotification> data) async {
    for (var i = 0; i < data.length; i++) {
      final _url = Uri.https(
        _baseUrl,
        _markNotifPath,
        {
          'apikey': _apiKey,
          'notificationid': data[i].id.toString(),
        },
      );

      await httpHandler.getData(_url);
    }
  }
}

class GlobalSearchProvider extends ChangeNotifier {
  final String _apiKey = 'ak8nui95ml00a12rw5in55gs';
  final String _baseUrl = 'www.cdlprepapp.com';

  final String _enrollByNamePath = 'api/getenrollbyname';
  final String _enrollByPhonePath = 'api/getenrollbyphone';
  final String _preTripPath = 'api/getenrollbypretrip';
  final String _skillPath = 'api/getenrollbyskillready';
  final String _roadPath = 'api/getenrollbyroadready';

  HandleHTTP httpHandler = new HandleHTTP();
  WebApi webApi = new WebApi();

  Future<List<CdlStudent>> fetchNameData(String name, String userid) async {
    final _url = Uri.https(
      _baseUrl,
      _enrollByNamePath,
      {
        'apikey': _apiKey,
        'name': name,
        'userid': userid,
      },
    );

    final response = await httpHandler.getData(_url);
    notifyListeners();

    if (response['responseMessage'] == 'SUCCESS') {
      List<CdlStudent> enroll = (response['response'] as List)
          .map((e) => CdlStudent.fromJson(e))
          .toList();

      notifyListeners();

      return enroll;
    } else {
      notifyListeners();

      return [];
    }
  }

  Future<List<CdlStudent>> fetchNumberData(String phone, String userid) async {
    final _url = Uri.https(
      _baseUrl,
      _enrollByPhonePath,
      {
        'apikey': _apiKey,
        'phone': phone,
        'userid': userid,
      },
    );

    final response = await httpHandler.getData(_url);
    notifyListeners();

    if (response['responseMessage'] == 'SUCCESS') {
      List<CdlStudent> enroll = (response['response'] as List)
          .map((e) => CdlStudent.fromJson(e))
          .toList();

      notifyListeners();

      return enroll;
    } else {
      notifyListeners();

      return [];
    }
  }

  Future<List<CdlStudent>> getPreTripReady(int schoolId) async {
    notifyListeners();
    return await webApi.getPreTrip(schoolId);
  }

  Future<List<CdlStudent>> getSkillReady(int schoolId) async {
    notifyListeners();
    return await webApi.getSkill(schoolId);
  }

  Future<List<CdlStudent>> getRoadReady(int schoolId) async {
    notifyListeners();
    return await webApi.getRoad(schoolId);
  }
}

class LocationProvider extends ChangeNotifier {
  final String _baseUrl = 'maps.googleapis.com';
  final String _autoCompletePath = 'maps/api/place/autocomplete/json';
  final String _apiKey = 'AIzaSyDe-AJ4JsNmj9je_G61gcgBgegOtI8k7CY';

  HandleHTTP httpHandler = new HandleHTTP();

  Future<List> getLocations(String input) async {
    final _url = Uri.https(
      _baseUrl,
      _autoCompletePath,
      {
        'input': input,
        'types': "geocode",
        'key': _apiKey,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['status'] == "OK") {
      notifyListeners();
      return response['predictions'] as List;
    } else
      return [];
  }
}

class AuthProvider extends ChangeNotifier {
  final String _apiKey = 'ak8nui95ml00a12rw5in55gs';
  final String _baseUrl = 'www.cdlprepapp.com';

  final String _loginPath = 'api/login';
  final String _signupPath = 'api/signup';
  final String _schoolSetPassword = 'api/setpswd';
  final String _updatePath = 'api/updateschool';
  final String _updatePicPath = 'api/profilepicupdate';

  UserStatus _currentUserStatus = UserStatus.NotLoggedIn;
  UserStatus get currentUserStatus => _currentUserStatus;

  HandleHTTP httpHandler = new HandleHTTP();

  Future<Map<String, String>> profilePic(
    String userid,
    String img,
  ) async {
    final _url = Uri.https(
      _baseUrl,
      _updatePicPath,
      {
        'apikey': _apiKey,
        'userid': userid,
      },
    );

    var request = http.MultipartRequest('POST', _url)
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
      })
      ..files.add(new http.MultipartFile(
        'file',
        File(img).readAsBytes().asStream(),
        (await File(img).length()),
        filename: img.split("/").last,
      ));

    try {
      http.Response _response =
          await http.Response.fromStream(await request.send());

      if (_response.statusCode == 201 || _response.statusCode == 200) {
        await UserPreferences()
            .updatePicPath(jsonDecode(_response.body)['response']['img']);
        notifyListeners();
        return {
          'responseMessage': "SUCCESS",
          'data': jsonDecode(_response.body)['response']['img'],
        };
      } else {
        return {
          'responseMessage': "ERROR",
          'data': _response.statusCode.toString(),
        };
      }
    } catch (e) {
      return {
        'responseMessage': "ERROR",
        'data': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateSchool(
    String name,
    String phone,
    String address,
    String city,
    String state,
    String country,
    String slottime,
    String schooltimefrom,
    String schooltimeto,
    String userid,
  ) async {
    final _url = Uri.http(
      _baseUrl,
      _updatePath,
      {
        'apikey': _apiKey,
        'schoolname': name,
        'phoneverify': "1",
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'slottime': slottime,
        'schooltimefrom': schooltimefrom,
        'schooltimeto': schooltimeto,
        'userid': userid,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      CdlSchool authSchool = CdlSchool.fromJson(response['response']);
      UserPreferences().saveSchool(authSchool);
      UserPreferences().setLastUserType("school");

      notifyListeners();
      return {
        'status': true,
        'school': authSchool,
      };
    } else {
      return {'status': false};
    }
  }

  Future<CdlSchool> loginSchool(String phone, String password) async {
    final _url = Uri.http(
      _baseUrl,
      _loginPath,
      {
        'username': phone,
        'password': password,
        'apikey': _apiKey,
        'usertype': "School",
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      CdlSchool authSchool = CdlSchool.fromJson(response['response']);
      UserPreferences().saveSchool(authSchool);
      UserPreferences().setLastUserType("school");

      _currentUserStatus = UserStatus.LoggedIn;
      notifyListeners();

      return authSchool;
    } else {
      _currentUserStatus = UserStatus.NotLoggedIn;
      notifyListeners();

      return CdlSchool(
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
    }
  }

  Future<bool> setSchPswd(
    int schoolId,
    String password,
  ) async {
    final _url = Uri.http(
      _baseUrl,
      _schoolSetPassword,
      {
        'userid': schoolId.toString(),
        'apikey': _apiKey,
        'password': password,
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      return true;
    } else {
      return false;
    }
  }

  Future<CdlSchool> signupSchool(
    String name,
    String password,
    String phone,
    String address,
    String city,
    String state,
    String country,
    String slottime,
    String schooltimefrom,
    String schooltimeto,
  ) async {
    final _url = Uri.http(
      _baseUrl,
      _signupPath,
      {
        'apikey': _apiKey,
        'schoolname': name,
        'phoneverify': "1",
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'slottime': slottime,
        'schooltimefrom': schooltimefrom,
        'schooltimeto': schooltimeto,
        'usertype': "School",
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      CdlSchool school = CdlSchool.fromJson(response['response']);
      late final CdlSchool finalSchool;
      (await setSchPswd(school.schoolId, password))
          ? finalSchool = await loginSchool(school.phone, password)
          : finalSchool = CdlSchool(
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

      return finalSchool;
    } else {
      return CdlSchool(
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
    }
  }

  Future<CdlUser> login(String phone, String password) async {
    final _url = Uri.http(
      _baseUrl,
      _loginPath,
      {
        'username': phone,
        'password': password,
        'apikey': _apiKey,
        'usertype': "Student",
      },
    );

    //_currentUserStatus = UserStatus.Authenticating;
    //notifyListeners();

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      CdlUser authUser = CdlUser.fromJson(response['response']);
      UserPreferences().saveUser(authUser);
      UserPreferences().setLastUserType("student");

      _currentUserStatus = UserStatus.LoggedIn;
      notifyListeners();

      return authUser;
    } else {
      _currentUserStatus = UserStatus.NotLoggedIn;
      notifyListeners();

      return CdlUser(
        userid: 0,
        name: "null",
        phone: "null",
        cdlState: CdlState(
          stateid: 0,
          country: "country",
          state: "state",
          status: 0,
        ),
      );
    }
  }

  Future<CdlUser> signup(
    String name,
    String password,
    String otpVerified,
    String phone,
    String cdlstate,
  ) async {
    final _url = Uri.http(
      _baseUrl,
      _signupPath,
      {
        'apikey': _apiKey,
        'name': name,
        'password': password,
        'phoneverify': otpVerified,
        'phone': phone,
        'cdlstate': cdlstate,
        'usertype': "Student",
      },
    );

    final response = await httpHandler.getData(_url);

    if (response['responseMessage'] == "SUCCESS") {
      CdlUser authUser = CdlUser.fromJson(response['response']);

      CdlUser newUser = await login(authUser.phone, password);

      return newUser;
    } else {
      return CdlUser(
        userid: 0,
        name: "null",
        phone: "null",
        cdlState: CdlState(
          stateid: 0,
          country: "country",
          state: "state",
          status: 0,
        ),
      );
    }
  }

  Future logout() async {
    UserPreferences().saveUser(
      CdlUser(
        userid: 0,
        name: "null",
        phone: "null",
        cdlState: CdlState(
          stateid: 0,
          country: "null",
          state: "null",
          status: 0,
        ),
      ),
    );
    UserPreferences().setLastUserType("student");

    notifyListeners();
  }
}
