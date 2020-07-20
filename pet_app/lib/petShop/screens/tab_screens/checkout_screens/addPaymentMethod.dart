import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_app/petShop/model/data/userData.dart';
import 'package:pet_app/petShop/model/services/user_management.dart';
import 'package:pet_app/petShop/utils/colors.dart';
import 'package:pet_app/petShop/utils/cardUtils/payment_card.dart';
import 'package:pet_app/petShop/utils/cardUtils/input_formatter.dart';
import 'package:pet_app/petShop/utils/cardUtils/cardStrings.dart';
import 'package:pet_app/petShop/widgets/allWidgets.dart';

class AddNewCard extends StatefulWidget {
  final UserDataCard card;
  final List<UserDataCard> cardList;

  AddNewCard(this.card, this.cardList);

  @override
  _AddNewCardState createState() => _AddNewCardState(card, cardList);
}

class _AddNewCardState extends State<AddNewCard> {
  final UserDataCard card;
  final List<UserDataCard> cardList;

  _AddNewCardState(this.card, this.cardList);

  String cardHolder;
  String cardNumber;
  String validThrough;
  String securityCode;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  var numberController = TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;

  @override
  void initState() {
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
          "Add Card",
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
          child: Form(
            autovalidate: _autoValidate,
            key: formKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Card holder",
                        style: normalFont(MColors.textGrey, null),
                      ),
                      SizedBox(height: 5.0),
                      primaryTextField(
                        null,
                        cardList.isEmpty ? "" : card.cardHolder,
                        "",
                        (val) => cardHolder = val,
                        true,
                        (String value) =>
                            value.isEmpty ? Strings.fieldReq : null,
                        false,
                        _autoValidate,
                        false,
                        TextInputType.text,
                        null,
                        null,
                        0.50,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Card number",
                        style: normalFont(MColors.textGrey, null),
                      ),
                      SizedBox(height: 5.0),
                      primaryTextField(
                        numberController,
                        cardList.isEmpty ? null : null,
                        "",
                        (val) => cardNumber = val,
                        true,
                        CardUtils.validateCardNum,
                        false,
                        _autoValidate,
                        false,
                        TextInputType.number,
                        <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(19),
                          CardNumberInputFormatter(),
                        ],
                        CardUtils.getCardIcon(_paymentCard.type),
                        0.50,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Valid through",
                              style: normalFont(MColors.textGrey, null),
                            ),
                            SizedBox(height: 5.0),
                            primaryTextField(
                              null,
                              cardList.isEmpty ? null : null,
                              "",
                              (val) => validThrough = val,
                              true,
                              CardUtils.validateDate,
                              false,
                              _autoValidate,
                              false,
                              TextInputType.number,
                              <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                CardMonthInputFormatter(),
                              ],
                              null,
                              0.50,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "CVV",
                              style: normalFont(MColors.textGrey, null),
                            ),
                            SizedBox(height: 5.0),
                            primaryTextField(
                              null,
                              cardList.isEmpty ? null : null,
                              "",
                              (val) => securityCode = val,
                              true,
                              CardUtils.validateCVV,
                              false,
                              _autoValidate,
                              false,
                              TextInputType.number,
                              <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              null,
                              0.50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  primaryButtonPurple(
                    Text("Save card",
                        style: normalFont(MColors.primaryWhite, 16.0)),
                    () {
                      _validateInputs();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: warningWidget(),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      showSimpleSnack("Please fix the errors", Icons.error_outline,
          Colors.redAccent, scaffoldKey);
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway

      cardList.isEmpty
          ? storeNewCard(
              cardHolder,
              cardNumber,
              validThrough,
              securityCode,
            )
          : updateCard(
              cardHolder,
              cardNumber,
              validThrough,
              securityCode,
            );
      Navigator.pop(context, true);
    }
  }
}
