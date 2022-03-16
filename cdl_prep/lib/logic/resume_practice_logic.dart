import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> categories = [
  'Air Brakes',
  'Combinations',
  'Doubles/Triples',
  'General Commercial',
  'Hazmat',
  'Passenger',
  'School Bus',
  'Tanks',
];

class ResumePracticeProvider extends ChangeNotifier {
  String? _lastCategory;
  List<ResumeModule> _modules = [];
  List<Map<String, dynamic>> _categoryWiseQuestionsDone = [];

  String? get lastCategory => _lastCategory;
  List<ResumeModule>? get modules => _modules;
  List<Map<String, dynamic>> get categoryWiseQuestionsDone =>
      _categoryWiseQuestionsDone;

  void resetCategoryWiseQuestionsDone(String category) {
    bool isKeyPresent = false;
    int? keyAt;

    for (var i = 0; i < _categoryWiseQuestionsDone.length; i++) {
      if (_categoryWiseQuestionsDone[i]['key'] ==
          'QuestionsAttempted$category') {
        isKeyPresent = true;
        keyAt = i;
        break;
      }
    }

    if (isKeyPresent) {
      _categoryWiseQuestionsDone.removeAt(keyAt!);
      notifyListeners();
    }
  }

  void setCategoryWiseQuestionsDone(String q, String category) {
    if (_categoryWiseQuestionsDone.isEmpty) {
      _categoryWiseQuestionsDone.add({
        'key': 'QuestionsAttempted$category',
        'data': [q],
      });
      notifyListeners();
    } else {
      bool isKeyPresent = false;
      int? keyAt;

      for (var i = 0; i < _categoryWiseQuestionsDone.length; i++) {
        if (_categoryWiseQuestionsDone[i]['key'] ==
            'QuestionsAttempted$category') {
          isKeyPresent = true;
          keyAt = i;
          break;
        }
      }

      if (isKeyPresent) {
        bool isQPresent = false;

        for (var j = 0;
            j < _categoryWiseQuestionsDone[keyAt!]['data'].length;
            j++) {
          if (_categoryWiseQuestionsDone[keyAt]['data'][j] == q) {
            isQPresent = true;
            break;
          }
        }

        if (!isQPresent) {
          _categoryWiseQuestionsDone[keyAt]['data'].add(q);
          notifyListeners();
        }
      } else {
        _categoryWiseQuestionsDone.add({
          'key': 'QuestionsAttempted$category',
          'data': [q],
        });
        notifyListeners();
      }
    }
  }

  void setLastCategory(String input) {
    _lastCategory = input;
    notifyListeners();
  }

  void setModules(ResumeModule input) {
    _modules.add(input);
    notifyListeners();
  }

  void removeModule(int i) {
    _modules.removeAt(i);
    notifyListeners();
  }

  void replaceModule(int i, ResumeModule input) {
    _modules.removeAt(i);
    _modules.insert(i, input);
    notifyListeners();
  }
}

class Progress {
  Future setQuestionsAttempted(String q, String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> getResult = await getQuestionsAttempted(category);

    if (getResult['status'] == 'ok') {
      bool isPresent = false;
      List<String> temp = getResult['data'] as List<String>;

      for (var i = 0; i < getResult['data'].length; i++) {
        if (getResult['data'][i] == q) {
          isPresent = true;
          break;
        }
      }

      if (!isPresent) {
        temp.add(q);
        prefs.setStringList('QuestionsAttempted$category', temp);
      }
    } else {
      prefs.setStringList('QuestionsAttempted$category', [q]);
    }
  }

  Future<Map<String, dynamic>> getQuestionsAttempted(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? temp = prefs.getStringList('QuestionsAttempted$category');

    if (temp == null) {
      return {
        'status': 'error',
        'data': null,
      };
    } else {
      return {
        'status': 'ok',
        'data': temp,
      };
    }

    /*try {
      return {
        'status': 'ok',
        'data': temp.toString(),
      };
    } catch (e) {
      return {
        'status': 'error',
        'data': e,
      };
    }*/
  }

  Future<List> getAllQuestionsAttempted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> modules = [];

    for (var i = 0; i < categories.length; i++) {
      Map temp = await getQuestionsAttempted(categories[i]);

      if (temp['status'] == 'ok') {
        modules.add({
          'key': 'QuestionsAttempted${categories[i]}',
          'data': temp['data'],
        });
      }
    }

    return modules;
  }

  Future<void> resetQuestionsAttempted(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('QuestionsAttempted$category');
  }

  Future save(ResumeModule data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList(data.categoryName!, [
      data.categoryId!.toString(),
      data.question!.toString(),
    ]);
  }

  Future<Map> get(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      List<String>? temp = prefs.getStringList(key);

      return {
        'status': 'ok',
        'data': ResumeModule(
          categoryId: int.parse(temp![0]),
          categoryName: key,
          question: int.parse(temp[1]),
        ),
      };
    } catch (e) {
      return {
        'status': 'error',
        'data': e,
      };
    }
  }

  Future<List<ResumeModule>> getAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ResumeModule> modules = [];

    for (var i = 0; i < categories.length; i++) {
      Map temp = await get(categories[i]);

      if (temp['status'] == 'ok') {
        modules.add(temp['data']);
      }
    }

    return modules;
  }

  Future remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(key);
  }

  Future setLast(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('lastCategoryPractice', category);
  }

  Future<Map<String, dynamic>> getLast() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String? temp = prefs.getString('lastCategoryPractice');
      return {
        'status': 'ok',
        'data': temp.toString(),
      };
    } catch (e) {
      return {
        'status': 'error',
        'data': e,
      };
    }
  }
}

class ResumeModule {
  String? categoryName;
  int? categoryId, question;

  ResumeModule({
    this.categoryName,
    this.categoryId,
    this.question,
  });

  factory ResumeModule.fromJson(Map json) {
    return ResumeModule(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      question: json['question'],
    );
  }
}
