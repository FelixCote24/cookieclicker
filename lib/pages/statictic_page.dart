import 'package:cookieclicker/model/user.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  final User currentUser;

  const StatisticsPage(this.currentUser, {Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Add this to make the whole page scrollable
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.currentUser.cookieMaster
                      ? [Colors.amber, Colors.orange]
                      : [Colors.blue, Colors.indigo],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Center(
                      child: Text(
                        "Statistics",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        buildStatRow(
                          "Nombre de cookies:",
                          widget.currentUser.nombreCookies,
                        ),
                        buildStatRow(
                          "Nombre de clics:",
                          widget.currentUser.nombreClics,
                        ),
                        if (widget.currentUser.cookieMaster)
                          buildStatRow(
                            "Nombre d'usines:",
                            widget.currentUser.nombreUsines,
                          ),
                        buildStatRow(
                          "Nombre de grand-mères:",
                          widget.currentUser.nombreGrandMeres,
                        ),
                        buildStatRow(
                          "Cookies générés depuis création:",
                          widget.currentUser.cookiesGeneresDepuisCreation,
                        ),
                        // Scrollable images for Usines and Grandmas
                        // Scrollable images for Usines and Grandmas
                        // Scrollable images for Usines and Grandmas
                        if (widget.currentUser.nombreUsines > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Usines:",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height:
                                      350, // Adjust height to fit 3 rows of images
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .grey[200], // Light gray background
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 2), // Black border
                                  ),
                                  child: GridView.builder(
                                    scrollDirection:
                                        Axis.vertical, // Vertical scrolling
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4, // 4 images per row
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: widget.currentUser.nombreUsines,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Image.asset(
                                          'assets/usine.png',
                                          width: 80, // Adjust image size here
                                          height: 80,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.currentUser.nombreGrandMeres > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Grand-mères:",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height:
                                      350, // Adjust height to fit 3 rows of images
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .grey[200], // Light gray background
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 2), // Black border
                                  ),
                                  child: GridView.builder(
                                    scrollDirection:
                                        Axis.vertical, // Vertical scrolling
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4, // 4 images per row
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount:
                                        widget.currentUser.nombreGrandMeres,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Image.asset(
                                          'assets/grandma.png',
                                          width: 80, // Adjust image size here
                                          height: 80,
                                        ),
                                      );
                                    },
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
            Positioned(
              top: 30,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.all(16),
                    side: const BorderSide(color: Colors.black, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.logout, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Logout",
                        style: TextStyle(fontSize: 18),
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

  Widget buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
