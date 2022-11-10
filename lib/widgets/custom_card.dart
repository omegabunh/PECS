//Packages
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final double size;
  final Color? cardColor;
  final Color? textColor;

  const CustomCard({
    super.key,
    required this.title,
    required this.size,
    this.cardColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4.0,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: size,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCardTable extends StatelessWidget {
  final String roundPlayed;
  final String top10s;
  final String kills;
  final String damageDealt;
  final String wins;
  final String losses;
  final String assists;
  final String headShotKills;
  final String longestKill;
  final String roundMostKills;
  final String mostSurvivalTime;

  const CustomCardTable({
    super.key,
    required this.roundPlayed,
    required this.top10s,
    required this.kills,
    required this.damageDealt,
    required this.wins,
    required this.losses,
    required this.assists,
    required this.headShotKills,
    required this.longestKill,
    required this.roundMostKills,
    required this.mostSurvivalTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4.0,
        child: Column(
          children: [
            Table(
              border: TableBorder.all(
                  width: 0.1, borderRadius: BorderRadius.circular(15.0)),
              children: [
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('게임 수'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(roundPlayed),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('탑 10'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(top10s),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('킬 수'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(kills),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('총 데미지'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(damageDealt),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('승'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(wins),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('패'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(losses),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('어시스트'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(assists),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('헤드샷'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(headShotKills),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('저격'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text('$longestKill m'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('최다 킬'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(roundMostKills),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('생존 시간'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(mostSurvivalTime),
                    ),
                    Container(),
                    Container(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
