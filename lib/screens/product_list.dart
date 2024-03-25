import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coralcart/screens/cart_screen.dart';
import 'package:coralcart/screens/checkout_screen.dart';
import 'package:coralcart/screens/payment_screen.dart';
import 'package:coralcart/screens/view_product.dart';
import 'package:coralcart/services/firbase_cart_service.dart';
import 'package:coralcart/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motion_toast/motion_toast.dart';

class PoductScreen extends StatefulWidget {
  PoductScreen({super.key, required this.catid});
  String catid;

  @override
  State<PoductScreen> createState() => _PoductScreenState();
}

class _PoductScreenState extends State<PoductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color.fromARGB(143, 0, 150, 135),
                width: 1,
              ),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search at Coral Cart',
                suffixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('product').where('catId', isEqualTo: widget.catid).snapshots(),
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
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewProductScreen(viewdata: data),
                          ),
                        );
                      },
                      child: ProductWidget(productdata: data,id: snapshot.data!.docs[index].id,),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        
        shape: CircleBorder(),
        
        onPressed: () {
          // Add onPressed logic to navigate to the cart screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.shopping_cart,
        color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


class ProductWidget extends StatefulWidget {
   ProductWidget({super.key, required this.productdata,required this.id});
  Map<String,dynamic> productdata;
  String id;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {


  bool _loading=false;
  @override
  Widget build(BuildContext context) {
    print(widget.productdata);
    return _loading? Center(child: CircularProgressIndicator(color: Colors.teal,),) :Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: Image.network(
              widget.productdata['image'],
              fit: BoxFit.cover,
            ),
          ),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productdata['productname'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.productdata['discription'],
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Shop Name',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 5),
                Text(
                  widget.productdata['price'].toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                      height: 40,
                      buttonName: "Buy",
                      onPressed: () async{
                        print(await FirebaseAuth.instance.currentUser!.uid);
  
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(),
                        ));

                      },
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: CustomButton(
                      height: 40,
                      buttonName: "Add to Cart",
                      onPressed: ()async {
                       try{
                        setState(() {
                          _loading=true;
                        });
                       await FirebaseCartService().addCart(productId:widget.id , price: widget.productdata['price'], productName:  widget.productdata['productname'], imageUrl: widget.productdata['image']);
                       setState(() {
                         _loading=false;
                       });
                       MotionToast.success(title: Text("Success"), description: Text('Item Added'))
            .show(context);
                       }
                       catch(e){
                        setState(() {
                          _loading=false;
                        });
                       
                        print(e);
                        
                        MotionToast.warning(title: Text("Warning"), description: Text('Somethig Went Wrong'))
            .show(context);
                       } 
                      },
                    ))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
