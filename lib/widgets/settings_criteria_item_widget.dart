import 'package:flutter/material.dart';

class SettingsCriteriaItemWidget extends StatelessWidget {
  final String label;
  final bool enabled;
  final double weight;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<double> onWeightChanged;

  const SettingsCriteriaItemWidget({
    Key? key,
    required this.label,
    required this.enabled,
    required this.weight,
    required this.onEnabledChanged,
    required this.onWeightChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Checkbox(
            value: enabled,
            onChanged: (v) => onEnabledChanged(v ?? false),
          ),
          Text(label, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          Expanded(
            child: Slider(
              value: weight,
              min: 0.1,
              max: 2.0,
              divisions: 19,
              label: weight.toStringAsFixed(1),
              onChanged: enabled ? onWeightChanged : null,
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(weight.toStringAsFixed(1), textAlign: TextAlign.right, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
} 