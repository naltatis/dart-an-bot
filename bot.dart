#import("openliga.dart");
#import("predictor.dart");
#import("botliga.dart");

var ol, predictor, apiKey;

main() {
  ol = new OpenLiga();
  predictor = new Predictor(2.6);
  List<String> argv = (new Options()).arguments;
  var apiKey = argv[0];

  ol.getCurrentMatches().then((Map data) {
    data["matchdata"].forEach((Map game) {
      predictGame(game, apiKey);
    });
  });
}

void predictGame(Map game, String token) {
  var nameTeam1 = game["name_team1"];
  var nameTeam2 = game["name_team2"];
  var matchId = game["match_id"];

  ol.getTeamResults(game["id_team1"], game["id_team2"]).then((List resutls) {

    List<num> team1Goals = resutls.map((result) => result[0]);
    List<num> team2Goals = resutls.map((result) => result[1]);

    String result = predictor.predict(team1Goals, team2Goals);

    var botliga = new Botliga(token);
    botliga.guess(matchId, result).then((int code) {
      print("[$code] - $result - $nameTeam1 vs. $nameTeam2");
    });

  });
}