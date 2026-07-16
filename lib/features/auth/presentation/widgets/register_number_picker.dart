import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class RegisterNumberPicker extends StatefulWidget {
  final int min;
  final int max;
  final int value;
  final String unit;
  final ValueChanged<int> onChanged;

  const RegisterNumberPicker({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.unit,
    required this.onChanged,
  });

  @override
  State<RegisterNumberPicker> createState() => _RegisterNumberPickerState();
}

class _RegisterNumberPickerState extends State<RegisterNumberPicker> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value.clamp(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(covariant RegisterNumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _value = widget.value.clamp(widget.min, widget.max);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.unit, style: TextStyles.authPickerUnit),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) => NumberPicker(
            value: _value,
            minValue: widget.min,
            maxValue: widget.max,
            axis: Axis.horizontal,
            itemCount: 5,
            itemHeight: 62,
            itemWidth: constraints.maxWidth / 5,
            textStyle: TextStyles.authPickerValue.copyWith(
              color: AppColors.lightGray,
              fontSize: 18,
            ),
            selectedTextStyle: TextStyles.authPickerValue.copyWith(
              fontSize: _value.toString().length > 2 ? 20 : 30,
            ),
            haptics: true,
            onChanged: _onChanged,
          ),
        ),
        const Icon(Icons.arrow_drop_up, color: AppColors.orange, size: 32),
      ],
    );
  }

  void _onChanged(int value) {
    setState(() => _value = value);
    widget.onChanged(value);
  }
}
