import 'package:flutter/material.dart';
import '../../global/variables.dart';

class TechRoleButton extends StatefulWidget {
  final String roleName;
  final IconData icon;
  final Color roleColor;
  final bool isSelected;
  final VoidCallback onPressed;

  const TechRoleButton({
    Key? key,
    required this.roleName,
    required this.icon,
    required this.roleColor,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  _TechRoleButtonState createState() => _TechRoleButtonState();
}

class _TechRoleButtonState extends State<TechRoleButton>
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

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected;
    final glowColor =
        isActive ? widget.roleColor : GlobalsVariables.textSecondary;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          widget.roleColor.withOpacity(0.8),
                          widget.roleColor.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          GlobalsVariables.secondaryDark,
                          GlobalsVariables.accentDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: Border.all(
                  color: glowColor.withOpacity(isActive ? 0.8 : 0.3),
                  width: isActive ? 2 : 1,
                ),
                boxShadow: [
                  if (isActive) ...[
                    BoxShadow(
                      color: widget.roleColor
                          .withOpacity(_glowAnimation.value * 0.6),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                    BoxShadow(
                      color: widget.roleColor.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: -5,
                    ),
                  ] else ...[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: isActive
                        ? Colors.white
                        : GlobalsVariables.textSecondary,
                    size: 20,
                    shadows: isActive
                        ? [
                            Shadow(
                              color: widget.roleColor.withOpacity(0.8),
                              blurRadius: 10,
                            ),
                          ]
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.roleName,
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : GlobalsVariables.textSecondary,
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      fontFamily: 'Montserrat',
                      shadows: isActive
                          ? [
                              Shadow(
                                color: widget.roleColor.withOpacity(0.8),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TechSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const TechSearchBar({
    Key? key,
    this.hintText = 'Search Champions...',
    required this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  _TechSearchBarState createState() => _TechSearchBarState();
}

class _TechSearchBarState extends State<TechSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: GlobalsVariables.cardGradient,
            border: Border.all(
              color: _isFocused
                  ? GlobalsVariables.neonBlue.withOpacity(_glowAnimation.value)
                  : GlobalsVariables.textSecondary.withOpacity(0.3),
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: GlobalsVariables.neonBlue
                          .withOpacity(_glowAnimation.value * 0.4),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: TextField(
            controller: _controller,
            style: const TextStyle(
              color: GlobalsVariables.textPrimary,
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: GlobalsVariables.textSecondary.withOpacity(0.7),
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              prefixIcon: Icon(
                Icons.search,
                color: _isFocused
                    ? GlobalsVariables.neonBlue
                    : GlobalsVariables.textSecondary,
                size: 24,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: GlobalsVariables.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        _controller.clear();
                        widget.onChanged('');
                        if (widget.onClear != null) {
                          widget.onClear!();
                        }
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {});
              widget.onChanged(value);
            },
            onTap: () {
              setState(() {
                _isFocused = true;
              });
            },
            onEditingComplete: () {
              setState(() {
                _isFocused = false;
              });
            },
            onSubmitted: (_) {
              setState(() {
                _isFocused = false;
              });
            },
          ),
        );
      },
    );
  }
}

class TechFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const TechFloatingActionButton({
    Key? key,
    required this.onPressed,
    this.icon = Icons.add,
    this.backgroundColor = const Color(0xFF00D4FF),
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  _TechFloatingActionButtonState createState() =>
      _TechFloatingActionButtonState();
}

class _TechFloatingActionButtonState extends State<TechFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
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
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.backgroundColor,
                  widget.backgroundColor.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.backgroundColor.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: widget.backgroundColor.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: widget.onPressed,
                child: Center(
                  child: Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 28,
                      shadows: [
                        Shadow(
                          color: widget.backgroundColor.withOpacity(0.8),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
