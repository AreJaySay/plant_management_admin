import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_management/widgets/materialbutton.dart';
import '../../../functions/loaders.dart';
import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../utils/snackbars/snackbar_message.dart';

class AddNewRecord extends StatefulWidget {
  final bool isEdit;
  final Map details;
  AddNewRecord({this.isEdit = false,required this.details});
  @override
  State<AddNewRecord> createState() => _AddNewRecordState();
}

class _AddNewRecordState extends State<AddNewRecord> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _disease = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final TextEditingController _recorderby = TextEditingController();
  String _image = "";
  String _status = "";
  DateTime? _selectedDate;
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future _register()async{
    DatabaseReference usersRef = database.ref('records');
    await usersRef.push().set({
      "id": "${Random().nextInt(900000) + 100000}",
      "name": _name.text,
      "disease": _disease.text,
      "status": _status,
      "notes": _notes.text,
      "recorderby": _recorderby.text,
      "date": "$_selectedDate",
    });
  }

  Future _update()async{
    DatabaseReference usersRef = database.ref('records');
    FirebaseDatabase.instance.ref().child('records').orderByChild("id").equalTo(widget.details["id"]).onChildAdded.forEach((event){
      usersRef.update({
        "${event.snapshot.key!}/name": _name.text,
        "${event.snapshot.key!}/disease": _disease.text,
        "${event.snapshot.key!}/status": _status,
        "${event.snapshot.key!}/notes": _notes.text,
        "${event.snapshot.key!}/recorderby": _recorderby.text,
        "${event.snapshot.key!}/date": "$_selectedDate",
      });
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if(widget.isEdit){
      _name.text = widget.details["name"];
      _disease.text = widget.details["disease"];
      _status = widget.details["status"];
      _notes.text = widget.details["notes"];
      _recorderby.text = widget.details["recorderby"];
      _selectedDate = DateTime.parse(widget.details["date"]);
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    _disease.dispose();
    _notes.dispose();
    _recorderby.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 550,
      height: 750,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                    minRadius: 50,
                    maxRadius: 60,
                    backgroundColor: Colors.grey.shade200,
                    child: Stack(
                      children: [
                        Center(
                          child: Image(
                            image: AssetImage("assets/icons/book.png"),
                            width: 50,
                            height: 50,
                            color: colors.primary,
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              backgroundColor: colors.primary,
                              child: Icon(Icons.edit,color: colors.primary,),
                            )
                        ),
                      ],
                    )
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _name,
                  style: TextStyle(fontFamily: "OpenSans"),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintText: 'Name',
                    hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (text) {

                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _disease,
                  style: TextStyle(fontFamily: "OpenSans"),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintText: 'Disease',
                    hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (text) {

                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Row(
                    children: [
                      Text(_status == "" ? "Freshness status" : _status,style: TextStyle(fontFamily: "OpenSans",color: _status == "" ? Colors.grey : Colors.black,fontSize: 17),),
                      Spacer(),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          customButton: Icon(
                              Icons.arrow_drop_down,
                              color: colors.primary
                          ),
                          items: [
                            ...FreshnessItems.firstItems.map(
                                  (item) => DropdownMenuItem<FreshnessItem>(
                                value: item,
                                child: FreshnessItems.buildItem(item),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _status = value!.text;
                            });
                          },
                          dropdownStyleData: DropdownStyleData(
                            width: 160,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                            offset: const Offset(0, 8),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            customHeights: [
                              ...List<double>.filled(FreshnessItems.firstItems.length, 48),

                            ],
                            padding: const EdgeInsets.only(left: 16, right: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _notes,
                  style: TextStyle(fontFamily: "OpenSans"),
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    hintText: 'Notes',
                    hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (text) {

                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _recorderby,
                  style: TextStyle(fontFamily: "OpenSans"),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintText: 'Recorded by',
                    hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (text) {

                  },
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){
                    _selectDate();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Row(
                      children: [
                        Text(_selectedDate == null ? "Date" : "${DateFormat("yyyy-MM-dd").format(_selectedDate!)}",style: TextStyle(fontFamily: "OpenSans",color: _selectedDate == null ? Colors.grey : Colors.black,fontSize: 17),),
                        Spacer(),
                        Icon(Icons.calendar_month,color: colors.primary,)
                      ],
                    ),
                  ),
                ),
                Spacer(),
                globalButtons.materialButton("Submit", (){
                  if(_notes.text.isEmpty || _disease.text.isEmpty || _status == "" || _notes.text.isEmpty || _recorderby.text.isEmpty || _selectedDate == null){
                    _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
                  }else{
                    _screenLoaders.functionLoader(context);
                    if(!widget.isEdit){
                      _register().whenComplete((){
                        Navigator.of(context).pop(null);
                        Navigator.of(context).pop(null);
                        _snackbarMessage.snackbarMessage(context, message: "New record successfully created!");
                      });
                    }else{
                      _update().whenComplete((){
                        Navigator.of(context).pop(null);
                        Navigator.of(context).pop(null);
                        _snackbarMessage.snackbarMessage(context, message: "Record successfully updated!");
                      });
                    }
                  }
                  // _update();
                }, bckgrndColor: colors.primary),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          Positioned(
            right: -40,
            top: -40,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FreshnessItem {
  const FreshnessItem({
    required this.text,
  });
  final String text;
}

abstract class FreshnessItems {
  static const List<FreshnessItem> firstItems = [fresh, moderately_fresh, spoiled];
  static const fresh = FreshnessItem(text: 'Fresh',);
  static const moderately_fresh = FreshnessItem(text: 'Moderately fresh',);
  static const spoiled = FreshnessItem(text: 'Spoiled',);

  static Widget buildItem(FreshnessItem item) {
    return Text(
      item.text,
      style: TextStyle(
        color: colors.primary,
      ),
    );
  }
}
