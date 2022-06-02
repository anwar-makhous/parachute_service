import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'GlobalState.dart';

class SubItem extends StatefulWidget {
  final String type;
  final String title;
  final List<String> subItems;
  final List<double> prices;
  final bool required;

  SubItem(this.type,this.title,this.subItems,this.prices,this.required);

  @override
  _SubItemState createState() =>
      _SubItemState(this.type,this.title,this.subItems,this.prices,this.required);
}

class _SubItemState extends State<SubItem> {
  String type;
  String title;
  List<String> subItems;
  List<double> prices;
  bool required;

  _SubItemState(this.type,this.title,this.subItems,this.prices,this.required);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) =>
          EntryItem(data[index], type),
      itemCount: data.length,
    );
  }
}

//this Class for each Item in The list which may contain children or not
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}
//Multilevel List

final List<Entry> data = <Entry>[
  Entry(
    'Your Choice of cheese ',
    <Entry>[
      Entry('A0'),
      Entry('A1'),
      Entry('A2'),
    ],
  ),
  Entry(
    'Your Choice of Meat',
    <Entry>[
      Entry('B0'),
      Entry('B1'),
      Entry('B2'),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatefulWidget {
  final String type;

  EntryItem(this.entry, this.type);

  final Entry entry;

  @override
  _EntryItemState createState() => _EntryItemState(this.type);
}

class _EntryItemState extends State<EntryItem> {
  String type;

  _EntryItemState(this.type);

  String radioSubtitle = "select one item";
  List<String> checkedItemsList = ["select items"];
  String groupSubtitle = "select items";
  bool expanded = true;
  int _key;




  _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  void initState() {
    super.initState();


    radioSubtitle = "select one item";
    expanded = true;
    checkedItemsList = ["select items"];
    groupSubtitle = "select items";
    _collapse();
  }

  Widget _buildRadio(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      initiallyExpanded: expanded,
      key: new Key(_key.toString()),
      title: Text(
        root.title,
        style: TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        radioSubtitle,
        style: TextStyle(color: GlobalState.secondColor),
      ),
      children: <Widget>[
        RadioButtonGroup(
          labels:
              root.children.map((_buildRadio) => _buildRadio.title).toList(),
          picked: radioSubtitle,
          onChange: (label, index) {
            setState(() {
              radioSubtitle = label;
              expanded = false;
              _collapse();
            });
          },
        ),
      ],
    ); //root.children.map(_buildTiles).toList(),
  }

  Widget _buildCheck(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      initiallyExpanded: expanded,
      key: new Key(_key.toString()),
      title: Text(
        root.title,
        style: TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        groupSubtitle,
        style: TextStyle(color: GlobalState.secondColor),
      ),
      children: <Widget>[
        CheckboxGroup(
          labels:
              root.children.map((_buildCheck) => _buildCheck.title).toList(),
          checked: checkedItemsList,
          onChange: (isChecked, label, index) {
            setState(() {
              if (isChecked)
                checkedItemsList.add(label);
              else if (!isChecked) checkedItemsList.remove(label);

              checkedItemsList.remove("select items");
              // تعليمة remove تنفذ اول مرة فقط

              groupSubtitle = checkedItemsList.toString();

              if (groupSubtitle.contains("[") | groupSubtitle.contains("]")) {
                groupSubtitle = groupSubtitle.replaceAll("[", "");
                groupSubtitle = groupSubtitle.replaceAll("]", "");
              }

              if (groupSubtitle.isEmpty) {
                groupSubtitle = "select items";
              }
            });
          },
        ),
      ],
    ); //root.children.map(_buildTiles).toList(),
  }

  @override
  Widget build(BuildContext context) {
    if (this.type == "R") {
      return _buildRadio(widget.entry);
    } else{
      return _buildCheck(widget.entry);
    }
  }
}
