import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'package:whatsapp_clone/features/call/presentation/pages/calls_history_screen.dart';
import 'package:whatsapp_clone/features/chat/presentation/pages/chat_screen.dart';
import 'package:whatsapp_clone/features/status/presentation/pages/status_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int _currentTabIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _currentTabIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Whatspp",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: greyColor)),
        actions: [
          Row(
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: greyColor,
                size: 28.sp,
              ),
              SizedBox(
                width: 25.w,
              ),
              Icon(Icons.search, color: greyColor, size: 28.sp),
              SizedBox(
                width: 10.w,
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: greyColor,
                  size: 28.sp,
                ),
                color: appBarColor,
                iconSize: 28.sp,
                onSelected: (value) {},
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Settings",
                    child: GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(
                          //     context, PageConst.settingsPage, arguments: widget.uid);
                          context.pushNamed(Routes.settingsScreen);
                        },
                        child: const Text('Settings')),
                  ),
                ],
              ),
            ],
          ),
        ],
        bottom: TabBar(
          labelColor: tabColor,
          unselectedLabelColor: greyColor,
          indicatorColor: tabColor,
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                "Chats",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                "Status",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                "Calls",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          switchFloatingActionButtonOnTabIndex(_currentTabIndex),
      body: TabBarView(
          controller: _tabController,
          children: const [ChatScreen(), StatusScreen(), CallsHistoryScreen()]),
    );
  }

  switchFloatingActionButtonOnTabIndex(int index) {
    switch (index) {
      case 0:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
            // Navigator.pushNamed(context, PageConst.contactUsersPage, arguments: widget.uid);
            context.pushNamed(Routes.contactsScreen);
          },
          child: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        );
      case 1:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsPage()));
            // Navigator.pushNamed(context, PageConst.contactUsersPage, arguments: widget.uid);
          },
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        );
      case 2:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsPage()));
            // Navigator.pushNamed(context, PageConst.contactUsersPage, arguments: widget.uid);
            context.pushNamed(Routes.callContactScreen);
          },
          child: const Icon(
            Icons.add_call,
            color: Colors.white,
          ),
        );
      default:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsPage()));
            // Navigator.pushNamed(context, PageConst.contactUsersPage, arguments: widget.uid);
          },
          child: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        );
    }
  }
}
