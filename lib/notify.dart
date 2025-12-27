import 'dart:html' as html;
import 'data.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Notify extends StatefulWidget {
  const Notify({super.key});
  @override
  NotifyState createState()=>NotifyState();
}
class NotifyState extends State<Notify>{
  bool enabled=false;
  List<String> habits=[];
  List<String> times=[];
  Map<String,int> all={};
  late Store s;
  void save() async{
    await s.setBool('notify', enabled);
    await s.setList('notifyHabits', habits);
    await s.setList('notifyTimes', times);
  }
  @override
  Widget build(BuildContext c){
    s=Provider.of<Store>(c);
    enabled=s.getBool('notify');
    all=s.getMap<String,int>('ToDo');
    habits=s.getList('notifyHabits');
    times=s.getList('notifyTimes');
    return template(c,3,Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SwitchListTile(
            title: text('Enable Notifications',size:24),
            value: enabled,
            onChanged: (v)async{
              setState(()=>enabled=v);
              save();
            },
          ),
          Divider(),
          text('Select Habits to Notify'),
          SizedBox(height: 10),
          ...all.entries.map((e){
            final c=Color(e.value);
            return FilterChip(
              label: text(e.key),
              labelStyle: TextStyle(color: c),
              selected: habits.contains(e.key),
              selectedColor: c.withOpacity(0.3),
              side: BorderSide(color: c, width: 2),
              onSelected: (b){
                setState((){
                  if(b) habits.add(e.key);
                  else habits.remove(e.key);
                });
                save();
              },
            );
          }),
          SizedBox(height: 20),
          text('Select Times to Notify'),
          SizedBox(height: 10),
          ...['Morning','Afternoon','Evening'].map((t)=>FilterChip(
            label: text(t),
            selected: times.contains(t),
            onSelected: (b){
              setState(() {
                if(b) times.add(t);
                else times.remove(t);
              });
              save();
            },
          )),
          Spacer(),
          button('Send Test Notification', (){
            if(html.Notification.permission!="granted") html.Notification.requestPermission().then((p){
              if(p=='granted'){
                html.Notification("Habit Reminder", body: "It's time to work on your habits!");
                show('Notification permission granted. Notification sent.');
              }else show('Notification permission denied.');
            });
            else{
              html.Notification("Habit Reminder",
                body: "It's time to work on your habits!");
              show('Notification sent directly.');
            }
          }),
        ],
      ),
    ));
  }
}