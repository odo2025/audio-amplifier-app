import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// Définition des fonctions natives
typedef StartAudioNative = Int32 Function();
typedef StartAudioDart = int Function();

typedef StopAudioNative = Int32 Function();
typedef StopAudioDart = int Function();

typedef SetAmplificationNative = Void Function(Float level);
typedef SetAmplificationDart = void Function(double level);

typedef SetMorphingPositionNative = Void Function(Float position);
typedef SetMorphingPositionDart = void Function(double position);

typedef SetMixLevelNative = Void Function(Float level);
typedef SetMixLevelDart = void Function(double level);

typedef GetLatencyNative = Float Function();
typedef GetLatencyDart = double Function();

class AudioEngine {
  static final DynamicLibrary _lib = Platform.isAndroid
      ? DynamicLibrary.open('libaudio_engine.so')
      : DynamicLibrary.process();

  // Fonctions natives
  late final StartAudioDart _startAudio;
  late final StopAudioDart _stopAudio;
  late final SetAmplificationDart _setAmplification;
  late final SetMorphingPositionDart _setMorphingPosition;
  late final SetMixLevelDart _setMixLevel;
  late final GetLatencyDart _getLatency;

  AudioEngine() {
    try {
      _startAudio = _lib.lookup<NativeFunction<StartAudioNative>>('start_audio').asFunction();
      _stopAudio = _lib.lookup<NativeFunction<StopAudioNative>>('stop_audio').asFunction();
      _setAmplification = _lib.lookup<NativeFunction<SetAmplificationNative>>('set_amplification').asFunction();
      _setMorphingPosition = _lib.lookup<NativeFunction<SetMorphingPositionNative>>('set_morphing_position').asFunction();
      _setMixLevel = _lib.lookup<NativeFunction<SetMixLevelNative>>('set_mix_level').asFunction();
      _getLatency = _lib.lookup<NativeFunction<GetLatencyNative>>('get_latency').asFunction();
    } catch (e) {
      print('Erreur lors du chargement de la bibliothèque native: $e');
      // Fallback pour les tests sans bibliothèque native
    }
  }

  Future<bool> start() async {
    try {
      final result = _startAudio();
      return result == 0;
    } catch (e) {
      print('Erreur lors du démarrage audio: $e');
      return false;
    }
  }

  Future<bool> stop() async {
    try {
      final result = _stopAudio();
      return result == 0;
    } catch (e) {
      print('Erreur lors de l\'arrêt audio: $e');
      return false;
    }
  }

  void setAmplificationLevel(double level) {
    try {
      _setAmplification(level);
    } catch (e) {
      print('Erreur lors du réglage de l\'amplification: $e');
    }
  }

  void setMorphingPosition(double position) {
    try {
      _setMorphingPosition(position);
    } catch (e) {
      print('Erreur lors du réglage du morphing: $e');
    }
  }

  void setMixLevel(double level) {
    try {
      _setMixLevel(level);
    } catch (e) {
      print('Erreur lors du réglage du mixage: $e');
    }
  }

  double getLatency() {
    try {
      return _getLatency();
    } catch (e) {
      print('Erreur lors de la récupération de la latence: $e');
      return 0.0;
    }
  }
}
