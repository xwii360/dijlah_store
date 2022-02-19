import 'package:dijlah_store_ibtechiq/languages/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineOrderStatus extends StatelessWidget { 
  final stepIndex;

  const TimeLineOrderStatus({Key key, this.stepIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 20) / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.pink, width: 2),
                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.list_alt,
                        color: Colors.pink,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        getTranslated(context, "deliveryStatus_pending"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: stepIndex >= 0 ? Colors.teal : Colors.grey,
                padding: const EdgeInsets.all(0),
                iconStyle: stepIndex >= 0
                    ? IconStyle(
                    color: Colors.white,
                    iconData: Icons.check,
                    fontSize: 16)
                    : null,
              ),
              beforeLineStyle: stepIndex >= 1
                  ? LineStyle(
                color: Colors.teal,
                thickness: 5,
              )
                  : LineStyle(
                color: Colors.grey,
                thickness: 4,
              ),
              afterLineStyle: stepIndex >= 0
                  ? LineStyle(
                color: Colors.teal,
                thickness: 5,
              )
                  : LineStyle(
                color: Colors.grey,
                thickness: 4,
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 20) / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.red, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        getTranslated(context, "deliveryStatus_cancelled"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: stepIndex >= 1 ? Colors.teal : Colors.grey,
                padding: const EdgeInsets.all(0),
                iconStyle: stepIndex >= 1
                    ? IconStyle(
                    color: Colors.white,
                    iconData: Icons.check,
                    fontSize: 16)
                    : null,
              ),
              beforeLineStyle: stepIndex >= 2
                  ? LineStyle(
                color: Colors.teal,
                thickness: 5,
              )
                  : LineStyle(
                color: Colors.grey,
                thickness: 4,
              ),
              afterLineStyle: stepIndex >= 1
                  ? LineStyle(
                color: Colors.teal,
                thickness: 5,
              )
                  : LineStyle(
                color: Colors.grey,
                thickness: 4,
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 20) / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.blue, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.thumb_up_sharp,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        getTranslated(context, "deliveryStatus_confirmed"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: stepIndex >= 2 ? Colors.teal : Colors.grey,
                padding: const EdgeInsets.all(0),
                iconStyle: stepIndex >= 2
                    ? IconStyle(
                    color: Colors.white,
                    iconData: Icons.check,
                    fontSize: 16)
                    : null,
              ),
              beforeLineStyle: stepIndex >= 3
                  ? LineStyle(
                color: Colors.teal,
                thickness: 5,
              )
                  : LineStyle(
                color: Colors.grey,
                thickness: 4,
              ),
              afterLineStyle: stepIndex >= 2
                  ? LineStyle(
                color: Colors.teal,
                thickness: 5,
              )
                  : LineStyle(
                color: Colors.grey,
                thickness: 4,
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 20) / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.amber, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.amber,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        getTranslated(context, "deliveryStatus_on_delivery"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: stepIndex >= 3 ? Colors.teal : Colors.grey,
                padding: const EdgeInsets.all(0),
                iconStyle: stepIndex >= 3
                    ? IconStyle(
                    color: Colors.white,
                    iconData: Icons.check,
                    fontSize: 16)
                    : null,
              ),
              beforeLineStyle: stepIndex >= 4
                  ? LineStyle(
                color: Colors.teal,
                thickness: 5,
              )
                  : LineStyle(
                color: Colors.grey,
                thickness: 4,
              ),
              afterLineStyle: stepIndex >= 3
                  ? LineStyle(
                color: Colors.teal,
                thickness: 5,
              )
                  : LineStyle(
                color: Colors.grey,
                thickness: 4,
              ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 20) / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.purple, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.done_all,
                        color: Colors.purple,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        getTranslated(context, "deliveryStatus_delivered"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: stepIndex >= 4 ? Colors.teal : Colors.grey,
                padding: const EdgeInsets.all(0),
                iconStyle: stepIndex >= 4
                    ? IconStyle(
                    color: Colors.white,
                    iconData: Icons.check,
                    fontSize: 16)
                    : null,
              ),
              beforeLineStyle: stepIndex >= 3
                  ? LineStyle(
                color: Colors.teal,
                thickness: 5,
              )
                  : LineStyle(
                color: Colors.grey,
                thickness: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
