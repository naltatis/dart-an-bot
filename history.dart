#library("history");
#import('dart:io');
#import('dart:math');

class History {
  Map<String, List<Result>> repo = new HashMap<String, List<Result>>();
  Map<String, String> teamMapping = {
    "7": "Dortmund",
    "134": "Werder Bremen",
    "100": "Hamburg",
    "9": "Schalke 04",
    "6": "Leverkusen",
    "40": "Bayern Munich",
    "131": "Wolfsburg",
    "16": "Stuttgart",
    "87": "M'gladbach",
    "55": "Hannover",
    "112": "Freiburg",
    "95": "Augsburg",
    "91": "Ein Frankfurt",
    "185": "Dusseldorf",
    "79": "Nurnberg",
    "81": "Mainz",
    "115": "Fürth",
    "123": "Hoffenheim"
  };

  load() {
    List<Match> matches = [];
    for (var i = 1993; i <= 2011; i++) {
      matches.addAll(getMatchesByYear(i));
    }
    matches.forEach(addToRepository);
  }

  getResultsByTeam(int team1, int team2) {
    var key = "${getTeamById(team1)}_${getTeamById(team2)}";
    return repo.containsKey(key) ? repo[key] : [];
  }

  getTeamById(int id) {
    String key = "$id";
    if (!teamMapping.containsKey(key)) {
      throw new Exception("team $key not found in mapping");
    }

    return teamMapping[key];
  }

  addToRepository (Match match) {
    String key = "${match.hostName}_${match.guestName}";
    Result result = new Result(match.hostGoals, match.guestGoals, match.date);
    if (!repo.containsKey(key)) {
      repo[key] = [];
    }
    repo[key].add(result);

    String keyReverse = "${match.guestName}_${match.hostName}";
    Result resultReverse = new Result(match.guestGoals, match.hostGoals, match.date);
    if (!repo.containsKey(keyReverse)) {
      repo[keyReverse] = [];
    }
    repo[keyReverse].add(resultReverse);
  }

  List<Match> getMatchesByYear (int year) {
    var file = new File("data/$year.csv");
    List<String> lines = file.readAsLinesSync();
    // remove legend
    lines.removeRange(0, 1);
    // remove empty lines
    lines = lines.filter((String line) => line.replaceAll(",","").trim().length > 0);
    return lines.map((String line) => new Match(line));
  }
}

class Result {
  int host;
  int away;
  Date date;
  Result(this.host, this.away, this.date);
}

class Match {
  String hostName;
  String guestName;
  int hostGoals;
  int guestGoals;
  Date date;

  Match(String string) {
    List<String> parts = string.split(",");
    dateString = parts[1];
    hostName = parts[2];
    guestName = parts[3];
    hostGoals = parseInt(parts[4]);
    guestGoals = parseInt(parts[5]);
  }

  set dateString(String string) {
    List<String> parts = string.split("/");
    int year = parseInt(parts[2]);
    int month = parseInt(parts[1]);
    int day = parseInt(parts[0]);
    date = new Date(year, month, day);
  }
}