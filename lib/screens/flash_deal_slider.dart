import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:dijlah_store_ibtechiq/model/flash_deal_slider.dart';
import 'package:dijlah_store_ibtechiq/screens/flash_deal_products.dart';
import 'package:dijlah_store_ibtechiq/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:sizer/sizer.dart';

class FlashDealSlider extends StatefulWidget {
  final BLoC bLoC;
  const FlashDealSlider({Key key, this.bLoC}) : super(key: key);

  @override
  _FlashDealSliderState createState() => _FlashDealSliderState();
}

class _FlashDealSliderState extends State<FlashDealSlider> {
  List<CountdownTimerController> _timerControllerList = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<FlashDealSliders>>(
        stream: widget.bLoC.allFlashDeals,
        initialData: UnmodifiableListView<FlashDealSliders>([]),
        builder: (context, snap) {
          return snap.hasData && snap.data.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10,left: 10,right: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: snap.data.map<Widget>((e) {
                      var index = snap.data.indexOf(e);
                      return GestureDetector(
                        onTap: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FlashDealProducts(
                                      bLoC: widget.bLoC,
                                      title: checkLanguage(context, e.arTitle,
                                          e.enTitle, e.kuTitle, e.title),
                                      id: e.id,
                                    )));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildFlashDealListItem(e, index),
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: e.banner == ''
                                  ? Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      color: e.bgColor == ''
                                          ? Colors.black
                                          : Color(int.parse(
                                         e.bgColor.toString().replaceFirst("#", '0xff'))),
                                      child: Center(
                                        child: Text(
                                          checkLanguage(context, e.arTitle,
                                              e.enTitle, e.kuTitle, e.title),
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: e.textColor == 'white'
                                                  ? Colors.white
                                                  : e.textColor == 'black'
                            ? Colors.black
                                :Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: IMAGE_URL + e.banner,
                                      placeholder: (context, url) =>
                                          loadingSliderHomePage(
                                              context,
                                              SizerUtil.deviceType ==
                                                      DeviceType.tablet
                                                  ? 18.h
                                                  : 10.h,
                                              MediaQuery.of(context).size.width),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.fill,
                                      height: SizerUtil.deviceType ==
                                              DeviceType.tablet
                                          ? 18.h
                                          : 10.h,
                                      width: MediaQuery.of(context).size.width),
                            ),
                          ],
                        ),
                      );
                    }).toList()),
                  ))
              : Container();
        });
  }

  DateTime convertTimeStampToDateTime(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateToTimeStamp;
  }

  String timeText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;
    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }
    return newtxt;
  }

  buildFlashDealListItem(e, index) {
    DateTime end = convertTimeStampToDateTime(e.date); // YYYY-mm-dd
    DateTime now = DateTime.now();
    int diff = end.difference(now).inMilliseconds;
    int endTime = diff + now.millisecondsSinceEpoch;
    void onEnd() {}

    CountdownTimerController time_controller =
        CountdownTimerController(endTime: endTime, onEnd: onEnd);
    _timerControllerList.add(time_controller);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CountdownTimer(
        controller: _timerControllerList[index],
        widgetBuilder: (_, CurrentRemainingTime time) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getTranslated(context, 'end_of'),
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: 220,
                child: Center(
                    child: time == null
                        ? Text(
                            getTranslated(context, 'end_flash'),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          )
                        : buildTimerRowRow(time)),
              ),
            ],
          );
        },
      ),
    );
  }

  Row buildTimerRowRow(CurrentRemainingTime time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
     "${timeText(time.days.toString(), default_length: 2)} ${getTranslated(context, 'day')}",
          style: TextStyle(
              color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0, right: 1.0),
          child: Text(
            ":",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Text(
         "${timeText(time.hours.toString(), default_length: 2)} ${getTranslated(context, 'hour')}",
          style: TextStyle(
              color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0, right: 1.0),
          child: Text(
            ":",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          "${timeText(time.min.toString(), default_length: 2)} ${getTranslated(context, 'minute')}",
          style: TextStyle(
              color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0, right: 1.0),
          child: Text(
            ":",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          "${timeText(time.sec.toString(), default_length: 2)} ${getTranslated(context, 'second')}",
          style: TextStyle(
              color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
