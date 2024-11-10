import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:numbies_animation/common/widgets/transparent_elevated_button.dart';
import 'package:numbies_animation/src/models/time_model.dart';
import 'package:numbies_animation/src/presentation/widgets/time_container.dart';

class ModalContent extends StatefulWidget {
  const ModalContent({
    super.key,
  });

  @override
  State<ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent>
    with SingleTickerProviderStateMixin {
  /// Constants
  final int animationTime = 500;
  final Curve animationCurve = Curves.slowMiddle;

  /// The value to show if the content is expanding
  bool isExpanding = false;

  /// The offset position of the selected item in the content grdiview
  Offset? _selectedItemOffset;

  /// The Size of the selected item in the content grdiview
  Size? _selectedItemSize;

  /// The size of the dialog container
  Size? _contentSize;

  /// The [TimeModel] of the selected item in the content grdiview
  TimeModel? _selectedTime;

  /// List of keys for individual [TimeContainer] for Gridview content
  late final List<GlobalKey> _itemKeys;

  /// Key for the Stack widget - Used for determining the position of selected
  /// [TimeContainer] in Gridview
  final _stackKey = GlobalKey();

  /// Key for the Animated Container
  final _contentKey = GlobalKey();

  /// Animation controller for morphinh animation
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: animationTime),
      vsync: this,
    );

    _itemKeys = List.generate(itemList.length, (index) => GlobalKey());

    _controller.addStatusListener((status) {
      /// Reseting the value of selected item dependencies once animation is dismissed
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _selectedTime = null;
          _selectedItemOffset = null;
          _selectedItemSize = null;
        });
      }
    });
  }

  @override
  void dispose() {
    // Disposing the animation controller rightfully
    _controller.dispose();
    super.dispose();
  }

  /// Callback function responsible for performing the container morphing
  void onItemSelect(int index) async {
    // Prevent selecting another item during animation
    if (isExpanding) return;

    // Getting the neccessary render box
    final RenderBox itemRenderBox =
        _itemKeys[index].currentContext!.findRenderObject() as RenderBox;
    final RenderBox stackRenderBox =
        _stackKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox contentRenderBox =
        _contentKey.currentContext!.findRenderObject() as RenderBox;

    setState(() {
      _selectedTime = itemList[index];
      _selectedItemSize = itemRenderBox.size;
      _contentSize = contentRenderBox.size;
      _selectedItemOffset =
          itemRenderBox.localToGlobal(Offset.zero, ancestor: stackRenderBox);
    });
    isExpanding = true;

    // Starting the animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: _contentKey,
      duration: Duration(milliseconds: animationTime),
      curve: Curves.decelerate,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Platform.isAndroid ? 20 : 40),
      ),
      height: isExpanding ? 400 : 500,
      width: double.infinity,
      child: Stack(
        key: _stackKey,
        children: [
          Column(
            children: [
              // --  Header
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: const Center(
                    child: Text(
                  'Start a Session',
                  style: TextStyle(fontSize: 24),
                )),
              ),

              // -- Gridview Content
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 90,
                  ),
                  itemCount: itemList.length,
                  // physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        onItemSelect(index);
                      },
                      child: TimeContainer(
                          key: _itemKeys[index], time: itemList[index]),
                    );
                  },
                ),
              )
            ],
          ),

          // -- Selected Container
          if (_selectedTime != null)
            AnimatedBuilder(
              animation:
                  CurvedAnimation(parent: _controller, curve: animationCurve),
              builder: (context, child) {
                /// Interpolate the value for the Positioned widget top
                final double top = lerpDouble(
                  _selectedItemOffset!.dy,
                  0,
                  _controller.value,
                )!;

                /// Interpolate the value for the Positioned widget left
                final double left = lerpDouble(
                  _selectedItemOffset!.dx,
                  0,
                  _controller.value,
                )!;

                /// Interpolate the value for the Positioned widget width
                final double width = lerpDouble(
                  _selectedItemSize!.width,
                  _contentSize!.width - 20,
                  _controller.value,
                )!;

                /// Interpolate the value for the Positioned widget height
                final double height = lerpDouble(
                  _selectedItemSize!.height,
                  _contentSize!.height - 180,
                  _controller.value,
                )!;

                return Positioned(
                  top: top,
                  left: left,
                  width: width,
                  height: height,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanding = false;
                      });
                      _controller.reverse();
                    },
                    child: TimeContainer(
                      time: _selectedTime!,
                      animation: _controller.value,
                    ),
                  ),
                );
              },
            ),

          // Button
          Positioned(
            bottom: 24,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 40),
                child: TransparentElevatedButton(
                  isExpanded: isExpanding,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
