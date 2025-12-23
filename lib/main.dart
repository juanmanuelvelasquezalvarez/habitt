import 'add_habit.dart';
import 'data.dart';
import 'home.dart';
import 'login.dart';
import 'notify.dart';
import 'profile.dart';
import 'report.dart';
import 'theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async{
  if(kIsWeb) await initLocalStorage();
  runApp(HabitTracker(kIsWeb?localStorage:null,
    kIsWeb?null:await SharedPreferences.getInstance()));
}
class HabitTracker extends StatelessWidget{
  final LocalStorage? l;
  final SharedPreferences? p;
  const HabitTracker(this.l, this.p, {super.key});
  @override
  Widget build(BuildContext _)=>MultiProvider(
    providers: [ChangeNotifierProvider(create: (_)=>Store(l,p))],
    child: MaterialApp(
      initialRoute: '/',
      routes: {for(int i=0;i<7;i++) (i==2?'/':'/${page[i].trim()}'):
        (_)=>i==0?Home():i==1?Add():i==2?Login():i==3?Notify():i==5?Report():Profile(i==4)},
      debugShowCheckedModeBanner: false,
    )
  );
}