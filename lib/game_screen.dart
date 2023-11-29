import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/home_screen.dart';

class GameScreen extends StatefulWidget {
   String player1;
   String player2;

  GameScreen({required this.player1, required this.player2});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> board;
  late String currentPlayer;
  late String winner;
  late bool gameOver;
  
  @override
  void initState(){
    super.initState();
    board = List.generate((3), (_) => List.generate(3,(_)=>""));
    currentPlayer = "X";
    winner = "";
    gameOver = false;
}

void resetGame(){
setState(() {
  board = List.generate((3), (_) => List.generate(3,(_)=>""));
  currentPlayer = "X";
  winner = "";
  gameOver = false;
});
}

void _makeMove(int row, int col){
    if(board[row][col] != "" || gameOver){
      return;
    }

    setState(() {
      board[row][col] = currentPlayer;

      if(board[row][0] == currentPlayer && board[row][1]==currentPlayer && board[row][2]==currentPlayer){
        winner = currentPlayer;
        gameOver = true;
      }else if(board[0][col] == currentPlayer && board[1][col]==currentPlayer && board[2][col]==currentPlayer){
        winner = currentPlayer;
        gameOver = true;
      }
      else if(board[0][0] == currentPlayer && board[1][1]==currentPlayer && board[2][2]==currentPlayer){
        winner = currentPlayer;
        gameOver = true;
      }
      else if(board[0][2] == currentPlayer && board[1][1]==currentPlayer && board[2][0]==currentPlayer){
        winner = currentPlayer;
        gameOver = true;
      }

    //   Switvh Players
      currentPlayer = currentPlayer == "X" ? "O" : "X";

    //   check for tie
      if(!board.any((row) => row.any((cell) => cell == ""))){
        gameOver = true;
        winner = "It's a Tie";
      }
      if(winner != ""){
        AwesomeDialog(context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        btnOkText: "Play again",
        title: winner=="X" ? widget.player1 + "Won!" : winner == "O" ? widget.player2 + "Won!" : "It's a Tie",
          btnOkOnPress: (){
          resetGame();
          },
        )..show();
      }
    });
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF323D5B),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 70),
          SizedBox(
            height: 120,
            child: Column(
              children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Turn: ",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
                Text(currentPlayer == "X" ? widget.player1 + " ($currentPlayer) ": widget.player2 + " ($currentPlayer)",style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: currentPlayer == "X" ? Color(0xFFE25041) : Color(0xFF1CBD9E),

                ),
                ),
              ],
            ),
                SizedBox(height: 20),
            ],
          ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF5F6884),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(5),
            child: GridView.builder(
            itemCount: 9,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,), itemBuilder: (context, index){
              int row = index ~/3;
              int col = index % 3;
              return GestureDetector(
                onTap: ()=>_makeMove(row, col),
                child: Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xFF0E1E3A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(board[row][col],
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: board[row][col] == "X" ? Color(0xFFE25041) : Color(0xFF1CBD9E),
                    ),)
                  ),
                ),
              );
            } ),

          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: resetGame,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18,horizontal: 20),
                  child: Text("Reset Game",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
                ),
              ),
              InkWell(
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                    widget.player1 = "";
                    widget.player2 = "";
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18,horizontal: 20),
                  child: Text("Restart Game",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),),
                ),
              )
            ],
          )
        ],
      ),),
    );
  }
}
