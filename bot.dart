#import('dart:io');
#import('dart:uri');
#import('dart:json');

main() {
  var uri = teamsUri(100,134);
  var result = getJson(uri);
  result.then((data) {
    List matches = data['matchdata'];
    List team1Gaols = matches.map((match) => Math.parseInt(match['points_team1']));
    List team2Gaols = matches.map((match) => Math.parseInt(match['points_team2']));
    var resultTeam1 = avgGoals(team1Gaols, 2).toStringAsFixed(0);
    var resultTeam2 = avgGoals(team2Gaols, 2).toStringAsFixed(0);
    print("$resultTeam1:$resultTeam2");
  });
}

double avgGoals(List goals, int weight) {
  double result = null;
  goals = goals.filter((g) => (g >= 0));
  goals.forEach((int gaol) {
    if (result == null) {
      result = gaol * 1.0;
    } else {
      result = (result + gaol * weight) / (weight + 1);
    }
  });
  return result;
}

Future<Object> getJson(Uri uri) {
  var completer = new Completer();
  var client = new HttpClient();
  var conn = client.getUrl(uri);
  conn.onRequest = (HttpClientRequest request) {
    request.outputStream.close();
  };
  conn.onResponse = (HttpClientResponse response) {
    final StringInputStream input = new StringInputStream(response.inputStream);
    StringBuffer buffer = new StringBuffer('');

    input.onData = () {
      buffer.add(input.read());
    };

    input.onClosed = () {
      completer.complete(JSON.parse(buffer.toString()));
      client.shutdown();
    };
  };  
  return completer.future;
}

Uri teamsUri(int team1, int team2) {
  return new Uri.fromString("http://openligadb-json.heroku.com/api/matchdata_by_teams?team_id_1=$team1&team_id_2=$team2");
}