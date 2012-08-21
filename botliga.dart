#library("botliga");
#import("rest.dart");

class Botliga {
  String domain = "http://botliga.de/api/guess";
  String token;
  Rest rest;

  Botliga(String token) {
    this.token = token;
    this.rest = new Rest();
  }

  Future<int> guess(String matchId, String result) {
    var url = "$domain";
    var data = "result=$result&match_id$matchId&token=$token";
    return rest.post(url, data);
  }
}