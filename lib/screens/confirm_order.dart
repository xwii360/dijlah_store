import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/screens/home.dart';
import 'package:dijlah_store_ibtechiq/screens/orders_history.dart';
import 'package:flutter/material.dart';
class ConfirmOrder extends StatefulWidget {
  final BLoC bLoC;

  const ConfirmOrder({Key key, this.bLoC}) : super(key: key);
  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}


class _ConfirmOrderState extends State<ConfirmOrder> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(bLoC: widget.bLoC,))),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/successfully.png"),
                fit: BoxFit.contain,
                width: 120,
                height: 120,
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(getTranslated(context, "successfully_ordered_title"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(getTranslated(context, "successfully_ordered_description"),textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: Colors.grey),),
              ),
              SizedBox(height: 40,),
              SizedBox(
                width: 250,
                height: 42,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 0,
                  color: Colors.teal[100],
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(bLoC: widget.bLoC,)), (route) => false);
                  },
                  child: Text(getTranslated(context, "back_to_home"),style: TextStyle(fontSize: 14,color: Colors.black),),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 250,
                height: 42,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 0,
                  color: Colors.grey[300],
                  onPressed: (){
                    widget.bLoC.getAllOrderHistoryFuture();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OrdersHistory(bLoC: widget.bLoC,fromOrder: true,)), (route) => false);
                  },
                  child: Text(getTranslated(context, "order_history"),style: TextStyle(fontSize: 14,color: Colors.black),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
