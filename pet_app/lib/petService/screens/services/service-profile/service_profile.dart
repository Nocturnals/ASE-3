import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/petService/model/service.dart';
import 'package:pet_app/petService/model/user.dart';
import 'package:pet_app/petService/screens/home/chat/chat_page.dart';
import 'package:pet_app/petService/screens/home/home_page.dart';
import 'package:pet_app/petService/screens/services/add-edit-service/add-edit_service_page.dart';
import 'package:pet_app/petService/screens/services/my-services/my_services_page.dart';
import 'package:pet_app/petService/services/auth/auth_service.dart';
import 'package:pet_app/petService/services/chat/chat_service.dart';
import 'package:pet_app/petService/services/services.dart';
import 'package:pet_app/petService/services/services/services_service.dart';
import 'package:pet_app/petService/services/user/user_service.dart';

class ServiceProfile extends StatelessWidget {
  static final String routeName = '/service-profile';
  Service displayedService;
  final _chatService = services.get<ChatService>();

  @override
  Widget build(BuildContext context) {
    displayedService = ModalRoute.of(context).settings.arguments;

    final currentUserId = services.get<AuthService>().currentUserUid;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(displayedService.name),
          actions: currentUserId == displayedService.ownerId
              ? actionsForOwner(context)
              : actionsForVisitor(context),
        ),
        body: SafeArea(
            child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  displayPetPicture(context),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Color(0x86FCBA94),
                          child: ListTile(
                            title: Text(
                              displayedService.serviceCategory,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              ListTile(
                title: Text(
                  displayedService.description,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
              ),
              ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(
                    "Address: " + displayedService.address,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ))
            ],
          ),
        )));
  }

  actionsForVisitor(BuildContext context) {
    return <Widget>[
      IconButton(
        padding: EdgeInsets.all(20),
        icon: Icon(Icons.chat, color: Colors.white),
        onPressed: () => startChat(context),
      )
    ];
  }

  startChat(BuildContext context) async {
    final serviceOwner =
        await services.get<UserService>().getUser(displayedService.ownerId);
    _chatService.sendMessage(serviceOwner.uid,
        "Hi, ${serviceOwner.username}! I'm interested in ${displayedService.name}.");
    Navigator.of(context)
        .pushNamed(ChatPage.routeName, arguments: serviceOwner);
  }

  actionsForOwner(BuildContext context) {
    return <Widget>[
      IconButton(
        padding: EdgeInsets.all(20),
        icon: Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed(AddEditServicePage.routeName,
              arguments: displayedService);
        },
      ),
      IconButton(
          padding: EdgeInsets.all(20),
          icon: Icon(Icons.delete, color: Colors.white),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return confirmDeleteDialog(context);
                });
          }),
    ];
  }

  backgroundAlignForImage(MaterialColor color, Alignment beginAlign,
      Alignment endAlign, double height, double topPadding) {
    return Align(
      alignment: beginAlign,
      child: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: beginAlign,
              end: endAlign,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.7),
                color.withOpacity(0.6),
                color.withOpacity(0.5),
                color.withOpacity(0.4),
                color.withOpacity(0.3),
                color.withOpacity(0.2),
                color.withOpacity(0.1),
                color.withOpacity(0.05),
                color.withOpacity(0.025),
              ],
            ),
          ),
          child: Padding(
              padding: EdgeInsets.only(top: topPadding), child: Container())),
    );
  }

  FadeInImage displayPetPicture(BuildContext context) {
    return FadeInImage(
        image: displayedService.pictureUrl.isEmpty
            ? AssetImage("assets/blank_services.png")
            : NetworkImage(displayedService.pictureUrl),
        height: 300,
        width: MediaQuery.of(context).size.width,
        placeholder: AssetImage('assets/blank_services.png'));
  }

  petOwnerProfilePicture() {
    return FutureBuilder<User>(
        future: services.get<UserService>().getUser(displayedService.ownerId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final User owner = snapshot.data;
            return GestureDetector(
                child: CircleAvatar(
                    minRadius: 20,
                    backgroundImage: owner.pictureUrl.isNotEmpty
                        ? NetworkImage(owner.pictureUrl)
                        : AssetImage('assets/blank_profile.png')),
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      HomePage
                          .routeName); // must be changed in order to redirect to the owner's profile
                });
          }
          return CircleAvatar(
              minRadius: 20,
              backgroundImage: AssetImage('assets/blank_profile.png'));
        });
  }

  deleteService(BuildContext context, String serviceId) async {
    final ServicesService servicesService = services.get<ServicesService>();
    await servicesService.deleteService(serviceId);
    Navigator.pushNamedAndRemoveUntil(context, MyServicesPage.routeName,
        ModalRoute.withName(HomePage.routeName));
  }

  AlertDialog confirmDeleteDialog(BuildContext context) {
    return AlertDialog(
      content: Text(
        'Are you sure you want to remove this service?',
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No')),
        FlatButton(
            onPressed: () {
              deleteService(context, displayedService.id);
            },
            child: Text('Yes')),
      ],
    );
  }
}
