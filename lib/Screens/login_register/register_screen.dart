import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_location/Screens/map_screen/locationFinder_screen.dart';
import 'package:maps_location/services/auth_Services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();

}
class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Register"),
       centerTitle: true,
     ),
     body: Form(
       key: _formKey ,
       child: Padding(padding: EdgeInsets.all(20),
       child:  Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           TextFormField(
             controller: userNameController,
             decoration: InputDecoration(
               icon: Icon(Icons.person),

               hintText: "User Name",
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(12),
               ),
             ),
           ),
           const SizedBox(height: 15),
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
           ElevatedButton(onPressed: (){
             if(_formKey.currentState!.validate()){
               AuthServices().createUser(emailController.text, passwordController.text);
               Navigator.push(context, MaterialPageRoute(builder: (context)=> LocationfinderScreen()));
               userNameController.clear();
               emailController.clear();
               passwordController.clear();
             }


           }, child: Text("Register")),
           ElevatedButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> LocationfinderScreen()));


           }, child: Text(" Temporary homeScreen"))
         ],

       ) ,
       ),),

   );
  }

}