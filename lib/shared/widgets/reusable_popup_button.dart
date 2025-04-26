// Generic Reusable PopupMenuButton widget
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

// Class to define a menu item with its properties
class PopupMenuItemData<T> {
  final T value;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final TextStyle? textStyle;

  PopupMenuItemData({
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
    this.textStyle,
  });
}

class ReusablePopupMenu<T> extends StatelessWidget {
  final void Function(T) onItemSelected;
  final List<PopupMenuItemData<T>> items;
  final IconData icon;
  final Color? menuColor;
  final double? elevation;

  const ReusablePopupMenu({
    super.key,
    required this.onItemSelected,
    required this.items,
    this.icon = Icons.more_vert,
    this.menuColor = Colors.white,
    this.elevation = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: Icon(icon),
      onSelected: (T? value) {
        Option.of(value).match(
          () => null, // If no value (None), do nothing
          (selectedItem) => onItemSelected(selectedItem!),
        );
      },
      itemBuilder: (BuildContext context) =>
          items.map((PopupMenuItemData<T> item) {
        return PopupMenuItem<T>(
          value: item.value,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.label,
                style: item.textStyle ?? AppTypography.textMedium,
              ),
              Spacer(),
              Icon(
                item.icon,
                color: item.iconColor ?? Colors.black,
              ),
            ],
          ),
        );
      }).toList(),
      color: menuColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
