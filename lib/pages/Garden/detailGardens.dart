import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flower/pages/feedback/addfeedback.dart';
class DetailGarden extends StatefulWidget {
  final productId;
  final name;
  final picture;
  final location;
  final time;
  final ticket;

  DetailGarden({
    this.productId,
    this.name,
    this.picture,
    this.location,
    this.time,
    this.ticket
  });
  @override
  _DetailGardenState createState() => _DetailGardenState();
}

class _DetailGardenState extends State<DetailGarden> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text(widget.name+' Garden'),
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
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child:  Image.network(widget.picture,fit: BoxFit.cover,),
              ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                       Text(
                      'Location : '+widget.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.black.withOpacity(0.9)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                       'Opening Hours : '+widget.time,
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.black.withOpacity(0.8)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                       'Ticket Price : '+widget.ticket,
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w400,

                            color: Colors.black.withOpacity(0.8)),
                      )
                    ]),
              )),
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 90.0),
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>  Feedbackpage()
                        ));
                      },
                      color: Colors.green.shade700,
                      textColor: Colors.white,
                      elevation: 0.2,
                      child: Text('Provide a Feedback'),
                    ),
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}
