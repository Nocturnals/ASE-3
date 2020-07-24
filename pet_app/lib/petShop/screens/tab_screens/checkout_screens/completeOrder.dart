import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/petShop/model/data/cart.dart';
import 'package:pet_app/petShop/model/data/order.dart';
import 'package:pet_app/petShop/model/data/userData.dart';
import 'package:pet_app/petShop/model/notifiers/cart_notifier.dart';
import 'package:pet_app/petShop/model/notifiers/userData_notifier.dart';
import 'package:pet_app/petShop/model/services/user_management.dart';
import 'package:pet_app/petShop/screens/tab_screens/checkout_screens/addPaymentMethod.dart';
import 'package:pet_app/petShop/screens/tab_screens/checkout_screens/orderPlaced.dart';
import 'package:pet_app/petShop/utils/colors.dart';
import 'package:pet_app/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:pet_app/petShop/widgets/allWidgets.dart';
import 'package:pet_app/petShop/screens/tab_screens/checkout_screens/enterAddress.dart';

class AddressContainer extends StatefulWidget {
  final List<Cart> cartList;
  AddressContainer(this.cartList);
  @override
  _AddressContainerState createState() => _AddressContainerState(cartList);
}

class AddressScreen extends StatelessWidget {
  final List<Cart> cartList;
  AddressScreen(this.cartList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserDataAddressNotifier>(
            create: (context) => UserDataAddressNotifier(),
          ),
          ChangeNotifierProvider<CartNotifier>(
            create: (context) => CartNotifier(),
          ),
          ChangeNotifierProvider<UserDataCardNotifier>(
            create: (context) => UserDataCardNotifier(),
          ),
        ],
        child: AddressContainer(cartList),
      ),
    );
  }
}

class _AddressContainerState extends State<AddressContainer> {
  bool _isLoading = false;
  final List<Cart> cartList;
  Future addressFuture;

  Future cardFuture;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _AddressContainerState(this.cartList);

  @override
  void initState() {
    UserDataAddressNotifier addressNotifier =
        Provider.of<UserDataAddressNotifier>(context, listen: false);
    addressFuture = getAddress(addressNotifier);

    UserDataCardNotifier cardNotifier =
        Provider.of<UserDataCardNotifier>(context, listen: false);
    cardFuture = getCard(cardNotifier);

    super.initState();
  }

  void _orderTheItems(UserDataAddress address, UserDataCard cardDetails) async {
    // set the loading to true
    setState(() {
      _isLoading = true;
    });

    try {
      // get the current logged user
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      // get all the cart items
      QuerySnapshot snapshot = await Firestore.instance
          .collection('userCart')
          .document(currentUser.email)
          .collection('cartItems')
          .getDocuments();

      // convert to cartItems
      List<Cart> cartList = List<Cart>();
      for (var i = 0; i < snapshot.documents.length; i++) {
        cartList.add(Cart.fromMap(snapshot.documents[i].data));
      }

      // create a order item
      Order order = Order(
        orderItems: cartList,
        address: address,
        cardDetails: cardDetails,
        orderDate: DateTime.now(),
      );

      // save the order in the database
      DocumentReference orderDocRef = await Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .collection('orders')
          .add(order.toMap());

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OrderPlaced(),
        ),
      );
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });

      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Some error while')));
    }
  }

  @override
  Widget build(BuildContext context) {
    UserDataAddressNotifier addressNotifier =
        Provider.of<UserDataAddressNotifier>(context);
    var addressList = addressNotifier.userDataAddressList;
    UserDataCardNotifier cardNotifier =
        Provider.of<UserDataCardNotifier>(context);
    var cardList = cardNotifier.userDataCardList;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MColors.primaryWhiteSmoke,
      appBar: primaryAppBar(
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: MColors.textGrey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Text(
          "Check out",
          style: boldFont(MColors.primaryPurple, 16.0),
        ),
        MColors.primaryWhiteSmoke,
        null,
        true,
        null,
      ),
      body: primaryContainer(
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              //Address container
              Container(
                child: FutureBuilder(
                  future: addressFuture,
                  builder: (c, s) {
                    switch (s.connectionState) {
                      case ConnectionState.active:
                        return Container(
                          height: MediaQuery.of(context).size.height / 7,
                          child: Center(
                              child: progressIndicator(MColors.primaryPurple)),
                        );
                        break;
                      case ConnectionState.done:
                        return addressList.isEmpty
                            ? noSavedAddress()
                            : savedAddressWidget();
                        break;
                      case ConnectionState.waiting:
                        return Container(
                          height: MediaQuery.of(context).size.height / 7,
                          child: Center(
                              child: progressIndicator(MColors.primaryPurple)),
                        );
                        break;
                      default:
                        return Container(
                          height: MediaQuery.of(context).size.height / 7,
                          child: Center(
                              child: progressIndicator(MColors.primaryPurple)),
                        );
                    }
                  },
                ),
              ),

              SizedBox(
                height: 20.0,
              ),

              //Cart summary container
              Container(
                child: cartSummary(cartList),
              ),

              SizedBox(
                height: 20.0,
              ),

              //Payment Container
              Container(
                child: FutureBuilder(
                  future: cardFuture,
                  builder: (c, s) {
                    switch (s.connectionState) {
                      case ConnectionState.active:
                        return Container(
                          height: MediaQuery.of(context).size.height / 7,
                          child: Center(
                              child: progressIndicator(MColors.primaryPurple)),
                        );
                        break;
                      case ConnectionState.done:
                        return cardList.isEmpty
                            ? noPaymentMethod()
                            : savedPaymentMethod();
                        break;
                      case ConnectionState.waiting:
                        return Container(
                          height: MediaQuery.of(context).size.height / 7,
                          child: Center(
                              child: progressIndicator(MColors.primaryPurple)),
                        );
                        break;
                      default:
                        return Container(
                          height: MediaQuery.of(context).size.height / 7,
                          child: Center(
                              child: progressIndicator(MColors.primaryPurple)),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isLoading
          ? Container(height: 90, width: 90, child: Loader())
          : Container(
              color: MColors.primaryWhite,
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
              child: primaryButtonPurple(
                Text(
                  "Place order",
                  style: boldFont(MColors.primaryWhite, 16.0),
                ),
                () async {
                  addressList.isEmpty || cardList.isEmpty
                      ? showSimpleSnack(
                          'Please complete shipping and card details',
                          Icons.error_outline,
                          Colors.amber,
                          _scaffoldKey,
                        )
                      : _orderTheItems(addressList.first, cardList.first);
                },
              ),
            ),
    );
  }

  Widget savedAddressWidget() {
    UserDataAddressNotifier addressNotifier =
        Provider.of<UserDataAddressNotifier>(context);
    var addressList = addressNotifier.userDataAddressList;
    var address = addressList.first;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: MColors.primaryWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  "assets/images/icons/Location.svg",
                  color: MColors.primaryPurple,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Shipping address",
                    style: normalFont(MColors.textGrey, 14.0),
                  ),
                ),
              ),
              Container(
                width: 60.0,
                height: 25.0,
                child: RawMaterialButton(
                  onPressed: () async {
                    UserDataAddressNotifier addressNotifier =
                        Provider.of<UserDataAddressNotifier>(context,
                            listen: false);
                    var navigationResult = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Address(address, addressList),
                      ),
                    );
                    if (navigationResult == true) {
                      setState(() {
                        getAddress(addressNotifier);
                      });
                      showSimpleSnack(
                        "Address has been updated",
                        Icons.check_circle_outline,
                        Colors.green,
                        _scaffoldKey,
                      );
                    }
                  },
                  child: Text(
                    "Change",
                    style: boldFont(MColors.primaryPurple, 14.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    address.fullLegalName,
                    style: boldFont(MColors.textDark, 16.0),
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  child: Text(
                    address.addressNumber + ", " + address.addressLocation,
                    style: normalFont(MColors.textGrey, 14.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget noSavedAddress() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: MColors.primaryWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  "assets/images/icons/Location.svg",
                  color: MColors.primaryPurple,
                ),
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: Container(
                  child: Text(
                    "Shipping address",
                    style: normalFont(MColors.textGrey, 14.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.only(
              left: 25.0,
            ),
            child: Text(
              "No shipping address added to this  account",
              style: normalFont(MColors.textGrey, 16.0),
            ),
          ),
          SizedBox(height: 10.0),
          primaryButtonWhiteSmoke(
            Text("Add a shipping address",
                style: boldFont(MColors.primaryPurple, 16.0)),
            () async {
              UserDataAddressNotifier addressNotifier =
                  Provider.of<UserDataAddressNotifier>(context, listen: false);
              var navigationResult = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Address(null, null),
                ),
              );
              if (navigationResult == true) {
                setState(() {
                  getAddress(addressNotifier);
                });
                showSimpleSnack(
                  "Address has been updated",
                  Icons.check_circle_outline,
                  Colors.green,
                  _scaffoldKey,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget cartSummary(cartList) {
    var totalList = cartList.map((e) => e.totalPrice);
    var total = totalList.isEmpty
        ? 0.0
        : totalList.reduce((sum, element) => sum + element).toStringAsFixed(2);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: MColors.primaryWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  "assets/images/icons/Bag.svg",
                  color: MColors.primaryPurple,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Bag summary",
                    style: normalFont(MColors.textGrey, 14.0),
                  ),
                ),
              ),
              Container(
                width: 50.0,
                height: 25.0,
                child: RawMaterialButton(
                  onPressed: () {
                    _showModalSheet(cartList, total);
                  },
                  child: Text(
                    "See all",
                    style: boldFont(MColors.primaryPurple, 14.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Container(
            padding: EdgeInsets.only(left: 25.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: cartList.length < 7 ? cartList.length : 7,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                var cartItem = cartList[i];

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: Text(cartItem.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: normalFont(MColors.textGrey, 14.0)),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                            "₹ " + cartItem.totalPrice.toStringAsFixed(2),
                            style: boldFont(MColors.textDark, 14.0)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            padding: EdgeInsets.only(left: 25),
            child: Row(
              children: <Widget>[
                Text("Total", style: boldFont(MColors.primaryPurple, 16.0)),
                Spacer(),
                Text("₹ " + total,
                    style: boldFont(MColors.primaryPurple, 16.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget savedPaymentMethod() {
    UserDataCardNotifier cardNotifier =
        Provider.of<UserDataCardNotifier>(context);
    var cardList = cardNotifier.userDataCardList;
    var card = cardList.first;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: MColors.primaryWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  "assets/images/icons/Wallet.svg",
                  color: MColors.primaryPurple,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Payment method",
                    style: normalFont(MColors.textGrey, 14.0),
                  ),
                ),
              ),
              Container(
                width: 60.0,
                height: 25.0,
                child: RawMaterialButton(
                  onPressed: () async {
                    UserDataCardNotifier cardNotifier =
                        Provider.of<UserDataCardNotifier>(context,
                            listen: false);

                    var navigationResult = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddNewCard(card, cardList),
                      ),
                    );
                    if (navigationResult == true) {
                      setState(() {
                        getCard(cardNotifier);
                      });
                      showSimpleSnack(
                        "Card has been updated",
                        Icons.check_circle_outline,
                        Colors.green,
                        _scaffoldKey,
                      );
                    }
                  },
                  child: Text("Change",
                      style: boldFont(MColors.primaryPurple, 14.0)),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    card.cardHolder,
                    style: boldFont(MColors.textDark, 16.0),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "•••• •••• •••• " +
                            card.cardNumber
                                .substring(card.cardNumber.length - 4),
                        style: normalFont(MColors.textGrey, 16.0),
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: SvgPicture.asset(
                        "assets/images/mastercard.svg",
                        height: 30.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget noPaymentMethod() {
    UserDataCardNotifier cardNotifier =
        Provider.of<UserDataCardNotifier>(context);
    var cardList = cardNotifier.userDataCardList;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: MColors.primaryWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  "assets/images/icons/Wallet.svg",
                  color: MColors.primaryPurple,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Payment method",
                    style: normalFont(MColors.textGrey, 14.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              "No payment method added to this account",
              style: normalFont(MColors.textGrey, 16.0),
            ),
          ),
          SizedBox(height: 10.0),
          primaryButtonWhiteSmoke(
            Text("Add a payment method",
                style: boldFont(MColors.primaryPurple, 16.0)),
            () async {
              var navigationResult = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddNewCard(null, cardList),
                ),
              );
              if (navigationResult == true) {
                setState(() {
                  getCard(cardNotifier);
                });
                showSimpleSnack(
                  "Card has been updated",
                  Icons.check_circle_outline,
                  Colors.green,
                  _scaffoldKey,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  //Payment method
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
                        "Bag summary",
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
}
