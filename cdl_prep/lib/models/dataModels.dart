import 'package:cdl_prep/models/userModel.dart';

class CdlNotification {
  int id, enrolledTo, enrolledBy;
  CdlSlot slot;
  String status, remarks;

  CdlNotification({
    required this.id,
    required this.enrolledTo,
    required this.enrolledBy,
    required this.slot,
    required this.status,
    required this.remarks,
  });

  factory CdlNotification.fromJson(Map json) {
    return CdlNotification(
      id: json['notificationid'],
      enrolledTo: json['slot']['enrollid']['enrollid'],
      enrolledBy: json['slot']['createdby']['userid'],
      slot: CdlSlot.fromJson(json['slot']),
      status: json['notificationstatus'],
      remarks: json['remark'],
    );
  }
}

class CdlSlot {
  int slotId;
  CdlStudent enroll;
  DateTime to, from;

  CdlSlot({
    required this.slotId,
    //required this.date,
    required this.from,
    required this.to,
    required this.enroll,
  });

  factory CdlSlot.fromJson(Map json) {
    return CdlSlot(
      slotId: json['slotid'],
      //date: json['slotdate'],
      from: DateTime.parse(json['slotfrom']).add(Duration(hours: 5)),
      to: DateTime.parse(json['slotto']).add(Duration(hours: 5)),
      enroll: CdlStudent.fromJson(json['enrollid']),
    );
  }
}

class CdlQuestions {
  String question;
  String optA, optB, optC;
  String correctAnswer;

  CdlQuestions({
    required this.question,
    required this.optA,
    required this.optB,
    required this.optC,
    required this.correctAnswer,
  });

  factory CdlQuestions.fromJson(Map json) {
    return CdlQuestions(
      question: json['question'],
      optA: json['optA'],
      optB: json['optB'],
      optC: json['optC'],
      correctAnswer: json['answer'],
    );
  }
}

class ScreenArguments {
  final String content;
  final String message;

  ScreenArguments(this.content, this.message);
}

class CdlCategory {
  String name;
  int categoryId, status;

  CdlCategory({
    required this.categoryId,
    required this.name,
    required this.status,
  });

  factory CdlCategory.fromJson(Map responseData) {
    return CdlCategory(
      categoryId: responseData['categoryid'],
      name: responseData['name'],
      status: responseData['status'],
    );
  }
}

class CdlState {
  String state, country;
  int stateid, status;

  CdlState({
    required this.stateid,
    required this.country,
    required this.state,
    required this.status,
  });

  factory CdlState.fromJson(Map responseData) {
    return CdlState(
      stateid: responseData['stateid'],
      country: responseData['country'],
      state: responseData['state'],
      status: responseData['status'],
    );
  }
}

class CdlAnswers {
  String answerId, statement;

  CdlAnswers({
    required this.answerId,
    required this.statement,
  });

  factory CdlAnswers.fromJson(Map option) {
    return CdlAnswers(answerId: "answerId", statement: "statement");
  }
}
