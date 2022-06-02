import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parachute/AccountInfo.dart';
import 'package:parachute/src/SocialLogin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'ChangeEmail.dart';
import 'GlobalState.dart';
import 'PlaceLocation.dart';
import 'ReservationsList.dart';
import 'ShopPage.dart';
import 'carousel_pro/src/carousel_pro.dart';
import 'data_horizontal.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static FoodCategoryHorizontal dataHorizontal = FoodCategoryHorizontal();
  List foodData = dataHorizontal.food;
  bool isLoading = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> adsImages = [];
  List _categoriesList = GlobalState.categoriesList;
  int categoryPressed;
  bool _inProgress = false;
  List _searchedList;
  var _search;
  bool searchInProgress;
  bool carouselCreated;
  TextEditingController _textEditingController = TextEditingController();

  Future<List> searchResults(String searchItem) async {
    String myURL = "${GlobalState.hostURL}/api/shops/search";
    final response = await http.post(myURL, body: {"text": searchItem});
    Map _responseMap = json.decode(response.body);
    _searchedList = _responseMap['success']['shops'];
    if (response.statusCode == 200) {
      return _searchedList;
    } else
      return null;
  }

  getData() async {
    setState(() {
      _inProgress = true;
    });
    String myURL = "${GlobalState.hostURL}/api/categories/";
    http.Response response = await http.get(myURL);
    if (response.statusCode == 200)
      setState(() {
        Map _responseMap = json.decode(response.body);
        _categoriesList = _responseMap['success']['categories'];
        GlobalState.categoriesList = _categoriesList;
        _inProgress = false;
      });
  }

  Future<Null> refreshPage() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      getData();
      categoriesHorizontalList(context);
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    categoryPressed = 0;
    searchInProgress = false;
    carouselCreated = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!carouselCreated) {
      createAdsCarousel(context);
      carouselCreated = true;
    }
    final double sliverAppBarHeight = MediaQuery.of(context).size.height * 0.25;
    final double paintHeight = MediaQuery.of(context).size.height * 0.35;
    final double toolbarHeight = MediaQuery.of(context).size.height * 0.12;
    final double logoHeight = MediaQuery.of(context).size.height * 0.1;
    final double searchBottom = MediaQuery.of(context).size.height * 0.01;
    final double searchHeight = MediaQuery.of(context).size.height * 0.08;
    final double searchWidth = MediaQuery.of(context).size.width * 0.66;
    return SafeArea(
        top: true,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: Drawer(
              child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: GlobalState.logoColor,
                ),
                child: Container(
                  child: Image.asset("assets/logo/Parachute"
                      " Logo on Red.png"),
                ),
              ),
              CustomListTile(
                  Icons.person,
                  "Profile",
                  () => {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountInfo()),
                            (route) => false)
                      }),
              Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(
                  Icons.email,
                  "Change Email",
                  () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeEmail()))
                      }),
              Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.vpn_key, "Change Password", () => {}),
              Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.notifications, "Notifications", () => {}),
              Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(
                  Icons.history,
                  "Your Reservations",
                  () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReservationsList()))
                      }),
              Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.history, "Your Orders", () => {}),
              Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.settings, "Settings", () => {}),
              Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.phone, "Contact Us", () => {}),
              (GlobalState.loggedIn)
                  ? Divider(thickness: 1, color: GlobalState.secondColor)
                  : Container(),
              (GlobalState.loggedIn)
                  ? CustomListTile(Icons.logout, "Log Out", () {
                      GlobalState.alert(
                        context,
                        onConfirm: () {
                          GlobalState.logOut();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          this.setState(() {});
                        },
                        onCancel: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        message: 'You\'re about to log out'
                            ' of your account',
                        title: 'Warning',
                        confirmText: "Log Out",
                        cancelText: "Cancel",
                      );
                    })
                  : Container(),
            ],
          )),
          body: RefreshIndicator(
            child: Stack(children: [
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.white,
                    expandedHeight: sliverAppBarHeight,
                    titleSpacing: 0,
                    toolbarHeight: toolbarHeight,
                    centerTitle: true,
                    title: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: GlobalState.logoColor,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Image.asset(
                          "assets/logo/Parachute-Logo-on-Red.png",
                          height: logoHeight,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    leading: Container(
                      width: MediaQuery.of(context).size.width,
                      color: GlobalState.logoColor,
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.ellipsisV,
                          color: Colors.white,
                        ),
                        onPressed: () => _scaffoldKey.currentState.openDrawer(),
                      ),
                    ),
                    actions: [
                      Container(
                        color: GlobalState.logoColor,
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Positioned(
                            width: MediaQuery.of(context).size.width,
                            height: paintHeight,
                            child: CustomPaint(
                              painter: RPSCustomPainter(),
                            ),
                          ),
                          Positioned(
                            bottom: searchBottom,
                            left: MediaQuery.of(context).size.width * 0.14,
                            right: MediaQuery.of(context).size.width * 0.14,
                            child: Container(
                              width: searchWidth,
                              height: searchHeight,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: GlobalState.secondColor, width: 1.0),
                                borderRadius: BorderRadius.circular(40.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: GlobalState.secondColor
                                        .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "What are you looking For ?",
                                    suffixIcon: Icon(Icons.search,
                                        color: GlobalState.secondColor),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10)),
                                onChanged: (value) {
                                  setState(() {
                                    _search = value;
                                    if (_search == "")
                                      searchInProgress = false;
                                    else if (_search != null)
                                      searchInProgress = true;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (!searchInProgress)
                    SliverList(
                        delegate: SliverChildListDelegate([
                      (GlobalState.loggedIn == false)
                          ? logInCard()
                          : Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                'Welcome ${GlobalState.thisUser.firstName}, '
                                'how can we help you?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      offersHorizontalList(foodData, context),
                      SizedBox(
                        height: 10,
                      ),
                      advertisementSlider(),
                      SizedBox(
                        height: 10,
                      ),
                    ])),
                  if (!searchInProgress)
                    SliverAppBar(
                        pinned: true,
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        bottom: PreferredSize(
                          preferredSize: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.width * 0.15),
                          child: (_inProgress)
                              ? Center(child: CircularProgressIndicator())
                              : categoriesHorizontalList(context),
                        )),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    mainList(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                  ])),
                ],
              ),
              Positioned(
                bottom: 0,
                height: MediaQuery.of(context).size.height * 0.1,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.1),
                  painter: BNBCustomPainter(),
                ),
              ),
              Positioned(
                bottom: 0,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (GlobalState.loggedIn == false) {
                            GlobalState.alert(
                              context,
                              onConfirm: () {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SocialLogin();
                                }));
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              title: "Log In",
                              message: 'You are not allowed to access '
                                  'this page until you log in',
                              confirmText: "Log in now",
                              cancelText: 'Log in later',
                            );
                          } else {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountInfo()),
                                (route) => false);
                          }
                        },
                        splashColor: Colors.white,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.language,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            (GlobalState.loggedIn)
                                ? GlobalState.alert(
                                    context,
                                    onConfirm: () {
                                      GlobalState.logOut();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      this.setState(() {});
                                    },
                                    onCancel: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    message: 'You\'re about to log out'
                                        ' of your account',
                                    title: 'Warning',
                                    confirmText: "Log Out",
                                    cancelText: "Cancel",
                                  )
                                : GlobalState.alert(context, onConfirm: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                    onCancel: null,
                                    confirmOnly: true,
                                    message:
                                        'You can\'t logout because you aren\'t loggedIn',
                                    title: 'Warning',
                                    confirmText: "OK");
                          }),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.89,
                left: MediaQuery.of(context).size.width * 0.4,
                right: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.08,
                child: FloatingActionButton(
                    backgroundColor: GlobalState.logoColor,
                    tooltip: 'change your location',
                    child: Icon(Icons.my_location_sharp, color: Colors.white),
                    onPressed: () async {
                      String currentLocation = await GlobalState.getLocation();
                      GlobalState.alert(
                        context,
                        onConfirm: () {
                          // Navigator.of(context, rootNavigator: true).pop();
                          // Navigator.of(context, rootNavigator: true).push(
                          //     MaterialPageRoute(
                          //         builder: (context) => PlaceLocation(true)));
                        },
                        onCancel: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        title: "Current Location",
                        message: 'Your Current Location is:\n' +
                            currentLocation +
                            '\n'
                                "Continue to change your Location?",
                      );
                    }),
              ),
            ]),
            onRefresh: refreshPage,
          ),
        ));
  }

  createAdsCarousel(BuildContext context) {
    for (int i = 1; i <= 2; i++) {
      adsImages.add(Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Image.asset(
                  "assets/images/Restaurants/ad$i.jpg",
                  fit: BoxFit.fill,
                ))
              ],
            ),
          )));
    }
  }

  Widget advertisementSlider() {
    return Container(
      height: 182,
      child: Carousel(
        boxFit: BoxFit.cover,
        dotColor: GlobalState.logoColor,
        dotSize: 5.5,
        dotSpacing: 16,
        dotBgColor: Colors.transparent,
        showIndicator: true,
        overlayShadow: true,
        overlayShadowColors: Colors.white.withOpacity(0.9),
        overlayShadowSize: 0.9,
        images: adsImages,
      ),
    );
  }

  Widget categoriesIcon(int category, Color color) {
    if (category == 0)
      return Icon(Icons.local_dining, color: color);
    else if (category == 1)
      return Icon(FontAwesomeIcons.store, color: color);
    else if (category == 2)
      return Icon(FontAwesomeIcons.syringe, color: color);
    else
      return Icon(FontAwesomeIcons.hotel, color: color);
  }

  Widget logInCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.black.withAlpha(20), width: 1),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: GlobalState.secondColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0),
              ),
            ),
            child: Row(children: <Widget>[
              Icon(
                Icons.person_pin,
                size: 50,
                color: GlobalState.logoColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Login or create an account to \n receive rewards and offers.",
                style: TextStyle(fontSize: 15),
              )
            ]),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SocialLogin();
              }));
            },
            splashColor: Colors.deepOrange.withAlpha(150),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                alignment: Alignment.center,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 15, color: GlobalState.logoColor),
                )),
          )
        ],
      ),
    );
  }

  Widget shopsVerticalList(int category) {
    return ListView.builder(
        itemCount: _categoriesList[category]['shops'].length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              navigateToShop(_categoriesList[category]['shops'][index]['id']);
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _categoriesList[category]['shops'][index]['name'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GlobalState.rateWithBlackStars(
                                  _categoriesList[category]['shops'][index]
                                      ['rank']),
                            ),
                            Text(
                              _categoriesList[category]['shops'][index]
                                  ['details'],
                              style: TextStyle(
                                  fontSize: 16, color: GlobalState.secondColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GlobalState.rateWithColoredStars(
                                  _categoriesList[category]['shops'][index]
                                      ['rate']),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      "Delivery time: ${_categoriesList[category]['shops'][index]['service_time']} Minutes",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: GlobalState.secondColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: GlobalState.secondColor, width: 1),
                          ),
                          child: Image.network(
                              "${GlobalState.hostURL + _categoriesList[category]['shops'][index]['icon']}",
                              fit: BoxFit.fitWidth))
                    ],
                  ),
                )),
          );
        });
  }

  Widget categoriesHorizontalList(BuildContext context) {
    double categoryRibLength = MediaQuery.of(context).size.width * 0.225;
    return Container(
      alignment: Alignment.center,
      height: categoryRibLength,
      margin: EdgeInsets.only(top: 5, bottom: 15),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _categoriesList.length,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  categoryPressed = index;
                });
              },
              child: Container(
                  width: categoryRibLength,
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      border: Border.all(
                          color: (index == categoryPressed)
                              ? GlobalState.logoColor
                              : GlobalState.secondColor),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: (index == categoryPressed)
                                ? GlobalState.logoColor.withAlpha(30)
                                : GlobalState.secondColor.withAlpha(30),
                            blurRadius: 10.0),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          child: categoriesIcon(
                              index,
                              (index == categoryPressed)
                                  ? GlobalState.logoColor
                                  : GlobalState.secondColor)),
                      Text(
                        _categoriesList[index]['name'].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: (index == categoryPressed)
                                ? GlobalState.logoColor
                                : GlobalState.secondColor),
                      ),
                    ],
                  )),
            );
          }),
    );
  }

  Widget searchedListWidget() {
    return FutureBuilder(
        future: searchResults(_search),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      navigateToShop(snapshot.data[index]['id']);
                    },
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data[index]['name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: GlobalState.rateWithBlackStars(
                                          snapshot.data[index]['rank']),
                                    ),
                                    Text(
                                      snapshot.data[index]['details'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: GlobalState.secondColor),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: GlobalState.rateWithColoredStars(
                                          snapshot.data[index]['rate']),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          text:
                                              "Delivery time: ${snapshot.data[index]['service_time']} Minutes",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: GlobalState.secondColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: GlobalState.secondColor,
                                        width: 1),
                                  ),
                                  child: Image.network(
                                      "${GlobalState.hostURL + snapshot.data[index]['icon']}",
                                      fit: BoxFit.fitWidth))
                            ],
                          ),
                        )),
                  );
                });
          }
          return SizedBox();
        });
  }

  Widget mainList() {
    return searchInProgress == false
        ? SingleChildScrollView(
            child: Column(children: [
              (_inProgress)
                  ? SizedBox()
                  : SizedBox(
                      height: 10,
                    ),
              (_inProgress) ? SizedBox() : shopsVerticalList(categoryPressed),
            ]),
          )
        : searchedListWidget();
  }

  void navigateToShop(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Shop(index);
    }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget offersHorizontalList(List data, context) {
    if (data == null)
      return ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Text(
              "tag",
              style: TextStyle(color: GlobalState.secondColor, fontSize: 16),
            )),
          ),
        ],
      );
    else if (data.length > 0)
      return Container(
        height: MediaQuery.of(context).size.width * 0.3,
        margin: EdgeInsets.only(top: 5, bottom: 10),
        child: ListView.builder(
            itemCount: data.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      color: GlobalState.secondColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 10.0),
                      ]),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.25,
                          child: Image.asset(
                            "assets/offers/${data[index]["image"]}",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            data[index]["name"].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ));
            }),
      );
    else
      return ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Text(
              "noData",
              style: TextStyle(color: GlobalState.secondColor, fontSize: 16),
            )),
          ),
        ],
      );
  }
}

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        onTap: onTap,
        splashColor: GlobalState.secondColor.withOpacity(0.5),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = new Paint()
      ..color = GlobalState.logoColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.49, size.height * -2.33);
    path_1.cubicTo(size.width * 0.86, size.height * -2.34, size.width * 1.42,
        size.height * -1.92, size.width * 1.42, size.height * -0.85);
    path_1.cubicTo(size.width * 1.42, size.height * -0.26, size.width * 1.14,
        size.height * 0.63, size.width * 0.49, size.height * 0.63);
    path_1.cubicTo(size.width * 0.12, size.height * 0.63, size.width * -0.44,
        size.height * 0.19, size.width * -0.44, size.height * -0.85);
    path_1.cubicTo(size.width * -0.44, size.height * -1.45, size.width * -0.16,
        size.height * -2.34, size.width * 0.49, size.height * -2.33);
    path_1.close();

    canvas.drawPath(path_1, paint_1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = GlobalState.logoColor
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(14.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
