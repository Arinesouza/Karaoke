import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecorderService {
  static final AudioRecorder _recorder = AudioRecorder();

  /// Inicia a gravação
  static Future<bool> startRecording() async {
    // Só grava em Android ou iOS
    if (!(Platform.isAndroid || Platform.isIOS)) return false;

    // Verifica permissão
    if (!await _recorder.hasPermission()) return false;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/karaoke_record.m4a';

    // Configuração de gravação
    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
    );

    await _recorder.start(config, path: path);
    return true;
  }

  /// Para a gravação e retorna o arquivo
  static Future<File?> stopRecording() async {
    final path = await _recorder.stop();
    if (path == null) return null;
    return File(path);
  }

  /// Cancela a gravação e apaga o arquivo
  static Future<void> cancelRecording() async {
    await _recorder.cancel();
  }

  /// Verifica se está gravando
  static Future<bool> isRecording() async {
    return await _recorder.isRecording();
  }

  /// Libera recursos
  static void dispose() {
    _recorder.dispose();
  }
}
