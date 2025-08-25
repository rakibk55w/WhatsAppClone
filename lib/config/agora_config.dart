import 'package:whats_app_clone/common/env/env.dart';

class AgoraConfig {
  static String appId = Env.appId;
  static String appCertificate = '';
  static String token = '';

  // static Future<String> getToken(String channelId) async {
  //   final supabase = Supabase.instance.client;
  //   String token = '';
  //   final res = await supabase.functions.invoke(
  //     'agora-token',
  //     body: {'channel': channelId, 'uid': 0},
  //   );

  //   if (res.data != null) {
  //     token = res.data['token'];
  //   }
  //   return token;
  // }
}
