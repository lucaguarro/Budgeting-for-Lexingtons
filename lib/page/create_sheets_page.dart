import 'package:budgeting_for_lexingtons/api/sheets/budget_sheet_api.dart';
import 'package:flutter/material.dart';
import 'package:budgeting_for_lexingtons/widget/expense_form_widget.dart';
import 'package:budgeting_for_lexingtons/widget/popup.dart';

class CreateSheetsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
     body: Container(
       alignment: Alignment.center,
       padding: EdgeInsets.all(32),
       child: ExpenseFormWidget(
         onSavedExpense: (expense) async {
            var insert_successful;
            var status_color;
            var msg1;
            var msg2;
            insert_successful = await BudgetSheetApi.insert([expense.toJson()]);
            if(insert_successful){
              msg1 = 'LETTSSS GOOOO';
              msg2 = "Expense was successfully uploaded to google sheets";
              status_color = Color.fromARGB(255, 28, 111, 1);
            } else {
              msg1 = 'Ruh roh';
              msg2 = "Something went wrong and the expense was not added...";
              status_color = Color.fromARGB(255, 103, 5, 5);
            }
            ScaffoldMessenger.of(context).showSnackBar(connectionPopup(status_color, msg1, msg2));
         },
       )
     )
  );
}