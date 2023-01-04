import 'package:flutter/material.dart';

import 'package:budgeting_for_lexingtons/api/sheets/budget_sheet_api.dart';
import 'button_widget.dart';
import 'package:budgeting_for_lexingtons/widget/popup.dart';

class SettingsFormWidget extends StatefulWidget {
  @override 
  _SettingsFormWidgetState createState() => _SettingsFormWidgetState();
}

class _SettingsFormWidgetState extends State<SettingsFormWidget> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController controllerSheetID;

  @override
  void initState(){
    super.initState();
    controllerSheetID = TextEditingController();
    loadSheetID();
  }

  loadSheetID() async {
    String sheetID = await BudgetSheetApi.readSheetID();
    setState(() {
      controllerSheetID.text = sheetID;
    });
    
  }

  @override
  void dispose() {
    controllerSheetID.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) => 
  Form(
    key: formKey,
    child: ListView(
      // mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        buildSheetID(),
        const SizedBox(height: 16),
        buildSubmit(context),
      ],
    )
  );

  Widget buildSheetID() => TextFormField(
      controller: controllerSheetID,
      decoration: InputDecoration(
          labelText: 'Google Spreadsheet ID',
          labelStyle: TextStyle(
              color: Color.fromARGB(255, 64, 82, 14),
              fontSize: 22,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
          )
      ),
  );

  Widget buildSubmit(context) => ButtonWidget(
    text: 'Salva', 
    onClicked: () async {
      print(await BudgetSheetApi.readSheetID());
      await BudgetSheetApi.writeSheetID(controllerSheetID.text);
      var status = await BudgetSheetApi.setSheetConnection();
      var status_color;
      var msg1;
      var msg2;
      if(status){
        msg1 = 'Fuck yeah';
        msg2 = "Connection to google sheet was successful";
        status_color = Color.fromARGB(255, 28, 111, 1);
      } else {
        msg1 = 'Shieeeeeet';
        msg2 = "Could not connect to google sheet";
        status_color = Color.fromARGB(255, 103, 5, 5);
      }
      ScaffoldMessenger.of(context).showSnackBar(connectionPopup(status_color, msg1, msg2));
    }
  );

}