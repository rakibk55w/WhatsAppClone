import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _Env.apiKey;

  @EnviedField(varName: 'GIPHY_KEY', obfuscate: true)
  static final String giphyKey = _Env.giphyKey;

  @EnviedField(varName: 'APP_ID', obfuscate: true)
  static final String appId = _Env.appId;
}
