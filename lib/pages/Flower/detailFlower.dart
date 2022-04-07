
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../feedback/addfeedback.dart';



class DetailProduct extends StatefulWidget {

  final detail_prod_name;
  final detail_prod_picture;
  final detail_description;
  final detail_time;

  DetailProduct({
    this.detail_prod_name,
    this.detail_prod_picture,
    this.detail_description,
    this.detail_time,
  });

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text(widget.detail_prod_name+' Flower'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            height: 350.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child:  Image.network(widget.detail_prod_picture,fit: BoxFit.cover,),
              ),

            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        widget.detail_description,
                        textAlign: TextAlign.left,

                        style: TextStyle(

                            height: 1.8,
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.9)),
                      ),

                    ]),
              )),
          // const Padding(
          //   padding: EdgeInsets.fromLTRB(0,20,0,0),
          //   child: ListTile(
          //     title: Padding(
          //       padding: EdgeInsets.fromLTRB(0,10,0,10),
          //       child: Text('product Detail'),
          //     ),
          //     subtitle: Text(
          //         'The rose is a type of flowse grow in many different colors,'
          //         ' ny different colors, from  lowse grow in many different colors, ny different colors,'
          //         ' from the well-known The flowers of the ro the well-known The flowers of the rose grow '
          //         'in many differenfrom the well-known The flowers of the rose grow in many different colors'
          //         ', from the well-known red rose or yellow rose and sometimes white or purple rose. Roses belong '
          //         'to the family of plants called Rosaceae.'),
          //   ),
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.only(top: 0.0),
          //           child: MaterialButton(
          //             height: 62.0,
          //             onPressed: (){
          //               Navigator.of(context).push(MaterialPageRoute(
          //                   builder: (context) =>  Feedbackpage()
          //               ));
          //             },
          //             color: Colors.green.shade700,
          //             textColor: Colors.white,
          //             elevation: 0.2,
          //             child: Text('Provide a Feedback'),
          //           ),
          //         )
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
