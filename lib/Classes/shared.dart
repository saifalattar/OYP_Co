import 'package:OYP/Classes/schemas.dart';
import 'package:OYP/Classes/sectionsWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Future localDataBase = SharedPreferences.getInstance();
String userOTP = "";
String userToken = "";
bool isFav = true;
List<Map> programs = [];
List<Map> apps = [];
List<Design> designs = [];
