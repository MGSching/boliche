import 'package:flutter/material.dart';

void main() {
  runApp(BowlingScoreApp());
}

class BowlingScoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bowling Score Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BowlingScorePage(),
    );
  }
}

class BowlingScorePage extends StatefulWidget {
  @override
  _BowlingScorePageState createState() => _BowlingScorePageState();
}

class _BowlingScorePageState extends State<BowlingScorePage> {
  List<List<int>> frames = List.generate(10, (_) => List.filled(2, 0));
  List<int> frame10 = List.filled(3, 0);
  int currentFrame = 0;
  int roll = 0;
  int selectedValue = 0;

  void _updateScore(int pins) {
    setState(() {
      selectedValue = pins;
      if (currentFrame < 9) {
        frames[currentFrame][roll] = pins;

        if (roll == 1 || pins == 10) {
          currentFrame++;
          roll = 0;
        } else {
          roll++;
        }
      } else if (currentFrame == 9) {
        frame10[roll] = pins;

        if (roll < 2) {
          roll++;
        } else {
          currentFrame++;
        }
      }
    });
  }

  int _calculateTotalScore() {
    int totalScore = 0;

    for (int frameIndex = 0; frameIndex < 9; frameIndex++) {
      int frameScore = frames[frameIndex][0] + frames[frameIndex][1];

      if (frames[frameIndex][0] == 10) {
        frameScore += frames[frameIndex + 1][0];

        if (frames[frameIndex + 1][0] == 10) {
          frameScore += frames[frameIndex + 2][0];
        } else {
          frameScore += frames[frameIndex + 1][1];
        }
      } else if (frameScore == 10) {
        frameScore += frames[frameIndex + 1][0];
      }

      totalScore += frameScore;
    }

    totalScore += frame10[0] + frame10[1] + frame10[2];

    return totalScore;
  }

  int _calculateMaxPossibleScore() {
    int maxPossibleScore = _calculateTotalScore();

    int remainingFrames = 10 - currentFrame - 1;
    int remainingRolls = roll == 1 ? 1 : 2;

    for (int i = 0; i < remainingFrames; i++) {
      maxPossibleScore += 10 + remainingRolls * 10;
      remainingRolls = 2;
    }

    if (currentFrame == 9) {
      if (roll == 0) {
        maxPossibleScore += frame10[0] + frame10[1] + frame10[2];
      } else if (roll == 1) {
        maxPossibleScore += frame10[1] + frame10[2];
      } else if (roll == 2) {
        maxPossibleScore += frame10[2];
      }
    }

    return maxPossibleScore;
  }

  int _maxSecondRollValue() {
    return 10 - frames[currentFrame][roll];
  }

  Widget _buildFrame(int index, [int roll1Score = 0, int roll2Score = 0, int roll3Score = 0]) {
    return Column(
      children: [
        Text(' ${index + 1}'),
        GestureDetector(
          onTap: () {
            if (index <= currentFrame) {
              _updateScore(index * 10);
            }
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            width: 80,
            height: 80,
            child: Text(
              roll1Score == 0 ? (selectedValue == index * 10 ? selectedValue.toString() : '-') : roll1Score.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromRGBO(165, 204, 221, 1), Color.fromRGBO(100, 174, 243, 1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (index <= currentFrame) {
              _updateScore(index * 10 + 1);
            }
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            width: 80,
            height: 80,
            child: Text(
              roll2Score == 0 ? (selectedValue == index * 10 + 1 ? selectedValue.toString() : '-') : roll2Score.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromRGBO(172, 214, 232, 1), Color.fromRGBO(100, 174, 243, 1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        if (index == 9)
          GestureDetector(
            onTap: () {
              if (index <= currentFrame) {
                _updateScore(index * 10 + 2);
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              width: 80,
              height: 80,
              child: Text(
                roll3Score == 0 ? (selectedValue == index * 10 + 2 ? selectedValue.toString() : '-') : roll3Score.toString(),
                style: const TextStyle(fontSize: 18),
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromRGBO(172, 214, 232, 1), Color.fromRGBO(100, 174, 243, 1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(11, (value) {
          if (roll == 1 && frames[currentFrame][0] + value > 10) {
            return Container();
          }
          return GestureDetector(
            onTap: () {
              _updateScore(value);
            },
            child: Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
              child: Text(value == 0 ? '-' : value.toString(), style: const TextStyle(fontSize: 14)),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromRGBO(172, 214, 232, 1), Color.fromRGBO(100, 174, 243, 1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boliche dos Guri'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Frame: ${currentFrame + 1}, Roll: ${roll + 1}',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int index = 0; index < 9; index++)
                      _buildFrame(index, frames[index][0], frames[index][1]),
                    _buildFrame(9, frame10[0], frame10[1], frame10[2]),
                  ],
                ),
              ),
            ),
          ),
          _buildButtonsRow(),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Total Score: ${_calculateTotalScore()}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Max Possible: ${_calculateMaxPossibleScore()}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
