import 'package:Flutter_App_Money/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  //ORIENTATION
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save Money',
      theme:
          //funciona como colors en android personalisas tus colors
          ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.redAccent,
              errorColor: Colors.red,
              fontFamily: 'Quicksand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
              appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      button: TextStyle(color: Colors.white),
                    ),
              )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final List<Transaction> _userTransactions = [
    //creamos una lista para ingresar datos a el constructor de la clase Transaction
    // Transaction(
    //   id: 't1',
    //   title: 'Shoes',
    //   amount: 30.5,
    //   date: DateTime.now(),
    // ),
    //
    // Transaction(
    //   id: 't2',
    //   title: 'Laptop',
    //   amount: 500.50,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  //TRANSACCION DE, LOS ULTIMOS 7 DIAS EN EL CHART
  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime date) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: date,
        id: DateTime.now().toString());

    setState(() {
      //PARA ANADIR TRANSACCION A LA LISTA
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
          // GestureDetector y onTap sirven para que al add una nueva transacion y precionar Done no se cierre hasta precionar el fondo
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('SaveUrMoney'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
        //BOTON EN LA PARTE DEL APPBAR PARTE SUPERIOR IZQ
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          //mover de arriba hacia abajo en la pantalla
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mover de izquierda a derecha en la pantalla
          children: <Widget>[
            //INTERRUCTOR PARA MOSTRAR LA GRAFICA
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart'),
                Switch(
                  value: _showChart,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  },
                ),
              ],
            ),

            //_showChart ? Container  (?) quiere decir que si se cumple. (:) es de lo contrario tipo un if else
            _showChart ? Container(
                //Responsive Design MediaQuery
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: Chart(_recentTransaction)) :
            Container(
                //Responsive Design MediaQuery
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: TransactionList(_userTransactions, _deleteTransaction))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () => _startAddNewTransaction(context),
      ),
      //BOTON EN LA PARTE INFERIOR FLOATING BUTTON COMO EN JAVA
    );
  }
}
