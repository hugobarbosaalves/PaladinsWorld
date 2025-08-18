import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../global/variables.dart';

class NeonGlowWidget extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double glowRadius;
  final Duration animationDuration;

  const NeonGlowWidget({
    Key? key,
    required this.child,
    this.glowColor = const Color(0xFF00D4FF),
    this.glowRadius = 20.0,
    this.animationDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _NeonGlowWidgetState createState() => _NeonGlowWidgetState();
}

class _NeonGlowWidgetState extends State<NeonGlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(_animation.value * 0.6),
                blurRadius: widget.glowRadius * _animation.value,
                spreadRadius: widget.glowRadius * _animation.value * 0.1,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

class PortalLoadingAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const PortalLoadingAnimation({
    Key? key,
    this.size = 100.0,
    this.color = const Color(0xFF00D4FF),
  }) : super(key: key);

  @override
  _PortalLoadingAnimationState createState() => _PortalLoadingAnimationState();
}

class _PortalLoadingAnimationState extends State<PortalLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color.withOpacity(0.8),
                    widget.color.withOpacity(0.4),
                    widget.color.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: PortalRingsPainter(
                  color: widget.color,
                  rotationAngle: _rotationAnimation.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PortalRingsPainter extends CustomPainter {
  final Color color;
  final double rotationAngle;

  PortalRingsPainter({required this.color, required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw multiple rotating rings
    for (int i = 0; i < 3; i++) {
      final radius = (size.width / 2) * (0.3 + (i * 0.2));
      final opacity = 1.0 - (i * 0.3);
      paint.color = color.withOpacity(opacity);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotationAngle * (1 + i * 0.5));
      canvas.translate(-center.dx, -center.dy);

      // Draw ring with gaps
      for (int j = 0; j < 8; j++) {
        final startAngle = (j * math.pi / 4) + (rotationAngle * (i + 1));
        final sweepAngle = math.pi / 6;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color glowColor;
  final Color textColor;
  final double width;
  final double height;
  final IconData? icon;

  const NeonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.glowColor = const Color(0xFF00D4FF),
    this.textColor = Colors.white,
    this.width = 200,
    this.height = 50,
    this.icon,
  }) : super(key: key);

  @override
  _NeonButtonState createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [
                    widget.glowColor.withOpacity(0.8),
                    widget.glowColor.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: widget.glowColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.glowColor
                        .withOpacity(_glowAnimation.value * 0.6),
                    blurRadius: 20 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
                  BoxShadow(
                    color: widget.glowColor.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: widget.textColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        shadows: [
                          Shadow(
                            color: widget.glowColor.withOpacity(0.8),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TechBackground extends StatefulWidget {
  final Widget child;

  const TechBackground({Key? key, required this.child}) : super(key: key);

  @override
  _TechBackgroundState createState() => _TechBackgroundState();
}

class _TechBackgroundState extends State<TechBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0A0E1A),
            Color(0xFF1A1F2E),
            Color(0xFF0A0E1A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Animated background pattern
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: TechPatternPainter(animationValue: _animation.value),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class TechPatternPainter extends CustomPainter {
  final double animationValue;

  TechPatternPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GlobalsVariables.neonBlue.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw animated grid pattern
    final spacing = 50.0;
    final offset = animationValue * spacing;

    for (double x = -spacing + offset; x < size.width + spacing; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = -spacing + offset;
        y < size.height + spacing;
        y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw glowing dots at intersections
    paint.style = PaintingStyle.fill;
    paint.color = GlobalsVariables.neonCyan.withOpacity(0.3);

    for (double x = offset; x < size.width; x += spacing * 2) {
      for (double y = offset; y < size.height; y += spacing * 2) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
