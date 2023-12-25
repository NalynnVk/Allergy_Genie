import 'package:allergygenieapi/bloc/med_reminder_bloc.dart';
import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/constant.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/med_reminder/list_med_reminder_response_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/home_page.dart';
import 'package:allergygenieapi/public_components/empty_list.dart';
import 'package:allergygenieapi/screens/default/navigation.dart';
import 'package:allergygenieapi/screens/medicationReminder/store_reminder_screen.dart';
import 'package:allergygenieapi/screens/medicationReminder/update_reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListReminderScreen extends StatefulWidget {
  final User user;
  const ListReminderScreen({super.key, required this.user});

  @override
  State<ListReminderScreen> createState() => _ListReminderScreenState();
}

class _ListReminderScreenState extends State<ListReminderScreen> {
  late Future<User?> _user;
  UserBloc userBloc = UserBloc();
  MedReminderBloc medReminderBloc = MedReminderBloc();

  static const _pageSize = 10;
  final PagingController<int, MedReminder> _medReminderPagingController =
      PagingController(firstPageKey: 1);

  // For refresher
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch

    _medReminderPagingController.refresh();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> _fetchPage(int pageKey) async {
    //Call API
    final ListMedReminderResponseModel response =
        await medReminderBloc.getListMedReminder();

    print(response.data);

    // If success
    if (response.statusCode == HttpResponse.HTTP_OK) {
      List<MedReminder> merReminderModel = response.data!;
      print(merReminderModel);
      // Compare the lenght with the page size to know either already last page or not
      final isLastPage = merReminderModel.length < _pageSize;
      if (isLastPage) {
        _medReminderPagingController.appendLastPage(merReminderModel);
      } else {
        final nextPageKey = pageKey + merReminderModel.length;
        _medReminderPagingController.appendPage(merReminderModel, nextPageKey);
      }
    } else {
      _medReminderPagingController.error = response.message;
      print(response.message);
    }
  }

  void callbackRefresh() {
    _onRefresh();
  }

  @override
  void initState() {
    super.initState();
    _medReminderPagingController.addPageRequestListener((pageKey) {
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
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StoreReminderScreen(user: widget.user)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                  ),
                  child: Text(
                    "Log Medication Intake",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 20),
              sliver: PagedSliverList<int, MedReminder>(
                pagingController: _medReminderPagingController,
                builderDelegate: PagedChildBuilderDelegate<MedReminder>(
                  firstPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  noItemsFoundIndicatorBuilder: (context) => const EmptyList(
                    icon: Icons.people,
                    title: "No Reminder Record",
                    query: '',
                  ),
                  animateTransitions: true,
                  itemBuilder: (context, medReminder, index) {
                    return medReminderListItem(
                      context: context,
                      medReminder: medReminder,
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

  Widget medReminderListItem({
    required BuildContext context,
    required MedReminder medReminder,
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
                            medReminder.medication!.name ?? "null",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Dosage: ${medReminder.dosage ?? "null"}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Reminder: ${medReminder.time_reminder ?? "null"}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Repitition: ${medReminder.repititon ?? "null"}',
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
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdateReminderScreen(user: widget.user, medReminder: medReminder)),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text(
                                'Are you sure you want to delete this item?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Return false if user cancels
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      true); // Return true if user confirms
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        // User confirmed, proceed with deletion
                        MedReminderBloc medReminderBloc = MedReminderBloc();
                        await medReminderBloc.delete(medReminder.id!);
                      }
                    },
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
