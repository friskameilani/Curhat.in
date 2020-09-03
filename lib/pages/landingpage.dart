import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LandingPage extends StatefulWidget {
  LandingPage() : super();

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {

  CarouselSlider carouselSlider;
  int _current = 0;
  List imgList = [
    'assets/images/image-landing-page.png',
    'assets/images/image-landing-page-2.png'
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(right: 30, top: 50, bottom: 100),
            child:
                (_current == imgList.length-1) ?
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/welcome');
                  },
                  child: Container(
                    child: Text("Mulai", style: TextStyle(fontWeight: FontWeight.w800),),),
                ) : InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/welcome');
                  },
                  child: Container(
                    child: Text("Lewati", style: TextStyle(fontWeight: FontWeight.w800),),),)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              carouselSlider = CarouselSlider(
                height: 400.0,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: false,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
                items: imgList.map((imgUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Image.asset(
                          imgUrl,
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  child:
                  (_current == 0) ?
                      Column(
                        children: [
                          Text("Konsultasi, Yuk!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 20,)),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Buat akun mu dan aplikasi Curhat.in akan\n"
                              " menjadi media untuk kamu berkonsultasi.", textAlign: TextAlign.center,)
                        ],
                      ) : Column(
                    children: [
                      Text("Chat Bersama Konselor",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Konsultasi bersama konselor spesialis,\n"
                          "kapan pun, di mana pun.", textAlign: TextAlign.center)
                    ],
                  )
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(imgList, (index, url) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index ? Color(0xFF17B7BD) : Colors.grey,
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}