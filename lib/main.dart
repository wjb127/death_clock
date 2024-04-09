import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(DeathClockApp());
}

class DeathClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Death Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeathClockPage(),
    );
  }
}

class DeathClockPage extends StatefulWidget {
  @override
  _DeathClockPageState createState() => _DeathClockPageState();
}

class _DeathClockPageState extends State<DeathClockPage> {
  DateTime? _birthday;
  Duration? _timeLeft;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Widget이 dispose될 때 타이머를 취소합니다.
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTimeLeft());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Death Clock'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('생일 설정'),
            ),
            if (_birthday != null)
              Text('당신의 생일: ${DateFormat('yyyy-MM-dd').format(_birthday!)}'),
            if (_timeLeft != null)
              Text('당신의 남은 수명: ${_formatDuration(_timeLeft!)}'),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
        _updateTimeLeft();
      });
    }
  }

  void _updateTimeLeft() {
  if (_birthday == null) {
    return; // 생일이 설정되지 않았으면 업데이트를 중단합니다.
  }
  
  final now = DateTime.now();
  final lifeExpectancy = DateTime(_birthday!.year + 80, _birthday!.month, _birthday!.day);
  setState(() {
    _timeLeft = lifeExpectancy.difference(now);
  });
}


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours % 24);
    final minutes = twoDigits(duration.inMinutes % 60);
    final seconds = twoDigits(duration.inSeconds % 60);
    return "$days 일, $hours 시간, $minutes 분, $seconds 초";
  }
}
