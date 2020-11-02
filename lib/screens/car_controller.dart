import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class CarController extends StatefulWidget {
  CarController({Key key}) : super(key: key);

  @override
  _CarControllerState createState() => _CarControllerState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _CarControllerState extends State<CarController> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Controls',
      style: optionStyle,
    ),
    NestedTabBar(),
    Text(
      'Index 1: Charts',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Controls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.battery_charging_full),
            label: 'Power sources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Charts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  final fuelCellData = {
    'voltage': 1.0,
    'current': 1.0,
    'hydrogen consumption': 150,
  };
  final batteryData = {
    'voltage': 1.0,
    'current': 1.0,
    'charge': 80,
  };
  TabController _nestedTabController;
  Random generator = Random(3);
  Timer timer;
  @override
  void initState() {
    super.initState();
    _nestedTabController = new TabController(length: 2, vsync: this);
    timer = Timer.periodic(Duration(seconds: 1), ((Timer timer) {
      setState(() {
        fuelCellData['voltage'] =
            double.parse(generator.nextDouble().toStringAsFixed(3));
        fuelCellData['current'] =
            double.parse(generator.nextDouble().toStringAsFixed(3));
        fuelCellData['hydrogen consumption'] = generator.nextInt(200);
      });
    }));
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: "Battery",
            ),
            Tab(
              text: "FuelCell",
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              ListView.builder(
                itemCount: batteryData.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = batteryData.keys.elementAt(index);
                  return ListTile(
                      trailing: Text(batteryData[key].toString()),
                      title: Text(key));
                },
              ),
              ListView.builder(
                itemCount: batteryData.length,
                itemBuilder: (context, index) {
                  String key = fuelCellData.keys.elementAt(index);
                  return ListTile(
                      trailing: Text(fuelCellData[key].toString()),
                      title: Text(key));
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
