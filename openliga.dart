#library("openliga");
#import("rest.dart");

class OpenLiga {
  String domain = "http://openligadb-json.heroku.com/api/";

  Rest rest;

  OpenLiga() {
    rest = new Rest();      
  }

  Future<Map> getTeamMatches(int team1, int team2) {
    var url = "matchdata_by_teams?team_id_1=$team1&team_id_2=$team2";
    return rest.getJson(domain + url);
  }

  Future<List> getTeamResults(int team1, int team2) {
    var completer = new Completer();

    getTeamMatches(team1, team2).then((Map data) {
      var result = [];
      data['matchdata'].forEach((Map game) {
        var gameResult = [Math.parseInt(game["points_team1"]), Math.parseInt(game["points_team2"])];

        if (gameResult[0] < 0 || gameResult[1] < 0 || game["league_shortcut"] != "bl1") {
          return;
        }

        if (team1 == game["id_team2"]) {
          gameResult.add(gameResult[0]);
          gameResult.removeRange(0, 1);
        }

        result.add(gameResult);
      });
      completer.complete(result);
    });

    return completer.future;
  }

  Future<Map> getCurrentGroup() {
    var url = "current_group?league_shortcut=bl1";
    return rest.getJson(domain + url);
  }

  Future<Object> getMatches(int groupOrderId) {
    var url = "matchdata_by_group_league_saison?group_order_id=$groupOrderId&league_saison=2012&league_shortcut=bl1";
    return rest.getJson(domain + url);
  }

  Future<Object> getCurrentMatches() {
    var completer = new Completer();
    getCurrentGroup().then((Object data) {
      getMatches(data["group_order_id"]).then((Map matches) {
        completer.complete(matches);
      });
    });
    return completer.future;
  }
}