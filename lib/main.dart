import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController totalPalitosController = TextEditingController();
  TextEditingController limitePalitosController = TextEditingController();
  TextEditingController moveController =
      TextEditingController(); // Novo controller para a jogada do usuário
  String outputText = "";
  int numberOfPieces = 0;
  int limit = 0;
  bool computerPlay = false;
  List<String> moveHistory = [];

  @override
  void initState() {
    super.initState();
  }

  void startGame() {
    numberOfPieces = int.tryParse(totalPalitosController.text) ?? 0;
    limit = int.tryParse(limitePalitosController.text) ?? 0;

    if (numberOfPieces < 2) {
      setState(() {
        outputText =
            'Quantidade de palitos inválida! Informe um valor maior ou igual a 2.\n';
      });
      return;
    }

    if (limit <= 0 || limit >= numberOfPieces) {
      setState(() {
        outputText =
            'Limite de palitos inválido! Informe um valor maior que zero e menor que o total de palitos.\n';
      });
      return;
    }

    setState(() {
      outputText = "";
      computerPlay = (numberOfPieces % (limit + 1)) == 0;
    });

    if (!computerPlay) {
      userPlay();
    } else {
      computerMove();
    }
  }

  void userPlay() {
    setState(() {
      outputText = "Sua vez. Quantos palitos você vai tirar? (1 a $limit)";
    });
  }

  void updateGame(int move) {
    setState(() {
      numberOfPieces -= move;
      moveHistory
          .add("Você tirou $move palito(s). Restam $numberOfPieces palitos.");
      if (numberOfPieces == 1) {
        endGame();
      } else {
        computerPlay = !computerPlay;
        if (computerPlay) {
          computerMove();
        } else {
          userPlay();
        }
      }
    });
  }

  void computerMove() {
    int computerMove = computerChoosesMove(numberOfPieces, limit);
    setState(() {
      numberOfPieces -= computerMove;
      moveHistory.add(
          "O computador tirou $computerMove palito(s). Restam $numberOfPieces palitos.");

      // Voltar para dentro do else
      computerPlay = !computerPlay;

      if (numberOfPieces == 1) {
        endGame();
      } else {
        userPlay();
      }
    });
  }

  int computerChoosesMove(int numberOfPieces, int limit) {
    int remainder = numberOfPieces % (limit + 1);
    // int move = (remainder == 0) ? 1 : remainder;
    if (remainder == 0) {
      return limit;
    } else {
      return (remainder - 1) == 0 ? limit : (remainder - 1);
    }
    // return move;
  }

  void endGame() {
    // moveHistory.add("\n\nSobraram $numberOfPieces peças e a o computador joga? $computerPlay\n\n");
    String result = computerPlay ? "Você ganhou!" : "O computador ganhou!";
    setState(() {
      moveHistory.add(result);
      outputText = "$result\nFim do jogo. Obrigado por jogar :)";
    });
  }

  void restartGame() {
    setState(() {
      numberOfPieces = 0;
      limit = 0;
      outputText = "";
      moveHistory.clear();
    });
  }

  void processUserMove() {
    int move = int.tryParse(moveController.text) ?? 0;
    if (move < 1 || move > limit) {
      setState(() {
        moveHistory.add("\nJogada inválida. Tente novamente.\n");
      });
    } else {
      updateGame(move);
      setState(() {
        moveController.text = ""; // Limpa o campo de entrada
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              UserAccountsDrawerHeader(
                accountName: Text('Nicole Carvalho Souza',
                    style: TextStyle(fontSize: 20)),
                accountEmail: Text('RA: 1431432312019',
                    style: TextStyle(
                        fontSize:
                            15)), // Adicione o email ou outra informação aqui
                currentAccountPicture: SizedBox(
                  width: 60, // Largura da imagem definida como 50 pixels
                  height: 60, // Altura da imagem definida como 50 pixels
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/91771078?v=4'), // Substitua pela URL da imagem da web
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green, // Cor de fundo do Drawer Header
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Jogo NIM', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: totalPalitosController,
                    decoration: const InputDecoration(
                        labelText: 'Total de palitos? (Maior que 2)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: limitePalitosController,
                    decoration: const InputDecoration(
                        labelText:
                            'Limite de palitos por jogada? (Maior que 0)'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: startGame,
                            child: const Text('Iniciar Jogo'),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                    color: Colors.green,
                                    width: 2.0), // Cor e largura da borda
                              ),
                            ),
                            onPressed: restartGame,
                            child: const Text('Reiniciar Jogo',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.green[200],
                    child: Text(
                      outputText,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: moveController,
                    decoration:
                        InputDecoration(labelText: 'Sua jogada (1 a $limit)'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: processUserMove,
                      child: const Text('Enviar Jogada'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jogadas realizadas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          itemCount: moveHistory.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                moveHistory[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
