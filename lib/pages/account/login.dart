import 'package:flutter/material.dart';
import '../../Settings.dart';
import '../../languages/all_translations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogIn extends StatefulWidget {
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int activeType = 1;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GestureDetector(
          onTap: () {
            focusNode1.unfocus();
            focusNode2.unfocus();
          },
          child: Scaffold(
              body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/imgs/bg.png"),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                  child: Text(
                                allTranslations.text("loginBy"),
                                style: TextStyle(color: Colors.grey),
                              )),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.close, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30.0),
                        child: Row(
                          children: <Widget>[
                            LoginType(
                                icon: Icons.phone_android,
                                onPress: () {
                                  setState(() {
                                    activeType = 1;
                                  });
                                },
                                isActive: activeType == 1),
                            LoginType(
                                icon: Icons.alternate_email,
                                onPress: () {
                                  setState(() {
                                    activeType = 2;
                                  });
                                },
                                isActive: activeType == 2),
                            LoginType(
                              svg: 'assets/imgs/facebook.svg',
                              onPress: () {
                                final AuthCredential credential =
                                    FacebookAuthProvider.getCredential();
                              },
                            ),
                            LoginType(
                              svg: 'assets/imgs/gmail.svg',
                              onPress: () async {
                                final GoogleSignInAccount googleUser =
                                    await _googleSignIn.signIn();
                                final GoogleSignInAuthentication googleAuth =
                                    await googleUser.authentication;
                                final AuthCredential credential =
                                    GoogleAuthProvider.getCredential(
                                  accessToken: googleAuth.accessToken,
                                  idToken: googleAuth.idToken,
                                );
                                final FirebaseUser user = await _auth
                                    .signInWithCredential(credential);
                                assert(user.email != null);
                                assert(user.displayName != null);
                                assert(!user.isAnonymous);
                                assert(await user.getIdToken() != null);

                                final FirebaseUser currentUser =
                                    await _auth.currentUser();
                                assert(user.uid == currentUser.uid);
                                await Navigator.of(context)
                                    .pushNamedAndRemoveUntil(
                                        '/home', ModalRoute.withName('/home'));
                              },
                            )
                          ],
                        ),
                      ),
                      LogInInput(
                        autoValidate: true,
                        focusNode: focusNode1,
                        name:
                            "userName or ${activeType == 1 ? "mobilePhone" : "email"}",
                      ),
                      activeType < 3
                          ? LogInInput(
                              name: "password",
                              autoValidate: true,
                              isPassword: true,
                              focusNode: focusNode2,
                            )
                          : Wrap(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 40.0),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.of(context).pushNamed('/reset');
                          },
                          child: Text(
                            allTranslations.text("forgetPassword"),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    child: RaisedButton(
                        elevation: 0.0,
                        color: Settings.mainColor(),
                        textColor: Colors.white,
                        onPressed: () async {
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home', ModalRoute.withName('/home'));
                        },
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            width: double.infinity,
                            child: Text(
                              allTranslations.text("landPage_logIn"),
                              style: TextStyle(fontSize: 18.0),
                              textAlign: TextAlign.center,
                            )),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
