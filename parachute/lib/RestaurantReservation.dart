import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:parachute/ReservationResult.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'GlobalState.dart';
import 'User.dart';

// ignore: must_be_immutable
class RestaurantReservation extends StatefulWidget {
  final Map _restaurantData;
  Map _reservationInfo;
  int _reservationID;
  bool edit;

  RestaurantReservation(this._restaurantData, this.edit);

  RestaurantReservation.edit(this._restaurantData, this.edit,
      this._reservationInfo, this._reservationID);

  @override
  State<StatefulWidget> createState() {
    return (edit)
        ? _RestaurantReservation.edit(this._restaurantData, this.edit,
            this._reservationInfo, this._reservationID)
        : _RestaurantReservation(this._restaurantData, this.edit);
  }
}

class _RestaurantReservation extends State<RestaurantReservation> {
  Map _restaurantData;
  int _reservationID;
  User _user;
  bool edit;
  TextEditingController _additionalDetailsController;
  Map<dynamic, dynamic> _reservationInfo = <dynamic, dynamic>{};
  Map<dynamic, dynamic> tablesMap = <dynamic, dynamic>{};
  List<DropdownMenuItem<String>> tables = [];
  List<DateTime> nextWeekOpeningDays = [];
  int selectedDate;
  int selectedTime;
  int selectedPeopleNoIndex;
  String _reservationDate;
  String _reservationTime;
  var _reservationFullDate;
  String _reservationDetails;
  int _peopleNo;
  String tableID;
  String tableNo;
  bool atvLo;
  List<String> timeSlots;
  TimeOfDay startTime;
  TimeOfDay endTime;
  final step = Duration(minutes: 30);
  List<String> _specialOccasions;
  String _specialOccasionsFinal;
  bool _inProgress;
  String closingDaysString;
  List<String> closingDaysList;
  bool oddTiming = false;
  DateTime now = DateTime.now();

  _RestaurantReservation(this._restaurantData, this.edit);

  _RestaurantReservation.edit(this._restaurantData, this.edit,
      this._reservationInfo, this._reservationID);

  setTable(dynamic key, dynamic value) => tablesMap[key] = value;

  getTable(dynamic key) => tablesMap[key];

  @override
  void initState() {
    super.initState();
    if (!edit) {
      selectedDate = -1;
      selectedTime = -1;
      selectedPeopleNoIndex = -1;
      _additionalDetailsController = new TextEditingController();
      _reservationID = -1;
    } else {
      selectedDate = _reservationInfo['Edit']['Date'];
      selectedTime = _reservationInfo['Edit']['Time'];
      selectedPeopleNoIndex = _reservationInfo['Edit']['People#'];
      tableID = _reservationInfo['Edit']['TableID'];
      tableNo = _reservationInfo['Edit']['Table#'];
      _additionalDetailsController = new TextEditingController(
          text: _reservationInfo['Edit']['Additional Details']);
      _specialOccasions = _reservationInfo['Edit']['Special Occasions'];
      _reservationDate = _reservationInfo['Date'];
      _reservationTime = _reservationInfo['Time'];
      _peopleNo = _reservationInfo['People#'];
    }
    prepareTables();
    atvLo = false;
    setOpeningTimes(
        (edit)
            ? _restaurantData['open_days']
            : _restaurantData['success']['shop']['open_days'],
        (edit)
            ? _restaurantData['open_hours']
            : _restaurantData['success']['shop']['open_hours']);
    if ((now.isAfter(DateTime(
            now.year, now.month, now.day, endTime.hour, endTime.minute))) &&
        !oddTiming) {
      getNextWeekOpeningDays(now.add(Duration(days: 1)));
    } else {
      getNextWeekOpeningDays(now);
    }
    _user = GlobalState.thisUser;
    _inProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Book A Table"),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
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
            children: [
              reservationContext(context),
              Positioned(
                  right: 0,
                  left: 0,
                  bottom: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side: BorderSide(color: GlobalState.logoColor)),
                            onPressed: (selectedDate == -1 ||
                                    selectedTime == -1 ||
                                    selectedPeopleNoIndex == -1 ||
                                    tableID == null)
                                ? null
                                : () {
                                    if (remainingTime(60)) {
                                      GlobalState.alert(context, onConfirm: () {
                                        this.setState(() {
                                          atvLo = true;
                                          prepareReservationInfo();
                                          Navigator.pop(context);
                                          _inProgress = true;
                                        });
                                      }, onCancel: () {
                                        setState(() {
                                          atvLo = false;
                                          prepareReservationInfo();
                                          Navigator.pop(context);
                                          _inProgress = true;
                                        });
                                      },
                                          title: 'Live Location Access',
                                          message:
                                              'Dear user, we recommend that you allow us to access your '
                                              'live Location to ensure that you get your delicious hot '
                                              'meal ready in time, so we can save your time and provide you with'
                                              ' the best reservation experience, '
                                              'we pledge to keep this information private and no one will'
                                              ' be able to access your live Location except the employee '
                                              'responsible for your reservation in the concerned '
                                              'restaurant, do you agree?');
                                    } else {
                                      prepareReservationInfo();
                                      setState(() {
                                        _inProgress = true;
                                      });
                                    }
                                  },
                            color: GlobalState.logoColor,
                            disabledColor:
                                GlobalState.logoColor.withOpacity(0.5),
                            child: Text(
                              "Submit",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ))),
                  )),
              (_inProgress) ? parachuteLogoLoading() : Container(),
            ],
          ),
        ));
  }

  Widget parachuteLogoLoading() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      width: MediaQuery.of(context).size.width,
      color: GlobalState.secondColor.withOpacity(0.7),
      child: Center(
        child: CircularPercentIndicator(
          radius: MediaQuery.of(context).size.width * 0.66,
          animation: _inProgress,
          animationDuration: 5000,
          lineWidth: 15.0,
          percent: 1,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: GlobalState.secondColor,
          progressColor: GlobalState.logoColor,
          header: Text(
            'Sending your reservation request...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          footer: RaisedButton(
            onPressed: () {
              setState(() {
                _inProgress = false;
              });
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
                side: BorderSide(color: GlobalState.logoColor)),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 20),
            ),
            color: GlobalState.logoColor,
            textColor: Colors.white,
          ),
          center: Padding(
            padding: EdgeInsets.all(14),
            child: new Image.asset(
                'assets/logo/Parachute Logo Icon@2x - CircularLogoColor.png'),
          ),
          onAnimationEnd: () async {
            setState(() {
              _inProgress = false;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => ReservationResult(
                          _reservationInfo,
                          (edit)
                              ? _restaurantData
                              : _restaurantData['success']['shop'],
                          'Pending',
                          _reservationID)),
                  (Route<dynamic> route) => false);
            });
          },
        ),
      ),
    );
  }

  Widget reservationContext(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              child: (edit)
                  ? Image.network(
                      "${GlobalState.hostURL + _restaurantData['photo']}",
                      fit: BoxFit.fitWidth,
                    )
                  : Image.network(
                      "${GlobalState.hostURL + _restaurantData['success']['shop']['photo']}",
                      fit: BoxFit.fitWidth,
                    )),
          SizedBox(
            height: 20,
          ),
          restaurantCard(),
          SizedBox(
            height: 15,
          ),
          calenderHorizontalList(context),
          (selectedDate == -1) ? Container() : timeSlotsHorizontalList(context),
          (selectedTime == -1) ? Container() : numberOfPeople(context),
          (selectedDate == 0)
              ? Container(
                  height: 100,
                  child: Text('//Payment here//'),
                )
              : Container(),
          (selectedPeopleNoIndex == -1) ? Container() : pickTable(),
          (tableID == null) ? Container() : detailsAboutReservation(context),
          personalInformation(),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }

  Widget calenderHorizontalList(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "What Day ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: new List.generate(nextWeekOpeningDays.length + 1,
                  (int index) {
                int lastIndex = nextWeekOpeningDays.length;
                return GestureDetector(
                  child: Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (index == selectedDate)
                            ? GlobalState.logoColor
                            : Colors.white,
                        border: Border.all(
                            color: Colors.black.withAlpha(20), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (index == lastIndex)
                              ? Icon(Icons.arrow_forward,
                                  color: GlobalState.secondColor)
                              : Text(
                                  DateFormat('d MMM')
                                      .format(nextWeekOpeningDays[index]),
                                  style: TextStyle(
                                      color: GlobalState.secondColor,
                                      fontSize: 17),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          (index == lastIndex)
                              ? Text('More',
                                  style: TextStyle(
                                      color: GlobalState.secondColor,
                                      fontSize: 17))
                              : Text(
                                  (nextWeekOpeningDays[index].day == now.day &&
                                          nextWeekOpeningDays[index].month ==
                                              now.month &&
                                          nextWeekOpeningDays[index].year ==
                                              now.year)
                                      ? 'Today'
                                      : (nextWeekOpeningDays[index].day ==
                                                  (now.day + 1) &&
                                              nextWeekOpeningDays[index]
                                                      .month ==
                                                  (now.month) &&
                                              nextWeekOpeningDays[index].year ==
                                                  now.year)
                                          ? 'Tomorrow'
                                          : DateFormat('EEEE').format(
                                              nextWeekOpeningDays[index]),
                                  style: TextStyle(
                                      color: GlobalState.secondColor,
                                      fontSize: 17))
                        ],
                      )),
                  onTap: (index == lastIndex)
                      ? () {
                          setState(() {
                            getNextWeekOpeningDays(nextWeekOpeningDays.last
                                .add(Duration(days: 1)));
                          });
                        }
                      : () {
                          setState(() {
                            selectedDate = index;
                            _reservationDate = DateFormat('EEEE')
                                    .format(nextWeekOpeningDays[index]) +
                                " " +
                                DateFormat('d MMM')
                                    .format(nextWeekOpeningDays[index]);
                            selectedTime = -1;
                            _reservationTime = '';
                          });
                        },
                );
              })),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget timeSlotsHorizontalList(BuildContext context) {
    setTimeSlots();
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "What Time ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: new List.generate(timeSlots.length, (int index) {
                return GestureDetector(
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (index == selectedTime)
                          ? GlobalState.logoColor
                          : Colors.white,
                      border: Border.all(
                          color: Colors.black.withAlpha(20), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    ),
                    child: Center(
                      child: Text(
                        timeSlots[index],
                        style: TextStyle(
                            color: GlobalState.secondColor, fontSize: 17),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedTime = index;
                      _reservationTime = timeSlots[index].toString();
                    });
                  },
                );
              })),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget numberOfPeople(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "How Many People ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 100,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: new List.generate(15, (int index) {
                return GestureDetector(
                  child: Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (index == selectedPeopleNoIndex)
                            ? GlobalState.logoColor
                            : Colors.white,
                        border: Border.all(
                            color: Colors.black.withAlpha(20), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (index + 1).toString(),
                            style: TextStyle(
                                color: GlobalState.secondColor, fontSize: 17),
                          ),
                        ],
                      )),
                  onTap: () {
                    setState(() {
                      selectedPeopleNoIndex = index;
                      _peopleNo = index + 1;
                    });
                  },
                );
              })),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget detailsAboutReservation(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Details about your reservation (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _additionalDetailsController,
          textInputAction: TextInputAction.next,
          maxLines: null,
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: GlobalState.secondColor,
              hintText: "Enter Your Details Here",
              filled: true),
        ),
        SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Special occasion ? (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        CheckboxGroup(
          activeColor: GlobalState.logoColor,
          checked: (edit) ? _specialOccasions : null,
          labels: <String>["Birthday", "Anniversary", "This is my first visit"],
          onSelected: (labels) {
            setState(() {
              _specialOccasions = labels;
            });
          },
        )
      ],
    );
  }

  Widget pickTable() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Here's an Image of the tables in the restaurant, "
              "you can pick your table if it's available",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Image.asset(
            "assets/tables.jpg",
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Table Number :',
              style: TextStyle(fontSize: 15),
            ),
            DropdownButton<String>(
              hint: Text('Choose your table'),
              value: tableID,
              items: tables,
              onChanged: (table) {
                setState(() {
                  tableID = table;
                  tableNo = getTable('$tableID');
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  void getNextWeekOpeningDays(DateTime dateTime) {
    DateTime temp;
    int end = (edit)
        ? 7 * (((selectedDate / (7 - closingDaysList.length)) + 1).floor())
        : 7;
    for (int i = 0; i <= end; i++) {
      temp = getDate(dateTime.add(Duration(days: i)));
      if (!closingDaysList.contains(DateFormat('EEEE').format(temp))) {
        nextWeekOpeningDays.add(temp);
      }
    }
  }

  void setTimeSlots() {
    if ((nextWeekOpeningDays[selectedDate].day == now.day) &&
        (nextWeekOpeningDays[selectedDate].month == now.month) &&
        (nextWeekOpeningDays[selectedDate].year == now.year) &&
        (now.hour >= startTime.hour)) {
      if (now.minute >= 30) {
        final availableStartTime = TimeOfDay(hour: (now.hour + 1), minute: 0);
        if (oddTiming) {
          timeSlots = getTimes(
                  availableStartTime, TimeOfDay(hour: 23, minute: 30), step)
              .map((x) => x.format(context))
              .toList();
        } else {
          timeSlots = getTimes(availableStartTime, endTime, step)
              .map((x) => x.format(context))
              .toList();
        }
      } else {
        final availableStartTime = TimeOfDay(hour: (now.hour), minute: 30);
        if (oddTiming) {
          timeSlots = getTimes(
                  availableStartTime, TimeOfDay(hour: 23, minute: 30), step)
              .map((x) => x.format(context))
              .toList();
        } else {
          timeSlots = getTimes(availableStartTime, endTime, step)
              .map((x) => x.format(context))
              .toList();
        }
      }
    } else {
      if (oddTiming) {
        timeSlots = getTimes(TimeOfDay(hour: 0, minute: 0), endTime, step)
            .map((x) => x.format(context))
            .toList();
        timeSlots.addAll(
            getTimes(startTime, TimeOfDay(hour: 23, minute: 30), step)
                .map((x) => x.format(context))
                .toList());
      } else {
        timeSlots = getTimes(startTime, endTime, step)
            .map((x) => x.format(context))
            .toList();
      }
    }
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  Widget restaurantCard() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (edit)
                                  ? _restaurantData['name']
                                  : _restaurantData['success']['shop']['name'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: GlobalState.rateWithBlackStars((edit)
                                    ? _restaurantData['rank']
                                    : _restaurantData['success']['shop']
                                        ['rank'])),
                          ],
                        ),
                        Container(
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: GlobalState.secondColor, width: 1),
                            ),
                            child: (edit)
                                ? Image.network(
                                    "${GlobalState.hostURL + _restaurantData['icon']}",
                                    fit: BoxFit.fitWidth)
                                : Image.network(
                                    "${GlobalState.hostURL + _restaurantData['success']['shop']['icon']}",
                                    fit: BoxFit.fitWidth)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      (edit)
                          ? _restaurantData['details']
                          : _restaurantData['success']['shop']['details'],
                      style: TextStyle(
                          fontSize: 16, color: GlobalState.secondColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Address : ${(edit) ? _restaurantData['address'] : _restaurantData['success']['shop']['address']}',
                      style: TextStyle(
                          fontSize: 16, color: GlobalState.secondColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      (closingDaysString == 'Opens Everyday')
                          ? closingDaysString
                          : "Off Days : $closingDaysString",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                    Text(
                      "Opening Hours : ${(edit) ? _restaurantData['open_hours'] : _restaurantData['success']['shop']['open_hours']}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GlobalState.rateWithColoredStars(
                          (edit)
                              ? _restaurantData['rate']
                              : _restaurantData['success']['shop']['rate'],
                          text: Text('Reservation Rate',
                              style: TextStyle(
                                fontSize: 16,
                                color: GlobalState.secondColor,
                              )),
                          isRow: true),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget personalInformation() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      'Personal Information :',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${_user.firstName} ${_user.lastName}',
                      style: TextStyle(
                          fontSize: 18, color: GlobalState.secondColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${_user.phone}',
                      style: TextStyle(
                          fontSize: 18, color: GlobalState.secondColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${_user.email}',
                      style: TextStyle(
                          fontSize: 18, color: GlobalState.secondColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    border:
                        Border.all(color: Colors.black.withAlpha(20), width: 1),
                  ),
                  child: Icon(
                    Icons.person_pin,
                    color: GlobalState.logoColor,
                    size: 75,
                  ))
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void prepareReservationInfo() {
    if (_specialOccasions != null) {
      _specialOccasionsFinal = _specialOccasions.toString();
      _specialOccasionsFinal = _specialOccasionsFinal.replaceAll('[', '');
      _specialOccasionsFinal = _specialOccasionsFinal.replaceAll(']', '');
    }
    _reservationDetails = (_specialOccasions == null)
        ? _additionalDetailsController.text.toString()
        : (_additionalDetailsController.text.toString() == '')
            ? "$_specialOccasionsFinal"
            : _additionalDetailsController.text.toString() +
                "\nSpecial Occasions: $_specialOccasionsFinal";
    _reservationInfo = {
      'Date': _reservationDate,
      'Time': _reservationTime,
      'Full Date': _reservationFullDate,
      'People#': _peopleNo,
      'Additional Details': _reservationDetails,
      'TableID': tableID,
      'Table#': tableNo,
      'Live Location Access': atvLo,
      'Edit': {
        'Date': selectedDate,
        'Time': selectedTime,
        'People#': selectedPeopleNoIndex,
        'TableID': tableID,
        'Table#': tableNo,
        'Additional Details': _additionalDetailsController.text.toString(),
        'Special Occasions': _specialOccasions,
      },
    };
  }

  bool remainingTime(int threshold) {
    _reservationFullDate = DateTime(
        nextWeekOpeningDays[selectedDate].year,
        nextWeekOpeningDays[selectedDate].month,
        nextWeekOpeningDays[selectedDate].day,
        DateFormat.jm().parse('${timeSlots[selectedTime]}').hour,
        DateFormat.jm().parse('${timeSlots[selectedTime]}').minute);
    final difference = _reservationFullDate.difference(now).inMinutes;
    return (difference <= threshold) ? true : false;
  }

  void handleDays(String openDaysString) {
    List<String> closingDays = [
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
    closingDays.removeWhere((day) => openDays.contains(day));
    setState(() {
      closingDaysList = closingDays;
    });
    closingDaysString = (closingDays.isEmpty)
        ? 'Opens Everyday'
        : closingDays.toString().replaceFirst('[', '').replaceFirst(']', '');
  }

  void handleHours(String openHoursString) {
    openHoursString = openHoursString.replaceAll(' - ', '-');
    List<String> openHours = openHoursString.split('-');
    (openHours[0].contains("AM") && openHours[1].contains("PM"))
        ? oddTiming = false
        : oddTiming = true;
    startTime = TimeOfDay(
        hour: DateFormat.jm().parse(openHours[0]).hour,
        minute: DateFormat.jm().parse(openHours[0]).minute);
    endTime = TimeOfDay(
        hour: DateFormat.jm().parse(openHours[1]).hour,
        minute: DateFormat.jm().parse(openHours[1]).minute);
  }

  void setOpeningTimes(String openDaysString, String openHoursString) {
    if (openHoursString == '24/7') {
      closingDaysString = 'Opens Everyday';
      closingDaysList = [];
      startTime = TimeOfDay(hour: 0, minute: 0);
      endTime = TimeOfDay(hour: 23, minute: 30);
      return;
    }
    if (openHoursString == '24/24') {
      startTime = TimeOfDay(hour: 0, minute: 0);
      endTime = TimeOfDay(hour: 23, minute: 30);
      handleDays(openDaysString);
      return;
    }
    if (openDaysString == 'Opens Everyday') {
      closingDaysString = 'Opens Everyday';
      closingDaysList = [];
      handleHours(openHoursString);
      return;
    }
    handleDays(openDaysString);
    handleHours(openHoursString);
  }

  void prepareTables() {
    int myLength = (edit)
        ? _restaurantData['tables'].length
        : _restaurantData['success']['shop']['tables'].length;
    for (int i = 0; i < myLength; i++) {
      if (edit) {
        if (_restaurantData['tables'][i]['availability'].toString() ==
            'available') {
          tables.add(new DropdownMenuItem<String>(
            value: _restaurantData['tables'][i]['id'].toString(),
            child: new Text(_restaurantData['tables'][i]['number'].toString()),
          ));
          setTable(_restaurantData['tables'][i]['id'].toString(),
              _restaurantData['tables'][i]['number'].toString());
        }
      } else {
        if (_restaurantData['success']['shop']['tables'][i]['availability']
                .toString() ==
            'available') {
          tables.add(new DropdownMenuItem<String>(
            value: _restaurantData['success']['shop']['tables'][i]['id']
                .toString(),
            child: new Text(_restaurantData['success']['shop']['tables'][i]
                    ['number']
                .toString()),
          ));
          setTable(
              _restaurantData['success']['shop']['tables'][i]['id'].toString(),
              _restaurantData['success']['shop']['tables'][i]['number']
                  .toString());
        }
      }
    }
  }
}
