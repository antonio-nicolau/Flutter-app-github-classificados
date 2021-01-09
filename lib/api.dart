import 'package:github_raking/ranking_model.dart';
import 'package:http/http.dart' as http;

Future<List<RankingModel>> getRanking() async {
  try {
    final url =
        'https://api.github.com/repositories?fbclid=IwAR057ZJ-oTBP14VbAAHA0azQ2kDYo5ZX44MjK0iYMCfdCknzpCZVo6hRwrY';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (response != null) {
        return rankingModelFromJson(response.body);
      }
    }
  } catch (e) {
    return null;
  }
}
