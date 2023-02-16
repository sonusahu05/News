import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:scroll_page_view/pager/scroll_page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool("showHome") ?? false;

  runApp(
    MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xff15001c)),
      // home: BlocProvider<AuthBloc>(
      //   create: (context) => AuthBloc(FirebaseAuthProvider()),
      //   child: HomePage(showHome: showHome),
      // ),
      home: showHome
          ? const MyHomePage(
              title: 'News App',
            )
          : OnBoarding(
              showHome: showHome,
            ),
      routes: {},
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class OnBoarding extends StatefulWidget {
  final bool showHome;
  const OnBoarding({super.key, required this.showHome});
  static const titles = [
    'Notes',
    'Event Updates',
    'Concession',
    // 'Attendance'
  ];

  static const descriptions = [
    'Our notes feature offers a personalized experience for managing your notes with features such as writing, saving, sharing, updating and deleting. Keep track of your thoughts, ideas and information all in one place. Try it now for a simple and user-friendly note-taking solution.',
    'Stay informed on college events with our platform. Get comprehensive information on future events and never miss out. Check it out now.',
    'Our platform offers a digital railway concession application process for students with the ability to check the status of their application. No more waiting in lines or searching for paper forms, apply now for a quick and efficient experience.',
  ];
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late final ScrollPageController _controller;
  bool isLastPage = false;
  @override
  void initState() {
    _controller = ScrollPageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 90,
            ),
            Image.asset(
              'assets/images/icon/spit_logo.png',
              height: 200,
            ),
            const SizedBox(
              height: 90,
            ),
            SizedBox(
              height: 250,
              child: ScrollPageView(
                allowImplicitScrolling: false,
                isTimer: false,
                checkedIndicatorColor: const Color(0xffff8c00),
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 2;
                  });
                },
                children: [
                  for (var i = 0; i < OnBoarding.titles.length; i++)
                    Column(
                      children: [
                        Text(
                          OnBoarding.titles[i],
                          style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            OnBoarding.descriptions[i],
                            style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 90,
            ),
            if (isLastPage != true)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.controller.jumpToPage(3);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xfffbd512),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff141414)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffff8c00),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff141414),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset(
                            'assets/images/icon/arrow_right.svg',
                            height: 13,
                            color: const Color(0xff141414),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (isLastPage == true)
              SizedBox(
                width: 300,
                height: 60,
                child: InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("showHome", true);
                    if (!mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(
                          title: 'News App',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xfffbd512),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Get started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff141414),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Color(0xff141414),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
