import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:parachute/PlaceLocation.dart';
import 'package:parachute/RestaurantReservation.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'GlobalState.dart';
import 'HomePage.dart';

class ReservationResult extends StatefulWidget {
  final Map _reservationInfo;
  final Map _restaurantData;
  final int _reservationID;
  final String status;
  static bool isFromLog = false;

  ReservationResult(this._reservationInfo, this._restaurantData, this.status,
      this._reservationID);

  ReservationResult.fromLog(this._reservationInfo, this._restaurantData,
      this.status, this._reservationID) {
    isFromLog = true;
  }

  @override
  _ReservationResultState createState() => _ReservationResultState(
      this._reservationInfo,
      this._restaurantData,
      this.status,
      this._reservationID);
}

class _ReservationResultState extends State<ReservationResult> {
  final Map _reservationInfo;
  Map _restaurantData;
  List tablesList = [];
  Map _reservationResponse;
  int _reservationID;
  String status;
  int waiterID;
  int reservationRate;
  bool readyToRate;

  _ReservationResultState(this._reservationInfo, this._restaurantData,
      this.status, this._reservationID);

  String pendingText;
  String confirmText;
  String refusedText;
  String canceledText;
  IconData pendingIcon;
  IconData confirmIcon;
  IconData refusedIcon;
  bool _inProgress = false;
  bool _gettingShop = false;
  bool canceled;
  DateTime date;
  String details;
  int peopleNumber;
  bool avtlo;
  int tableNo;
  Map<dynamic, dynamic> tablesMap = <dynamic, dynamic>{};

  setTable(dynamic key, dynamic value) => tablesMap[key] = value;

  getTable(dynamic key) => tablesMap[key];

  makeReservation(String tableID, String details, int peopleNumber,
      DateTime date, bool atvlo) async {
    setState(() {
      _inProgress = true;
    });
    String apiURL = (_reservationID != -1)
        ? "${GlobalState.hostURL}/api/update_reservation/${_reservationID.toString()}"
        : "${GlobalState.hostURL}/api/request_reservation";
    final response = (_reservationID != -1)
        ? await http.put(apiURL, body: {
            "table_id": tableID,
            "details": details,
            "people_number": peopleNumber.toString(),
            "date": date.toString(),
            "atvlo": (atvlo) ? '1' : '0',
            "status": 'Pending'
          }, headers: {
            'Authorization': 'Bearer ${GlobalState.thisUser.token}'
          })
        : await http.post(apiURL, body: {
            "table_id": tableID,
            "details": details,
            "people_number": peopleNumber.toString(),
            "date": date.toString(),
            "atvlo": (atvlo) ? '1' : '0'
          }, headers: {
            'Authorization': 'Bearer ${GlobalState.thisUser.token}'
          });
    if (response.statusCode == 200) {
      _reservationResponse = json.decode(response.body);
      if (_reservationID == -1) {
        _reservationID = _reservationResponse['data']['id'];
        status =
            (_reservationResponse['data']['status'].toString().toLowerCase() ==
                    'pending')
                ? "Pending"
                : (_reservationResponse['data']['status']
                            .toString()
                            .toLowerCase() ==
                        'accepted')
                    ? "Accepted"
                    : "Declined";
      }
      this.date = DateTime.parse(_reservationResponse['data']['date']);
      this.details = _reservationResponse['data']['details'];
      tableNo = _reservationResponse['data']['table_id'];
      try {
        this.peopleNumber =
            int.parse(_reservationResponse['data']['people_number']);
      } catch (e) {
        this.peopleNumber = _reservationResponse['data']['people_number'];
        print(e);
      }
      avtlo = (_reservationResponse['data']['avtlo'] == 1) ? true : false;
      waiterID = _reservationResponse['data']['waiter_id'];
      reservationRate = _reservationResponse['data']['rate'];
      GlobalState.toastMessage('Done');
    } else {
      GlobalState.toastMessage(json.decode(response.body).toString());
    }
    setState(() {
      _inProgress = false;
    });
  }

  cancelReservation() async {
    setState(() {
      _inProgress = true;
    });
    String apiURL =
        "${GlobalState.hostURL}/api/management_reservations/${_reservationID.toString()}";
    final response = await http.delete(apiURL,
        headers: {'Authorization': 'Bearer ${GlobalState.thisUser.token}'});
    if (response.statusCode == 200) {
      setState(() {
        canceled = true;
      });
      GlobalState.toastMessage(json.decode(response.body)["message"]);
    } else {
      setState(() {
        canceled = false;
        GlobalState.toastMessage(json.decode(response.body).toString());
      });
    }
    setState(() {
      _inProgress = false;
    });
  }

  getShop(int id) async {
    setState(() {
      _gettingShop = true;
    });
    String apiURL = '${GlobalState.hostURL}/api/shops/$id';
    final response = await http.get(apiURL);
    if (response.statusCode == 200) {
      _restaurantData = json.decode(response.body)['success']['shop'];
      tablesList = _restaurantData['tables'];
      for (int i = 0; i < tablesList.length; i++)
        setTable(tablesList[i]['id'], tablesList[i]['number']);
      tableNo = getTable(_reservationInfo['table_id']);
    } else {
      GlobalState.toastMessage('Error');
      Navigator.pop(context);
    }
    setState(() {
      _gettingShop = false;
    });
  }

  @override
  void initState() {
    super.initState();
    canceled = false;
    pendingText = 'Your request to '
        '${_restaurantData['name']} have been sent, '
        'waiting for their response.';
    canceledText = 'You have canceled your reservation request to '
        '${_restaurantData['name']} '
        'successfully.';
    refusedText = 'We\'re sorry, looks like '
        '${_restaurantData['name']} didn\'t accept '
        'your reservation request, wanna try another place ?';
    confirmText = '${_restaurantData['name']} '
        'accepted your reservation request and ready to serve you in time,'
        ' enjoy your meal !';
    pendingIcon = Icons.pending;
    confirmIcon = Icons.done;
    refusedIcon = FontAwesomeIcons.times;
    if (!ReservationResult.isFromLog)
      makeReservation(
          _reservationInfo['TableID'],
          _reservationInfo['Additional Details'],
          _reservationInfo['People#'],
          _reservationInfo['Full Date'],
          _reservationInfo['Live Location Access']);
    else {
      getShop(_restaurantData['id']);
      date = DateTime.parse(_reservationInfo['date']);
      details = _reservationInfo['details'];
      peopleNumber = _reservationInfo['people_number'];
      avtlo = (_reservationInfo['avtlo'] == 1) ? true : false;
      waiterID = _reservationInfo['waiter_id'];
      reservationRate = _reservationInfo['rate'];
    }
  }

  @override
  Widget build(BuildContext context) {
    waiterID = 3;
    reservationRate = 4;
    readyToRate = true;
    return SafeArea(
        top: true,
        child: Stack(children: [
          Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: ReservationResult.isFromLog,
                centerTitle: true,
                title: Text("Your Reservation Details"),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                leading: (!ReservationResult.isFromLog)
                    ? IconButton(
                        iconSize: 30,
                        icon: Icon(Icons.home, color: GlobalState.logoColor),
                        tooltip: 'Back to home',
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (Route<dynamic> route) => false);
                        },
                      )
                    : null,
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
              body: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (!canceled) ? confirmationTile() : cancellationTile(),
                        Divider(
                          thickness: 2,
                        ),
                        reservationInfoWidget(),
                        SizedBox(
                          height: (canceled)
                              ? MediaQuery.of(context).size.height * 0.10
                              : MediaQuery.of(context).size.height * 0.20,
                        )
                      ],
                    )),
              )),
          Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: (status.toLowerCase() == 'declined' || canceled == true)
                ? refusedButton()
                : actionButtons(context),
          ),
          (_inProgress)
              ? GlobalState.parachuteLogoLoading(context, _inProgress,
                  headerText: 'Sending your reservation request...')
              : Container(),
          (_gettingShop)
              ? GlobalState.progressIndicator(context, transparent: false)
              : Container()
        ]));
  }

  Widget confirmationTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .75,
          child: Text(
            (status.toLowerCase() == "pending")
                ? pendingText
                : (status.toLowerCase() == 'accepted')
                    ? confirmText
                    : refusedText,
            style: TextStyle(fontSize: 18),
          ),
        ),
        GlobalState.reservationStatusIcon(status, size: 40),
      ],
    );
  }

  Widget cancellationTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .75,
          child: Text(
            canceledText,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Icon(
          confirmIcon,
          size: 40,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget reservationInfoWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Restaurant Details :',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name :\n${_restaurantData['name']}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Container(
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: GlobalState.secondColor, width: 1),
                  ),
                  child: Image.network(
                      "${GlobalState.hostURL + _restaurantData['icon']}",
                      fit: BoxFit.fitWidth)),
            ]),
        SizedBox(
          height: 10,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  'Address : \n${_restaurantData['address']}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
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
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Icon(Icons.my_location, size: 18, color: Colors.white),
                    ],
                  ),
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return PlaceLocation.showLocation(
                    //       false,
                    //       LatLng(double.parse(_restaurantData['lat']),
                    //           double.parse(_restaurantData['long'])));
                    // }));
                  }),
            ]),
        (waiterID == null)
            ? SizedBox()
            : SizedBox(
                height: 10,
              ),
        (waiterID == null)
            ? SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                      'Waiter ID : \n$waiterID',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    if (readyToRate)
                      RaisedButton(
                          color: GlobalState.logoColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              side: BorderSide(color: GlobalState.logoColor)),
                          child: Text(
                            "Rate Waiter",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onPressed: () {
                            //
                          }),
                  ]),
        Divider(
          thickness: 2,
        ),
        Text(
          'Reservation Details :',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
        (canceled)
            ? Text(
                'Status : Canceled',
                style: TextStyle(
                  color: GlobalState.logoColor,
                  fontSize: 18,
                ),
              )
            : SizedBox(),
        if (!_inProgress)
          Text(
            'Date : \n${DateFormat('EEEE d MMMM y').format(date)}\n${DateFormat.jm().format(date)}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Number of people : \n$peopleNumber',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Table# : \n$tableNo',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        (details == '' || details == null)
            ? SizedBox()
            : Text(
                'Additional Details : \n$details',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
        (details == '' || details == null)
            ? SizedBox()
            : SizedBox(
                height: 10,
              ),
        (avtlo == true)
            ? Text(
                'Live Location Access :\nYes',
                style: TextStyle(
                  fontSize: 18,
                ),
              )
            : SizedBox(),
        (avtlo == true)
            ? SizedBox(
                height: 10,
              )
            : SizedBox(),
        Text(
          'Name : \n${GlobalState.thisUser.firstName + ' ' + GlobalState.thisUser.lastName}',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Phone : \n${GlobalState.thisUser.phone}',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        if (ReservationResult.isFromLog)
          SizedBox(
            height: 10,
          ),
        if (ReservationResult.isFromLog)
          Text(
            'Created at : \n'
            '${DateFormat('EEEE d MMMM y').format(DateTime.parse(_reservationInfo['created_at']))}\n${DateFormat('jm').format(DateTime.parse(_reservationInfo['created_at']))}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        (reservationRate == null)
            ? SizedBox()
            : SizedBox(
                height: 10,
              ),
        (reservationRate == null)
            ? SizedBox()
            : GlobalState.rateWithIcon(reservationRate,
                isRow: true,
                text: Text(
                  'Your Rate : ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
      ],
    );
  }

  Widget refusedButton() {
    return RaisedButton(
      color: GlobalState.logoColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: BorderSide(color: GlobalState.logoColor)),
      child: Text(
        'Try another restaurant',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
      },
    );
  }

  Widget actionButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RaisedButton(
          color: GlobalState.logoColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: GlobalState.logoColor)),
          child: Text(
            'Edit Reservation',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RestaurantReservation.edit(
                    _restaurantData,
                    true,
                    _reservationInfo,
                    this._reservationID)));
          },
        ),
        RaisedButton(
          color: GlobalState.logoColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: GlobalState.logoColor)),
          child: Text(
            'Cancel Reservation',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            GlobalState.alert(context, onConfirm: () {
              Navigator.pop(context);
              cancelReservation();
            }, onCancel: () {
              setState(() {
                Navigator.pop(context);
              });
            },
                confirmText: 'Yes, delete my reservation',
                cancelText: 'No, go back',
                title: 'Warning',
                message: 'Are you sure you want to cancel this reservation? '
                    'this step cannot be undone.');
          },
        )
      ],
    );
  }
}
