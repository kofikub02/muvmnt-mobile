import 'package:flutter/material.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class BottomSlidingPanel extends StatefulWidget {
  const BottomSlidingPanel({super.key});

  @override
  State<BottomSlidingPanel> createState() => _BottomSlidingPanelState();
}

class _BottomSlidingPanelState extends State<BottomSlidingPanel> {
  late final ScrollController scrollController;
  late final PanelController panelController;
  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 95.0;

  @override
  void initState() {
    scrollController = ScrollController();
    panelController = PanelController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return SlidingUpPanel(
      snapPoint: .5,
      disableDraggableOnScrolling: false,
      color: Theme.of(context).colorScheme.surface,
      header: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ForceDraggableWidget(
              child: SizedBox(
                width: 100,
                height: 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 7,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: .5,
      controller: panelController,
      scrollController: scrollController,
      panelBuilder:
          () => MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              physics: PanelScrollPhysics(controller: panelController),
              controller: scrollController,
              children: [],
            ),
          ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18.0),
        topRight: Radius.circular(18.0),
      ),
      onPanelSlide: (double pos) {},
    );
  }
}
