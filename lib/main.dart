import 'package:flutter/material.dart';
import 'package:numericc/ipv4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NumeriCC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Game>? currentGame;
  bool wrongAnswer = false;
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _focus = FocusNode();
  int puntos = 0;
  int errores = 0;

  @override
  void initState() {
    currentGame = IPv4().getRandomGame();
    super.initState();
  }

  reset() {
    setState(() {
      currentGame = null;
      wrongAnswer = false;
      _valueController.text = "";
      puntos++;
      currentGame = IPv4().getRandomGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset(
                  "assets/background.png",
                  height: 35,
                  width: 35,
                ).image,
                repeat: ImageRepeat.repeat,
                opacity: 0.2,
                scale: 0.3)),
        child: Center(
          child: FutureBuilder(
              future: currentGame,
              builder: (context, game) {
                if (!game.hasData) {
                  return const Column(
                    children: [
                      Text("Cargando nuevo juego..."),
                      CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MediaQuery.of(context).size.width > 900
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Text("Puntaje: ",
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text(puntos.toString(),
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.white)),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text("Errores: ",
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                                Text(errores.toString(),
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Form(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 64.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (wrongAnswer)
                                    const Text(
                                      "Respuesta incorrecta :(",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Pregunta: ",
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    game.data!.question,
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width >
                                            900
                                        ? MediaQuery.of(context).size.width / 3
                                        : double.infinity,
                                    child: TextFormField(
                                      controller: _valueController,
                                      focusNode: _focus,
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.white),
                                      onFieldSubmitted: (r) {
                                        if (!game.data!.verifyAnswer(r)) {
                                          setState(() {
                                            wrongAnswer = true;
                                            errores++;
                                          });
                                        } else {
                                          reset();
                                        }
                                        _focus.requestFocus();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        if (!game.data!.verifyAnswer(
                                            _valueController.text)) {
                                          setState(() {
                                            wrongAnswer = true;
                                            errores++;
                                          });
                                        } else {
                                          reset();
                                        }
                                        _focus.requestFocus();
                                      },
                                      child: Card(
                                        color: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            "Enviar respuesta",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            )),
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
