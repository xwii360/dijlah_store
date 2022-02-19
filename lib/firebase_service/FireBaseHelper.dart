import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/firebase_service/local_notification.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/screens/detail_product.dart';
import 'package:dijlah_store_ibtechiq/screens/products.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../service/bLoC.dart';
class FireBaseHelper {
  FireBaseHelper._();
  factory FireBaseHelper() => _instance;

  static final FireBaseHelper _instance = FireBaseHelper._();

  Future<void> init(BuildContext context, BLoC bLoC) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true
    );
    FirebaseMessaging.instance.subscribeToTopic("dijlah");
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
         if(message != null){
           String type = message.data['type'];
           String typeId = message.data['type_id'];
           String name = message.data['type_name'];
           if (type == '1') {
             await getProduct(typeId).then((value) {
                 Product product = value;
                 Navigator.push(
                   context,
                   MaterialPageRoute<void>(
                     builder: (BuildContext context) =>
                         DetailProduct(
                           bLoC: bLoC,
                           product: product,
                         ),
                   ),
                 );
             });
           }
           else if(type == '0'){
             Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
             Products(
               bLoC: bLoC,
               id: typeId,
               title:name ==
                   null
                   ? getTranslated(context, "all_products_title")
                   : name,
               getFrom: "category",
             )));
           }
           else if(type == '2'){
             Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
             Products(
               bLoC: bLoC,
               id: typeId,
               title:name ==
                   null
                   ? getTranslated(context, "all_products_title")
                   : name,
               getFrom: "brand",
             )));
           }
           else if(type == '3' ){
             Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
             Products(
               bLoC: bLoC,
               id: typeId,
               title:name ==
                   null
                   ? getTranslated(context, "all_products_title")
                   : name,
               getFrom: "shop",
             )));
           }
           else{

           }
         }
    });
     FirebaseMessaging.onMessage.listen((message) {
           LocalNotification.display(message);
     });
     FirebaseMessaging.onMessageOpenedApp.listen((message) async {
       if(message != null){
         String type = message.data['type'];
                 String typeId = message.data['type_id'];
                 String name = message.data['type_name'];
                 if (type == '1') {
                   await getProduct(typeId).then((value) {
                       Product product = value;
                       Navigator.push(
                         context,
                         MaterialPageRoute<void>(
                           builder: (BuildContext context) =>
                               DetailProduct(
                                 bLoC: bLoC,
                                 product: product,
                               ),
                         ),
                       );
                   });
                 }
                 else if(type == '0'){
                  Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
                               Products(
                                 bLoC: bLoC,
                                 id: typeId,
                                 title:name ==
                                     null
                                     ? getTranslated(context, "all_products_title")
                                     : name,
                                 getFrom: "category",
                               )));
                 }
                 else if(type == '2'){
                  Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
                               Products(
                                 bLoC: bLoC,
                                 id: typeId,
                                 title:name ==
                                     null
                                     ? getTranslated(context, "all_products_title")
                                     : name,
                                 getFrom: "brand",
                               )));
                 }
                 else if(type == '3' ){
                  Navigator.push(context, PageTransition(type:PageTransitionType.fade, child:
                               Products(
                                 bLoC: bLoC,
                                 id: typeId,
                                 title:name ==
                                     null
                                     ? getTranslated(context, "all_products_title")
                                     : name,
                                 getFrom: "shop",
                               )));
                 }
                 else{

                 }
       }
     });
  }
}
