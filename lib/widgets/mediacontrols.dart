import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';

// This is the MediaControls widget, which is a ConsumerStatefulWidget that displays media controls
class MediaControls extends ConsumerStatefulWidget {
  const MediaControls({Key? key}) : super(key: key);

  @override
  MediaControlsState createState() => MediaControlsState();
}

// This is the MediaControlsState class, which is a ConsumerState that manages the state of the MediaControls widget
class MediaControlsState extends ConsumerState<MediaControls> {
  double _currentSliderValue = 0;
  double _maxSliderValue = 0;
  double _videoPosition = 0;
  bool _isSliderGrabbed = false;
  bool _isPlaying = false;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    // Get the cameraToggleProvider from the providers file
    final bool isCameraToggle = ref.watch(cameraToggleProvider);
    // If the camera toggle is on, display the recording toggle button
    if (isCameraToggle) {
      final bool isRecordingToggle = ref.watch(recordingToggleProvider);
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: IconButton(
            onPressed: () {
              ref.watch(recordingToggleProvider.notifier).toggle();
            },
            isSelected: isRecordingToggle,
            icon: Icon(Icons.fiber_manual_record),
            selectedIcon: Icon(Icons.stop_circle),
          ),
        ),
      );
    } else {
      // Else, display the video player controls
      final playerPositionStream = ref.watch(playerPositionStreamProvider);
      final playerPlaybackStream = ref.watch(playerPlaybackStreamProvider);
      final playerNotifier = ref.watch(playerProvider.notifier);
      playerPositionStream.whenData((positionState) {
        _videoPosition = positionState.position!.inMilliseconds.toDouble();

        if (positionState.duration!.inMilliseconds.toDouble() != 0.0 &&
            positionState.duration!.inMilliseconds.toDouble() !=
                _maxSliderValue) {
          _maxSliderValue = positionState.duration!.inMilliseconds.toDouble();
        }
      });
      playerPlaybackStream.whenData((playbackState) {
        if (playbackState.isPlaying == true) {
          debugPrint("Playing");
          _isPlaying = true;
        } else {
          debugPrint("Not playing");
          _isPlaying = false;
        }

        if (playbackState.isCompleted == true) {
          _isCompleted = true;

          ref
              .watch(playerProvider.notifier)
              .open(ref.watch(fileSelectedProvider));
        } else {
          _isCompleted = false;
        }
      });
      return Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Build the video scroller
              Slider(
                max: _maxSliderValue,
                value: _isSliderGrabbed ? _currentSliderValue : _videoPosition,
                onChangeStart: (value) => _isSliderGrabbed = true,
                onChanged: (double value) {
                  if (_isSliderGrabbed) {
                    playerNotifier.seek(Duration(milliseconds: value.toInt()));
                    setState(() {
                      _currentSliderValue = value;
                    });
                  } else {
                    debugPrint(_videoPosition.toString());

                    setState(() {
                      _currentSliderValue = _videoPosition;
                    });
                  }
                },
                onChangeEnd: (value) => _isSliderGrabbed = false,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Build fast rewind button
                  IconButton(
                    onPressed: () {
                      playerNotifier.fastRewind();
                    },
                    icon: Icon(Icons.fast_rewind),
                  ),
                  // Build play/pause button
                  IconButton(
                    onPressed: () {
                      playerNotifier.playorpause();
                    },
                    icon:
                        _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                  ),
                  // Build fast forward button
                  IconButton(
                    onPressed: () {
                      playerNotifier.fastForward();
                    },
                    icon: Icon(Icons.fast_forward),
                  ),
                ],
              )
            ],
          ));
    }
  }
}
