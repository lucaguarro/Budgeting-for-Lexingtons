import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:budgeting_for_lexingtons/api/sheets/budget_sheet_api.dart';
import 'package:budgeting_for_lexingtons/widget/expense_form_widget.dart';
import 'package:budgeting_for_lexingtons/widget/popup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON parsing

class CreateSheetsPage extends StatelessWidget {
  final String apiKey = dotenv.env['EXCHANGE_RATE_API_KEY']!;

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

              print('--- DEBUG: New Expense Submitted ---');
              print('Amount entered: ${expense.amount}');
              print('Currency selected: ${expense.currency}');

              String amountInUSD = expense.amount; // default

              if (expense.currency != 'USD') {
                amountInUSD = await convertToUSD(expense.amount, expense.currency);
              }

              print('Converted Amount (USD): $amountInUSD');

              // Now override the amount in the JSON with the USD value
              final expenseJson = expense.toJson();
              print('Original Expense JSON: ${expenseJson.toString()}');

              expenseJson['Amount'] = amountInUSD; // Replace with converted USD amount
              print('Modified Expense JSON (with USD amount): ${expenseJson.toString()}');

              insert_successful = await BudgetSheetApi.insert([expenseJson]);

              print('Insert successful: $insert_successful');

              if (insert_successful) {
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

  Future<String> convertToUSD(String amountStr, String fromCurrency) async {
    final double? amount = double.tryParse(amountStr);
    if (amount == null) {
      print('--- DEBUG: Amount parsing failed ---');
      return amountStr; // fallback if parsing fails
    }

    final uri = Uri.parse('https://api.exchangerate.host/convert?access_key=$apiKey&from=$fromCurrency&to=USD&amount=$amount');
    print('--- DEBUG: Fetching exchange rate from: $uri');

    try {
      final response = await http.get(uri);
      print('--- DEBUG: API Response Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('--- DEBUG: API Response Data: $data');

        if (data['success'] == true) {
          final double result = (data['result'] as num).toDouble();
          print('--- DEBUG: Conversion result: $result');
          return result.toStringAsFixed(2);
        } else {
          print('--- DEBUG: API response success=false: ${data['error']}');
          return amountStr;
        }
      } else {
        print('--- DEBUG: Non-200 response, falling back to original amount');
        return amountStr;
      }
    } catch (e) {
      print('--- DEBUG: Exception during API call: $e');
      return amountStr;
    }
  }
}
