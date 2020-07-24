import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/petShop/model/data/cart.dart';
import 'package:pet_app/petShop/model/data/order.dart';
import 'package:pet_app/petShop/utils/colors.dart';
import 'package:pet_app/petShop/widgets/allWidgets.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = false;
  List<Order> ordersList;

  @override
  void initState() {
    getTheUserOrders();
    super.initState();
  }

  void getTheUserOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // get the current user
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      // get the orders documents
      QuerySnapshot snapshot = await Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .collection('orders')
          .getDocuments();

      // generate the list of orders
      ordersList = List<Order>();
      for (var i = 0; i < snapshot.documents.length; i++) {
        ordersList.add(Order.fromMap(snapshot.documents[i].data));
      }

      print(ordersList.length);
    } catch (e) {
      print(e);
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Error retriving order")));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showModalSheet(cartList, total) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          padding: EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height,
          color: MColors.primaryWhiteSmoke,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Order summary",
                        style: boldFont(MColors.textGrey, 16.0),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      child: SvgPicture.asset(
                        "assets/images/icons/Bag.svg",
                        color: MColors.primaryPurple,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "₹ " + total,
                      style: boldFont(MColors.primaryPurple, 16.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: ListView.builder(
                    itemCount: cartList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      var cartItem = cartList[i];

                      return Container(
                        decoration: BoxDecoration(
                          color: MColors.primaryWhite,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        padding: EdgeInsets.all(7.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30.0,
                              height: 40.0,
                              child: FadeInImage.assetNetwork(
                                image: cartItem.productImage,
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height,
                                placeholder: "assets/images/placeholder.jpg",
                                placeholderScale:
                                    MediaQuery.of(context).size.height / 2,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                cartItem.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: normalFont(MColors.textGrey, 14.0),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color: MColors.dashPurple,
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "X${cartItem.quantity}",
                                style: normalFont(MColors.textGrey, 14.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "₹" + cartItem.totalPrice.toStringAsFixed(2),
                                style: boldFont(MColors.textDark, 14.0),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return primaryContainer(
      Center(
        child: _isLoading || ordersList.isEmpty
            ? SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: SvgPicture.asset(
                      "assets/images/noHistory.svg",
                      height: 150,
                    ),
                  ),
                  Container(
                    child: Text(
                      "No history",
                      style: boldFont(MColors.textDark, 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: Text(
                      "Your past orders, transactions and hires will show up here.",
                      style: normalFont(MColors.textGrey, 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ))
            : ListView.builder(
                itemCount: ordersList.length,
                itemBuilder: (BuildContext context, int index) {
                  Order order = ordersList[index];
                  var totalList = order.orderItems.map((e) => e.totalPrice);
                  var total = totalList.isEmpty
                      ? 0.0
                      : totalList
                          .reduce((sum, element) => sum + element)
                          .toStringAsFixed(2);
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    height: 200.0,
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: MColors.primaryWhite,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            width: 80.0,
                            child: FadeInImage.assetNetwork(
                              image: order.orderItems[0].productImage,
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height,
                              placeholder: "assets/images/placeholder.jpg",
                              placeholderScale:
                                  MediaQuery.of(context).size.height / 2,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    order.orderItems[0].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: normalFont(MColors.textDark, 16.0),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  child: Text(
                                    'Address',
                                    style: boldFont(MColors.primaryPurple, 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    order.address.addressLocation,
                                    style: boldFont(MColors.primaryPurple, 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),

                                // date widget
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: MColors.primaryPurple,
                                      ),
                                      Text(
                                          ' ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),

                          Container(
                            child: Column(
                              children: [
                                // price text
                                Text(
                                  'Paid',
                                  style: TextStyle(
                                    color: MColors.primaryPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '₹ $total',
                                  style: TextStyle(
                                    color: MColors.primaryPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Expanded(child: Container()),
                                InkWell(
                                  onTap: () {
                                    _showModalSheet(order.orderItems, total);
                                  },
                                  child: Text(
                                    'see all',
                                    style: TextStyle(
                                      color: MColors.primaryPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Builder(
                          //   builder: (context) {
                          //     CartNotifier cartNotifier =
                          //         Provider.of<CartNotifier>(context,
                          //             listen: false);

                          //     return Container(
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: <Widget>[
                          //           Container(
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   new BorderRadius.circular(10.0),
                          //               color: MColors.primaryPurple,
                          //             ),
                          //             height: 34.0,
                          //             width: 34.0,
                          //             child: RawMaterialButton(
                          //               onPressed: () {
                          //                 addAndApdateData(cartItem);
                          //                 getCart(cartNotifier);
                          //               },
                          //               child: Icon(
                          //                 Icons.add,
                          //                 color: MColors.primaryWhiteSmoke,
                          //                 size: 24.0,
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //             padding: const EdgeInsets.all(5.0),
                          //             child: Center(
                          //               child: Text(
                          //                 cartItem.quantity.toString(),
                          //                 style: normalFont(
                          //                     MColors.textDark, 18.0),
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   new BorderRadius.circular(10.0),
                          //               color: MColors.primaryWhiteSmoke,
                          //             ),
                          //             width: 34.0,
                          //             height: 34.0,
                          //             child: RawMaterialButton(
                          //               onPressed: () {
                          //                 subAndApdateData(cartItem);
                          //                 getCart(cartNotifier);
                          //               },
                          //               child: Icon(
                          //                 Icons.remove,
                          //                 color: MColors.primaryPurple,
                          //                 size: 30.0,
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
