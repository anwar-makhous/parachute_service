import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:parachute/InfoPage.dart';
import 'package:parachute/PlaceLocation.dart';
import 'package:parachute/RestaurantReservation.dart';
import 'package:parachute/src/LoginPage.dart';
import 'GlobalState.dart';

class Shop extends StatefulWidget {
  final int index;
  Shop(this.index);

  @override
  _ShopState createState() => _ShopState(this.index);
}

class _ShopState extends State<Shop> {
  int index;
  List _menuCategories;
  bool inProgress;
  bool hasDelivery;
  bool hasReservation;
  bool isOpen;
  Map _shopData;
  String closingDays;
  bool freeDelivery;

  _ShopState(this.index);

  getData() async {
    String apiURL = "${GlobalState.hostURL}/api/shops/$index";
    http.Response response = await http.get(apiURL);
    if (response.statusCode == 200) {
      _shopData = json.decode(response.body);
      _menuCategories = _shopData['success']['shop']['menu_categories'];
      hasDelivery =
          (_shopData['success']['shop']['delivery'] == 1) ? true : false;
      hasReservation = (_shopData['success']['shop']['category_id'] == 1)
          ? (_shopData['success']['shop']['reservation'] == 1)
              ? true
              : false
          : false;
      isOpen = checkForOpening(_shopData['success']['shop']['open_days'],
          _shopData['success']['shop']['open_hours']);
      setState(() {
        inProgress = false;
      });
    }
  }

  @override
  void initState() {
    inProgress = true;
    getData();
    super.initState();
    freeDelivery = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: (inProgress)
          ? GlobalState.progressIndicator(context, transparent: false)
          : Scaffold(
              appBar: AppBar(
                title: Text("${_shopData['success']['shop']['name']}"),
                centerTitle: true,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {},
                  ),
                ],
                toolbarTextStyle: TextTheme(
                    headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                )).bodyText2,
                titleTextStyle: TextTheme(
                    headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                )).headline6,
              ),
              backgroundColor: Colors.white,
              body: Stack(
                children: [mainBody(), addToBasket()],
              )),
    );
  }

  Widget mainBody() {
    return DefaultTabController(
      length: _menuCategories.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              expandedHeight: 1100,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    shopImage(),
                    shopInfo(),
                  ],
                ),
              ),
              bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: GlobalState.logoColor,
                  indicatorWeight: 3.5,
                  labelColor: Colors.black,
                  tabs: [
                    for (int i = 0; i < _menuCategories.length; i++)
                      Tab(text: _menuCategories[i]["name"]),
                  ]),
            ),
          ];
        },
        body: TabBarView(
          children: [
            for (int i = 0; i < _menuCategories.length; i++)
              dataVerticalListView(i),
          ],
        ),
      ),
    );
  }

  Widget shopInfo() {
    return Flexible(
      child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 3,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: GlobalState.secondColor, width: 0.5),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (hasDelivery)
                        GlobalState.rateWithColoredStars(3,
                            text: Text('Delivery',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                )),
                            isRow: false),
                      if (hasReservation)
                        GlobalState.rateWithColoredStars(5,
                            text: Text('Reservation',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                )),
                            isRow: false),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _shopData['success']['shop']['name'],
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        GlobalState.rateWithBlackStars(
                            _shopData['success']['shop']['rank']),
                        Text(
                          _shopData['success']['shop']['details'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: GlobalState.secondColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: GlobalState.secondColor, width: 1),
                        ),
                        child: Image.network(
                            "${GlobalState.hostURL + _shopData['success']['shop']['icon']}",
                            fit: BoxFit.fitWidth))
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                if (hasDelivery)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Delivery Time : ${_shopData['success']['shop']['service_time']} Minutes",
                        style: TextStyle(
                          fontSize: 16,
                          color: GlobalState.secondColor,
                        ),
                      ),
                      GlobalState.parachuteIcon(size: 40),
                    ],
                  ),
                if (hasDelivery && freeDelivery)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Free Delivery",
                        style: TextStyle(
                          fontSize: 16,
                          color: GlobalState.secondColor,
                        ),
                      ),
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ],
                  ),
                if (hasDelivery)
                  Divider(
                    thickness: 2,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Address :",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                    RaisedButton(
                        color: GlobalState.logoColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            side: BorderSide(color: GlobalState.logoColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Show On Map  ",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(Icons.my_location,
                                size: 18, color: Colors.white),
                          ],
                        ),
                        onPressed: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return PlaceLocation.showLocation(
                          //       false,
                          //       LatLng(
                          //           double.parse(
                          //               _shopData['success']['shop']['lat']),
                          //           double.parse(
                          //               _shopData['success']['shop']['long'])));
                          // }));
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${_shopData['success']['shop']['address']}",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      (isOpen) ? "Open Now" : "Closed Now",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: (isOpen) ? Colors.green : GlobalState.logoColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        (closingDays == 'Opens Everyday')
                            ? closingDays
                            : (closingDays == '')
                                ? 'Opens Everyday'
                                : "Off Days : $closingDays",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 16,
                          color: GlobalState.secondColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Opening Hours : ${_shopData['success']['shop']['open_hours']}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                if (hasReservation)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        color: GlobalState.logoColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            side: BorderSide(color: GlobalState.logoColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Book A Table",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(Icons.arrow_forward,
                                size: 18, color: Colors.white),
                          ],
                        ),
                        onPressed: () {
                          if (GlobalState.loggedIn == true) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RestaurantReservation(_shopData, false);
                            }));
                          } else {
                            GlobalState.alert(context, onConfirm: () {
                              setState(() {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginPage();
                                }));
                              });
                            }, onCancel: () {
                              Navigator.pop(context);
                            },
                                title: 'You\'re not logged in',
                                message: 'In order to book a table '
                                    'and make a reservation you have to log in or '
                                    'create an account',
                                confirmText: "OK",
                                cancelText: "Cancel");
                          }
                        },
                      ),
                    ],
                  ),
                if (hasReservation)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Online Reservation Is Available',
                          style: TextStyle(
                            fontSize: 16,
                            color: GlobalState.secondColor,
                          )),
                    ],
                  ),
                if (hasReservation)
                  Divider(
                    thickness: 2,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                        color: GlobalState.logoColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            side: BorderSide(color: GlobalState.logoColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Reviews  ",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(Icons.rate_review,
                                size: 18, color: Colors.white),
                          ],
                        ),
                        onPressed: () {
                          print('See Reviews');
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GlobalState.rateWithColoredStars(
                        _shopData['success']['shop']['rate'],
                        text: Text('General Rate',
                            style: TextStyle(
                              fontSize: 16,
                              color: GlobalState.secondColor,
                            ))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Based on 60 reviews",
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          )),
    );
  }

  Widget dataVerticalListView(int catIndex) {
    return ListView.builder(
        itemCount: _shopData['success']['shop']['menu_categories'][catIndex]
                ['items']
            .length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  navigateToMeal(catIndex, index, _shopData);
                },
                child: Container(
                  height: 130,
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 15, bottom: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _shopData['success']['shop']['menu_categories']
                                  [catIndex]['items'][index]['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                _shopData['success']['shop']['menu_categories']
                                    [catIndex]['items'][index]["details"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: GlobalState.secondColor),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "SP ${_shopData['success']['shop']['menu_categories'][catIndex]['items'][index]["price"]}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0)),
                            border: Border.all(
                                color: Colors.black.withAlpha(20), width: 1),
                          ),
                          child: Image.network(
                              "${GlobalState.hostURL + "/storage/items_images/" + _shopData['success']['shop']['menu_categories'][catIndex]['items'][index]["image"]}",
                              fit: BoxFit.fill))
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1,
              ),
            ],
          );
        });
  }

  Widget addToBasket() {
    return Positioned(
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
                  "Add items",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Total: EP 0.00",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )));
  }

  void navigateToMeal(int catIndex, int itemIndex, Map data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return InfoPage(catIndex, itemIndex, data);
    }));
  }

  bool checkForOpening(String openDaysString, String openHoursString) {
    if (openHoursString == '24/7') {
      this.closingDays = 'Opens Everyday';
      return true;
    }
    DateTime now = DateTime.now();
    List<String> closingDaysList = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    openDaysString = openDaysString.replaceAll(' ', '');
    List<String> openDays = openDaysString.split(',');
    closingDaysList.removeWhere((day) => openDays.contains(day));
    this.closingDays = (closingDaysList == null)
        ? 'Opens Everyday'
        : closingDaysList
            .toString()
            .replaceFirst('[', '')
            .replaceFirst(']', '');
    openHoursString = openHoursString.replaceAll(' - ', '-');
    List<String> openHours = openHoursString.split('-');
    String today = DateFormat('EEEE').format(now);
    bool workDay = (openDays.contains(today)) ? true : false;
    if (workDay) {
      DateTime start = DateTime(
          now.year,
          now.month,
          now.day,
          DateFormat.jm().parse(openHours[0]).hour,
          DateFormat.jm().parse(openHours[0]).minute);
      DateTime end = DateTime(
          now.year,
          now.month,
          (openHours[1].contains('AM')) ? now.day + 1 : now.day,
          DateFormat.jm().parse(openHours[1]).hour,
          DateFormat.jm().parse(openHours[1]).minute);
      return (now.isAfter(start) && now.isBefore(end));
    } else
      return false;
  }

  Widget shopImage() {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          "${GlobalState.hostURL + _shopData['success']['shop']['photo']}",
          fit: BoxFit.fitWidth,
        ));
  }
}
