import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parachute_service/EditReservation.dart';
import 'package:parachute_service/ReservationInfo.dart';
import 'GlobalState.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              drawer: serviceAppDrawer(),
              appBar: AppBar(
                title: mainLogo(),
                toolbarHeight:MediaQuery.of(context).size.height*0.175,
                backgroundColor: GlobalState.logoColor,
                centerTitle: true,
                actions: [
                  Container(
                    color: GlobalState.logoColor,
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.infoCircle,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return EditReservation();
                            })
                        );
                      },
                    ),
                  )
                ],
                bottom: TabBar(
                  isScrollable: false,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  onTap: (index) {},
                  tabs: <Widget>[
                    Tab(
                      text: 'Reservation',
                    ),
                    Tab(
                      text: 'Delivery',
                    ),
                    Tab(
                      text: 'Self-PickUp',
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child:  Icon(
                    Icons.add,
                    color: GlobalState.secondColor,
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  for (int i = 0; i < 3; i++)
                    SingleChildScrollView(
                        child: Center(
                            child: (i == 0)
                                ? reservations(GlobalState.reservationsList)
                                : (i == 1)
                                    ? Text('Delivery')
                                    : Text('Self-PickUp')))
                ],
              ),
            )));
  }

  Widget reservations(List reservation) {
    return ListView.builder(
      itemCount: reservation.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(reservation[index]['name']),
          subtitle: Text(reservation[index]['date']),
          leading: GlobalState.reservationStatusIcon(reservation[index]['status']),
          trailing: Column(
            children: [
              Text('Table#'),
              Text(reservation[index]['table_no'].toString()),
            ],
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    ReservationInfo(index),));
          },
        );
      },
    );
  }

  Widget mainLogo() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03,
          bottom: MediaQuery.of(context).size.height*0.01),
      child: Image.asset(
        "assets/logo/Parachute-Logo-on-Red.png",
        height: MediaQuery.of(context).size.height * 0.1,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget serviceAppDrawer() {
    return Drawer(
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
            CustomListTile(Icons.person, "Profile", () => {}),
            Divider(
              thickness: 1,
              color: GlobalState.secondColor,
            ),
            CustomListTile(
                Icons.notifications, "Notifications", () => {}),
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
            (GlobalState.loggedIn == true)
                ? Divider(thickness: 1, color: GlobalState.secondColor)
                : Container(),
            (GlobalState.loggedIn == true)
                ? CustomListTile(Icons.lock, "Log Out", () {
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
        ));
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
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
                    padding: const EdgeInsets.all(8.0),
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
