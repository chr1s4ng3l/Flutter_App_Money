import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedDate); //anadir transicion a la lista
    Navigator.of(context).pop(); //cerrar la hoja de transacciones con el DONE
  }

  //chosen the date
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickDate) {
      if (pickDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickDate;
      });
    });
    print('....');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
              //flutter conecta automaticamente nuestros controles con el textfield
              onSubmitted: (_) => _submitData(),

              /* onChanged: (value) { //PARA OBTENER TEXTO DEL TEXFIELD
                      titleInput = value;
                    }, */
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              //flutter conecta automaticamente nuestros controles con el textfield
              //onChanged: (value) => amountInput = value,
              keyboardType: TextInputType.number,
              //teclado numerico al ingresar el amount

              onSubmitted: (_) => _submitData(),
              //al dar click en el teclado se ingresa a la lista
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date chosen'
                          : 'Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _presentDatePicker,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            RaisedButton(
              child: Text(
                'ADD',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}
