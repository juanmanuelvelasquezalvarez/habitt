import 'data.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Login extends StatefulWidget{
  const Login({super.key});
  @override
  LoginState createState()=>LoginState();
}
class LoginState extends State<Login>{
  final t=[TextEditingController(),TextEditingController()];
  @override
  Widget build(BuildContext c){
    Store p=Provider.of<Store>(c);
    return template(c,7,Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          field(t[0], Icons.person, 'Username'),
          SizedBox(height: 20),
          field(t[1], Icons.lock, 'Password', pw:true),
          SizedBox(height: 20),
          button('Log in', ()async{
            for(int i in [0,1]){
              if(t[i].text.isEmpty){
                show("Empty ${i==0?'username':'password'}");
                return;
              }
              if(t[i].text!=p.getString(i==0?'username':'password')){
                show(i==0?"Unregistered username":"Incorrect password");
                return;
              }
            }
            await Navigator.pushReplacementNamed(c,'/Home');
          }),
          SizedBox(height: 20),
          text('or'),
          SizedBox(height: 10),
          button('Sign up', ()async=>await Navigator.pushNamed(c,'/Register')),
        ],
      ),
    ));
  }
}