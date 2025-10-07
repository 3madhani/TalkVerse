import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../manager/home_view_model.dart';
import '../widgets/keep_alive_wrapper.dart';

class HomeLayout extends StatelessWidget {
  static const String routeName = 'home-layout';

  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homeViewModel, _) {
          return Scaffold(
            body: PageView(
              controller: homeViewModel.pageController,
              onPageChanged: homeViewModel.changeTab,
              children:
                  homeViewModel.tabs
                      .map((tab) => KeepAliveWrapper(child: tab.screen))
                      .toList(),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: homeViewModel.currentIndex,
              onDestinationSelected: (index) {
                homeViewModel.pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                homeViewModel.changeTab(index);
              },

              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              elevation: 0,
              height: 70,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Colors.transparent,
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
