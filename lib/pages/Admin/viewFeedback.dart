import 'package:flutter/material.dart';
import '../../api/feedbackApi.dart';
import '../../dialogs/custom_dialog_box.dart';

class FeedbackDetails extends StatefulWidget {
  const FeedbackDetails({Key? key}) : super(key: key);
  @override
  _FeedbackDetailsState createState() => _FeedbackDetailsState();
}
class _FeedbackDetailsState extends State<FeedbackDetails> {

  late Database db;
  List docs =[];

  initialise(){
    db=Database();
    db.initiliase();
    db.readFeedbackDetails().then((value) =>{
      setState((){
        docs=value;
      })
    } );
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text('Received Feedback '),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Image.asset(
          //   'assets/images/5.webp',
          //   fit: BoxFit.cover,
          //   height: double.infinity,
          //   width: double.infinity,
          // ),
          // Container(
          //   color: Colors.black.withOpacity(0.8),
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          Container(
            child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (BuildContext context, int index){
                  return Card(
                      color: Colors.grey,
                      margin: EdgeInsets.all(10),
                    child :Column(

                      children: [
                         ListTile(

                          onTap: (){},
                          contentPadding: EdgeInsets.only(right:30,left:36,top:10),
                          title: Text('user name :'+docs[index]['email']),
                          subtitle: Padding(
                            padding: const  EdgeInsets.only(top:10),
                            child: Text('asd by Julie Gable. Lyrics by Sidney Stein. asd by Julie Gable. Lyrics by Sidney Stein. asd by Julie Gable. Lyrics by Sidney Stein. asd by Julie Gable. Lyrics by Sidney Stein. asd by Julie Gable. Lyrics by Sidney Stein.'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: const Text('Delete',style: TextStyle(color: Colors.red),),
                              onPressed: () {
                                db.delete(docs[index]['id']);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomDialogBox(
                                        title: "Feedback Deleted !",
                                        descriptions: "Feedback deleted successfully!",
                                        text: "Yes",
                                      );
                                    }).whenComplete(() => Navigator.of(context).push(MaterialPageRoute( builder: (context) => const FeedbackDetails())));
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}
