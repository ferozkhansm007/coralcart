import 'package:coralcart/services/firebase_review_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:motion_toast/motion_toast.dart';

class ViewProductScreen extends StatefulWidget {
   ViewProductScreen({Key? key, required this.viewdata, required this.productId}) : super(key: key);

  final Map<String, dynamic> viewdata;
  final String productId;

  @override
  State<ViewProductScreen> createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  final reviewController=TextEditingController();

  double totalrating=1.0;

  bool _loading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Section: Image and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  widget.viewdata[
                      'image'], // Replace with your image URL, // Replace with your image path
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.viewdata['productname'],
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.viewdata['price'], // Replace with your price
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.viewdata['discription'],
                            maxLines: 10,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Reviews',
                            maxLines: 10,
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(
                            height: 200, // Adjust height as needed
                            child: ListView.builder(
                              itemCount: 5, // Replace with actual number of reviews
                              itemBuilder: (context, index) {
                                // Replace these with actual review data
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text((index + 1).toString()),
                                  ),
                                  title: Text('User ${index + 1}'),
                                  subtitle: Text(
                                      'This is the review from user ${index + 1}.'),
                                  trailing: RatingBarIndicator(
                                    rating: 3.5, // Replace with actual rating
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
       
          // Bottom Section: Button
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rate this product',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: RatingBar.builder(
                            wrapAlignment: WrapAlignment.spaceBetween,
                            initialRating: 1,
                            itemCount: 5,
                            
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return const Icon(
                                    Icons.sentiment_very_dissatisfied,
                                    color: Colors.red,
                                    size: 50,
                                  );
                                case 1:
                                  return const Icon(
                                    Icons.sentiment_dissatisfied,
                                    color: Colors.redAccent,
                                  );
                                case 2:
                                  return const Icon(
                                    Icons.sentiment_neutral,
                                    color: Colors.amber,
                                  );
                                case 3:
                                  return const Icon(
                                    Icons.sentiment_satisfied,
                                    color: Colors.lightGreen,
                                  );
                                case 4:
                                  return const Icon(
                                    Icons.sentiment_very_satisfied,
                                    color: Colors.green,
                                  );
                                default:
                                  return const Icon(
                                    Icons.sentiment_very_satisfied,
                                    color: Colors.green,
                                  );
                              }
                            },
                            onRatingUpdate: (rating) {
                              totalrating = rating;
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Share Your Thoughts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                         TextField(
                        
                          maxLines: 6,
                          controller: reviewController,
                          decoration: InputDecoration(
                            hintText: 'Write your review here...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const Spacer(),
                       _loading? Center(
                        child: CircularProgressIndicator(color: Colors.teal,),

                       ):
                         SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                             try{

                              if(reviewController.text.isNotEmpty){

                                setState(() {
                                  _loading=true;
                                });

                                await FirebaseReviewService().storeReview(
                                productId: widget.productId, 
                                sellerId: widget.viewdata['sellerId'], rating: totalrating, review: reviewController.text);
                             Navigator.pop(context);
                             setState(() {
                                  _loading=false;
                                });
                             
                              }else{
                                 setState(() {
                                  _loading=false;
                                });
                             

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Add the review'),),);
                              }

                             }catch(e){
                               setState(() {
                                  _loading=false;
                                });
                             
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Somthing went wrongP'),),);



                             }
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.teal,
                                
                                ),
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal, // Text color
              ),
              child: const Text('Add Your Review'),
            ),
          ),
        ],
      ),
    );
  }
}
