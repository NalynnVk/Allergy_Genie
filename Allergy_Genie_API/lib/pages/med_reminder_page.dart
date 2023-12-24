import 'package:allergygenieapi/helpers/general_method.dart';
import 'package:allergygenieapi/pages/add_reminder_page.dart';
import 'package:flutter/material.dart';
import 'package:allergygenieapi/bloc/med_reminder_bloc.dart';
import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/constant.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/med_reminder/list_med_reminder_response_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/widgets/base_page.dart';
import 'package:allergygenieapi/public_components/empty_list.dart';
// import 'package:allergygenieapi/public_components/theme_spinner.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MedReminderPage extends StatefulWidget {
  final User user;

  const MedReminderPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MedReminderPage> createState() => _MedReminderPageState();
}

class _MedReminderPageState extends State<MedReminderPage> {
  //medication reminder api
  MedReminderBloc medReminderBloc = MedReminderBloc();
  // late Future<User?> _user;
  UserBloc userBloc = UserBloc();
  static const _pageSize = 10;
  final PagingController<int, MedReminder> _medreminderPagingController =
      PagingController(firstPageKey: 1);

  // For refresher
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    _medreminderPagingController.refresh();
    // if failed, use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Call API
      final ListMedReminderResponseModel response =
          await medReminderBloc.getListMedReminder();

      // If success
      if (response.statusCode == HttpResponse.HTTP_OK) {
        List<MedReminder> medreminderModel = response.data!;

        // Compare the length with the page size to know either already last page or not
        final isLastPage = medreminderModel.length < _pageSize;
        if (isLastPage) {
          _medreminderPagingController.appendLastPage(medreminderModel);
        } else {
          final nextPageKey = pageKey + medreminderModel.length;
          _medreminderPagingController.appendPage(
              medreminderModel, nextPageKey);
        }

        print(medreminderModel);
      } else {
        _medreminderPagingController.error = response.message;
        print(response.message);
      }
    } catch (error) {
      _medreminderPagingController.error = "Server Error";
    }
  }

  void callbackRefresh() {
    _onRefresh();
  }

  @override
  void initState() {
    super.initState();
    _medreminderPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  int delayAnimationDuration = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePage(
        user: widget.user,
        body: SmartRefresher(
          controller: _refreshController,
          header: const WaterDropMaterialHeader(
            backgroundColor: Colors.grey,
          ),
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: <Widget>[
              PagedSliverList<int, MedReminder>(
                pagingController: _medreminderPagingController,
                builderDelegate: PagedChildBuilderDelegate<MedReminder>(
                  firstPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  noItemsFoundIndicatorBuilder: (context) => const EmptyList(
                    icon: Icons.menu_book,
                    title: "No Med Reminder Information",
                    query: '',
                  ),
                  animateTransitions: true,
                  itemBuilder: (context, medreminder, index) {
                    return medreminderListItem(
                      context: context,
                      medreminder: medreminder,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
            bottom: 65.0, right: 10.0), // Adjust the bottom margin as needed
        child: FloatingActionButton(
          onPressed: () {
            // _showAddDialog(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddReminderPage(user: widget.user),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget medreminderListItem({
    required BuildContext context,
    required medreminder,
  }) =>
      GestureDetector(
        // onTap: () {
        //   // Call the edit dialog when the container is tapped
        //   _buildEditMedicationForm(context, medreminder);
        // },
        onTap: () {
          navigateTo(context, AddReminderPage(user: widget.user));
        },
        child: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            // SizedBox(height: 10),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${medreminder.time_reminder}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${medreminder.medication!.name}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                // SizedBox(height: 8),
                // Text(
                //   'Dosage: ${medreminder.dosage}',
                //   style: const TextStyle(
                //     color: Colors.black,
                //     fontSize: 15,
                //   ),
                // ),
                // SizedBox(height: 8),
                // Text(
                //   'Repetition: ${medreminder.repititon}',
                //   style: const TextStyle(
                //     color: Colors.black,
                //     fontSize: 15,
                //   ),
                // ),
                // SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Enable Reminder',
                //       style: const TextStyle(
                //         color: Colors.black,
                //         fontSize: 16,
                //       ),
                //     ),
                //     Switch(
                //       value: medreminder.isReminderEnabled,
                //       onChanged: (value) {
                //         // Add your logic here to enable/disable the reminder
                //         // You might want to call an API to update the reminder status
                //         setState(() {
                //           medreminder.isReminderEnabled = value;
                //         });
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      );
}

class ThemeSpinner {
  static Widget spinner() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
    );
  }
}


// https://chat.openai.com/c/ccba5442-8e2c-4a69-bf25-02efe7c73790
