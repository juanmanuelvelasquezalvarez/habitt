import 'dart:convert';
import 'data.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Home extends StatefulWidget{
  const Home({super.key});
  @override
  HomeState createState()=>HomeState();
}
class HomeState extends State<Home>{
  List<Map<String,int>> m=[{},{}];
  String name='';
  @override
  Widget build(BuildContext c){
    Store s=Provider.of<Store>(c);
    setState((){
      name=s.getString('name');
      for(var i=0;i<2;i++) m[i]=s.getMap<String,int>(i==0?'ToDo':'Done');
    });
    return template(c,0,Column(
      children: [2,0,4,3,1].map((i)=>i==4?Divider():i>1?Padding(
      padding: EdgeInsets.all(8),
      child: text(i<3?'To Do 📝':'Done ✅🎉')
    ):m[i].isEmpty?i==0?Expanded(
      child: Center(
        child: text('Use the + button to create some habits!'),
      ),
    ):Padding(
      padding: EdgeInsets.all(16),
      child: text('Swipe right on an activity to mark as done.'),
    ):Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(16),
        itemCount: m[i].length,
        itemBuilder: (_,j){
          String h=m[i].keys.elementAt(j);
          return Dismissible(
            key: Key(h),
            direction: i==1?DismissDirection.startToEnd:DismissDirection.endToStart,
            onDismissed: (_)=>setState(()async{
              m[1-i][h]=m[i].remove(h)!;
              await s.setString(i==1?'ToDo':'Done', jsonEncode(m[1-i]));
            }),
            background: Container(
              color: i==1?Colors.red:Colors.green,
              alignment: i==1?Alignment.centerLeft:Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  text('Swipe to ${i==1?'Undo':'Complete'}'),
                  SizedBox(width: 10),
                  Icon(i==1?Icons.undo:Icons.check),
                ],
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Color(m[i][h]!),
              child: SizedBox(
                height: 60,
                child: ListTile(
                  title: text(h.toUpperCase()),
                  trailing: i==1?Icon(Icons.check_circle, color: Colors.green, size: 28):null,
                ),
              ),
            ),
          );
        },
      ),
    )).toList()));
  }
}