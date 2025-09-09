import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_management/utils/snackbars/snackbar_message.dart';

import '../../utils/palettes/app_colors.dart' hide Colors;
import 'components/chart.dart';

class Reports extends StatefulWidget {
  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String _selected = "All";
  List<DateTime> _days = [];

  Future _selectDate({required DateTime initial, required DateTime first}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial, // Sets the initial focus to today
      firstDate: first,   // Allows selection from Jan 1, 2000
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: colors.primary,
            datePickerTheme: const DatePickerThemeData(),
          ),
          child: child ?? const SizedBox(),
        );
      },// Allows selection up to Jan 1, 2050
    );

    if (pickedDate != null) {
      print('Selected date: $pickedDate');
      return pickedDate;
    }
  }

  List<DateTime> _getDaysInBetween(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      _days.add(startDate.add(Duration(days: i)));
    }
    print("DAYS BETWEEN $_days");
    return _days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          flexibleSpace: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Center(
                child: GestureDetector(
                  onTap: (){
                    _selectDate(initial: DateTime.now(), first: DateTime(2000)).then((value){
                      setState(() {
                        _dateFrom = value;
                      });
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.primary)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month,size: 22,color: colors.primary),
                        SizedBox(
                          width: 10,
                        ),
                        _dateFrom == null ?
                        Text("Start date",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),) :
                        Text("${DateFormat("dd MMM, yyyy").format(_dateFrom!)}",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600,fontSize: 15),),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: (){
                    if(_dateFrom != null){
                      _selectDate(initial: _dateFrom!, first: _dateFrom!).then((value){
                        setState(() {
                          _dateTo = value;
                        });
                        _getDaysInBetween(_dateFrom!,_dateTo!);
                      });
                    }else{
                      _snackbarMessage.snackbarMessage(context, message: "Must pick start date first!", is_error: true);
                    }
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.primary)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month,size: 22,color: colors.primary),
                        SizedBox(
                          width: 10,
                        ),
                        _dateTo == null ?
                        Text("End date",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),) :
                        Text("${DateFormat("dd MMM, yyyy").format(_dateTo!)}",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600,fontSize: 15),),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Center(
                child: Container(
                  width: 200,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid,color: colors.primary),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    iconEnabledColor: colors.primary,
                    items: <String>[
                      "All",
                      'Fresh',
                      'Moderately fresh',
                      'Not fresh',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(_selected == ""
                        ? 'Select category'
                        : _selected,style: TextStyle(color: Colors.black,fontFamily: "OpenSans",fontWeight: FontWeight.w400),),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selected = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              // Center(
              //   child: GestureDetector(
              //     onTap: (){
              //
              //     },
              //     child: Container(
              //       width: 200,
              //       height: 50,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(color: colors.primary)
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Icon(Icons.add_circle_outlined,size: 28,color: colors.primary),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text("Generate data",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600,fontSize: 15),),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.print,size: 28,),
                onPressed: (){},
              ),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(),
              SizedBox(
                width: 20,
              ),
            ],
          )
      ),
      body: ReportsChart(type: _selected,days: _days,),
    );
  }
}

