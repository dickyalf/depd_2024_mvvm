part of 'pages.dart';

class MainMenu extends StatefulWidget {
 const MainMenu({super.key});

 @override
 State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
 int _selectedIndex = 0;

 static const List<Widget> _pages = <Widget>[
   HomePage(),
   CostPage(),
 ];

 void _onItemTapped(int index) {
   setState(() {
     _selectedIndex = index;
   });
 }

 @override
 void initState() {
   super.initState();
   _selectedIndex = 0;
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: DoubleBack(
       child: _pages[_selectedIndex],
       waitForSecondBackPress: 4,
       onFirstBackPress: () {
         return Fluttertoast.showToast(
           msg: "Tekan sekali lagi untuk keluar",
           gravity: ToastGravity.BOTTOM,
           toastLength: Toast.LENGTH_LONG,
           backgroundColor: Colors.blue[600]?.withOpacity(0.9),
           textColor: Colors.white,
           fontSize: 14,
         );
       },
     ),
     bottomNavigationBar: Container(
       decoration: BoxDecoration(
         boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.1),
             blurRadius: 10,
             offset: Offset(0, -5),
           ),
         ],
       ),
       child: ClipRRect(
         borderRadius: BorderRadius.only(
           topLeft: Radius.circular(20),
           topRight: Radius.circular(20),
         ),
         child: BottomNavigationBar(
           type: BottomNavigationBarType.fixed,
           backgroundColor: Colors.white,
           currentIndex: _selectedIndex,
           onTap: _onItemTapped,
           selectedItemColor: Colors.blue[600],
           unselectedItemColor: Colors.grey[400],
           selectedFontSize: 12,
           unselectedFontSize: 12,
           elevation: 0,
           items: [
             BottomNavigationBarItem(
               icon: Container(
                 padding: EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: _selectedIndex == 0 
                     ? Colors.blue.withOpacity(0.1)
                     : Colors.transparent,
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Icon(Icons.home_outlined),
               ),
               activeIcon: Container(
                 padding: EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: Colors.blue.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Icon(Icons.home),
               ),
               label: 'Beranda',
             ),
             BottomNavigationBarItem(
               icon: Container(
                 padding: EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: _selectedIndex == 1 
                     ? Colors.blue.withOpacity(0.1)
                     : Colors.transparent,
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Icon(Icons.local_shipping_outlined),
               ),
               activeIcon: Container(
                 padding: EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: Colors.blue.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Icon(Icons.local_shipping),
               ),
               label: 'Cek Ongkir',
             ),
           ],
         ),
       ),
     ),
   );
 }
}