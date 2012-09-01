#import("predictor.dart");
#import("history.dart");
#import("botliga.dart");

#import("dart:json");
#import("dart:io");

var predictor, apiKey;

main() {
  predictor = new Predictor(3);
  List<String> argv = (new Options()).arguments;
  var apiKey = argv[0];

  var history = new History();
  history.load();

  getCurrentMatches(2012).forEach((Map game) {
    List<Result> results = history.getResultsByTeam(game["hostId"], game["guestId"]);
    predictGame(game, results, apiKey);
  });
}

List<Map> getCurrentMatches(int year) {
  var file = new File("data/$year.json");
  return JSON.parse(file.readAsTextSync());
}

void predictGame(Map game, List<Results> results, String token) {
  var nameTeam1 = game["hostName"];
  var nameTeam2 = game["guestName"];
  var season = game["season"];
  var group = game["group"];
  var matchId = game["id"];

  List<num> team1Goals = results.map((result) => result.host);
  List<num> team2Goals = results.map((result) => result.away);

  String result = predictor.predict(team1Goals, team2Goals);

  // limiting the number of parallel request due to dart:io issue
  if (season == "2012" && group < 20) {
    print("$result (${results.length} matches) $nameTeam1 vs. $nameTeam2");
    var botliga = new Botliga(token);
    botliga.guess(matchId, result).then((int code) {
      print("[$code] - $result - $nameTeam1 vs. $nameTeam2");
    });
  }
}