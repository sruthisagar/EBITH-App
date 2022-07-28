import 'package:http/http.dart';

Future<String> Post(Future<String> a) async {
  final String apiUrl = "http://10.0.2.2:5000/submit";
  try {
    final response = await post(Uri.parse(apiUrl), body: {
      "image": a,
    });
    var output = response.body as String;
    print(output);
    print(response.body);
    return output;
  } catch (e) {
    print(e);
    return "Error";
  }
}