import 'dart:convert';
import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:plant_management/models/records.dart';
import 'package:plant_management/services/apis/records.dart';
import '../../../functions/loaders.dart';
import '../../../services/routes.dart';
import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../utils/snackbars/snackbar_message.dart' show SnackbarMessage;
import '../../../widgets/shimmer_loader/table.dart';
import 'add_new_record.dart';


class DashboardTable extends StatefulWidget {
  @override
  State<DashboardTable> createState() => _DashboardTableState();
}

class _DashboardTableState extends State<DashboardTable> {
  final Routes _routes = new Routes();
  final RecordsApi _recordsApi = new RecordsApi();
  final _scrollController = ScrollController();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future _delete({required Map details})async{
    FirebaseDatabase.instance.ref().child('records').orderByChild("id").equalTo(details["id"]).onChildAdded.forEach((event)async{
      DatabaseReference ref = FirebaseDatabase.instance.ref("records/${event.snapshot.key!}");
      await ref.remove();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _recordsApi.getRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: recordsModel.subject,
      builder: (context, snapshot) {
        return !snapshot.hasData ?
          TableLoader() :
          Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            child: Table(
              border: TableBorder.all(color: colors.primary.withOpacity(0.1)),
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(100),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
                4: FlexColumnWidth(),
                5: FixedColumnWidth(250),
                6: FlexColumnWidth(),
                7: FlexColumnWidth(),
                8: FlexColumnWidth(),
                9: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    TableCell(child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                      child: Center(child: Text('ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold),)),
                    )),
                    TableCell(child: Center(child: Text('Name',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Image',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Disease',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Freshness status',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Notes',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Recorded by',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Date',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Actions',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                  ],
                ),
                for(int x = 0; x < snapshot.data!.length; x++)...{
                  TableRow(
                    decoration: BoxDecoration(
                        color: x.isEven ? Colors.white : colors.primary.withOpacity(0.1)
                    ),
                    children: <Widget>[
                      TableCell(child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                        child: Center(child: Text('${x + 1}',style: TextStyle(fontFamily: "Roboto_normal"))),
                      )),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["name"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                      TableCell(child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                        child: Center(child: Text('Image',style: TextStyle(fontFamily: "Roboto_normal"))),
                      )),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["disease"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["status"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["notes"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["recorderby"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                      TableCell(child: Center(child: Text('${DateFormat("yyyy-MM-dd").format(DateTime.parse(snapshot.data![x]["date"]))}',style: TextStyle(fontFamily: "Roboto_normal")))),
                      TableCell(child: Center(child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          customButton: Icon(
                              Icons.more_vert,
                              color: colors.primary
                          ),
                          items: [
                            ...MenuItems.firstItems.map(
                                  (item) => DropdownMenuItem<MenuItem>(
                                value: item,
                                child: MenuItems.buildItem(item),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            MenuItems.onChanged(context, value! as MenuItem);
                            if(value.text == "Edit"){
                              showDialog<void>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                                      ),
                                      content: AddNewRecord(isEdit: true,details: snapshot.data![x])
                                  )
                              );
                            }else{
                              _screenLoaders.functionLoader(context);
                              _delete(details: snapshot.data![x]).whenComplete((){
                                Navigator.of(context).pop(null);
                                _snackbarMessage.snackbarMessage(context, message: "Record successfully daleted!");
                              });
                            }
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
                              ...List<double>.filled(MenuItems.firstItems.length, 48),

                            ],
                            padding: const EdgeInsets.only(left: 16, right: 16),
                          ),
                        ),
                      ))),
                    ],
                  ),
                }
              ],
            ),
          ),
        );
      }
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [edit, delete];

  static const edit = MenuItem(text: 'Edit', icon: Icons.edit);
  static const delete = MenuItem(text: 'Delete', icon: Icons.delete);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: colors.primary, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: TextStyle(
              color: colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.edit:
      //Do something
        break;
      case MenuItems.delete:
      //Do something
        break;
    }
  }
}