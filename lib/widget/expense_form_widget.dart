import 'package:flutter/material.dart';
import 'package:budgeting_for_lexingtons/model/expense.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- Add this

import 'button_widget.dart';

class ExpenseFormWidget extends StatefulWidget {
  final ValueChanged<Expense> onSavedExpense;

  const ExpenseFormWidget({
    Key? key,
    required this.onSavedExpense,
  }) : super(key: key);

  @override
  _ExpenseFormWidgetState createState() => _ExpenseFormWidgetState();
}

class _ExpenseFormWidgetState extends State<ExpenseFormWidget> {
  final formKey = GlobalKey<FormState>();

  late DateTime date;
  DateFormat formatter = DateFormat('MM/dd/yyyy');

  List<String> categories = [
    'Clothes', 'Education', 'Electronics', 'Entertainment', 'Gifts', 'Groceries',
    'Hobbies', 'Rent', 'Restaurants', 'Transportation', 'Travel',
    'Necessities/Utilities/Hygiene/Other'
  ];
  String _category = 'Groceries';

  List<String> currencies = ['USD', 'EUR', 'MXN'];
  String _currency = 'USD';

  late TextEditingController controllerAmount;
  late TextEditingController controllerDetails;
  late TextEditingController controllerStore;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    controllerAmount = TextEditingController();
    controllerDetails = TextEditingController();
    controllerStore = TextEditingController();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currency = prefs.getString('selected_currency') ?? 'USD';
    });
  }

  Future<void> _saveCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_currency', currency);
  }

  @override
  Widget build(BuildContext context) =>
      Form(
          key: formKey,
          child: ListView(
            children: [
              buildDate(),
              const SizedBox(height: 16),
              buildAmountWithCurrency(),
              const SizedBox(height: 16),
              buildStore(),
              const SizedBox(height: 16),
              buildCategory(),
              const SizedBox(height: 16),
              buildDetails(),
              const SizedBox(height: 16),
              buildSubmit(),
            ],
          )
      );

  Widget buildCategory() => DropdownButtonFormField(
    items: categories.map((String category) {
      return DropdownMenuItem(
          value: category,
          child: Row(
            children: <Widget>[
              Icon(Icons.category),
              const SizedBox(width: 8),
              Text(category),
            ],
          )
      );
    }).toList(),
    onChanged: (newValue) {
      setState(() => _category = newValue as String);
    },
    value: _category,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      filled: true,
      fillColor: Colors.grey[200],
    ),
  );

  Widget buildDate() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '${date.month}/${date.day}/${date.year}',
        style: TextStyle(fontSize: 32),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        child: Text('Select Date'),
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2021),
            lastDate: DateTime(2120),
          );

          if (newDate == null) return;

          setState(() {
            date = newDate;
          });
        },
      ),
    ],
  );

  Widget buildAmountWithCurrency() => Row(
    children: [
      Expanded(
        flex: 2,
        child: TextFormField(
          controller: controllerAmount,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        flex: 1,
        child: DropdownButtonFormField<String>(
          value: _currency,
          decoration: InputDecoration(
            labelText: 'Currency',
            border: OutlineInputBorder(),
          ),
          items: currencies.map((String currency) {
            return DropdownMenuItem(
              value: currency,
              child: Text(currency),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _currency = newValue;
              });
              _saveCurrency(newValue);
            }
          },
        ),
      ),
    ],
  );

  Widget buildStore() => TextFormField(
    controller: controllerStore,
    decoration: InputDecoration(
      labelText: 'Store',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildDetails() => TextFormField(
    controller: controllerDetails,
    decoration: InputDecoration(
      labelText: 'Details (Optional)',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildSubmit() => ButtonWidget(
    text: 'Salva',
    onClicked: () {
      final form = formKey.currentState!;
      final expense = Expense(
        dateOfPurchase: formatter.format(date),
        store: controllerStore.text,
        amount: controllerAmount.text,
        category: _category,
        details: controllerDetails.text,
        currency: _currency,
      );
      widget.onSavedExpense(expense);
    },
  );
}
