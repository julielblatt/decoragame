import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(DecoraApp());
}

class DecoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decora Game',
      home: DecoraGame(),
    );
  }
}

class DecoraGame extends StatefulWidget {
  @override
  DecoraGameState createState() => DecoraGameState();
}

class DecoraGameState extends State<DecoraGame> {
  List<Color> buttonColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
  ];
  List<Color> buttonOriginalColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
  ];
  List<int> sequence = [];
  int currentIndex = 0;
  bool canPressButton = false;
  bool gameOver = false;
  bool isGameStarted = false;
  int roundCount = 0;
  int maxRoundCount =
      0; // Variável para armazenar o maior número de rodadas alcançadas

  @override
  void initState() {
    super.initState();
  }

  void startGame() {
    gameOver = false;
    sequence.clear();
    currentIndex = 0;
    roundCount = 0;
    generateNextSequence();
    playSequence();
  }

  void generateNextSequence() {
    Random random = Random();
    int nextColorIndex = random.nextInt(4);
    sequence.add(nextColorIndex);
    roundCount++;

    // Atualiza o maior número de rodadas alcançadas
    if (roundCount > maxRoundCount) {
      maxRoundCount = roundCount;
    }
  }

  void playSequence() {
    canPressButton = false;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentIndex >= sequence.length) {
        setState(() {
          currentIndex = 0;
          canPressButton = true;
        });
        timer.cancel();
        return;
      }

      int buttonIndex = sequence[currentIndex];
      highlightButton(buttonIndex);

      currentIndex++;
    });
  }

  void highlightButton(int index) {
    Timer(Duration(milliseconds: 500), () {
      if (!gameOver) {
        setState(() {
          buttonColors[index] = getBrighterColor(buttonOriginalColors[index]);
        });
      }
    });

    Timer(Duration(milliseconds: 1000), () {
      if (!gameOver) {
        setState(() {
          buttonColors[index] = buttonOriginalColors[index];
        });
      }
    });
  }

  Color getBrighterColor(Color color) {
    double correctionFactor = 0.6;
    int red = color.red + ((255 - color.red) * correctionFactor).round();
    int green = color.green + ((165 - color.green) * correctionFactor).round();
    int blue = color.blue + ((0 - color.blue) * correctionFactor).round();

    return Color.fromARGB(color.alpha, red, green, blue);
  }

  void handleButtonPress(int index) {
    if (canPressButton) {
      if (index == sequence[currentIndex]) {
        currentIndex++;

        if (currentIndex >= sequence.length) {
          generateNextSequence();
          currentIndex = 0;
          playSequence();
        }
      } else {
        setState(() {
          gameOver = true;
        });
        showGameOverDialog();
      }
    }
  }

 void showGameOverDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Game Over'),
        content: Text('Você errou! Deseja jogar novamente?'),
        actions: [
          TextButton(
            child: Text('Sim'),
            onPressed: () {
              Navigator.of(context).pop();
              startGame();
            },
          ),
          TextButton(
            child: Text('Não'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Adicione esta linha
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Decora'),
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isGameStarted)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGameStarted = true;
                  });
                  startGame();
                },
                child: Text('Iniciar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .red, // Define a cor de fundo do botão como vermelho
                ),
              ),
            if (isGameStarted) ...[
              Text(
                'Rodada: $roundCount',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Recorde: $maxRoundCount',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 16),
              buildGameButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildGameButtons() {
    return Column(
      children: [
        for (int i = 0; i < buttonColors.length; i++)
          Container(
            color: Colors.black,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColors[i],
                minimumSize: Size(100, 100),
              ),
              onPressed: () {
                handleButtonPress(i);
              },
              child: SizedBox(
                width: 100,
                height: 100,
              ),
            ),
          ),
      ],
    );
  }
}
//teste de run do git