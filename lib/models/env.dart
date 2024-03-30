import 'package:flutter_dotenv/flutter_dotenv.dart';

// 前提：Dartのenumは値は定義できず、名前だけが定義できる
// そのため、Mapを使用してenumとデータを定義
enum EnvKey {
  openApiKey,
}

// .envのキーをキーをベタ書きするのはここだけ
final Map<EnvKey, String?> env = {
  EnvKey.openApiKey: dotenv.env['OPEN_API_KEY'],
};
