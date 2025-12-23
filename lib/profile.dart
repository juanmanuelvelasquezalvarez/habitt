import 'dart:convert';
import 'data.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
class Profile extends StatefulWidget{
  final bool logged;
  const Profile(this.logged, {super.key});
  @override
  ProfileState createState()=>ProfileState();
}
class ProfileState extends State<Profile>{
  var t=[TextEditingController(),TextEditingController()];
  int age=35;
  String nation='Colombia';
  List<String> nations=[];
  List<String> habits=[];
  bool get b=>widget.logged;
  @override
  void initState(){
    super.initState();
    if(!b) t.add(TextEditingController());
    get(url).then((r)=>setState(()=>nations=List<String>.from(jsonDecode(r.body))));
  }
  @override
  Widget build(BuildContext c){
    Store s=Provider.of<Store>(c);
    if(b) setState((){
      t[0].text=s.getString('name');
      t[1].text=s.getString('username');
      age=s.getInt('age');
      nation=s.getString('nation');
    });
    return template(c,b?4:6,SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          field(t[0], Icons.person, 'Name'),
          SizedBox(height: 10),
          field(t[1], Icons.person, 'Username'),
          SizedBox(height: 10),
          if(!b) field(t[2], Icons.lock, 'Password', pw:true),
          if(!b) SizedBox(height: 10),
          text('Age: ${age.round()}'),
          Slider(
            value: age.toDouble(),
            min: 5,
            max: 120,
            divisions: 115,
            onChanged: (v)=>setState(()=>age=v.truncate())
          ),
          SizedBox(height: 10),
          text('Country: $nation'),
          list(null, nations.map((n)=>DropdownMenuItem<String>(
            value: n,
            child: text(n),
          )).toList(), (n)=>setState(()=>nation=n!)),
          SizedBox(height: 10),
          if(!b) text('Select Your Habits'),Wrap(
            spacing: 10,
            runSpacing: 10,
            children: availableHabits.map((h)=>GestureDetector(
              onTap: ()=>setState((){
                if(habits.contains(h)) habits.remove(h);
                else habits.add(h);
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: habits.contains(h)?Colors.white:Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: text(h),
              ),
            )).toList(),
          ),
          if(!b) SizedBox(height: 20),
          Center(
            child: button(b?'Save Changes':'Register', ()async{
              if(t[0].text.isEmpty||t[1].text.isEmpty||t[2].text.isEmpty||nation.isEmpty){
                show('Fill in all fields');
                return;
              }
              await s.setString('name', t[0].text);
              await s.setString('username', t[1].text);
              await s.setString('password', t[2].text);
              await s.setInt('age', age);
              await s.setString('nation', nation);
              if(b) show("Profile updated successfully");
              else{
                await s.setMap('ToDo', {for(var h in habits) h:Colors.white.toARGB32()});
                await Navigator.pushReplacementNamed(c, '/Home');
              }
            }),
          ),
        ],
      ),
    ));
  }
}