import 'package:flutter/material.dart';
import 'GlobalState.dart';

class HomeServiceApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeServiceApp();
  }
}

class _HomeServiceApp extends State<HomeServiceApp> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  List<ListItem> _dropDownItems = [
    ListItem(1, "Manager"),
    ListItem(2, "Waiter"),
    ListItem(3, "SalesMan"),
    ListItem(4, "Delivery Boy")
  ];
  List<DropdownMenuItem<ListItem>> _dropDownMenuItems;
  ListItem _itemSelected;
  bool _obscureText;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = buildDropDownMenuItems(_dropDownItems);
    _itemSelected = _dropDownMenuItems[0].value;
    _obscureText = true;
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems)
      items.add(DropdownMenuItem(
        child: Text(listItem.item),
        value: listItem,
      ));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final double paintHeight = MediaQuery.of(context).size.height * 0.58;
    final double logoHeight = MediaQuery.of(context).size.height * 0.2;
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, paintHeight),
                painter: RPSCustomPainter(),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*0.05,
                left: MediaQuery.of(context).size.width*0.01,
                right: MediaQuery.of(context).size.width*0.01,
                child: Image.asset(
                  "assets/logo/Parachute Logo on Red@2x.png",
                  height: logoHeight,
                  fit: BoxFit.fitHeight,
                )),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                left: MediaQuery.of(context).size.width*0.05,
                right: MediaQuery.of(context).size.width*0.05,
                child: enterCard()),
          ],
        ),
      ),
    );
  }

  Widget enterCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.025),
      decoration: BoxDecoration(
        color: GlobalState.secondColor,
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _idController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  fillColor: Colors.white,
                  hintText: "Enter Your ID",
                  filled: true,
                  suffixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  fillColor: Colors.white,
                  hintText: "Enter Your Password",
                  filled: true,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: _obscureText
                          ? Icon(
                        Icons.lock,
                        color: Colors.black,
                      )
                          : Icon(
                        Icons.lock,
                        color: GlobalState.logoColor,
                      ))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  "Role:",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    color: Colors.white,
                    border: Border.all(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        dropdownColor: GlobalState.secondColor,
                        items: _dropDownMenuItems,
                        value: _itemSelected,
                        onChanged: (value) {
                          setState(() {
                            _itemSelected = value;
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          RaisedButton(
            color: GlobalState.logoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
                side: BorderSide(color: GlobalState.secondColor)),
            onPressed: () {
              ///NoThing For Now
            },
            child: Text(
              'Submit',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
        ],
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

class ListItem {
  int value;
  String item;

  ListItem(this.value, this.item);
}
