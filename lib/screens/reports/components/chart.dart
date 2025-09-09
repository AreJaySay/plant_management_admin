import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_management/utils/palettes/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/records.dart';

class ReportsChart extends StatefulWidget {
  final String type;
  final List<DateTime> days;
  ReportsChart({required this.type,required this.days});
  @override
  State<ReportsChart> createState() => _ReportsChartState();
}

class _ReportsChartState extends State<ReportsChart> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: recordsModel.subject,
        builder: (context, snapshot) {
        return Scaffold(
          body: Center(
            child: !snapshot.hasData ?
            CircularProgressIndicator(color: colors.primary,) :
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              isTransposed: true,
              series: <CartesianSeries>[
                BarSeries<ChartData, String>(
                  color: colors.primary,
                  dataSource: [
                    for(int x = 0; x < widget.days.length; x++)...{
                      if(widget.type == "All")...{
                        ChartData('${DateFormat("dd MMMM, yyyy").format(widget.days[x])}', double.parse("${snapshot.data!.where((s) => DateFormat("dd-MM-yyyy").format(DateTime.parse(s["date"])) == DateFormat("dd-MM-yyyy").format(DateTime.parse("${widget.days[x]}"))).toList().length}")),
                      }else...{
                        ChartData('${DateFormat("dd MMMM, yyyy").format(widget.days[x])}', double.parse("${snapshot.data!.where((s) => DateFormat("dd-MM-yyyy").format(DateTime.parse(s["date"])) == DateFormat("dd-MM-yyyy").format(DateTime.parse("${widget.days[x]}")) && s["status"] == widget.type).toList().length}")),
                      }
                    }
                  ],
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  }
class ChartData {
  ChartData(this.x, this.y);
  final String x; // Or double, depending on your x-axis type
  final double y;
}
