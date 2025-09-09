import 'package:flutter/material.dart';
import 'package:plant_management/models/records.dart';
import 'package:plant_management/screens/dashboard/components/add_new_record.dart';
import 'package:plant_management/screens/dashboard/components/table.dart';
import 'package:plant_management/utils/palettes/app_colors.dart' hide Colors;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> _titles = ["Fresh","Moderately fresh","Not fresh","Total record"];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: recordsModel.search,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: Colors.white,
            flexibleSpace: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Center(
                  child: ZoomTapAnimation(
                    end: 0.99,
                    onTap: (){
                      showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              content: AddNewRecord(details: {})
                          )
                      );
                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.primary)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outlined,color: colors.primary,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Add new record",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600,color: Colors.black),),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                for(int x = 0; x < _titles.length; x++)...{
                  SizedBox(
                    width: 10,
                  ),
                  Visibility(
                      visible: x != 0,
                      child: SizedBox(
                        height: 40,
                        child: VerticalDivider(color: Colors.grey.shade200,),
                      )
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_titles[x],style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600),),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(1000)
                          ),
                          child: Center(child: Text(!snapshot.hasData ? "0" : "${snapshot.data!.where((s) => s["status"] == _titles[x]).toList().length}",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w700,fontSize: 12),)),
                        )
                      ],
                    ),
                  )
                },
                Spacer(),
                SizedBox(
                  width: 350,
                  child: TextField(
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      hintStyle: TextStyle(fontFamily: "OpenSans"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.primary.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: colors.primary.withOpacity(0.4)),
                      ),
                    ),
                    onChanged: (text) {
                      if(snapshot.hasData){
                        recordsModel.update(data: snapshot.data!.where((s) => s["name"].toString().toLowerCase().contains(text.toLowerCase())).toList());
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(),
                SizedBox(
                  width: 20,
                ),
              ],
            )
          ),
          body: DashboardTable()
        );
      }
    );
  }
}
