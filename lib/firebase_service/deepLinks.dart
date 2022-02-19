import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/products.dart';
import 'package:dijlah_store_ibtechiq/screens/detail_product.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import '../service/bLoC.dart';
class DeepLinkHelper {
  DeepLinkHelper._();

  factory DeepLinkHelper() => _instance;
  static final DeepLinkHelper _instance = DeepLinkHelper._();
  //this fun for firebase Messaging
  Future<void> init(BuildContext context, BLoC bLoC) async {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
            final Uri deepLink = dynamicLink?.link;
            if (deepLink != null) {
              String id = deepLink.path.substring(1);
              await getProduct(id).then((value) {
                print(value);
                if (value != null) {
                  Product recipe = value;
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => DetailProduct(
                        bLoC: bLoC,
                        product: recipe,
                      ),
                    ),
                  );
                }
              });
            }
          }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });
      final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;
      if (deepLink != null) {
        String id = deepLink.path.substring(1);
        await getProduct(id).then((value) {
          print(value);
          if (value != null) {
            Product recipe = value;
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => DetailProduct(
                  bLoC: bLoC,
                  product: recipe,
                ),
              ),
            );
          }
        });
      }
  }
}
