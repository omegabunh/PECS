class PlayerStats {
  int assist = 0;
  num damageDealt = 0;
  int headshotKills = 0;
  int kills = 0;
  num longestKill = 0;
  num mostSurvivalTime = 0;
  int losses = 0;
  int roundMostKills = 0;
  int roundsPlayed = 0;
  int top10s = 0;
  int wins = 0;

  PlayerStats(
      this.assist,
      this.damageDealt,
      this.headshotKills,
      this.kills,
      this.longestKill,
      this.losses,
      this.mostSurvivalTime,
      this.roundMostKills,
      this.roundsPlayed,
      this.top10s,
      this.wins);
  PlayerStats.fromJson(Map<String, dynamic> statsMap) {
    assist = statsMap['assists'];
    damageDealt = statsMap['damageDealt'];
    headshotKills = statsMap['headshotKills'];
    kills = statsMap['kills'];
    longestKill = statsMap['longestKill'];
    losses = statsMap['losses'];
    mostSurvivalTime = statsMap['mostSurvivalTime'];
    roundMostKills = statsMap['roundMostKills'];
    roundsPlayed = statsMap['roundsPlayed'];
    top10s = statsMap['top10s'];
    wins = statsMap['wins'];
  }
}
