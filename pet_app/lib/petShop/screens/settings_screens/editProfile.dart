import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/petShop/model/data/userData.dart';
import 'package:pet_app/petShop/model/services/user_management.dart';
import 'package:pet_app/petShop/utils/cardUtils/cardStrings.dart';
import 'package:pet_app/petShop/utils/colors.dart';
import 'package:pet_app/petShop/utils/textFieldFormaters.dart';
import 'package:pet_app/petShop/widgets/allWidgets.dart';

class EditProfile extends StatefulWidget {
  final UserDataProfile user;
  EditProfile(this.user);

  @override
  _EditProfileState createState() => _EditProfileState(user);
}

class _EditProfileState extends State<EditProfile> {
  UserDataProfile user;

  _EditProfileState(this.user);
  Future profileFuture;

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _name;
  String _phone;
  String _error;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
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
          "Profile",
          style: boldFont(MColors.primaryPurple, 16.0),
        ),
        MColors.primaryWhiteSmoke,
        null,
        true,
        <Widget>[
          FlatButton(
            onPressed: () {
              _submit();
            },
            child: Text(
              "Save",
              style: boldFont(MColors.primaryPurple, 16.0),
            ),
          )
        ],
      ),
      body: primaryContainer(
        SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Container(
                    width: 90.0,
                    height: 90.0,
                    child: SvgPicture.asset(
                      "assets/images/femaleAvatar.svg",
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: MColors.dashPurple,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Full name",
                            style: normalFont(MColors.textGrey, null),
                          ),
                          SizedBox(height: 5.0),
                          primaryTextField(
                            null,
                            user.name,
                            "",
                            (val) => _name = val,
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
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Email",
                            style: normalFont(MColors.textGrey, null),
                          ),
                          SizedBox(height: 5.0),
                          primaryTextField(
                            null,
                            user.email,
                            "",
                            null,
                            false,
                            null,
                            false,
                            _autoValidate,
                            false,
                            null,
                            null,
                            null,
                            0.50,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Phone",
                            style: normalFont(MColors.textGrey, null),
                          ),
                          SizedBox(height: 5.0),
                          primaryTextField(
                            null,
                            user.phone,
                            "",
                            (val) => _phone = val,
                            true,
                            (String value) =>
                                value.isEmpty ? Strings.fieldReq : null,
                            false,
                            _autoValidate,
                            true,
                            TextInputType.phone,
                            [maskTextInputFormatter],
                            null,
                            0.50,
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
      ),
    );
  }

  void _submit() async {
    final form = formKey.currentState;

    try {
      if (form.validate()) {
        form.save();
        updateProfile(_name, _phone);
        Navigator.pop(context, true);
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.message;
      });
      print(_error);
    }
  }
}
