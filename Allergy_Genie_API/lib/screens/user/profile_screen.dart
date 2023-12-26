import 'package:allergygenieapi/bloc/allergic_bloc.dart';
import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/constant.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/patient/allergic_model.dart';
import 'package:allergygenieapi/models/patient/list_allergic_response_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/home_page.dart';
import 'package:allergygenieapi/public_components/empty_list.dart';
import 'package:allergygenieapi/screens/default/navigation.dart';
import 'package:allergygenieapi/screens/user/store_allergic_screen.dart';
import 'package:allergygenieapi/screens/user/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User?> _user;
  UserBloc userBloc = UserBloc();
  AllergicBloc allergicBloc = AllergicBloc();

  static const _pageSize = 10;
  final PagingController<int, Allergic> _allergicPagingController =
      PagingController(firstPageKey: 1);

  // For refresher
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch

    _allergicPagingController.refresh();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> _fetchPage(int pageKey) async {
    //Call API
    final ListAllergicResponseModel response =
        await allergicBloc.getListAllergic();

    print(response.data);

    // If success
    if (response.statusCode == HttpResponse.HTTP_OK) {
      List<Allergic> allergicModel = response.data!;
      print(allergicModel);
      // Compare the lenght with the page size to know either already last page or not
      final isLastPage = allergicModel.length < _pageSize;
      if (isLastPage) {
        _allergicPagingController.appendLastPage(allergicModel);
      } else {
        final nextPageKey = pageKey + allergicModel.length;
        _allergicPagingController.appendPage(allergicModel, nextPageKey);
      }
    } else {
      _allergicPagingController.error = response.message;
      print(response.message);
    }
  }

  void callbackRefresh() {
    _onRefresh();
  }

  @override
  void initState() {
    super.initState();
    _allergicPagingController.addPageRequestListener((pageKey) {
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${widget.user.name}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Date of Birth: ${widget.user.date_of_birth}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          // Use Navigator.push and then to handle auto-refresh
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateProfileScreen(user: widget.user),
                            ),
                          );
                          // Refresh the page after editing the profile
                          setState(() {});
                        },
                        child: Text('Edit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'My Allergic List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StoreAllergicScreen(user: widget.user)),
                    );
                  },
                  child: Text('Add Allergic'),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 20),
              sliver: PagedSliverList<int, Allergic>(
                pagingController: _allergicPagingController,
                builderDelegate: PagedChildBuilderDelegate<Allergic>(
                  firstPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  noItemsFoundIndicatorBuilder: (context) => const EmptyList(
                    icon: Icons.people,
                    title: "No Allergic Record",
                    query: '',
                  ),
                  animateTransitions: true,
                  itemBuilder: (context, allergic, index) {
                    return allergicListItem(
                      context: context,
                      allergic: allergic,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget allergicListItem({
    required BuildContext context,
    required Allergic allergic,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allergic.allergen!.name ?? "null",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Severity: ${allergic.severity ?? "null"}',
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
