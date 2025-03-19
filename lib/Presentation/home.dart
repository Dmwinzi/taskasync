import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:task_async/DI/Locator.dart';
import 'Viewmodel/Taskviewmodel.dart';
import 'Widgets/ToDos.dart';
import 'Widgets/Completed.dart';
import 'Widgets/Inprogress.dart';
import 'Widgets/addtaskdialogue.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String getFormattedDate() {
    return DateFormat("MMMM d, yyyy").format(DateTime.now());
  }

  String getDay() {
    return DateFormat("EEE").format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<Taskviewmodel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => locator<Taskviewmodel>(),
      onViewModelReady: (viewModel) => viewModel.fetchTasks(),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
            title: Text(
              "Task Async",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          getDay(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      getFormattedDate(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: "Todo"),
                    Tab(text: "In-progress"),
                    Tab(text: "Completed"),
                  ],
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                ),
              ),
              SizedBox(height: 20,),
              viewModel.isBusy ? Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ) :
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Todos(viewModel: viewModel),
                    Inprogress(viewModel: viewModel),
                    Completed(viewModel: viewModel),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => TaskBottomSheet(),
              );
            },
            backgroundColor: Colors.black,
            child: Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}
