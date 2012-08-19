#import("openliga.dart");
#import("predictor.dart");

var ol, predictor;

main() {
  ol = new OpenLiga();
  predictor = new Predictor(2.6);

  ol.getCurrentMatches().then((Map data) {
    data["matchdata"].forEach((Map game) {
      predictGame(game);
    });
  });
}

void predictGame(Map game) {
  var nameTeam1 = game["name_team1"];
  var nameTeam2 = game["name_team2"];

  ol.getTeamResults(game["id_team1"], game["id_team2"]).then((List resutls) {

    List<num> team1Goals = resutls.map((result) => result[0]);
    List<num> team2Goals = resutls.map((result) => result[1]);

    String result = predictor.predict(team1Goals, team2Goals);

    print("$result >> $nameTeam1 vs. $nameTeam2");
  });
}