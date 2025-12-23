import 'data.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Add extends StatefulWidget{
  const Add({super.key});
  @override
  AddState createState()=>AddState();
}
class AddState extends State<Add>{
  final t=TextEditingController();
  Color color=Colors.amber;//Default
  List<Map<String,int>> m=[{},{}];
  String colorName='Amber';
  @override
  Widget build(BuildContext c){
    Store s=Provider.of<Store>(c);
    for(var i=0;i<2;i++) m[i]=s.getMap<String,int>(i==0?'ToDo':'Done');
    return template(c,1,SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          field(t,Icons.text_fields,'Habit'),
          SizedBox(height: 20),
          text('Color'),
          SizedBox(height: 10),
          list(colorName, colors.keys.map((c)=>DropdownMenuItem<String>(
            value: c,
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors[c],
                borderRadius: BorderRadius.circular(5),
              ),
              child: text(c),
            ),
          )).toList(), (v)=>setState(()=>color=colors[colorName=v!]!)),
          SizedBox(height: 20),
          button('Add Habit', (){
            if(t.text.isNotEmpty) setState((){
              m[0][t.text]=color.toARGB32();
              t.clear();
              color=colors[colorName='Amber']!;
            });
          }),
          SizedBox(height: 20),
          ListView(
            shrinkWrap: true,
            children: {...m[0], ...m[1]}.entries.map((e)=>ListTile(
              leading: CircleAvatar(backgroundColor: Color(e.value)),
              title: text(e.key),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: ()=>setState((){
                  m[0].remove(e.key);
                  m[1].remove(e.key);
                }),
              ),
            )).toList(),
          ),
        ],
      ),
    ));
  }
}