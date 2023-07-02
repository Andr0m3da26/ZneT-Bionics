import 'package:flutter/material.dart';

class IconButtonWithAnimatedToolbar extends StatefulWidget {
  const IconButtonWithAnimatedToolbar(
      {Key? key,
      required this.onCameraOptionSelected,
      required this.onCameraOptionDeselected,
      required this.onGraphOptionSelected,
      required this.onGraphOptionDeselected})
      : super(key: key);
  @override
  State<IconButtonWithAnimatedToolbar> createState() =>
      _IconButtonWithAnimatedToolbarState();

  final VoidCallback onCameraOptionSelected;
  final VoidCallback onCameraOptionDeselected;
  final VoidCallback onGraphOptionSelected;
  final VoidCallback onGraphOptionDeselected;
}

class _IconButtonWithAnimatedToolbarState
    extends State<IconButtonWithAnimatedToolbar> {
  bool _isToolbarExtended = false;
  bool _graphOptionSelected = false;
  bool _cameraOptionSelected = false;

  double height = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 25,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            width: 55,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(100),
              ),
            ),
          ),
        ),
        Column(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
                shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    0.0),
                onPressed: () {
                  setState(() {
                    _isToolbarExtended = !_isToolbarExtended;
                    height = _isToolbarExtended ? 151 : 0;
                  });
                },
                child: Icon(Icons.menu)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AnimatedOpacity(
              opacity: _isToolbarExtended ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 50),
              child: Material(
                  borderRadius: BorderRadius.circular(100),
                  color: _cameraOptionSelected
                      ? Colors.grey[300]
                      : Colors.white.withOpacity(0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    radius: 100,
                    onTap: () {
                      if (_cameraOptionSelected) {
                        widget.onCameraOptionDeselected();
                      } else {
                        widget.onCameraOptionSelected();
                      }
                      setState(() {
                        _cameraOptionSelected = !_cameraOptionSelected;
                      });
                    },
                    splashColor: Colors.grey,
                    highlightColor: Colors.grey,
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.videocam,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AnimatedOpacity(
              opacity: _isToolbarExtended ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 50),
              child: Material(
                  borderRadius: BorderRadius.circular(100),
                  color: _graphOptionSelected
                      ? Colors.grey[300]
                      : Colors.white.withOpacity(0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    radius: 100,
                    onTap: () {
                      if (_graphOptionSelected) {
                        widget.onGraphOptionDeselected();
                      } else {
                        widget.onGraphOptionSelected();
                      }
                      setState(() {
                        _graphOptionSelected = !_graphOptionSelected;
                      });
                    },
                    splashColor: Colors.grey,
                    highlightColor: Colors.grey,
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.timeline,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  )),
            ),
          ),
        ]),
      ],
    );
  }
}
