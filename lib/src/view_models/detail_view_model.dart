import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleep/src/utils/globals.dart';

import '../models/progress_bar_model.dart';
import '../models/sleep_media_model.dart';

class DetailViewModel extends ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isTime = false;
  bool _isRemake = true;
  String ?_currentUrl;
  late SleepMediaItem _music;
  bool _popUp = false;
  bool _close = false;
  int _time = 60;
  List<bool> _isPlayingList = [];
  List<bool> _isChoseList = [];
  List<AudioPlayer> _audioPlayers = [];
  List<String?> _currentUrls = [];
  List<double> _volumeList = [];
  List<Map<String, String>> _listSound = [];
  List<Map<String, String>> _listSoundPlay = [];



  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  bool get isTime => _isTime;
  bool get isRemake => _isRemake;
  bool get popUp => _popUp;
  bool get close => _close;
  int get time => _time;
  String? get currentUrl => _currentUrl;
  SleepMediaItem get music => _music;
  List<AudioPlayer> get audioPlayers => _audioPlayers;
  List<String?> get currentUrls => _currentUrls;
  List<bool> get isPlayingList => _isPlayingList;
  List<bool> get isChoseList => _isChoseList;
  List<double> get volumeList => _volumeList;
  List<Map<String, String>> get listSound => _listSound;
  List<Map<String, String>> get listSoundPlay => _listSoundPlay;



  showSnackbar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.black87,
      duration: const Duration(seconds: 1),
    );
  }
  void addList(Map<String, String> sound, int index) {
    // Kiểm tra xem có sự trùng lặp về index trong danh sách không
    if (!_listSound.any((element) => element["index"] == index.toString())) {
      // Nếu không có sự trùng lặp, thêm mới vào danh sách
      Map<String, String> newSound = {
        "name": sound["name"]!,
        "icon": sound["icon"]!,
        "sound_file": sound["sound_file"]!,
        "index": index.toString(),
      };

      _listSound.add(newSound);

      // Thông báo cho các người nghe rằng dữ liệu đã thay đổi
      notifyListeners();
    } else {
      // Nếu có sự trùng lặp, bạn có thể xử lý theo ý của mình, ví dụ thông báo lỗi hoặc không làm gì cả.
    }
  }
  void removeAll() {
    _listSound.clear();
  }

  void removeById(String index) {
    _listSound.removeWhere((sound) => sound["index"] == index.toString());
    notifyListeners();
  }
  void addAllUnique() {
    for (var sound in _listSound) {
      if (!_listSoundPlay.any((element) => element["index"] == sound["index"])) {
        _listSoundPlay.add(sound);
      }
    }
    // Kiểm tra và loại bỏ các phần tử không tồn tại trong _listSound nữa
    _listSoundPlay.removeWhere((sound) => !_listSound.any((element) => element["index"] == sound["index"]));
    notifyListeners();
  }
  void cancelUnique() {
    for (var sound in _listSoundPlay) {
      if (!_listSound.any((element) => element["index"] == sound["index"])) {
        _listSound.add(sound);
      }
    }
    // Kiểm tra và loại bỏ các phần tử không tồn tại trong _listSound nữa
    _listSound.removeWhere((sound) => !_listSoundPlay.any((element) => element["index"] == sound["index"]));
    notifyListeners();
  }

  void playAudio1(int index)  {
    if (index >= 0 && index < _audioPlayers.length) {
      _audioPlayers[index].play();
      _isPlayingList[index] = true;
      notifyListeners();
    }
  }
  void pauseAudio1(int index) async {
    if (index >= 0 && index < _audioPlayers.length) {
      await _audioPlayers[index].pause();
      _isPlayingList[index] = false;
      _isChoseList[index] = false;

      notifyListeners();
    }
  }

  void pauseAll() {
    for (int i = 0; i < _audioPlayers.length; i++) {
      if (_isPlayingList[i]) {
        _audioPlayers[i].pause();
        _isPlayingList[i] = false;
      }
    }
    notifyListeners();
  }
  void f(){
    _isRemake = false;
    notifyListeners();
  }
  void t(){
    _isRemake = true;
    notifyListeners();
  }
  void remakeAll() {
    for (int i = 0; i < _audioPlayers.length; i++) {
      if (_isChoseList[i]) {
        _isChoseList[i] = false;
      }
    }
    notifyListeners();
  }

  void choise (int index) {
    _isChoseList[index] = true;
    notifyListeners();
  }
  void playAll() {
    for (int i = 0; i < _audioPlayers.length; i++) {
      if (_isChoseList[i]) {
         _audioPlayers[i].play();
        _isPlayingList[i] = true;
      }
    }
    notifyListeners();
  }
  void setTime (int time) {
    _time = time;
    notifyListeners();
  }
  void timing (){
    _isTime = true;
    notifyListeners();
  }
  void closetiming() {
    _isTime = false;
    notifyListeners();
  }
  void setUrl1(String url)  {
    if (!_currentUrls.contains(url)) {
      _currentUrls.add(url);
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.setAsset('assets/${url}');
      audioPlayer.setLoopMode(LoopMode.one);
      _isPlayingList.add(false);
      _isChoseList.add(false);
      _volumeList.add(0.5);
      _audioPlayers.add(audioPlayer);
      notifyListeners();
    }
  }
  void setUrl (String url, SleepMediaItem music) async{
    try {
      if (_currentUrl != url) {
        _currentUrl = url;
        _music = music;
        _close = false;
        await _audioPlayer.setAsset(url);
        _audioPlayer.setLoopMode(LoopMode.one);
      }
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(showSnackbar(e.toString()));
    }

  }

  void changeVolume(int index, double volume) {
    if (index >= 0 && index < _audioPlayers.length) {
      _volumeList[index] = volume;
      _audioPlayers[index].setVolume(volume); // Đặt âm lượng mới cho AudioPlayer
      notifyListeners();
    }
  }
  void playAudio() async{
    try {
      if (_currentUrl == null) return;
      _audioPlayer.play();
      _isPlaying = true;
      _popUp = true;
      _close = false;
      notifyListeners();
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(showSnackbar(e.toString()));
    }
  }


  void pauseAudio() {
    try {
      _audioPlayer.pause();
      _isPlaying = false;
      _close = true;
      notifyListeners();
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(showSnackbar(e.toString()));
    }
  }
  void clear() {
    _currentUrls = [];
    _volumeList = [];
    for (int i = 0; i < _audioPlayers.length; i++) {
        _isPlayingList[i] = false;
        _isChoseList[i] = false ;
    }
    _listSoundPlay=[];
    _listSound = [];
    notifyListeners();
  }
  void popup() async{
    _popUp = false;
    _isPlaying = false;
    _currentUrl = '';
    _audioPlayer.pause();
    notifyListeners();
  }

  void pause() async{
    _audioPlayer.pause();
    notifyListeners();
  }

  void seek(Duration position) {
    try {
      _audioPlayer.seek(position);
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(showSnackbar(e.toString()));
    }
  }

  void dispose() {
    try {
      _audioPlayer.dispose();
      notifyListeners();
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(showSnackbar(e.toString()));
    }
  }
}
