import 'package:flutter/material.dart';
import 'bubble_view.dart' show CustomSpeechBubble;
import 'hole_overlay_view.dart' show HoleOverlay;

class TourStep {
  final GlobalKey targetKey;
  final String title;
  final String description;
  TourStep({
    required this.targetKey,
    required this.title,
    required this.description,
  });
}

class CustomAppTour {
  final BuildContext context;
  final List<TourStep> steps;
  int _currentStep = 0;
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;

  CustomAppTour({required this.context, required this.steps});

  void startTour() {
    _currentStep = 0;
    _showStep();
  }

  Future<void> _showStep() async {
    if (_currentStep >= steps.length) {
      _removeOverlay();
      return;
    }

    final step = steps[_currentStep];
    final context = step.targetKey.currentContext;

    if (context == null || !context.mounted) {
      _removeOverlay();
      return;
    }

    const bubbleHeight = 100.0;
    const tooltipGap = 40.0;
    const bubbleWidth = 320.0;
    const highlightPadding = 12.0;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final safeTopPadding = statusBarHeight + 12.0;
    await Future.delayed(Duration.zero);
    if(!context.mounted)return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.5,
    );

    await Future.delayed(const Duration(milliseconds: 50));
    await WidgetsBinding.instance.endOfFrame;
    if(!context.mounted)return;
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final showAbove = position.dy > bubbleHeight + tooltipGap;
    if (showAbove) {
      await Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        alignment: 0.3,
      );
    } else {
      await Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        alignment: 0.7,
      );
    }

    await Future.delayed(const Duration(milliseconds: 50));
    await WidgetsBinding.instance.endOfFrame;
    final updatedRenderBox = step.targetKey.currentContext!.findRenderObject() as RenderBox;
    final updatedPosition = updatedRenderBox.localToGlobal(Offset.zero);
    final updatedSize = updatedRenderBox.size;
    final targetCenterX = updatedPosition.dx + updatedSize.width / 2;
    double bubbleLeft = targetCenterX - bubbleWidth / 2;
    bubbleLeft = bubbleLeft.clamp(16.0, screenWidth - bubbleWidth - 16.0);
    double bubbleTop = showAbove
        ? updatedPosition.dy - bubbleHeight - tooltipGap
        : updatedPosition.dy + updatedSize.height + tooltipGap;

    // Fix: Prevent tooltip from going off-screen above or below
    if (showAbove && bubbleTop < safeTopPadding) {
      bubbleTop = updatedPosition.dy + updatedSize.height + tooltipGap;
    } else if (!showAbove && (bubbleTop + bubbleHeight > screenHeight)) {
      bubbleTop = updatedPosition.dy - bubbleHeight - tooltipGap;
    }

    final isActuallyAbove = bubbleTop < updatedPosition.dy;
    final trianglePositionPercentage = (targetCenterX - bubbleLeft) / bubbleWidth;
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: () {
          _currentStep++;
          _showStep();
        },
        child: Material(
          color: Colors.grey.withOpacity(0.2),
          child: Stack(
            children: [
              Positioned.fill(
                child: HoleOverlay(
                  holeRect: Rect.fromLTWH(
                    updatedPosition.dx - highlightPadding,
                    updatedPosition.dy - highlightPadding,
                    updatedSize.width + highlightPadding * 2,
                    updatedSize.height + highlightPadding * 2,
                  ),
                ),
              ),
              Positioned(
                top: updatedPosition.dy - highlightPadding,
                left: updatedPosition.dx - highlightPadding,
                child: Container(
                  width: updatedSize.width + highlightPadding * 2,
                  height: updatedSize.height + highlightPadding * 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Positioned(
                top: bubbleTop,
                left: bubbleLeft,
                child: CustomSpeechBubble(
                  width: bubbleWidth,
                  title: step.title,
                  description: step.description,
                  isAbove: isActuallyAbove,
                  trianglePositionPercentage: trianglePositionPercentage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if(!context.mounted)return;
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    _isOverlayVisible = true;
  }

  void _removeOverlay() {
    if (_isOverlayVisible && _overlayEntry != null) {
      try {
        _overlayEntry!.remove();
      } catch (e) {
        debugPrint('Overlay remove failed: $e');
      }
      _isOverlayVisible = false;
      _overlayEntry = null;
    }
  }
}

