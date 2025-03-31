import 'package:flutter/material.dart';

class IconButtonWithBadge extends StatelessWidget {
  final IconData icon;
  final String badgeCount;
  final VoidCallback onPressed;
  final double badgePositionLeft;
  final double badgePositionTop;

  IconButtonWithBadge({
    required this.icon,
    required this.badgeCount,
    required this.onPressed,
    this.badgePositionLeft = 0.0,
    this.badgePositionTop = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allows positioning outside the Stack
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: onPressed,
        ),
        Positioned(
          left: badgePositionLeft,
          top: badgePositionTop,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Center(
              child: Text(
                badgeCount,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
