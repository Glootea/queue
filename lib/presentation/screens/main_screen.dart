import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:queue/logic/bloc.dart';
import 'package:queue/logic/events.dart';
import 'package:queue/logic/states.dart';
import 'package:queue/presentation/navigation.dart';
import 'package:queue/presentation/widgets/connectiom_status.dart';
import 'package:queue/presentation/widgets/lesson_widget.dart';
import 'package:queue/presentation/widgets/padding.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 0;
  late final PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: 0);
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
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<QueueBloc, QueueState>(
            builder: (context, state) {
              if (state is UserUnAuthenticatedState) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.loginScreen);
                });
              }
              try {
                MainState mainState = state as MainState;
                return Stack(
                  children: [
                    Positioned.fill(
                        child: Image.asset(
                      'assets/panda.png',
                      width: 50,
                      height: 50,
                      repeat: ImageRepeat.repeat,
                    )),
                    MediaQuery.of(context).size.width < 600
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConnectionStatusWidget(),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ConnectionStatusWidget(),
                            ],
                          ),
                    Material(
                      color: Colors.transparent,
                      elevation: 20,
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          TodayView(mainState: mainState),
                          const QRScannerView()
                        ],
                      ),
                    ),
                  ],
                );
              } catch (e) {
                log("Wrong state at transition. Not critical");
                return const Scaffold();
              }
            },
          ),
        ),
        bottomNavigationBar: NavigationBar(
            selectedIndex: currentPage,
            onDestinationSelected: (value) {
              if (pageController.hasClients) {
                pageController.animateToPage(value,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
              } else {
                build(context);
              }

              setState(() {
                currentPage = value;
              });
            },
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.today_outlined), label: "Today"),
              NavigationDestination(
                  icon: Icon(Icons.qr_code_outlined), label: "Qr scanner")
            ]),
      ),
    );
  }
}

class TodayView extends StatelessWidget {
  const TodayView({
    super.key,
    required this.mainState,
  });

  final MainState mainState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width > 600
          ? const EdgeInsets.symmetric(horizontal: 64.0)
          : const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MyPadding(),
            const MyPadding(),
            Text(
              "Пары с очередью сегодня: ",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const MyPadding(),
            (mainState.todayLessons.isEmpty)
                ? Text(
                    "Пар с очередью нет",
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: mainState.todayLessons.length,
                    itemBuilder: (context, index) =>
                        LessonWidget(mainState.todayLessons[index]),
                    separatorBuilder: (context, index) => const MyPadding(),
                  ),
            const MyPadding(),
            OutlinedButton(
              style: Theme.of(context).outlinedButtonTheme.style,
              onPressed: () => context.read<QueueBloc>().add(UserLogOutEvent()),
              child: Text(
                "Выйти из аккаунта",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  late final MobileScannerController controller;
  @override
  void initState() {
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
    );
    // controller.stop();
    // controller.start();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // final _snackBarState = SnackBarState();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: MobileScanner(
            controller: controller,
            onDetect: (barcodes) {
              log('Detected');
              controller.stop();

              context.read<QueueBloc>().add(
                  UploadFromLinkEvent(barcodes.barcodes.first.rawValue ?? ''));
              Navigator.of(context).pushReplacementNamed(Routes.uploadScreen);
            }
            // onScan: (String value) { TODO: update to bloc
            //   debugPrint(value);
            // },
            //       onDetect: (BarcodeCapture capture) async {
            //         final messenger = ScaffoldMessenger.of(context);
            //         try {
            //           final data = capture.barcodes.last.rawValue;
            //           if (data == null) return;
            //           final decrypted =
            //               Encryption.decrypt(data.substring(data.indexOf('info=') + 5));
            //           final result = await OnlineDataBase.uploadFromQuery(decrypted);
            //           if (!_snackBarState._snackbarShown) {
            //             if (result) {
            //               messenger
            //                   .showSnackBar(const SnackBar(
            //                       content: Text("Спасибо за помощь!"),
            //                       showCloseIcon: true))
            //                   .closed
            //                   .then((value) => _snackBarState._snackbarShown = false);
            //             } else {
            //               messenger
            //                   .showSnackBar(const SnackBar(
            //                       content: Text("Ошибка при отправке запроса"),
            //                       showCloseIcon: true))
            //                   .closed
            //                   .then((value) => _snackBarState._snackbarShown = false);
            //             }
            //             _snackBarState._snackbarShown = true;
            //           }
            //           return;
            //         } catch (e) {
            //           log(e.toString());
            //         }
            //       },
            //     ),
            //   );
            // }
            ));
  }
}