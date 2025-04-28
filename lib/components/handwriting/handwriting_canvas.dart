import 'package:flutter/material.dart' hide Ink;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:japanese_lyrics_app/components/handwriting/handwriting_canvas_controller.dart';

class HandwritingRecognizer extends StatefulWidget {
  final void Function(List<String> predictions) onPrediction;
  final CanvasController? controller;

  const HandwritingRecognizer({super.key, required this.onPrediction, this.controller});

  @override
  State<HandwritingRecognizer> createState() => _HandwritingRecognizerState();
}

class _HandwritingRecognizerState extends State<HandwritingRecognizer> {
  final _ink = Ink();
  final _points = <StrokePoint>[];
  final _modelManager = DigitalInkRecognizerModelManager();
  late DigitalInkRecognizer _recognizer;

  List<String> _candidates = [' ', ' ', ' '];

  @override
  void initState() {
    super.initState();
    _recognizer = DigitalInkRecognizer(languageCode: 'ja'); // Japanese model
    widget.controller?.clearCallback = _clear;
    _downloadModel();
  }

  @override
  void dispose() {
    _recognizer.close();
    super.dispose();
  }

  Future<void> _downloadModel() async {
    final isDownloaded = await _modelManager.isModelDownloaded('ja');
    if (!isDownloaded) {
      await _modelManager.downloadModel('ja');
    }
  }

  Future<void> _recognize() async {
    try {
      final candidates = await _recognizer.recognize(_ink);
      final predictions = candidates.map((c) => c.text).toList();
      widget.onPrediction(predictions);

      setState(() {
        _candidates = predictions.take(3).toList();
      });
    } catch (e) {
      debugPrint('Recognition error: $e');
    }
  }

  void _clear() {
    setState(() {
      _ink.strokes.clear();
      _points.clear();
      _candidates = [' ', ' ', ' '];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_candidates.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _candidates.map((c) => 
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blueAccent.withAlpha(50),
                  ),
                  child: Text(
                    c,
                    style: const TextStyle(fontSize: 20),
                  ),
                )
              ).toList(),
            ),
          ),
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _ink.strokes.add(Stroke());
                  });
                },
                onPanUpdate: (details) {
                  final RenderObject? object = context.findRenderObject();
                  final localPosition = details.localPosition;
                  if (localPosition != null) {
                    setState(() {
                      _points.add(
                        StrokePoint(
                          x: localPosition.dx,
                          y: localPosition.dy,
                          t: DateTime.now().millisecondsSinceEpoch,
                        ),
                      );
                      if (_ink.strokes.isNotEmpty) {
                        _ink.strokes.last.points = List.from(_points);
                      }
                    });
                  }
                },
                onPanEnd: (details) {
                  _points.clear();
                  _recognize();
                },
                child: CustomPaint(
                  painter: _SignaturePainter(_ink),
                  size: Size.infinite,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: FloatingActionButton.small(
                  heroTag: 'clearBtn',
                  onPressed: _clear,
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.clear),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final Ink ink;

  _SignaturePainter(this.ink);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (final stroke in ink.strokes) {
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];
        canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
