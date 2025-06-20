import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'audio_engine.dart';

void main() {
  runApp(const AudioAmplifierApp());
}

class AudioAmplifierApp extends StatelessWidget {
  const AudioAmplifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Amplifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AudioAmplifierHome(),
    );
  }
}

class AudioAmplifierHome extends StatefulWidget {
  const AudioAmplifierHome({super.key});

  @override
  State<AudioAmplifierHome> createState() => _AudioAmplifierHomeState();
}

class _AudioAmplifierHomeState extends State<AudioAmplifierHome> {
  final AudioEngine _audioEngine = AudioEngine();
  bool _isRunning = false;
  double _amplificationLevel = 0.5;
  double _mixLevel = 0.5;
  double _morphingPosition = 0.5; // 0=Ultra-rapide, 0.5=Équilibré, 1=Haute Qualité
  double _ambientLevel = 0.0;
  double _systemLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.audio.request();
  }

  void _toggleAudio() async {
    if (_isRunning) {
      await _audioEngine.stop();
    } else {
      await _audioEngine.start();
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _updateMorphingPosition(double value) {
    setState(() {
      _morphingPosition = value;
    });
    _audioEngine.setMorphingPosition(value);
  }

  void _updateAmplification(double value) {
    setState(() {
      _amplificationLevel = value;
    });
    _audioEngine.setAmplificationLevel(value);
  }

  void _updateMixLevel(double value) {
    setState(() {
      _mixLevel = value;
    });
    _audioEngine.setMixLevel(value);
  }

  String _getModeText() {
    if (_morphingPosition < 0.33) {
      return "Mode Ultra-rapide";
    } else if (_morphingPosition < 0.67) {
      return "Mode Équilibré";
    } else {
      return "Mode Haute Qualité";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Amplifier'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bouton ON/OFF principal
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _toggleAudio,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: _isRunning ? Colors.red : Colors.green,
                ),
                child: Text(
                  _isRunning ? 'OFF' : 'ON',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Curseur morphing (fader DJ)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _getModeText(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Ultra-rapide'),
                        Expanded(
                          child: Slider(
                            value: _morphingPosition,
                            onChanged: _updateMorphingPosition,
                            divisions: 100,
                          ),
                        ),
                        const Text('Haute Qualité'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Contrôles d'amplification
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Amplification: ${(_amplificationLevel * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: _amplificationLevel,
                      onChanged: _updateAmplification,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Contrôles de mixage
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Mixage Ambiant/Système: ${(_mixLevel * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        const Text('Ambiant'),
                        Expanded(
                          child: Slider(
                            value: _mixLevel,
                            onChanged: _updateMixLevel,
                          ),
                        ),
                        const Text('Système'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // VU-mètres
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Niveaux Audio',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Ambiant: '),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _ambientLevel,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Système: '),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _systemLevel,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioEngine.stop();
    super.dispose();
  }
}
