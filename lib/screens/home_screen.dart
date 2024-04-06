import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coralcart/screens/product_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 String searchQuery = ''; // Add searchQuery variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          CurvedBottomContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            logo: Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
            ),
            searchBar: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                onChanged: _handleSearch, // Call _handleSearch method
                decoration: InputDecoration(
                  hintText: 'Search at Coral Cart',
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('category').snapshots(),
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
                  // Filter categories based on searchQuery
                  final filteredCategories = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final category = data['category'] as String;
                    return category.toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      var data = filteredCategories[index].data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PoductScreen(
                                catid: filteredCategories[index].id,
                              ),
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
                                    data['image'],
                                    fit: BoxFit.cover,
                                    width: 200,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                data['category'],
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _handleSearch(String query) {
    setState(() {
      searchQuery = query;
    });
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
