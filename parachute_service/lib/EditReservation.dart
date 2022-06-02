import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:parachute_service/GlobalState.dart';
import 'dart:async';
import 'package:numberpicker/numberpicker.dart';
import'package:image_picker/image_picker.dart';
import 'package:parachute_service/HomePage.dart';
import 'dart:io';
import 'package:path/path.dart';
import'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
 class EditReservation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _EditReservation();
  }

 }
 class _EditReservation extends State<EditReservation>{
   ImagePicker _imagePic=new ImagePicker();
   File _imageFile;
   Map _shopsInfo;
  List _daysList=['Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday',
   'Friday'];
  List <bool>_selectedDayList=[false,false,false,false,false,false,false];
  List <String> _readingTimeFromServer=List();
  List <String> _shopOpenDaysList=new List();
  List <String> firstOpeningList=List();
  List <String> secondClosingList=List();
  List <String> firstOpeningMinutesList=List();
  List <String> _minutesListFromFirstOpeningList=List();
  List <String> _minutesListFromSecondClosingList= List();
  Set<String> _selectedDays=Set();
  int currentIntegerValueForHoursClosing;
  int currentIntegerValueForMinutesClosing;
  int currentIntegerValueForHoursOpening;
  int currentIntegerValueForMinutesOpening;
  int _selectedReservationValue;
  int _selectedDeliveryValue;
  int _selectedOpeningValue;
  int _showImage;
  int _shopHasDelivery;
  int _shopHasReservation;
  NumberPicker integerNumberPickerForHoursOpening;
  NumberPicker integerNumberPickerForMinutesOpening;
  NumberPicker integerNumberPickerForHoursClosing;
  NumberPicker integerNumberPickerForMinutesClosing;
  bool _checkedNumberPicker;
  bool _isPressedFirstButtonOpening;
  bool _isPressedSecondButtonOpening;
  bool _inProgress;
  bool _isPressedFirstButtonClosing;
  bool _isPressedSecondButtonClosing;
  bool _checkedHorizontalList;
  bool _checkedValue;
  bool _buttonDisabled;
  bool _selectNewImage;
  String _openDays;
  String _openHours;
  String _openMinutes;
  String _openingPeriod;
  String _workingTime;
  String _closingHours;
  String _closingMinutes;
  String _closingPeriod;
  String _shopOpenDays;
  String _shopPhoto;
  String _openingHoursFromOpeningList;
  String _closingHoursFromSecondClosingList;
  String _minutesFromFirstOpeningList;
  String _minutesFromSecondClosingList;
  String _periodFromSecondClosingList;
  String _shopOpenTime;
  String _periodFromOpeningList;
  String token="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjM1NzYxOGJjZmQzYWRi"
      "NWI4NjRhYTc4MWJiNDFkNDY4YzZlNjk5NzVlNmM3MTZhYTU5NGMxZWQ1YTkzODZiYjhiYWM5Y"
      "jhhNTIwNGYyMzA0In0.eyJhdWQiOiIxIiwianRpIjoiMzU3NjE4YmNmZDNhZGI1Yjg2NGFhNz"
      "gxYmI0MWQ0NjhjNmU2OTk3NWU2YzcxNmFhNTk0YzFlZDVhOTM4NmJiOGJhYzliOGE1MjA0ZjI"
      "zMDQiLCJpYXQiOjE2MTI0NTgyMTAsIm5iZiI6MTYxMjQ1ODIxMCwiZXhwIjoxNjQzOTk0MjA5"
      "LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.c7u78g3nHbgyc5-e5MoIbuul-CxXga7MU2SzZ4m1"
      "qJIJFUVv8PXk-R8U4nKqnHjhYfmfAf-4p2qYnxwlZOfJ5LkaX-8nbO2_4wOVoukM-dEOq_Wob"
      "0F_LS48MbNdd54Fz2mhmVUYnjPRQsPVWO2IhHgbelHd2uB8IBuVfnhlSnz_E2sfvSSHPKgmIg"
      "3BXVtNjxCxjaR0Shvr6vgg1fBd3yeC3z5RLWR8XYodA4EvFLyPIHW8gkcYbtQ6VHk2rU7RmYl"
      "fGGeT9V-kpGe5SqqQ_gvEMwjJ94wRHWfT4TWywa2e6knNPr5Ot71HD4LJsad8c_AzZwy9Nsc5"
      "-byGKH-dl4r9_TfizqwOZc3hxWqO4zZdQPKiu3tuVbw2vWzdwm0nQczTESrMzFqYDTIMaDSKv"
      "33Vm1dqe1UXsz-NYX1pykXV8RSexrIfySO5fAUWy8M4E_V4wLGHsq-hVLIsRouab7RuGyHCJN"
      "gOJPrFy3DdOCc-yItoLxjEEnk2NF9ZukZdOK0JoUGBbIbo9jod4UL7gt5jCE2QrpkzSqD3jnv"
      "wAxRrAkO0NIxQx0lpEbWaZZCHjNmV22nicD4xkgi2SprC4Auet7Zut5fn5Pt40qtL-2AcUHM3"
      "nWQ9pDp07A3H54NKg8B-W98nEvMTGcxSHCr02W4srkQwzGMPDlI557FloPs";
  @override
  void initState() {
    super.initState();
    _readingTimeFromServer=["Open","Close"];
    _checkedNumberPicker=false;
    _isPressedFirstButtonOpening=false;
    _isPressedSecondButtonOpening=false;
    _isPressedFirstButtonClosing=false;
   _isPressedSecondButtonClosing=false;
    _selectedReservationValue=0;
    _selectedDeliveryValue=0;
    _selectedOpeningValue=0;
    _buttonDisabled=true;
    _openHours="1";
    _openMinutes="00";
    _closingHours="1";
    _closingMinutes="00";
    _showImage=0;
    currentIntegerValueForHoursClosing=1;
    currentIntegerValueForHoursOpening=1;
    currentIntegerValueForMinutesClosing=0;
    currentIntegerValueForMinutesOpening=0;
    _selectNewImage=false;
    _checkedHorizontalList=false;
    _checkedValue=false;
    _inProgress=false;
     getData();

    // preparingTime();
  }
  void initialOpenTimePeriod(){
    if(_isPressedFirstButtonOpening==true){
      _openingPeriod="AM";
    }
    if(_isPressedFirstButtonClosing==true)
      _closingPeriod="AM";
  }
  void preparingTime(){
    setState(() {
      if(_checkedHorizontalList==false && _checkedValue) {
        _openDays = "Opens EveryDay";
        _workingTime = "24/7";
      }
      else if(_checkedHorizontalList ==false){
        _openDays="Opens EveryDay";
      }
      else if(_checkedValue)
        _workingTime="24/24";
      if(_checkedValue==false && _checkedNumberPicker==true)
        _workingTime="$_openHours:$_openMinutes $_openingPeriod - "
            "$_closingHours:$_closingMinutes $_closingPeriod";
    });
  }
  getData() async {
    _inProgress=true;
    String apiURL = "${GlobalState.hostURL}/api/shops/1";
    http.Response response = await http.get(apiURL);
    if (response.statusCode == 200) {
      _shopsInfo = json.decode(response.body);
      _shopOpenDays =_shopsInfo['success']['shop']['open_days'];
      _shopHasDelivery =(_shopsInfo['success']['shop']['delivery']==null)?0:
      _shopsInfo['success']['shop']['delivery'];
      _shopHasReservation =(_shopsInfo['success']['shop']['reservation']==null)?0:
      _shopsInfo['success']['shop']['reservation'];
      _shopOpenTime=(_shopsInfo['success']['shop']['open_hours']=="")?"24/24":
      _shopsInfo['success']['shop']['open_hours'];
      _shopPhoto=_shopsInfo['success']['shop']['tables_photo'];
      _shopOpenDaysList=_shopOpenDays.replaceAll(new RegExp(r"\s+"), "").split(",");
      setState(() {
        _selectedReservationValue=_shopHasReservation;
        _selectedDeliveryValue=_shopHasDelivery;
        if(_shopOpenDays=="Opens EveryDay"){
          _selectedOpeningValue=1;
        _checkedHorizontalList=false;
        }
        else {
          _selectedOpeningValue=2;
          _checkedHorizontalList=true;
          for (int i = 0; i < _shopOpenDaysList.length; i++) {
          for (int j = 0; j <= 6; j++) {
            if (_shopOpenDaysList[i] == _daysList[j])
              _selectedDayList[j] = true;
            _selectedDays.add(_shopOpenDaysList[i]);
          }
          }
          _openDays=_selectedDays.toString().replaceAll("{","")
           .replaceAll("}","");
        }
        if(_shopOpenTime=="24/24" || _shopOpenTime=="24/7") {
          _checkedValue = true;
          _workingTime = _shopOpenTime;
        }else{
          _checkedValue=false;
          _workingTime=_shopOpenTime.replaceAll(" - ","-").toString();
          _readingTimeFromServer=_workingTime.split("-");
          firstOpeningList=_readingTimeFromServer[0].split(":");
          secondClosingList=_readingTimeFromServer[1].split(":");
          //First Part From First Opening List
          //Get Hours From First Part
          _openingHoursFromOpeningList=firstOpeningList[0];
          //Get Minutes From First Part
          _minutesListFromFirstOpeningList=firstOpeningList[1].split(" ");
          _minutesFromFirstOpeningList=_minutesListFromFirstOpeningList[0];
          //Get Period From First Part
          _periodFromOpeningList=_minutesListFromFirstOpeningList[1];
          // Second Part From Second Opening List
          //Get Hours From Second Part
          _closingHoursFromSecondClosingList=secondClosingList[0];
          //Get Minutes From Second Part
          _minutesListFromSecondClosingList=secondClosingList[1].split(" ");
          _minutesFromSecondClosingList=_minutesListFromSecondClosingList[0];
          //Get Period From Second Part
          _periodFromSecondClosingList=_minutesListFromSecondClosingList[1];
          print("hey I am umber Picker");
          _workingTime="$_openingHoursFromOpeningList:"
              "$_minutesFromFirstOpeningList"
              " $_periodFromOpeningList - "
              "$_closingHoursFromSecondClosingList:"
              "$_minutesFromSecondClosingList "
              "$_periodFromSecondClosingList";
          print(_workingTime);
            // currentIntegerValueForHoursOpening=int.parse(_openingHoursFromOpeningList);
            // currentIntegerValueForMinutesOpening=int.parse(_minutesFromFirstOpeningList);
            // currentIntegerValueForHoursClosing=int.parse(_closingHoursFromSecondClosingList);
            // currentIntegerValueForMinutesClosing=int.parse(_minutesFromSecondClosingList);
            // print(currentIntegerValueForHoursOpening);
            // print(currentIntegerValueForMinutesOpening);
            // print(currentIntegerValueForHoursClosing);
            // print(currentIntegerValueForMinutesClosing);
          //Setting Buttons
          if(_periodFromOpeningList=="AM"){
            _openingPeriod="AM";
            _isPressedFirstButtonOpening=true;
          }else{
            _openingPeriod="PM";
            _isPressedSecondButtonOpening=true;
          }
          if(_periodFromSecondClosingList=="AM"){
            _closingPeriod="AM";
            _isPressedFirstButtonClosing=true;
          }
          else{
            _closingPeriod="PM";
            _isPressedSecondButtonClosing=true;
          }
        }
        if(_selectedReservationValue==1)
          {
            _selectNewImage=true;
            _buttonDisabled=false;
          }
      });
      // await integerNumberPickerForHoursOpening.animateInt(currentIntegerValueForHoursOpening);
      // await integerNumberPickerForMinutesOpening.animateInt(currentIntegerValueForMinutesOpening);
      // await integerNumberPickerForHoursClosing.animateInt(currentIntegerValueForHoursClosing);
      // await integerNumberPickerForMinutesClosing.animateInt(currentIntegerValueForMinutesClosing);

      // await integerNumberPickerForHoursOpening
      //     .animateInt(currentIntegerValueForHoursOpening)
      //     .then((value) {
      //   integerNumberPickerForMinutesOpening
      //       .animateInt(currentIntegerValueForMinutesOpening)
      //       .then((value) {
      //     integerNumberPickerForHoursClosing
      //         .animateInt(currentIntegerValueForHoursClosing)
      //         .then((value) {
      //       integerNumberPickerForMinutesClosing
      //           .animateInt(currentIntegerValueForMinutesClosing);
      //     });
      //   });
      // });
    }
    setState(() {
      _inProgress=false;
    });
    print(_shopOpenDaysList.toString());
    print("fetch data"+_openDays.toString());
    print("fetch data"+_shopHasDelivery.toString());
    print("fetch data"+_shopHasReservation.toString());
    print("fetch data"+_workingTime.toString());
    print(_readingTimeFromServer.toString());
  }

   @override
  void dispose() {
    super.dispose();

  }

  void uploadInfo(BuildContext context,File filePath,String openDays,String workingTime,
      int hasReservation,
      int hasDelivery) async{
    setState(() {
      _inProgress=true;
    });
    String fileName=basename(filePath.path);
    // print("file base Name $fileName");
    // print("file path"+filePath.path);
    try{
      FormData formData=new FormData.fromMap({
        "open_days":openDays,
        "open_hours":workingTime,
        "reservation":hasReservation,
        "delivery":hasDelivery,
        "_method":"put",
        "tables_photo":await MultipartFile.fromFile(filePath.path,
            filename:fileName,
           contentType: MediaType("image","jpg"),
        )
      });
      Response response =
          await Dio().post("http://parachute-group.com/api/management_shops/1",
              data:formData,
           options:Options(headers:{
             "Authorization":"Bearer $token"})
          );
      // print("file uploaded Response$response");
      if(response.statusCode==200){
        print("successfully response");
        setState(() {
          currentIntegerValueForHoursOpening=0;
          currentIntegerValueForHoursClosing=0;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>HomePage()),
                  (Route<dynamic> route) => false);
          _inProgress=false;
        });
      }
    }catch(e){
      print("Exception caught: $e");
    }
  }
  void uploadInfoWithoutFile(BuildContext context,String openDays,String workingTime,
      int hasReservation,
      int hasDelivery) async{
    setState(() {
      _inProgress=true;
    });
    try{
      FormData formData=new FormData.fromMap({
        "open_days":openDays,
        "open_hours":workingTime,
        "reservation":hasReservation,
        "delivery":hasDelivery,
        "_method":"put",
      });
      Response response =
      await Dio().post("http://parachute-group.com/api/management_shops/1",
          data:formData,
          options:Options(headers:{
            "Authorization":"Bearer $token"})
      );
      if(response.statusCode==200){
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>HomePage()),
                  (Route<dynamic> route) => false);
          _inProgress=false;

        });
      }
    }catch(e){
      print("Exception caught: $e");
    }
  }
  Future<void> _showChoiceDialog(BuildContext context){
   return showDialog(context: context,builder: (BuildContext context){
        return AlertDialog(
          title: Text("Make a Choice !"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: (){
                    // print("gallery");
                    _openGallery(context);
                  },
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: (){
                    // print("camera");
                    _openCamera(context);
                  },
                ),
              ],
            ),
          ),
        );
   });
  }
   _openGallery(BuildContext context) async{
    PickedFile picture=await _imagePic.getImage(source:ImageSource.gallery);
    this.setState(() {
    _imageFile = File(picture.path);
    });
    Navigator.of(context).pop();
  }
  _openCamera(BuildContext context) async{
    var picture=await _imagePic.getImage(source:ImageSource.camera);
    this.setState(() {
      _imageFile = File(picture.path);
    });
    Navigator.of(context).pop();
  }
  setSelectedReservationRadioBox(int val){
    setState(() {
      _selectedReservationValue=val;
    });
  }
  setSelectedDeliveryRadioBox(int val){
    setState(() {
      _selectedDeliveryValue=val;
    });
  }
  setSelectedOpeningRadioBox(int val){
    setState(() {
      _selectedOpeningValue=val;
    });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      integerNumberPickerForHoursOpening=NumberPicker.integer(
        highlightSelectedValue: false,
          initialValue: 1,
          minValue: 1,
          step: 1,
          maxValue: 12,
          onChanged:(value){
            _checkedNumberPicker=true;
            setState(() {
              currentIntegerValueForHoursOpening=value;
              _openHours=currentIntegerValueForHoursOpening.toString();

            });
          });
      integerNumberPickerForMinutesOpening=NumberPicker.integer(
          highlightSelectedValue: false,
          initialValue: 0,
          zeroPad: true,
          minValue: 0,
          maxValue: 59,
          onChanged: (value){
            setState(() {
              if(value==1)
                value=0;
              currentIntegerValueForMinutesOpening=value;
              if(currentIntegerValueForMinutesOpening<10)
                _openMinutes="0$currentIntegerValueForMinutesOpening";
              else
                _openMinutes=currentIntegerValueForMinutesOpening.toString();
            });
          });
      integerNumberPickerForHoursClosing=NumberPicker.integer(
          highlightSelectedValue: false,
          initialValue: 1,
          minValue: 1,
          step: 1,
          maxValue: 12,
          onChanged: (value){
            setState(() {
              currentIntegerValueForHoursClosing=value;
              _closingHours=currentIntegerValueForHoursClosing.toString();
            });
          });
      integerNumberPickerForMinutesClosing=NumberPicker.integer(
          highlightSelectedValue: false,
          initialValue: 0,
          zeroPad: true,
          minValue: 0,
          maxValue: 59,
          onChanged:(value){
            setState(() {
              if(value==1)
                value=0;
              currentIntegerValueForMinutesClosing=value;
              _closingMinutes=currentIntegerValueForMinutesClosing.toString();
              if(currentIntegerValueForMinutesClosing<10)
                _closingMinutes="0$currentIntegerValueForMinutesClosing";
              else
                _closingMinutes=currentIntegerValueForMinutesClosing.toString();
            });
          });
      print("one"+currentIntegerValueForHoursOpening.toString());
      print("two"+currentIntegerValueForMinutesOpening.toString());
      print("three"+currentIntegerValueForHoursClosing.toString());
      print("four"+currentIntegerValueForMinutesClosing.toString());
    });

    return SafeArea(
     top: true,
     child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       toolbarHeight: MediaQuery.of(context).size.height*0.097,
       centerTitle:true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )
        ),
       title: Text("Setting Your Shop Info"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>HomePage()),
                    (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: mainBody(context)
          ),
          (_inProgress)? GlobalState.progressIndicator(context,
              transparent: false):Center()
        ],
      ),
     ),

    );
  }

  Widget mainLogo(BuildContext context) {
   return Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
    child: Image.asset(
     "assets/logo/Parachute-Logo-on-Red.png",
     height: MediaQuery.of(context).size.height * 0.07,
     fit: BoxFit.fitHeight,
    ),
   );
  }
  Widget mainBody(BuildContext context){
   return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
     SizedBox(height: 20,),
      RadioListTile(
          value: 1,
          groupValue:_selectedOpeningValue,
          title: Text("Opens EveryDay"),
          onChanged:(val){
            setState(() {
              setSelectedOpeningRadioBox(val);
              if(_selectedOpeningValue==1)
                _checkedHorizontalList=false;
            });
          }
      ),
      RadioListTile(
          value: 2,
          groupValue:_selectedOpeningValue,
          title: Text("Specific Days"),
          onChanged:(val){
            setState(() {
              setSelectedOpeningRadioBox(val);
              if(_selectedOpeningValue==2)
                _checkedHorizontalList=true;
              _openDays='';
              _selectedDays.clear();
              for(int i=0;i<7;i++)
                _selectedDayList[i]=false;
            });
          }
          ),
      SizedBox(height: 15),
      (_checkedHorizontalList)?Padding(
       padding: const EdgeInsets.only(left: 15),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Text("Open Days :",style: TextStyle(
               fontWeight: FontWeight.bold,
               fontSize: 18
           ),),
         ],
       ),
     ):Container(),
     SizedBox(height: 15,),
      (_checkedHorizontalList)?dataHorizontalList():Container(),
     SizedBox(height:15,),
     openHours(),
      SizedBox(height: 15,),
      (_checkedValue)?Container(): closedHours(),
      SizedBox(height: 15,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: reservationRadioBox()),
          Expanded(child: deliveryRadioBox()),
        ],
      ),
      SizedBox(height: 15,),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:15),
            child: RaisedButton(
              color:GlobalState.logoColor,
              disabledColor: GlobalState.logoColor.withOpacity(0.5),
              onPressed:(_buttonDisabled)? null :(){
                setState(() {
                  _showImage=1;
                });
               } ,
              child: Text("Click Here To Show Image "),
            ),
          ),
        ],
      ),
      (_showImage==1)?reservationImage(context):Container(),
      SizedBox(height: 20,),
      RaisedButton(
        color: GlobalState.logoColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: GlobalState.secondColor)),
        onPressed: () async{
          setState(() {
            preparingTime();
            print(_workingTime.length.toString());
            if(_selectedOpeningValue==1 || _selectedOpeningValue==2){
            if(_openDays.isEmpty){
              GlobalState.alert(
                  context, onConfirm: (){
                Navigator.of(context).pop();
              },onCancel: (){},
                  title: "Warning !",
                  message: "Dear user, please specify "
                      "the days that the restaurant will be opened.",
                  confirmText: "Got It",
                  confirmOnly: true);
            }
            else if(_workingTime.contains("null") || (_isPressedFirstButtonOpening==false
            &&_isPressedSecondButtonOpening==false &&
                _workingTime!="24/24"&&_workingTime!="24/7") ||
      (_isPressedFirstButtonClosing==false && _isPressedSecondButtonClosing==false && _workingTime!="24/24"&&_workingTime!="24/7")
           &&_workingTime!="24/24" && _workingTime!="24/7") {
              print("hey from 2");
              GlobalState.alert(
                  context, onConfirm: (){
                Navigator.of(context).pop();
              },onCancel: (){},
                  title: "Warning !",
                  message: "Dear user, please specify the"
                      " time that the restaurant will be worked through.",
                  confirmText: "Got It",
                  confirmOnly: true);
            }
            if(_selectedReservationValue==1
            &&(_openDays.isNotEmpty)&&(_workingTime=="24/7"||
                _workingTime=="24/24"||(
                _isPressedFirstButtonOpening==true
                    ||_isPressedSecondButtonOpening==true &&
                    _workingTime!="24/24"&&_workingTime!="24/7"&&
                    _workingTime.length>16
            )&&(
                _isPressedFirstButtonClosing==true
                    ||_isPressedSecondButtonClosing==true &&
                    _workingTime!="24/24"&&_workingTime!="24/7"&&
                    _workingTime.length>16
            )
            )){
                if(_imageFile==null && _selectNewImage==false){
                  GlobalState.alert(context, onConfirm: (){
                    Navigator.of(context).pop();
                  }, confirmOnly: true,
                      onCancel: (){},
                  title: "Warning !",
                  message: "Dear user, please choose a picture of "
                      "the tables in your restaurant",
                  confirmText: "Got It");
                }else{
                  uploadInfo(context,_imageFile, _openDays,
                   _workingTime, _selectedReservationValue, _selectedDeliveryValue);
                }
            }else
              if(_selectedReservationValue==0 &&
                  _openDays.isNotEmpty && (_workingTime=="24/24"||
                  _workingTime=="24/7"||
                  (
                      _isPressedFirstButtonOpening==true
                          ||_isPressedSecondButtonOpening==true &&
                          _workingTime!="24/24"&&_workingTime!="24/7"&&
                          _workingTime.length>16
                  )&&(
                      _isPressedFirstButtonClosing==true
                          ||_isPressedSecondButtonClosing==true &&
                          _workingTime!="24/24"&&_workingTime!="24/7"&&
                          _workingTime.length>16
                  )) ){
                print("open Days After Update"+_openDays.toString());
               uploadInfoWithoutFile(context,_openDays, _workingTime,
                   _selectedReservationValue, _selectedDeliveryValue);
              }

            }else{
              _openDays="";
              GlobalState.alert(context, onConfirm: (){
                Navigator.of(context).pop();
              },onCancel: (){},
              confirmOnly: true,
              title: "Warning",
              message: "Dear user, please specify one of the cases"
                  " of the restaurant opening days",
              confirmText: "Got It");
            }
          });
        },
        child: Text(
          'Save Changes',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    ],
   );
  }
Widget dataHorizontalList(){
return Container(
 height: 100,
padding: EdgeInsets.symmetric(horizontal: 10),
 child: ListView(
  scrollDirection: Axis.horizontal,
children: new List.generate(7, (index) {
           return GestureDetector(
            child: Container(
                width: 100,
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                 color: _selectedDayList[index]?GlobalState.logoColor:
                 Colors.white,
                 border: Border.all(
                     color: Colors.black.withAlpha(20), width: 1),
                 borderRadius: BorderRadius.all(Radius.circular(14.0)),
                ),
                child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                  Text(
                   _daysList[index].toString(),
                   maxLines: 1,
                   style: TextStyle(
                       color: GlobalState.secondColor, fontSize: 17),
                  ),
                 ],
                )
            ),
            onTap: (){
             setState(() {
              _selectedDayList[index]=!_selectedDayList[index];
              if(_selectedDayList[index]){
                _selectedDays.add(_daysList[index]);
              }else if(!_selectedDayList[index]){
                _selectedDays.remove(_daysList[index]);
              }
              _openDays=_selectedDays.toString().replaceAll("{","")
                  .replaceAll("}","");
             });
            },
           );
        }
        ),
 ),
);
}
Widget openHours(){
   return Column(
    children: [
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Padding(
         padding: const EdgeInsets.only(left:15),
         child: Text("Opening Time :",style: TextStyle(
             fontWeight: FontWeight.bold,
             fontSize: 18
         ),
         ),
       ),
        Padding(
          padding: const EdgeInsets.only(right:15),
          child: Row(
            children: [
              Checkbox(
                value:_checkedValue,
                onChanged: (bool value){
                  setState(() {
                    _checkedValue=value;
                    _workingTime="";
                    currentIntegerValueForMinutesOpening=0;
                    currentIntegerValueForHoursOpening=0;
                    currentIntegerValueForHoursClosing=0;
                    currentIntegerValueForMinutesClosing=0;
                    _isPressedSecondButtonOpening=false;
                    _isPressedFirstButtonOpening=false;
                    _isPressedFirstButtonClosing=false;
                    _isPressedSecondButtonClosing=false;
                  });
                },
              ),
              Text("24/24",style: TextStyle(fontSize: 18),),
            ],
          ),
        )
      ],
     ),
      SizedBox(height: 15,),
      (_checkedValue)?Container():Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 200,
            margin: EdgeInsets.only(right: 12),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color:GlobalState.logoColor,
              border: Border.all(
                  color: GlobalState.secondColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
            ),
            child:  Text("${_readingTimeFromServer[0]}",
              style:TextStyle(fontSize: 18,color: GlobalState.secondColor),),
          )
        ],
      ),
      SizedBox(height: 15,),
      (_checkedValue)?Container():Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Text("Hours",style: TextStyle(
                fontSize: 18 )),
            integerNumberPickerForHoursOpening,
          ],),
          Text("\n:",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
          ),
          Column(
            children: [
              Text("Minutes",style: TextStyle(
                fontSize: 18
              ),),
              integerNumberPickerForMinutesOpening,
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: Column(
              children: [
                RaisedButton(
                  color: _isPressedFirstButtonOpening?Colors.grey:Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: GlobalState.secondColor)),
                  onPressed: () {
                   setState(() {
                     if(_isPressedSecondButtonOpening) {
                       _isPressedSecondButtonOpening = false;
                     }
                       _isPressedFirstButtonOpening=!_isPressedFirstButtonOpening;
                     if(_isPressedFirstButtonOpening)
                       _openingPeriod="AM";
                     else
                       _openingPeriod="";
                   });
                  },
                  child: Text(
                    'AM',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                RaisedButton(
                  color: _isPressedSecondButtonOpening?Colors.grey:Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: GlobalState.secondColor)),
                  onPressed: () {
                    setState(() {
                      if(_isPressedFirstButtonOpening)
                        _isPressedFirstButtonOpening=false;
                        _isPressedSecondButtonOpening=!_isPressedSecondButtonOpening;
                      if(_isPressedSecondButtonOpening)
                        _openingPeriod="PM";
                      else
                        _openingPeriod="";
                    });
                  },
                  child: Text(
                    'PM',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ],
   );
}
  Widget closedHours(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:15),
              child: Text("Closing Time :",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15,),
        (_checkedValue)?Container():Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
                width: 200,
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: GlobalState.logoColor,
                  border: Border.all(
                      color: GlobalState.secondColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                ),
              child:  Text("${_readingTimeFromServer[1]}",
                  style:TextStyle(fontSize: 18,color: GlobalState.secondColor)),
            )
          ],
        ),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Hours",style: TextStyle(
                    fontSize: 18 )),
                integerNumberPickerForHoursClosing,
              ],),
            Text("\n:",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
            ),
            Column(
              children: [
                Text("Minutes",style: TextStyle(
                    fontSize: 18
                ),),
                integerNumberPickerForMinutesClosing,
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: Column(
                children: [
                  RaisedButton(
                    color: _isPressedFirstButtonClosing?Colors.grey:Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: GlobalState.secondColor)),
                    onPressed: () {
                      setState(() {
                        if(_isPressedSecondButtonClosing) {
                          _isPressedSecondButtonClosing = false;
                        }
                        _isPressedFirstButtonClosing=!_isPressedFirstButtonClosing;
                        if(_isPressedFirstButtonClosing)
                          _closingPeriod="AM";
                        else
                          _closingPeriod="";

                      });
                    },
                    child: Text(
                      'AM',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  RaisedButton(
                    color: _isPressedSecondButtonClosing?Colors.grey:Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: GlobalState.secondColor)),
                    onPressed: () {
                      setState(() {
                        if(_isPressedFirstButtonClosing)
                          _isPressedFirstButtonClosing=false;
                        _isPressedSecondButtonClosing=!_isPressedSecondButtonClosing;
                        if(_isPressedSecondButtonClosing)
                          _closingPeriod="PM";
                        else
                          _closingPeriod="";
                      });
                    },
                    child: Text(
                      'PM',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
Widget  reservationRadioBox(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Has Reservation",style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        RadioListTile(
            value: 1,
            groupValue:_selectedReservationValue,
            title: Text("True"),
            onChanged:(val){
              setState(() {
                setSelectedReservationRadioBox(val);
                _buttonDisabled=false;
              });
            }
            ),
        RadioListTile(
            value: 0,
            groupValue: _selectedReservationValue,
            title: Text("False"),
            onChanged:(val){
              setState(() {
                setSelectedReservationRadioBox(val);
                _buttonDisabled=true;
                _showImage=0;
              });
            })
      ],
    );
}
  Widget  deliveryRadioBox(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Has Delivery",style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        RadioListTile(
            value: 1,
            groupValue:_selectedDeliveryValue,
            title: Text("True"),
            onChanged:(val){
              setSelectedDeliveryRadioBox(val);
            }
        ),
        RadioListTile(
            value: 0,
            groupValue:_selectedDeliveryValue,
            title: Text("False"),
            onChanged:(val){
              setSelectedDeliveryRadioBox(val);
            })
      ],
    );
  }
  Widget reservationImage(BuildContext context){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Padding(
            padding: const EdgeInsets.only(left:15),
            child: Text("Choose An Image : ",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    onPressed:(){
                      GlobalState.alert(context, onConfirm: (){
                        Navigator.of(context).pop();
                        _showChoiceDialog(context);
                        _selectNewImage=false;
                      }, onCancel: (){
                        Navigator.of(context).pop();
                      },
                      title:"Warning !",
                      confirmText: "Continue To Change Restaurant's Pic",
                      cancelText: "Back",
                      message: "Dear user, are you sure you want to change the reservation picture?\n"
                      "Note that if approved, the old photo will be removed!");
                    },
                    child: Text("select Image"),
                  ),
                ],
              ),
            )
        ],
        ),
        SizedBox(height: 15,),
        (_selectNewImage==true)?
        Container(
          width: MediaQuery.of(context).size.width,
            child: Image.network("http://parachute-group.com/img/backend/shops/1_tables_photo.",
              fit:BoxFit.fitWidth)):
        _imageView(context),
        SizedBox(height: 15,),
      ],
    );
  }
  Widget _imageView(BuildContext context){
    if(_imageFile==null)
      return Text("No Image Selected");
    else
      return Container(
        width:MediaQuery.of(context).size.width,
          child: Image.file(_imageFile,fit: BoxFit.fitWidth)
      );
  }
   animateIntCustom(NumberPicker numberPicker,int valueToSelect) {
     int diff = valueToSelect - numberPicker.minValue;
     int index = diff ~/ numberPicker.step;
     return numberPicker.animateIntToIndex(index);
   }
 }