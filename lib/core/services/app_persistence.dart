import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/irn_filter.dart';
import '../data/models.dart';

const storageKey = "agendar-cc";

class AppPersistanceModel {
  final bool runningFirstTime;
  final UserDataState userData;
  final IrnFilter filter;

  AppPersistanceModel({
    required this.runningFirstTime,
    required this.userData,
    required this.filter,
  });

  AppPersistanceModel copyWith({
    bool? runningFirstTime,
    UserDataState? userData,
    IrnFilter? filter,
  }) {
    return AppPersistanceModel(
      runningFirstTime: runningFirstTime ?? this.runningFirstTime,
      userData: userData ?? this.userData,
      filter: filter ?? this.filter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'runningFirstTime': runningFirstTime,
      'userData': userData.toMap(),
      'filter': filter.toMap(),
    };
  }

  factory AppPersistanceModel.fromMap(Map<String, dynamic> map) {
    return AppPersistanceModel(
      runningFirstTime: map['runningFirstTime'],
      userData: UserDataState.fromMap(map['userData']),
      filter: IrnFilter.fromMap(map['filter']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppPersistanceModel.fromJson(String source) =>
      AppPersistanceModel.fromMap(json.decode(source));
}

var defaultUserData = UserDataState(
  citizenCardNumber: "7343623",
  email: "pedronsousa@gmail.com",
  name: "Pedro Sousa",
  phone: "961377576",
);

var defaultFilter = IrnFilter();

class AppPersistence {
  AppPersistanceModel _storage;
  late SharedPreferences _sharedPreferences;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var persisted = _sharedPreferences.getString(storageKey);
    if (persisted != null) {
      _storage = AppPersistanceModel.fromJson(persisted);
    }
  }

  AppPersistence()
      : _storage = AppPersistanceModel(
            runningFirstTime: true,
            userData: defaultUserData,
            filter: defaultFilter);

  bool get runningFirstTime => _storage.runningFirstTime;
  UserDataState get userData => _storage.userData;
  IrnFilter get filter => _storage.filter;

  void update({
    bool? runningFirstTime,
    UserDataState? userData,
    IrnFilter? filter,
  }) {
    _storage = _storage.copyWith(
      runningFirstTime: runningFirstTime,
      userData: userData,
      filter: filter,
    );

    _sharedPreferences.setString(storageKey, _storage.toJson());
  }
}
