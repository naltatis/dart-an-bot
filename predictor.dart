#library("predictor");

class Predictor {
  double agingFactor = 2.5;

  Predictor(this.agingFactor);

  String predict(List<num> team1Goals, List<num> team2Goals) {

    var resultTeam1 = avgGoals(team1Goals).toStringAsFixed(0);
    var resultTeam2 = avgGoals(team2Goals).toStringAsFixed(0);
    return "$resultTeam1:$resultTeam2";
  }

  double avgGoals(List<num> goals) {
    double result = 1;
    
    // remove invalid values
    goals = goals.filter((g) => (g >= 0));

    goals.forEach((int gaol) {
      if (result == null) {
        result = gaol * 1.0;
      } else {
        result = (result + gaol * agingFactor) / (agingFactor + 1);
      }
    });
    return result;
  }
}