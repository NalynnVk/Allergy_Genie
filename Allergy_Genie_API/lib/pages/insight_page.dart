import 'package:allergygenieapi/bloc/insight_bloc.dart';
import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/constant.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/insight/insight_model.dart';
import 'package:allergygenieapi/models/insight/list_insight_response_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/base_page.dart';
import 'package:allergygenieapi/public_components/empty_list.dart';
import 'package:allergygenieapi/public_components/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InsightPage extends StatefulWidget {
  final User user;

  const InsightPage({super.key, required this.user});

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  InsightBloc insightBloc = InsightBloc();
  late Future<User?> _user;
  UserBloc userBloc = UserBloc();
  static const _pageSize = 10;
  final PagingController<int, Insight> _insightPagingController =
      PagingController(firstPageKey: 1);

  // For refresher
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch

    _insightPagingController.refresh();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> _fetchPage(int pageKey) async {
    // try {
    //Call API
    final ListInsightResponseModel response =
        await insightBloc.getListInsight();

    // If success
    if (response.statusCode == HttpResponse.HTTP_OK) {
      List<Insight> insightModel = response.data!;

      // Compare the lenght with the page size to know either already last page or not
      final isLastPage = insightModel.length < _pageSize;
      if (isLastPage) {
        _insightPagingController.appendLastPage(insightModel);
      } else {
        final nextPageKey = pageKey + insightModel.length;
        _insightPagingController.appendPage(insightModel, nextPageKey);
      }

      print(insightModel);
    } else {
      _insightPagingController.error = response.message;
      print(response.message);
    }
    // } catch (error) {
    //   _insightPagingController.error = "Server Error";
    // }
  }

  void callbackRefresh() {
    _onRefresh();
  }

  @override
  void initState() {
    super.initState();
    _insightPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  int delayAnimationDuration = 100;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      user: widget.user,
      body: SmartRefresher(
        controller: _refreshController,
        header: const WaterDropMaterialHeader(
          backgroundColor: kPrimaryColor,
        ),
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: <Widget>[
            // SliverToBoxAdapter(
            //   child: calendar(),
            // ),
            PagedSliverList<int, Insight>(
              pagingController: _insightPagingController,
              builderDelegate: PagedChildBuilderDelegate<Insight>(
                firstPageProgressIndicatorBuilder: (context) {
                  return ThemeSpinner.spinner();
                },
                newPageProgressIndicatorBuilder: (context) {
                  return ThemeSpinner.spinner();
                },
                noItemsFoundIndicatorBuilder: (context) => const EmptyList(
                  icon: Icons.menu_book,
                  title: "No Insight Details",
                  query: '',
                ),
                animateTransitions: true,
                itemBuilder: (context, insight, index) {
                  return insightList(
                    context: context,
                    insight: insight,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget insightList({required BuildContext context, required insight}) =>
      Center(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card Widgets
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 8),
                                  // Text('Symptom category: Skin-related Symptoms'),
                                  // Text('Allergen type: Fish (eg: tuna)'),
                                  // Text('Severity number: 2'),
                                  // Text('Notes: Rashes around the arm'),
                                  // Text(
                                  //   'Photo Path: ${insight.photo_path}',
                                  //   style: const TextStyle(
                                  //     color: Colors.black,
                                  //     fontSize: 15,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  Text(
                                    '${insight.title}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}