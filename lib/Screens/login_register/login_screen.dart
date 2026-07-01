import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_location/Screens/login_register/register_screen.dart';
import 'package:maps_location/services/auth_Services.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginScreen();

}
class _LoginScreen extends State<LoginScreen>{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Login"),
       centerTitle: true,
     ),
     body: Form(
         key : _formKey,
         child: Padding(padding: EdgeInsets.all(20),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             TextFormField(
               controller: emailController,
               decoration: InputDecoration(
                 icon: Icon(Icons.email),
                 hintText: "Email",
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                 ),
               ),

             ),
             const SizedBox(height: 15),
             TextFormField(
               controller: passwordController,
               decoration: InputDecoration(
                 icon: Icon(Icons.password),
                 hintText: "Password",
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                 ),
               ),
             ),
             const SizedBox(height: 15),
             InkWell(
               onTap: (){

                 Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));

               },
               child: Text("Not Have An Account ? Register"),
             ),
             const SizedBox(height: 15),
             ElevatedButton(onPressed: (){
               if(_formKey.currentState!.validate()){
                 AuthServices().login(emailController.text, passwordController.text);
               }

             }, child: Text("Login"))
           ],
         ),))
   );
  }

}