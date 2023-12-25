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
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<User?> _user;
  UserBloc userBloc = UserBloc();
  TrackingBloc trackingBloc = TrackingBloc();

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
    //Call API
    final ListTrackingResponseModel response =
        await trackingBloc.getListTracking();

    print(response.data);

    // If success
    if (response.statusCode == HttpResponse.HTTP_OK) {
      List<Tracking> trackingModel = response.data!;
      print(trackingModel);
      // Compare the lenght with the page size to know either already last page or not
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
    _trackingPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  int delayAnimationDuration = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Greetings ${widget.user.name}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ellipse(),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 20),
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
    );
  }

  Widget ellipse() {
    return Stack(
      children: [
        Center(
          child: ClipOval(
            child: Container(
              width: 200,
              height: 200,
              color: Colors.blue, // Change the color as needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How do you feel today?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreTrackingScreen(user: widget.user),
                        ),
                      );
                    },
                    child: Text('LOG SYMPTOM'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget trackingListItem({
    required BuildContext context,
    required Tracking tracking,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(
              color: Colors.blue,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Severity Level: ${tracking.severity ?? "null"}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Description: ${tracking.notes ?? "null"}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
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
