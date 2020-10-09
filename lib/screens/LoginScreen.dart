import 'package:authbase/screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget{

final _phoneController=TextEditingController();
final _codeController=TextEditingController();

Future<bool> loginUser(String phone,BuildContext context)async{
  FirebaseAuth _auth=FirebaseAuth.instance;
  _auth.verifyPhoneNumber(
    phoneNumber: phone,
    timeout: Duration(seconds:50),
    verificationCompleted: (AuthCredential credential)async{
      var user=(await _auth.signInWithCredential(credential)).user;

      if(user!=null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(user:user,)));
      }
      else{
        print("ERROR");
      }

    }, 
    verificationFailed: (FirebaseAuthException exception){
      print(exception);
    }, 
    codeSent: (String verificationId,[int forceResendingToken]){
      showDialog(context:context,
      barrierDismissible:false,
      builder:(context){
        return AlertDialog(
          title:Text("One Time Password"),
          content:Column(mainAxisSize:MainAxisSize.min,
          children:<Widget>[TextField(controller: _codeController,),],),


          actions:<Widget>[FlatButton(child:Text("Confirm"),
          textColor: Colors.white,
          color:Colors.blueAccent,
          onPressed: ()async{
            final code=_codeController.text.trim();
            // ignore: deprecated_member_use
            AuthCredential credential=PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);

            var user=(await _auth.signInWithCredential(credential)).user;

            

            if(user!=null){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen(user: user,)));
    
            }
            else{
              print("ERROR");
            }
          },)]
        );
      });
    }, 
    codeAutoRetrievalTimeout: null
    );
    return null;
}




@override
Widget build(BuildContext context){
  return Scaffold(
    body:SingleChildScrollView(child: Container(padding: EdgeInsets.all(32),
    child: Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text("Verify your number",style: TextStyle(color:Colors.blueAccent,fontSize: 36,fontWeight: FontWeight.w500),),
      SizedBox(height:16,),
      TextFormField(
        decoration:InputDecoration(enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.teal)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color:Colors.white)),
        filled:true, fillColor:Colors.white30,hintText: "Mobile Number"),
        controller:_phoneController,
      ),
      SizedBox(height:16,),

      Container(width:double.infinity,child:FlatButton(child: Text("Authenticate"),
      textColor: Colors.white,
      padding: EdgeInsets.all(16),onPressed: (){
        final phone=_phoneController.text.trim();
        loginUser(phone,context);
      },
      color: Colors.cyan,),)
    ],),),),)
  );
}
}
