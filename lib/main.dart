import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'Flutter + Bluetooth';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color((0xFF0B0A3B))),
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = true;

  @override
  initState() {
    super.initState();
    initBluetoothScanning();
  }

//method to initiate Bluetooth scanning
  void initBluetoothScanning() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }


  scan() async {
    if (!_isScanning) {
  
      scanResultList.clear();
      flutterBlue.startScan(timeout: Duration(seconds: 4));
     
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
        setState(() {});
      });
    } else {
      
      flutterBlue.stopScan();
    }
  }

 
  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }


  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }


  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
   
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
  
      name = r.advertisementData.localName;
    } else {
  
      name = 'N/A';
    }
    return Text(name);
  }


  Widget leading(ScanResult r) {
    return CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  void onTap(ScanResult r) {
    print('${r.device.name}');
  }

 
  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
      
        child: ListView.separated(
          itemCount: scanResultList.length,
          itemBuilder: (context, index) {
            return listItem(scanResultList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
     
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}
