import 'package:feszora/layout/color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart'; // ✅ for SVGs

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PageView (slider)
                    Expanded(
                      child: PageView(
                        controller: _controller,
                      children: [
        buildPage(
          title: "Welcome to Feszora",
          subtitle:
              "The all-in-one platform to simplify your invoicing, quotations, and expense tracking. Run your business smarter, not harder.",
          asset: "assets/animations/top.svg",
        ),
        buildPage(
          title: "Smart Invoicing",
          subtitle:
              "Create, customize, and send professional invoices in minutes. Get paid faster with a seamless process.",
          asset: "assets/animations/top3.svg",
        ),
        buildPage(
          title: "Professional Quotations",
          subtitle:
              "Send clear, branded quotations to clients. Impress prospects and win more business effortlessly.",
          asset: "assets/animations/top2.svg",
        ),
        buildPage(
          title: "Financial Control",
          subtitle:
              "Track expenses in real time, manage cash flow, and make confident decisions to grow your business.",
          asset: "assets/animations/top1.svg",
        ),
      ],

                ),
              ),

              const SizedBox(height: 20),

              // Page Indicator
              SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: const WormEffect(
                  dotHeight: 3,
                  dotWidth: 30,
                  activeDotColor: AppColors.black,
                ),
              ),

              const SizedBox(height: 30),

              // Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.black87,
                    ),
                    child: const Text(
                      "Open an Account",
                      style: TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color:AppColors.gray , width: 1.5), // ✅ outline color
                foregroundColor: AppColors.black, // ✅ text + ripple color
              ),
              child: const Text(
                "I have an Account",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
              const SizedBox(height: 20),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage({
    required String title,
    required String subtitle,
    required String asset,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SVG Centered
        Center(
          child: SizedBox(
            height: 250,
            child: SvgPicture.asset(asset, fit: BoxFit.contain, ),
          ),
        ),
        const SizedBox(height: 30),

        // Title & Subtitle aligned to start
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style:Theme.of(context).textTheme.displayLarge
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
      ],
    );
  }
}
