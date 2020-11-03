import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../services/device_data_streamer.dart';

class CarController extends StatelessWidget {
  CarController({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(children: <Widget>[
            Center(
                child: Text(
              'Controls',
              style: optionStyle,
            )),
            PowerSourcesView(
              streamer: DeviceDataStreamer(device),
            ),
            Center(
                child: Text(
              'Charts',
              style: optionStyle,
            )),
          ]),
          bottomNavigationBar: TabBar(
            tabs: <Tab>[
              Tab(
                icon: Icon(Icons.gamepad),
                text: 'Controls',
              ),
              Tab(
                icon: Icon(Icons.battery_charging_full),
                text: 'Power sources',
              ),
              Tab(
                icon: Icon(Icons.show_chart),
                text: 'Charts',
              ),
            ],
          ),
        ));
  }
}

class PowerSourcesView extends StatelessWidget {
  final DeviceDataStreamer streamer;

  PowerSourcesView({Key key, this.streamer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TabBar(
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
                children: <Widget>[
                  StreamBuilder(
                      stream: streamer.dataStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                String key =
                                    snapshot.data.keys.elementAt(index);
                                return ListTile(
                                    trailing:
                                        Text(snapshot.data[key].toString()),
                                    title: Text(key));
                              });
                        } else {
                          return Center(child: Text('No data'));
                        }
                      }),
                  StreamBuilder(
                      stream: streamer.dataStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                String key =
                                    snapshot.data.keys.elementAt(index);
                                return ListTile(
                                    trailing:
                                        Text(snapshot.data[key].toString()),
                                    title: Text(key));
                              });
                        } else {
                          return Center(child: Text('No data'));
                        }
                      }),
                ],
              ),
            )
          ],
        ));
  }
}
