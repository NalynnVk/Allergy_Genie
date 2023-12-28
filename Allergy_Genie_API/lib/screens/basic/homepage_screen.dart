import 'package:allergygenieapi/screens/insight/list_insight_screen.dart';
import 'package:allergygenieapi/screens/medicationReminder/list_reminder_screen.dart';
import 'package:allergygenieapi/screens/medicationTracking/update_tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:allergygenieapi/bloc/tracking_bloc.dart';
import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/constant.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/tracking/list_tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/home_page.dart';
import 'package:allergygenieapi/public_components/empty_list.dart';
import 'package:allergygenieapi/screens/default/navigation.dart';
import 'package:allergygenieapi/screens/medicationTracking/store_tracking_screen.dart';
// import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int _currentIndex = 0;

class _HomeScreenState extends State<HomeScreen> {
  // late Future<User?> _user;
  UserBloc userBloc = UserBloc();
  TrackingBloc trackingBloc = TrackingBloc();
  // DateTime today = DateTime.now();
  // void _onDaySelected(DateTime day, DateTime focusedDay) {
  //   setState(() {
  //     today = day;
  //   });
  // }

  static const _pageSize = 10;
  final PagingController<int, Tracking> _trackingPagingController =
      PagingController(firstPageKey: 1);

  // For refresher
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    _trackingPagingController.refresh();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> _fetchPage(int pageKey) async {
    // Call API
    final ListTrackingResponseModel response =
        await trackingBloc.getListTracking();

    print(response.data);

    // If success
    if (response.statusCode == HttpResponse.HTTP_OK) {
      List<Tracking> trackingModel = response.data!;
      print(trackingModel);
      // Compare the length with the page size to know either already last page or not
      final isLastPage = trackingModel.length < _pageSize;
      if (isLastPage) {
        _trackingPagingController.appendLastPage(trackingModel);
      } else {
        final nextPageKey = pageKey + trackingModel.length;
        _trackingPagingController.appendPage(trackingModel, nextPageKey);
      }
    } else {
      _trackingPagingController.error = response.message;
      print(response.message);
    }
  }

  void callbackRefresh() {
    _onRefresh();
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _trackingPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  int delayAnimationDuration = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '     Greetings, ${widget.user.name}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      drawer: AppDrawer(user: widget.user),
      body: SmartRefresher(
        controller: _refreshController,
        header: const WaterDropMaterialHeader(
          backgroundColor: kPrimaryColor,
        ),
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // SliverToBoxAdapter(
                  //   child: calendar(),
                  // ),
                  const SizedBox(height: 28.0),
                  ellipse(),
                  const SizedBox(height: 18.0),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              sliver: PagedSliverList<int, Tracking>(
                pagingController: _trackingPagingController,
                builderDelegate: PagedChildBuilderDelegate<Tracking>(
                  firstPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  noItemsFoundIndicatorBuilder: (context) => const EmptyList(
                    icon: Icons.people,
                    title: "No Tracking Record",
                    query: '',
                  ),
                  animateTransitions: true,
                  itemBuilder: (context, tracking, index) {
                    return trackingListItem(
                      context: context,
                      tracking: tracking,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _navigateTo(index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_add),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insight',
          ),
        ],
      ),
    );
  }

  // Widget calendar() {
  //   return Padding(
  //     padding: const EdgeInsets.all(15.0),
  //     child: Column(
  //       children: [
  //         Container(
  //           child: TableCalendar(
  //             headerStyle: const HeaderStyle(
  //               formatButtonVisible: false,
  //               titleCentered: true,
  //               titleTextStyle: TextStyle(fontSize: 24),
  //             ),
  //             selectedDayPredicate: (day) => isSameDay(day, today),
  //             focusedDay: today,
  //             firstDay: DateTime.utc(2000, 01, 01),
  //             lastDay: DateTime.utc(2060, 01, 01),
  //             onDaySelected: _onDaySelected,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget ellipse() {
    return Stack(
      children: [
        Center(
          child: ClipOval(
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black87,
                  // color: kPrimaryColor,
                  width: 5, // Increased thickness of the oval
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 22.0),
                  const Text(
                    'How do you feel today?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StoreTrackingScreen(user: widget.user),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      'Log Symptom',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return HomeScreen(user: widget.user);
            },
          ),
        );
        break;
      case 1:
        // Update this block to navigate to the correct screen for Medication Info
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ListReminderScreen(user: widget.user);
            },
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ListInsightScreen(user: widget.user);
            },
          ),
        );
        break;
    }
  }

  Widget trackingListItem({
    required BuildContext context,
    required Tracking tracking,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateTrackingScreen(
              user: widget.user,
              tracking: tracking,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tracking.symptom!.name ?? "null",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Allergen Type: ${tracking.allergen!.name ?? "null"}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Severity Level: ${tracking.severity ?? "null"}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Text(
                          //   'Note:',
                          //   style: const TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 15,
                          //   ),
                          // ),
                          // const SizedBox(height: 5),
                          // // Wrap description in Expanded to avoid overflow
                          Text(
                            '${tracking.notes ?? "null"}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
