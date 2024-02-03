import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:queue/logic/bloc.dart';
import 'package:queue/logic/events.dart';
import 'package:queue/logic/states.dart';
import 'package:queue/presentation/screens/mainScreen/subscreens/admin_view.dart';
import 'package:queue/presentation/screens/mainScreen/subscreens/qr_scanner_screen.dart';
import 'package:queue/presentation/screens/mainScreen/subscreens/today_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentPage;
  late final PageController pageController;
  late bool isAdmin;
  Image? backgroundImage;
  @override
  void initState() {
    final bloc = context.read<QueueBloc>();
    final state = (bloc.state as MainState);
    isAdmin = state.isAdmin;
    pageController = PageController(initialPage: isAdmin ? 1 : 0);
    currentPage = pageController.initialPage;
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<QueueBloc, QueueState>(
          builder: (context, state) {
            state = state as MainState;
            if (state.backgroundImageDecoded != null) {
              backgroundImage = Image.memory(state.backgroundImageDecoded!, repeat: ImageRepeat.repeat);
            } else {
              if (backgroundImage == null && state.backgroundImageDecoded == null) {
                backgroundImage = Image.asset("assets/panda.png", repeat: ImageRepeat.repeat);
              }
            }
            return Stack(
              children: [
                Positioned.fill(
                  key: ValueKey(state.backgroundImageDecoded?.sublist(0, 10)),
                  child: backgroundImage!,
                ),
                Material(
                  color: Colors.transparent,
                  elevation: 20,
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (isAdmin) const AdminView(),
                      const TodayScreen(),
                      const QRScannerScreen(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: NavigationBar(
            selectedIndex: currentPage,
            onDestinationSelected: (value) {
              if (pageController.hasClients) {
                pageController.animateToPage(value,
                    duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              } else {
                build(context);
              }

              setState(() {
                currentPage = value;
              });
            },
            destinations: [
              if (isAdmin)
                const NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), label: "Admin settings"),
              const NavigationDestination(icon: Icon(Icons.today_outlined), label: "Today"),
              const NavigationDestination(icon: Icon(Icons.qr_code_outlined), label: "Qr scanner"),
            ]),
        endDrawer: Drawer(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const Gap(32),
              OutlinedButton(
                style: Theme.of(context).outlinedButtonTheme.style,
                onPressed: () => context.read<QueueBloc>().add(UserLogOutEvent()),
                child: Text(
                  "Выйти из аккаунта",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ]),
          ),
        )),
      ),
    );
  }
}
