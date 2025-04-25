import 'package:flutter_dotenv/flutter_dotenv.dart';

String getImageUrl(String name, String subfolder) {
  return "${dotenv.env['BASE_API_URL']}/media/$name/$subfolder";
}