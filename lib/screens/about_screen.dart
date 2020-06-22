import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about-screen';

  _launchUrl() async {
    const url = "https://github.com/ShashankBiplav/eCommerceAppFlutter";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                    'https://scontent.fpat1-1.fna.fbcdn.net/v/t1.0-9/66063887_2253939574703396_9159168138409934848_o.jpg?_nc_cat=102&_nc_sid=7aed08&_nc_ohc=Cni7nF5cVf4AX-cgW4u&_nc_ht=scontent.fpat1-1.fna&oh=540e25f3be09d588e2132a79b8623185&oe=5F15112B'),
              ),
              Text(
                'Shashank Biplav',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'FULL STACK DEVELOPER',
                style: TextStyle(
                  fontFamily: 'Anton',
                  fontSize: 20.0,
                  letterSpacing: 2.5,
                  color: Colors.teal.shade100,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.teal,
                  ),
                  title: Text(
                    '+91 7004026852',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Anton',
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'shashankbiplav@gmail.com',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Anton',
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Text(
                  'This is an eCommerce app built on Flutter and the backend is on Firebase. It features full backend and frontend integrations. The app works on API endpoints. Here you can place orders, CRUD products and everything works on per user basis. This project repository is also available on my Github Profile:',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 15.0,
                    letterSpacing: 2.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                  onPressed: _launchUrl,
                  child: Container(
                    margin: EdgeInsets.all(13),
                    child: Text(
                      'Go to Repository',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Anton',
                        color: Colors.teal.shade900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
