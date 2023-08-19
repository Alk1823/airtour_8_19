import 'package:flutter/material.dart';


import '../Manage_booking/view_bookings.dart';
import '../One-Way/one_way.dart';
import '../Round-Trip/round_trip.dart';
import '../profile/ProfileView.dart';
import 'display_history.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int indexx = 0;
  final pages = [
    const Center(child: SelectTravelType()),
    const Center(child: History()),
    const Center(child: ViewBookings()),
    const Center(child: ProfileView()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[indexx],
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: Colors.blue,
        indicatorColor: Colors.white,
        selectedIndex: indexx,
        onDestinationSelected: (value) {
          setState(() {
            indexx = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
              icon: Icon(Icons.history_sharp), label: 'History'),
          NavigationDestination(
              icon: Icon(Icons.manage_history_sharp), label: 'Manage'),
          NavigationDestination(
              icon: Icon(Icons.person_2_sharp), label: "Profile")
        ],
      ),
    );
  }
}






class SelectTravelType extends StatefulWidget {
  const SelectTravelType({super.key});

  @override
  State<SelectTravelType> createState() => _SelectTravelTypeState();
}

class _SelectTravelTypeState extends State<SelectTravelType> {
  List<String> selectType = ["One Way", "Round Trip"];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(title: Text("Switch")),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TabBar(
                      indicator: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25)),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Tab(text: "One way"), Icon(Icons.flight)],
                        ),
                        Tab(
                          text: "Round trip",
                        )
                      ],
                    ),
                  ),
                  const Expanded(
                      child: TabBarView(children: [
                    OneWay(),
                    Center(
                      child: RoundTrip(),
                    )
                  ]))
                ],
              ),
            ),
          )),
    );
  }
}
