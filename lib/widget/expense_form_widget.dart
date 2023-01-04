import 'package:flutter/material.dart';
import 'package:budgeting_for_lexingtons/model/expense.dart';
import 'package:intl/intl.dart';

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

  List<String> categories = ['Clothes', 'Education', 'Electronics', 'Entertainment', 'Gifts', 'Groceries', 'Hobbies', 'Rent', 'Restaurants', 'Transportation', 'Travel', 'Necessities/Utilities/Hygiene/Other'];
  String _category = 'Groceries';

  late TextEditingController controllerAmount;
  late TextEditingController controllerDetails;
  late TextEditingController controllerStore;

  @override
  void initState(){
    super.initState();
    DateTime now = new DateTime.now();
    date = new DateTime(now.year, now.month, now.day);
    // formatter = ;
    controllerAmount = TextEditingController();
    controllerDetails = TextEditingController();
    controllerStore = TextEditingController();
  }

  @override 
  Widget build(BuildContext context) => 
  Form(
    key: formKey,
    child: ListView(
      // mainAxisSize: MainAxisSize.min,
      children: [
        buildDate(),
        const SizedBox(height: 16),
        buildAmount(),
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
      return new DropdownMenuItem(
        value: category,
        child: Row(
          children: <Widget>[
            Icon(Icons.category),
            Text(category),
          ],
        )
        );
      }).toList(),
      onChanged: (newValue) {
        // do other stuff with _category
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
            style: TextStyle(fontSize: 32)
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
        )
      ],
    );

  // Widget buildDate() => InputDatePickerFormField(  
  //   firstDate: DateTime(2000),
  //   lastDate: DateTime(2101),
  //   fieldLabelText: 'Select Date',
  //   initialDate: DateTime.now(), //Add this in your Code.
  //   // initialDate: DateTime(2017),
  // );

  Widget buildAmount() => TextFormField(
    controller: controllerAmount,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: 'Amount',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildStore() => TextFormField(
    controller: controllerStore,
    decoration: InputDecoration(
      labelText: 'Store',
      border: OutlineInputBorder(),
    )
  );

  Widget buildDetails() => TextFormField(
    controller: controllerDetails,
    decoration: InputDecoration(
      labelText: 'Details (Optional)',
      border: OutlineInputBorder(),
    )
  );

  Widget buildSubmit() => ButtonWidget(
    text: 'Salva', 
    onClicked: () {
      final form = formKey.currentState!;
      final expense =  Expense(
        dateOfPurchase: formatter.format(date),
        store: controllerStore.text,
        amount: controllerAmount.text,
        category: _category,
        details: controllerDetails.text,
      );
      widget.onSavedExpense(expense);
    }
  );
}