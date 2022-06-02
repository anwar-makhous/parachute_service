import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parachute/GlobalState.dart';

class InfoPage extends StatefulWidget {
  final int itemIndex;
  final int catIndex;
  final Map data;

  InfoPage(this.catIndex, this.itemIndex, this.data);

  @override
  State<StatefulWidget> createState() =>
      _InfoPage(this.catIndex, this.itemIndex, this.data);
}

class _InfoPage extends State<InfoPage> {
  int itemIndex;
  int catIndex;
  Map data;
  int amount = 0;
  double total = 0.0;
  double price;

  _InfoPage(this.catIndex, this.itemIndex, this.data);

  @override
  void initState() {
    super.initState();
    price = data["success"]['shop']['menu_categories'][catIndex]['items']
            [itemIndex]['price'] *
        1.0;
    amount = 1;
    total = price;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                mealImage(),
                SizedBox(
                  height: 15,
                ),
                mealInfo(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                margin: EdgeInsets.only(right: 25, left: 25, bottom: 15),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: GlobalState.logoColor,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "EP ${total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Add to basket",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ]),
      ),
    );
  }

  Widget specialRequest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(children: [
            WidgetSpan(
              child: Icon(
                Icons.add_comment,
              ),
            ),
            TextSpan(
                text: '  Special request?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
            TextSpan(
                text: '  (optional)',
                style: TextStyle(
                  color: GlobalState.secondColor,
                  fontSize: 16,
                )),
          ]),
        ),
        TextField(
          maxLength: 50,
          decoration: InputDecoration(
              hintText: "Tap to enter request",
              hintStyle: TextStyle(fontSize: 14)),
        )
      ],
    );
  }

  Widget amountCalculator() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 70),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                if (amount > 0) {
                  amount--;
                  total = amount * price;
                }
              });
            },
            child: Container(
              child: Icon(
                Icons.remove,
                size: 30,
                color: GlobalState.logoColor,
              ),
            ),
          ),
          Text(
            "$amount",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (amount < 100) {
                  amount++;
                  total = amount * price;
                }
              });
            },
            child: Container(
              child: Icon(
                Icons.add,
                size: 30,
                color: GlobalState.logoColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // ignore: must_call_super
  void dispose() {
    super.dispose();
    amount = 0;
    total = 0.0;
  }

  Widget mealInfo() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data["success"]['shop']['menu_categories'][catIndex]['items']
                  [itemIndex]['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              data["success"]['shop']['menu_categories'][catIndex]['items']
                  [itemIndex]['details'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "SP ${data["success"]['shop']['menu_categories'][catIndex]['items'][itemIndex]['price']}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            // SubItem("R"),
            // SubItem("C"),
            specialRequest(),
            amountCalculator(),
          ],
        ));
  }

  Widget mealImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Image.network(
        "${GlobalState.hostURL + "/storage/items_images/" + data["success"]['shop']['menu_categories'][catIndex]['items'][itemIndex]['image']}",
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
