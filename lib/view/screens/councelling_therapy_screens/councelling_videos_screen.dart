import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../theme/constants.dart';
import '../../theme/text_styles.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerScreen({required this.videoUrl, Key? key})
      : super(key: key);

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _youtubeController;
  // late VideoPlayerController _videoController;
  // bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: true,
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.videoUrl);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Material(
        child:
            // (widget.isYouTube) ?
            YoutubePlayer(
      topActions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.close_outlined,
              color: Colors.white,
            ),
          ),
        )
      ],
      controller: _youtubeController,
      actionsPadding: const EdgeInsets.symmetric(vertical: 18),
      showVideoProgressIndicator: true,
    ));
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen(
      {required this.videoUrl, required this.title, Key? key})
      : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(('${StringConstants.baseUrl}${widget.videoUrl}')))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _videoController.play(); // Automatically start playing the video
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title, style: t400_14),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                  const Spacer(),
                  VideoControls(_videoController),
                ],
              )
            : const CircularProgressIndicator(color: Color(0xff3478AF)),
      ),
    );
  }
}

class VideoControls extends StatefulWidget {
  final VideoPlayerController videoController;

  const VideoControls(this.videoController, {Key? key}) : super(key: key);

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: widget.videoController,
            builder: (context, value, child) {
              final position = value.position;
              final duration = value.duration;

              return Column(
                children: [
                  Slider(
                    value: position.inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      widget.videoController
                          .seekTo(Duration(seconds: value.toInt()));
                    },
                    activeColor: Colors.white70,
                    inactiveColor: clr757575,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Current Position
                      Text(
                        _formatDuration(position),
                        style: t400_12,
                      ),
                      // Video Duration
                      Text(
                        _formatDuration(duration),
                        style: t400_12,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.fast_rewind,
                  color: Colors.white,
                ),
                onPressed: () {
                  final position = widget.videoController.value.position;
                  final newPosition = position - const Duration(seconds: 10);
                  widget.videoController.seekTo(newPosition);
                },
              ),
              IconButton(
                icon: Icon(
                  widget.videoController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    if (widget.videoController.value.isPlaying) {
                      widget.videoController.pause();
                    } else {
                      widget.videoController.play();
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.fast_forward,
                  color: Colors.white,
                ),
                onPressed: () {
                  final position = widget.videoController.value.position;
                  final newPosition = position + const Duration(seconds: 10);
                  widget.videoController.seekTo(newPosition);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class PlayButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final Color color;
  final Color iconColor;

  const PlayButton({
    required this.onPressed,
    this.size = 60.0,
    this.color = Colors.blue,
    this.iconColor = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Icon(
            Icons.play_arrow,
            color: iconColor,
            size: size * 0.6, // Icon size as a fraction of the container size
          ),
        ),
      ),
    );
  }
}
