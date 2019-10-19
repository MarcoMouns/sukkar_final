import 'package:flutter/material.dart';
import 'package:health/languages/all_translations.dart';

class AboutApp extends StatefulWidget {
  @override
  AboutAppState createState() => AboutAppState();
}

class AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text("about")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
                "تطبيق سكر هو الأول من نوعه في المملكة العربية السعودية الذي يهدف إلى مساعدة المصابين بالسكر في تنظيم مستوى السكر في الدم والذي بدوره يقوم على مساعدتهم لممارسة حياتهم بشكل طبيعي ",
                style:TextStyle(fontSize: 20),),
            SizedBox(
              height: 15,
            ),
            Text(
                "وإنطلاقاً لما تسعى إليه رؤية المملكة العربية السعودية وتحديداً برنامج التحول الوطني 2030 وما يسعى إليه من أهداف للإرتقاء بالرعاية الصحية لتسهيل الحصول على الخدمات الصحية وتحسين جودة وكفاءة الخدمات الصحية وتعزيز الوقاية ضد المخاطر الصحية فقد سعى الشركاء في تقديم مشروع تطبيق سكر الذي يوفر العديد من الخصائص المتعددة في في جهة واحدة ."
                ,style:TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
