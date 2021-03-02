import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName, phone, accountType, firstName, surname;

  const ProfilePage(this.userName, this.phone, this.accountType, this.firstName,
      this.surname);

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://wallpaperaccess.com/full/1558939.jpg"),
                    fit: BoxFit.cover)),
            child: Container(
              width: double.infinity,
              height: 200,
              child: Container(
                alignment: Alignment(0.0, 2.5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.pngitem.com/pimgs/m/22-220721_circled-user-male-type-user-colorful-icon-png.png"),
                  radius: 60.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Text(
            "${firstName + ' ' + surname}",
            style: TextStyle(
                fontSize: 25.0,
                color: Colors.blueGrey,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${phone}",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black45,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Account type $accountType",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.black45,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w300),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Completed",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "15",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Pending",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "20",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    ));
  }
}
