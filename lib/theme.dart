import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
void show(String s)=>Fluttertoast.showToast(
  msg: s,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  fontSize: 16,
);
Text text(String s, {size=18})=>Text(s, style:TextStyle(
  fontSize: size,
  fontWeight: FontWeight.bold,
));
Widget button(String s, VoidCallback f)=>ElevatedButton(
  onPressed: f,
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
    elevation: 5,
  ),
  child: text(s)
);
Container field(TextEditingController c, IconData i, String s, {pw=false})=>Container(
  padding: EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
  child: TextField(
    controller: c,
    obscureText: pw,
    maxLength: 255,
    decoration: InputDecoration(
      prefixIcon: Icon(i),
      hintText: s,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)
    ),
  ),
);
Container list(String? v, List<DropdownMenuItem<String>> d, ValueChanged c)=>Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(),
            ),
            child: DropdownButton<String>(
              value: v,
              icon: Icon(Icons.arrow_drop_down),
              underline: SizedBox(),
              items: d,
              onChanged: c
            ),
          );
const page=['Home','Add habit','Log out','Notifications','User data','Weekly Report','Register','Log in'];
const icon=[Icons.home,Icons.add,Icons.logout,Icons.notifications,Icons.person,Icons.view_week,Icons.dynamic_form,Icons.login];
Scaffold template(BuildContext c, int t, Widget w)=>Scaffold(
  appBar: AppBar(
    centerTitle: true,
    title: text(page[t],size:24),
    leading: t==0?null:Icon(icon[t])
  ),
  drawer: t>5?null:Drawer(
    child: ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(),
          child: text('Menu',size:24),
        ),
        ...[for(int i=t==0?1:0;i<6;i+=i==t-1?2:1) ListTile(
          leading: Icon(icon[i]),
          title: text(page[i]),
          onTap: ()async{
            if(i==2) await Navigator.pushReplacementNamed(c,'/');
            else await Navigator.pushNamed(c,'/${page[i].trim()}');
          }
        )]
      ],
    ),
  ),
  body: w
);