import 'package:dqapp/view/theme/constants.dart';
import 'package:dqapp/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../home_screen_widgets.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String fileUrl;
  final String? thumbnail;
  final String? title;
  final String? artist;
  final bool isExternalUrl;
  const AudioPlayerScreen({
    super.key,
    required this.fileUrl,
    required this.title,
    required this.artist,
    required this.isExternalUrl,
    required this.thumbnail,
  });
  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    _playPause();
    super.initState();
    // Load and listen to audio duration & position changes
    _audioPlayer.onDurationChanged.listen((Duration d) {
      // print("_audioPlayer.mode");
      // print(_audioPlayer.onPlayerStateChanged);
      setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  Future<void> _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(
        UrlSource(
          '${widget.isExternalUrl ? "" : StringConstants.baseUrl}${widget.fileUrl}',
        ),
      ); // Use your asset path
      // await _audioPlayer.play(UrlSource('https://file-examples.com/storage/fee47d30d267f6756977e34/2017/11/file_example_MP3_700KB.mp3')); // Use your asset path
    }
    setState(() => isPlaying = !isPlaying);
  }

  Future<void> _seekTo(double value) async {
    await _audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  Future<void> _forward() async {
    final newPosition = _position + const Duration(seconds: 10);
    if (newPosition < _duration) {
      await _audioPlayer.seek(newPosition);
    }
  }

  Future<void> _backward() async {
    final newPosition = _position - const Duration(seconds: 10);
    if (newPosition < _duration) {
      await _audioPlayer.seek(newPosition);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    playerBtn({
      required Function() onPressed,
      required String icon,
      Color? color,
    }) {
      return GestureDetector(
        onTap: onPressed,
        child: SizedBox(child: Image.asset(icon, height: 29, color: color)),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Container(
          color: clrFFFFFF,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: SizedBox(
                    height: 70,
                    width: maxWidth,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: clrD9D9D9,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                "assets/images/music-player-arrow-down.png",
                                height: 7,
                                width: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: maxWidth,
                    height: maxWidth - w1p * 8,
                    child: HomeWidgets().cachedImg(
                      widget.thumbnail ?? "",
                      placeholderImage:
                          "assets/images/music-player-placeholder.png",
                    ),
                  ),
                ),
                verticalSpace(18),

                Text(
                  widget.title ?? "",
                  style: t500_24.copyWith(color: clr2D2D2D),
                ),
                Row(
                  children: [
                    Text('Song', style: t400_12.copyWith(color: clr2D2D2D)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: clr2D2D2D,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Text(
                      widget.artist ?? "unknown",
                      style: t400_12.copyWith(color: clr2D2D2D),
                    ),
                  ],
                ),
                verticalSpace(12),
                // Progress Bar (Seekbar)
                SizedBox(
                  width: maxWidth,
                  height: 30,
                  child: Slider(
                    activeColor: const Color(0xffFC2241),
                    min: 0,
                    inactiveColor: clr2D2D2D.withOpacity(0.10),
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble(),
                    onChanged: _seekTo,
                  ),
                ),

                // Time Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_position.inMinutes}:${_position.inSeconds.remainder(60)}",
                        style: t400_14.copyWith(
                          color: clr2D2D2D.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        "${_duration.inMinutes}:${_duration.inSeconds.remainder(60)}",
                        style: t400_14.copyWith(
                          color: clr2D2D2D.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    playerBtn(
                      icon: 'assets/images/music-player-prev-btn.png',
                      onPressed: () {
                        _backward();
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: const BoxDecoration(
                        color: Color(0xffFA7285),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: playerBtn(
                          icon: isPlaying
                              ? 'assets/images/music-player-pause-btn.png'
                              : 'assets/images/music-player-play-btn.png',
                          color: clrFFFFFF,
                          onPressed: () {
                            _playPause();
                          },
                        ),
                      ),
                    ),
                    playerBtn(
                      icon: 'assets/images/music-player-next-btn.png',
                      onPressed: () {
                        _forward();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
