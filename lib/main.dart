import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ExampleApp());
}

class BottomSheetBarPage extends StatefulWidget {
  final String title;

  const BottomSheetBarPage({Key? key, this.title = ''}) : super(key: key);

  @override
  _BottomSheetBarPageState createState() => _BottomSheetBarPageState();
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomAppBarColor: Colors.green,
      ),
      home: const BottomSheetBarPage(),
    );
  }
}

class _BottomSheetBarPageState extends State<BottomSheetBarPage> {
  bool _isLocked = false;
  bool _isCollapsed = true;
  bool _isExpanded = false;
  int _listSize = 5;
  final _bsbController = BottomSheetBarController();
  final _listSizeController = TextEditingController(text: '5');

  @override
  void initState() {
    _bsbController.addListener(_onBsbChanged);
    _listSizeController.addListener(_onListSizeChanged);
    super.initState();
  }

  @override
  void dispose() {
    _bsbController.removeListener(_onBsbChanged);
    super.dispose();
  }

  void _onListSizeChanged() {
    _listSize = int.tryParse(_listSizeController.text) ?? 5;
  }

  void _onBsbChanged() {
    if (_bsbController.isCollapsed && !_isCollapsed) {
      setState(() {
        _isCollapsed = true;
        _isExpanded = false;
      });
    } else if (_bsbController.isExpanded && !_isExpanded) {
      setState(() {
        _isCollapsed = false;
        _isExpanded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Scrollable Bottomsheet',style: TextStyle(fontSize: 15),),
          actions: [
            if (_isCollapsed)
              IconButton(
                icon: const Icon(Icons.open_in_full),
                onPressed: _bsbController.expand,
              ),
            if (_isExpanded)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _bsbController.collapse,
              ),
          ],
        ),
        body: BottomSheetBar(
          willPopScope: true,
          backdropColor: Colors.black.withOpacity(0.3),
          locked: _isLocked,
          controller: _bsbController,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          boxShadows: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5.0,
              blurRadius: 32.0,
              offset: const Offset(0, 0),
            ),
          ],
          expandedBuilder: (scrollController) {
            final itemList =
                List<int>.generate(_listSize, (index) => index + 1);

            return Material(
              color: Colors.transparent,
              child: CustomScrollView(
                controller: scrollController,
                shrinkWrap: true,
                slivers: [
                  SliverFixedExtentList(
                    itemExtent: 56.0,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(
                        title: Text("Add Items "+
                          itemList[index].toString(),
                          style: const TextStyle(fontSize: 15.0,color: Colors.white),
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              itemList[index].toString(),
                            ),
                          ),
                        ),
                      ),
                      childCount: _listSize,
                    ),
                  ),
                ],
              ),
            );
          },
          collapsed: TextButton(
            onPressed: () => _bsbController.expand(),
            child: Text(
              'Click${_isLocked ? "" : " or swipe"} to expand',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _listSizeController,
                    decoration: const InputDecoration(
                        hintText: 'Number of expanded list-items'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}