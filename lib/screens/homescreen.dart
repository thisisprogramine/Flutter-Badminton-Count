import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin  {
  late double _scale;
  late AnimationController _controller;
  int player_1 = 0;
  int player_2 = 0;
  String playerOne = 'Player 1';
  String playerTwo = 'Player 2';
  String winnerName = '';
  bool _visibility = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 10,
      ),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Badminton', style: Theme.of(context).textTheme.headline5,),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  player_1 = 0;
                  player_2 = 0;
                  _visibility = false;
                });
              },
              icon: Icon(Icons.list, color: Colors.black54,)
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *0.15,
                child: Center(
                  child: Text('Match',
                    style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *0.30,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if(player_1 < 21 && player_1 >= 0) {
                              player_1++;
                            }
                            if(isWinner() == 1) {
                              winnerName = '${playerOne}';
                              _visibility = true;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          color: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showAlertDialog(context, 1);
                                  },
                                  child: Text('${playerOne}', style: Theme.of(context).textTheme.headline6,)),
                              SizedBox(height: 20,),
                              Text('${player_1}', style: Theme.of(context).textTheme.headline2, overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset('assets/vs.png', width: 40,),
                        SizedBox(height: 20,),
                        Container(
                          width: 1.0,
                          height: 50,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if(player_2 < 21 && player_2 >= 0) {
                              player_2++;
                            }
                            if(isWinner() == 2) {
                              winnerName = '${playerTwo}';
                              _visibility = true;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          color: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showAlertDialog(context, 2);
                                  },
                                  child: Text('${playerTwo}', style: Theme.of(context).textTheme.headline6,)),
                              SizedBox(height: 20,),
                              Text('${player_2}', style: Theme.of(context).textTheme.headline2, overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *0.30,
                child: FittedBox(
                  child: Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _visibility,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset('assets/win.png', width: 150,),
                        SizedBox(height: 20,),
                        Text('${winnerName} Win the match', style: Theme.of(context).textTheme.subtitle2, )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *0.03,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *0.10,
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  child: Transform.scale(
                    scale: _scale,
                    child: _animatedButtonUI,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  showAlertDialog(BuildContext context, int player) {

    // set up the button
    Widget okButton = TextButton(
      child: Text('DONE', style: Theme.of(context).textTheme.button,),
      onPressed: () {
        if(player == 1) {
          if(textEditingController.text.isNotEmpty){
            playerOne = textEditingController.text;
            textEditingController.text = '';
          }
        }else if(player == 2) {
          if(textEditingController.text.isNotEmpty) {
            playerTwo = textEditingController.text;
            textEditingController.text = '';
          }
        }
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: player == 1 ? 'Enter Player 1 Name...' : 'Enter Player 1 Name...',
          hintStyle: TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget get _animatedButtonUI => Container(
    margin: EdgeInsets.all(10.0),
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.secondary,
        ),
    child: Center(
      child: Text(
        'Save',
        style: Theme.of(context).textTheme.button,
      ),
    ),
  );

  int isWinner() {
    if(player_1 == 21){
      return 1;
    }else if(player_2 == 21){
      return 2;
    }
    return 0;
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
