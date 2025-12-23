import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
final colors={
  'White': Colors.white,
  'Grey': Colors.grey,
  'Black': Colors.black,
  'Brown': Colors.brown,
  'Red': Colors.red,
  'Orange': Colors.orange,
  'Amber': Colors.amber,
  'Yellow': Colors.yellow,
  'Lime': Colors.lime,
  'Green': Colors.green,
  'Cyan': Colors.cyan,
  'Teal': Colors.teal,
  'Blue': Colors.blue,
  'Indigo': Colors.indigo,
  'Purple': Colors.purple,
  'Pink': Colors.pink
};
List<String> availableHabits=[
  'Wake Up Early',
  'Workout',
  'Drink Water',
  'Meditate',
  'Read a Book',
  'Practice Gratitude',
  'Sleep 8 Hours',
  'Eat Healthy',
  'Journal',
  'Walk 10,000 Steps'
];
final url=Uri.parse('http://localhost:3000');
class Store with ChangeNotifier{
  LocalStorage? l;
  SharedPreferences? p;
  Store(this.l, this.p){
    if(l!=null) initLocalStorage();
  }
  Future<void> setString(String k, String v) async{
    if(l!=null) l!.setItem(k,v);
    else await p!.setString(k,v);
    notifyListeners();
  }
  Future<void> setInt(String k, int v) async{
    if(l!=null) l!.setItem(k,v.toString());
    else await p!.setInt(k,v);
    notifyListeners();
  }
  Future<void> setBool(String k, bool v) async{
    if(l!=null) l!.setItem(k,v?'true':'false');
    else await p!.setBool(k,v);
    notifyListeners();
  }
  Future<void> setList(String k, List<String> v) async{
    if(l!=null) l!.setItem(k,jsonEncode(v));
    else await p!.setStringList(k,v);
    notifyListeners();
  }
  Future<void> setMap<K,V>(String k, Map<K,V> m) async{
    if(l!=null) l!.setItem(k,jsonEncode(m));
    else await p!.setString(k,jsonEncode(m));
  }
  String getString(String k)=>(l!=null?l!.getItem(k):p!.getString(k))??'';
  int getInt(String k){
    if(l!=null){
      var i=l!.getItem(k);
      return i==null?-1:int.parse(i);
    }
    return p!.getInt(k)??-1;
  }
  bool getBool(String k)=>l!=null?l!.getItem(k)=='true':p!.getBool(k)==true;
  List<String> getList(String k){
    if(l!=null){
      var v=l!.getItem(k);
      return v==null?[]:List<String>.from(jsonDecode(v));
    }
    return p!.getStringList(k)??[];
  }
  Map<K,V> getMap<K,V>(String k){
    var m=l!=null?l!.getItem(k):p!.getString(k);
    return m==null?{}:Map<K,V>.from(jsonDecode(m));
  }
}