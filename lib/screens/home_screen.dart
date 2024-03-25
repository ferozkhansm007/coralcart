import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coralcart/screens/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurvedBottomContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            logo: Container(
              color: Colors.white, // Replace with your logo asset
              height: 50,
              width: 50,
            ),
            searchBar: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                    decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                )))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('category')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      mainAxisSpacing: 10, // Spacing between rows
                      crossAxisSpacing: 10, // Spacing between columns
                    ),
                    itemCount: snapshot
                        .data!.docs.length, // Number of items in the grid
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PoductScreen(catid: snapshot.data!.docs[index].id,), // Pass data to the ProductScreen
                            ),
                          );
                        },
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            border: Border.all(color: Colors.teal, width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    data[
                                        'image'], // Use imageUrl from Firestore data
                                    fit: BoxFit.cover,
                                    width: 200,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                data[
                                    'category'], // Use productName from Firestore data
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class CurvedBottomContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget logo;
  final Widget searchBar;

  const CurvedBottomContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.logo,
    required this.searchBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        color: Colors.teal, // Set container color to teal
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          logo,
          searchBar,
        ],
      ),
    );
  }
}
