import 'package:flutter/material.dart';
import 'package:record/record.dart'; // record 패키지 임포트
import 'package:permission_handler/permission_handler.dart'; // permission_handler 패키지 임포트
import 'dart:io'; // 파일 경로 등을 다루기 위해 필요
import 'package:path_provider/path_provider.dart'; // 앱 저장 경로를 얻기 위해 필요

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
  String _wordToPractice = "こんにちは";
  String _statusText = "버튼을 누르고 발음해 보세요";
  bool _isRecording = false;
  final _audioRecorder = AudioRecorder(); // AudioRecorder 인스턴스 생성
  String? _audioPath; // 녹음된 파일 경로 저장 변수

  @override
  void initState() {
    super.initState();
    _checkPermissions(); // 화면 시작 시 권한 확인
  }

  @override
  void dispose() {
    _audioRecorder.dispose(); // 화면 종료 시 리소스 해제
    super.dispose();
  }

  // 마이크 권한 확인 및 요청 함수
  Future<void> _checkPermissions() async {
    if (await Permission.microphone.request().isGranted) {
      // 권한이 이미 있거나 사용자가 허용한 경우
      print("마이크 권한 허용됨");
    } else {
      // 사용자가 권한을 거부한 경우 처리 (예: 안내 메시지 표시)
      print("마이크 권한 거부됨");
      setState(() {
        _statusText = "마이크 권한이 필요합니다.";
      });
    }
  }

  // 녹음 시작/종료 토글 함수 (비동기 처리 필요)
  Future<void> _toggleRecording() async {
    // 권한이 있는지 다시 확인
    if (!await Permission.microphone.isGranted) {
      await _checkPermissions(); // 권한 없으면 다시 요청
      if (!await Permission.microphone.isGranted) {
        // 그래도 권한 없으면 녹음 시작 불가
        setState(() {
          _statusText = "마이크 권한이 없어 녹음할 수 없습니다.";
        });
        return;
      }
    }

    try {
      if (await _audioRecorder.isRecording()) {
        // 녹음 중지
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
          _statusText = "녹음 완료!";
          _audioPath = path; // 녹음된 파일 경로 저장
        });
        print("녹음 중지, 파일 경로: $_audioPath");
        // TODO: 녹음된 파일(_audioPath)을 활용한 분석 로직 호출
      } else {
// 녹음 시작
// 앱의 임시 디렉토리에 저장하도록 경로 설정
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath =
            '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a'; // 파일 이름 예시
        await _audioRecorder.start(const RecordConfig(), path: filePath);
        // 또는: await _audioRecorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: filePath);

        setState(() {
          _isRecording = true;
          _statusText = "녹음 중...";
          _audioPath = null; // 녹음 시작 시 이전 경로 초기화
        });
        print("녹음 시작!");
      }
    } catch (e) {
      print("녹음 시작/중지 오류: $e");
      setState(() {
        _statusText = "녹음 중 오류가 발생했습니다.";
        _isRecording = false; // 오류 발생 시 녹음 상태 초기화
      });
    }
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
              style: const TextStyle(fontSize: 40.0),
            ),
            const SizedBox(height: 40),
            Text(
              _statusText,
              style: const TextStyle(fontSize: 16.0),
            ),
            // 녹음된 파일 경로 표시 (테스트용)
            if (_audioPath != null && !_isRecording)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('저장 경로: $_audioPath'),
              ),
            const SizedBox(height: 60),
            IconButton(
              icon: Icon(_isRecording
                  ? Icons.stop_circle_outlined
                  : Icons.mic_rounded), // 아이콘 변경
              color: Colors.red, // 버튼 색상
              iconSize: 80.0,
              onPressed: _toggleRecording, // 비동기 함수 호출
              tooltip: _isRecording ? '녹음 중지' : '녹음 시작',
            ),
          ],
        ),
      ),
    );
  }
}
