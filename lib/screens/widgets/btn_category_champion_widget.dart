import 'package:flutter/material.dart';

import '../../global/variables.dart';

class BtnCategoryChampion extends StatefulWidget {
  final bool selected;
  final void Function()? onPressed;
  final String pathIcon;
  final String label;
  const BtnCategoryChampion({
    super.key,
    required this.selected,
    required this.onPressed,
    required this.pathIcon,
    required this.label,
  });

  @override
  State<BtnCategoryChampion> createState() => _BtnCategoryChampionState();
}

class _BtnCategoryChampionState extends State<BtnCategoryChampion> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 120,
      child: TextButton.icon(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(10.0),
          backgroundColor: widget.selected
              ? WidgetStateProperty.all<Color>(
                  GlobalsVariables.buttonBlueDark.withValues(alpha: 0.6))
              : WidgetStateProperty.all<Color>(GlobalsVariables.buttonBlueDark),
          foregroundColor: WidgetStateProperty.all<Color>(
            GlobalsVariables.textButtonGrey,
          ),
          alignment: Alignment.topLeft,
        ),
        onPressed: widget.onPressed,
        icon: Image.asset(
          widget.pathIcon,
          color: GlobalsVariables.textButtonGrey,
        ),
        label: Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: GlobalsVariables.textButtonGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
