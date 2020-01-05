import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main.dart';
import 'package:health/pages/Settings.dart';
import '../../languages/all_translations.dart';

class ChangePassword extends StatefulWidget {
  final String phone;
  ChangePassword(this.phone);
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _passwrodController = TextEditingController();

  bool _isLoading = false;
  bool _autoValidate = false;

  Map<String, dynamic> _formData = {
    "phone": null,
    // "code": null,
    "password": null
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      _formData['phone'] = widget.phone;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted(BuildContext context, MainModel model) {
    Locale myLocale = Localizations.localeOf(context);
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.

      showInSnackBar(myLocale.languageCode.contains("en")
          ? "Please fix errors before submit"
          : "من فضلك قم بتصحيح جميع الاخطاء اولا");
    } else {
      form.save();
      setState(() {
        _isLoading = true;
      });
      print("form data => $_formData");
      model.changePassword(_formData).then((result) {
        if (result == true) {
          setState(() {
            _isLoading = false;
          });

          // show registration success
          showInSnackBar(myLocale.languageCode.contains("en")
              ? "ChangePasswordd completed successfully"
              : "تم تغيير الباسورد بنجاح");
          // go to Home  page
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
        } else {
          setState(() {
            _isLoading = false;
          });
          // show registration failed
          // and show error message
          showInSnackBar(myLocale.languageCode.contains("en")
              ? "Invalid code."
              : "كود التحقيق غير صحيح");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return Directionality(
        textDirection: allTranslations.currentLanguage == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GestureDetector(
          onTap: () {
            _focusNode1.unfocus();
            _focusNode2.unfocus();
            _focusNode3.unfocus();
            _focusNode4.unfocus();
            _focusNode5.unfocus();
          },
          child: Scaffold(
            key: _scaffoldKey,
            body: ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              // LogInInput(
                              //   enabled: true,
                              //   name: "Code",
                              //   keyboard: TextInputType.text,
                              //   autoValidate: _autoValidate,
                              //   focusNode: _focusNode1,
                              //   onSaved: (String val) {
                              //     setState(() {
                              //       _formData['userName'] = val;
                              //     });
                              //   },
                              //   validator: (String val) {
                              //     if (val.isEmpty) {
                              //       return myLocale.languageCode.contains("en")
                              //           ? "Code is required."
                              //           : " الكود مطلوب";
                              //     }
                              //   },
                              // ),
                              Center(
                                child: Text(myLocale.languageCode.contains("en")
                                    ? "Change Password"
                                    : "تغيير الباسورد"),
                              ),
                              LogInInput(
                                enabled: true,
                                autoValidate: _autoValidate,
                                name: "password",
                                isPassword: true,
                                focusNode: _focusNode4,
                                onSaved: (String val) {
                                  setState(() {
                                    _formData['password'] = val;
                                  });
                                },
                                validator: (String val) {
                                  if (val.toString().length < 6)
                                    return myLocale.languageCode.contains("en")
                                        ? "Password must contain at least 6 char"
                                        : "الرقم السرى يجب ان يحتوى على 6 حروف على الاقل";
                                  else
                                    return null;
                                },
                              ),
                              LogInInput(
                                enabled: true,
                                name: "passwordConfirm",
                                autoValidate: _autoValidate,
                                controller: _passwrodController,
                                isPassword: true,
                                focusNode: _focusNode5,
                                validator: (String val) {
                                  if (_passwrodController.text != val) {
                                    return myLocale.languageCode.contains("en")
                                        ? "Password don't match."
                                        : "الرقم السرى غير صحيح";
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //margin: MediaQuery.of(context).viewInsets,
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 30.0),
                          child: _isLoading
                              ? CupertinoActivityIndicator(
                                  animating: true,
                                  radius: 15,
                                )
                              : RaisedButton(
                                  elevation: 0.0,
                                  color: Settings.mainColor(),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    _handleSubmitted(context, model);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(0.0),
                                      width: double.infinity,
                                      child: Text(
                                        allTranslations.text("verify"),
                                        style: TextStyle(fontSize: 18.0),
                                        textAlign: TextAlign.center,
                                      )),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
