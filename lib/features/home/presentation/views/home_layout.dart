import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../manager/home_view_model.dart';

class HomeLayout extends StatelessWidget {
  static const String routeName = 'home-layout';

  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homeViewModel, child) {
          return Scaffold(
            body: PageView(
              controller: homeViewModel.pageController,
              onPageChanged: homeViewModel.changeTab,
              children: homeViewModel.tabs.map((tab) => tab.screen).toList(),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: homeViewModel.currentIndex,
              onDestinationSelected: homeViewModel.changeTab,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              elevation: 0,
              height: 70,
              backgroundColor:
                  Theme.of(
                    context,
                  ).colorScheme.surface, // Match scaffold background
              surfaceTintColor:
                  Colors.transparent, // Prevents shadow or elevation
              destinations:
                  homeViewModel.tabs
                      .map(
                        (tab) => NavigationDestination(
                          icon: Icon(tab.icon),
                          label: tab.title,
                        ),
                      )
                      .toList(),
            ),
          );
        },
      ),
    );
  }
}
