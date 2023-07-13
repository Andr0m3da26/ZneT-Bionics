import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';

class MediaControls extends ConsumerStatefulWidget {
  const MediaControls({Key? key}) : super(key: key);

  @override
  MediaControlsState createState() => MediaControlsState();
}

class MediaControlsState extends ConsumerState<MediaControls> {
  double _currentSliderValue = 0;
  double _maxSliderValue = 0;
  double _videoPosition = 0;
  bool _isSliderGrabbed = false;
  bool _isPlaying = false;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    final bool isCameraToggle = ref.watch(cameraToggleProvider);
    if (isCameraToggle) {
      final bool isRecordingToggle = ref.watch(recordingToggleProvider);
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child:
              //  IconButton(
              //     onPressed: () {
              //       ref.watch(recordingToggleProvider.notifier).toggle();
              //     },
              //     icon: Icon(Icons.fiber_manual_record),
              //     selectedIcon: Icon(Icons.stop_circle))
              IconButton(
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
      // final PositionState value = ref.watch(playerProvider);
      // final playerController = ref.watch(playerProvider);
      // final playerStream = ref.watch(playerStreamProvider);
      final playerPositionStream = ref.watch(playerPositionStreamProvider);
      final playerPlaybackStream = ref.watch(playerPlaybackStreamProvider);
      final playerNotifier = ref.watch(playerProvider.notifier);
      playerPositionStream.whenData((positionState) {
        _videoPosition = positionState.position!.inMilliseconds.toDouble();

        if (positionState.duration!.inMilliseconds.toDouble() != 0.0 &&
            positionState.duration!.inMilliseconds.toDouble() !=
                _maxSliderValue) {
          // debugPrint(
          //     'Duration: ${positionState.duration!.inMilliseconds.toDouble().toString()}');

          // debugPrint("Max slider value: ${_maxSliderValue.toString()}");
          // _currentSliderValue = 0;
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
          // debugPrint("Completed");
          _isCompleted = true;

          ref
              .watch(playerProvider.notifier)
              .open(ref.watch(fileSelectedProvider));

          // ref.watch(playerProvider.notifier).seek(Duration.zero);
        } else {
          // debugPrint("Not completed");
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
              Slider(
                // value: value.position.inMilliseconds.toDouble(),

                max: _maxSliderValue,
                // max: 100,
                value:
                    // playerStream.when(
                    //     data: (data) => data,
                    //     error: (err, stack) => 0,
                    //     loading: () => 0),
                    // player.position.position!.inMilliseconds.toDouble(),
                    _isSliderGrabbed ? _currentSliderValue : _videoPosition,
                onChangeStart: (value) => _isSliderGrabbed = true,
                onChanged: (double value) {
                  // PositionState positionState = PositionState();
                  // positionState.position =
                  //     Duration(milliseconds: value.toInt());
                  // playerController.sink.add(positionState);
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
                  IconButton(
                    onPressed: () {
                      // debugPrint("Rewind pressed");
                      playerNotifier.fastRewind();
                    },
                    icon: Icon(Icons.fast_rewind),
                  ),
                  IconButton(
                    onPressed: () {
                      // debugPrint("Play pressed");
                      playerNotifier.playorpause();
                    },
                    icon:
                        _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: () {
                      // debugPrint("Forward pressed");
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
