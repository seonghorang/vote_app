import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '일본어 발음 연습',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PronunciationPracticeScreen(),
    );
  }
}

class PronunciationPracticeScreen extends StatefulWidget {
  const PronunciationPracticeScreen({super.key});

  @override
  State<PronunciationPracticeScreen> createState() =>
      _PronunciationPracticeScreenState();
}

class _PronunciationPracticeScreenState
    extends State<PronunciationPracticeScreen> {
  String _wordToPractice = "こんにちは"; // 연습할 단어
  String _statusText = "버튼을 누르고 발음해 보세요"; // 현재 상태 표시 텍스트
  bool _isRecording = false; // 녹음 중인지 여부

  void _toggleRecording() {
    // TODO: 실제 녹음 시작/종료 로직 추가 예정
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _statusText = "녹음 중...";
        // 여기에 녹음 시작 코드 추가
        print("녹음 시작!");
      } else {
        _statusText = "녹음 완료! 분석 중..."; // 실제로는 분석 후 결과 표시
        // 여기에 녹음 중지 코드 추가
        print("녹음 중지!");
        // TODO: 녹음된 파일 처리 로직 (예: 저장, 분석 요청)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일본어 발음 연습'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _wordToPractice,
              style: const TextStyle(fontSize: 40.0), // 글자 크기 키움
            ),
            const SizedBox(height: 40), // 단어와 상태 텍스트 사이 간격
            Text(
              _statusText,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 60), // 상태 텍스트와 버튼 사이 간격
            IconButton(
              icon: Icon(_isRecording
                  ? Icons.stop
                  : Icons.mic), // 녹음 중이면 정지 아이콘, 아니면 마이크 아이콘
              iconSize: 80.0, // 아이콘 크기 키움
              onPressed: _toggleRecording, // 버튼 클릭 시 _toggleRecording 함수 실행
              tooltip: _isRecording ? '녹음 중지' : '녹음 시작', // 길게 눌렀을 때 설명
            ),
          ],
        ),
      ),
    );
  }
}
