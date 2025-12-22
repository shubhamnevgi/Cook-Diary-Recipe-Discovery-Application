import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/views/pages/home_page.dart';
import 'package:flutter_application_1/views/pages/explore_page.dart';
import 'package:flutter_application_1/views/pages/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
// google_fonts removed due to asset loading issues; using default TextStyle

import '../../widgets/navbar_widget.dart';
import '../../widgets/profile_widget.dart';

List<Widget> pages = [HomePage(), ExplorePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Lottie.asset(
                'assets/animations/FoodChoice.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
            // const SizedBox(width: 10),
            Text(
              'Cook Diary',
              style: GoogleFonts.pacifico(
                // or .lobster() or .poppins()
                fontSize: 24, // Increased size for script fonts
                fontWeight: FontWeight.w400,
                color: Theme.of(
                  context,
                ).colorScheme.primary, // Matches your app theme
              ),
            ),
          ],
        ),

        // centerTitle: true,
        actions: [
          // Added width to prevent overflow in AppBar
          // SizedBox(width: 80.0),
          IconButton(
            onPressed: () {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode);
              },
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(
              right: 12.0,
            ), // Control spacing from the edge
            child: Center(
              // Center ensures the tap area is around the circle
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(
                  50,
                ), // Matches the avatar shape
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  child: ProfileWidget(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages[selectedPage];
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
