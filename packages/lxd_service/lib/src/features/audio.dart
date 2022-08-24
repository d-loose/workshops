import 'package:stdlibc/stdlibc.dart';

import 'context.dart';
import 'feature.dart';

class LxdAudioFeature extends LxdImageFeature {
  const LxdAudioFeature();

  @override
  List<String> getDirectories(LxdFeatureContext context) {
    return const [
      '/etc/pulse/client.conf.d',
      '/etc/profile.d',
      '/srv/pulse',
    ];
  }

  @override
  Map<String, String> getFiles(LxdFeatureContext context) {
    return {
      '/etc/pulse/client.conf.d/workshops-no-shm.conf': 'enable-shm=no',
      '/etc/profile.d/workshops-audio.sh': '''
  # Created by Workshops on ${DateTime.now().toIso8601String()}
  
  export PULSE_SERVER=unix:/srv/pulse/native
  '''
    };
  }

  @override
  Map<String, Map<String, String>> getDevices(LxdFeatureContext context) {
    return {
      'pulse': {
        'type': 'proxy',
        'bind': 'instance',
        'listen': 'unix:/srv/pulse/native',
        'connect': 'unix:/run/user/${getuid()}/pulse/native',
        'gid': '${context.gid}',
        'uid': '${context.uid}',
        'mode': '0777',
        'security.gid': '${getgid()}',
        'security.uid': '${getuid()}',
      },
    };
  }
}
