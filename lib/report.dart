import 'dart:math';
import 'data.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Report extends StatefulWidget {
  const Report({super.key});
  @override
  ReportState createState()=>ReportState();
}
class ReportState extends State<Report>{
  Map<String, List<int>> weekly={};
  List<String> habits=[];
  @override
  Widget build(BuildContext c){
    Store s=Provider.of<Store>(c);
    habits=s.getMap<String,int>('ToDo').keys.toList();
    setState(()=>weekly={
      for(var h in habits) h: List.generate(7, (_)=>Random().nextBool()?1:0)
    });
    s.setMap('weekly', weekly);
    return template(c,5,weekly.isEmpty?Center(
      child: text('No data available. Configure habits first.'),
    ):SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(
              label: text('Habit'),
            ),
            ...['Mon','Tue','Wed','Thu','Fri','Sat','Sun'].map((d)=>DataColumn(
              label: text(d),
            )),
          ],
          rows: habits.map((h)=>DataRow(
            cells: [
              DataCell(text(h)),
              ...List.generate(7,(i){
                bool completed=weekly[h]?[i]==1;
                return DataCell(
                  Icon(
                    completed?Icons.check_circle:Icons.cancel,
                    color: completed?Colors.green:Colors.red,
                  ),
                );
              }),
            ],
          )).toList(),
        ),
      ),
    ));
  }
}