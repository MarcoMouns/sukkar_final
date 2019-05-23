
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../Settings.dart';
import '../../languages/all_translations.dart';

class Reset extends StatefulWidget {
  _ResetState createState() => _ResetState();
}
class _ResetState extends State<Reset> {
  FocusNode _focusNode=FocusNode();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: allTranslations.currentLanguage=="ar"?TextDirection.rtl:TextDirection.ltr,
      child: GestureDetector(onTap: (){
        _focusNode.unfocus();
      },
        child: Scaffold(
          body:FormKeyboardActions(
                  keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
                  keyboardBarColor:Colors.grey[200],
                  nextFocus: true,
                  actions: [
                    KeyboardAction(
                      focusNode: _focusNode,
                    ),
                  ],
                  child: Container(
            padding:  Platform.isIOS?EdgeInsets.only(top:50.0):EdgeInsets.only(top:10.0),
            child:Column(
              children: <Widget>[
                Flexible(
                            child: ListView(
                   // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(),
                            )
                            ,InkWell(
                              onTap: (){
                                     _focusNode.unfocus();
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.close,color:Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: ImageIcon(AssetImage("assets/icons/ic_password.png"),size: 70.0,color:Colors.grey),
                            )
                            ,Padding(padding: EdgeInsets.all(10.0),)
                            ,ListTile(
                              title:Text(allTranslations.text("forgetMyPassword"),style: TextStyle(color:Colors.redAccent,fontSize: Platform.isIOS?40.0:25),)
                              ,subtitle: Text(allTranslations.text("enterYourMobile"),style: TextStyle(color:Colors.grey,fontSize: Platform.isIOS?20.0:15),),
                            )
                          ],
                        ),
                      )
                      ,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            LogInInput(name:"mobilePhone",focusNode: _focusNode,keyboard: TextInputType.phone,)
                          ],
                        ),
   Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical:40.0,horizontal: 30.0),
                            child: RaisedButton(
                              elevation: 0.0,
                              color: Settings.mainColor(),
                              textColor: Colors.white,
                              onPressed: ()async{
                                     _focusNode.unfocus();
                                await Navigator.of(context).pushNamedAndRemoveUntil('/home',ModalRoute.withName('/home'));
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                width: double.infinity
                                ,child: Text(allTranslations.text("sendCode"),style: TextStyle(fontSize:18.0),textAlign: TextAlign.center,)
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))
                            ),
                          ),
                        )
                    ],
                  ),
                ),  
              ],
            ),
          )
        ),
      ))
    );
  }
}