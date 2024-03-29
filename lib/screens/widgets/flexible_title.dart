import 'package:flutter/material.dart';
import 'package:paladins_world/global/variables.dart';
import 'package:paladins_world/models/champion.dart';

class FlexibleTitle extends StatelessWidget {
  const FlexibleTitle({
    super.key,
    required this.champion,
  });

  final Champion champion;

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    double cHeight = MediaQuery.of(context).size.height * 0.1;
    return SizedBox(
      height: cHeight,
      width: cWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              champion.name,
              style: TextStyle(
                color: GlobalsVariables.purpleTitles,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Flexible(
            child: Text(
              champion.title,
              style: TextStyle(
                color: GlobalsVariables.purpleTitles,
                fontFamily: 'Montserrat',
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
