import 'package:flutter/material.dart';
import '../../global/variables.dart';

class NeonTitle extends StatefulWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color glowColor;
  final Color textColor;
  final TextAlign textAlign;
  final bool animated;

  const NeonTitle({
    Key? key,
    required this.title,
    this.fontSize = 28,
    this.fontWeight = FontWeight.bold,
    this.glowColor = const Color(0xFF00D4FF),
    this.textColor = Colors.white,
    this.textAlign = TextAlign.center,
    this.animated = true,
  }) : super(key: key);

  @override
  _NeonTitleState createState() => _NeonTitleState();
}

class _NeonTitleState extends State<NeonTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );
      _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animated) {
      return _buildTitle(1.0);
    }

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return _buildTitle(_glowAnimation.value);
      },
    );
  }

  Widget _buildTitle(double glowIntensity) {
    return Text(
      widget.title,
      textAlign: widget.textAlign,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        fontFamily: 'Montserrat',
        color: widget.textColor,
        shadows: [
          Shadow(
            color: widget.glowColor.withOpacity(glowIntensity * 0.8),
            blurRadius: 20 * glowIntensity,
          ),
          Shadow(
            color: widget.glowColor.withOpacity(glowIntensity * 0.6),
            blurRadius: 40 * glowIntensity,
          ),
          Shadow(
            color: widget.glowColor.withOpacity(glowIntensity * 0.4),
            blurRadius: 60 * glowIntensity,
          ),
        ],
      ),
    );
  }
}

class TechCard extends StatefulWidget {
  final Widget child;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color glowColor;
  final bool hasGlow;
  final VoidCallback? onTap;

  const TechCard({
    Key? key,
    required this.child,
    this.elevation = 8,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.glowColor = const Color(0xFF00D4FF),
    this.hasGlow = true,
    this.onTap,
  }) : super(key: key);

  @override
  _TechCardState createState() => _TechCardState();
}

class _TechCardState extends State<TechCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
                gradient: GlobalsVariables.cardGradient,
                border: Border.all(
                  color: widget.hasGlow
                      ? widget.glowColor.withOpacity(0.5)
                      : Colors.transparent,
                  width: 1,
                ),
                boxShadow: widget.hasGlow
                    ? [
                        BoxShadow(
                          color: widget.glowColor
                              .withOpacity(_glowAnimation.value * 0.3),
                          blurRadius: 20 * _glowAnimation.value,
                          spreadRadius: 2 * _glowAnimation.value,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

class ParticleField extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final double particleSize;

  const ParticleField({
    Key? key,
    this.particleCount = 30,
    this.particleColor = const Color(0xFF00D4FF),
    this.particleSize = 2.0,
  }) : super(key: key);

  @override
  _ParticleFieldState createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    particles = List.generate(widget.particleCount, (index) => Particle());
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticleFieldPainter(
            particles: particles,
            animationValue: _controller.value,
            particleColor: widget.particleColor,
            particleSize: widget.particleSize,
          ),
        );
      },
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double opacity;
  late double size;

  Particle() {
    reset();
  }

  void reset() {
    x = (DateTime.now().millisecondsSinceEpoch % 1000) / 1000;
    y = (DateTime.now().microsecondsSinceEpoch % 1000) / 1000;
    vx = (((DateTime.now().millisecondsSinceEpoch % 100) - 50) / 50) * 0.02;
    vy = (((DateTime.now().microsecondsSinceEpoch % 100) - 50) / 50) * 0.02;
    opacity = 0.3 + ((DateTime.now().millisecondsSinceEpoch % 70) / 100);
    size = 1.0 + ((DateTime.now().microsecondsSinceEpoch % 30) / 30);
  }

  void update() {
    x += vx;
    y += vy;

    if (x < 0 || x > 1 || y < 0 || y > 1) {
      reset();
    }
  }
}

class ParticleFieldPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final Color particleColor;
  final double particleSize;

  ParticleFieldPainter({
    required this.particles,
    required this.animationValue,
    required this.particleColor,
    required this.particleSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      particle.update();

      paint.color = particleColor.withOpacity(particle.opacity * 0.6);

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particleSize * particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NeonDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double width;

  const NeonDivider({
    Key? key,
    this.height = 2,
    this.color = const Color(0xFF00D4FF),
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color,
            color,
            Colors.transparent,
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
