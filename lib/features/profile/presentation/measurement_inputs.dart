import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/units.dart';

/// Result of parsing a body measurement field: a canonical value, an error,
/// or neither (left blank).
class ParsedMeasurement {
  const ParsedMeasurement._(this.value, this.error);
  const ParsedMeasurement.blank() : this._(null, null);
  const ParsedMeasurement.value(int v) : this._(v, null);
  const ParsedMeasurement.error(String e) : this._(null, e);

  final int? value;
  final String? error;

  bool get isBlank => value == null && error == null;
}

double? _parseNumber(String text) =>
    double.tryParse(text.trim().replaceAll(',', '.'));

/// Height text → millimetres. For [HeightUnit.ftIn], [primary] is feet and
/// [secondary] inches.
ParsedMeasurement parseHeight(
  HeightUnit unit,
  String primary, [
  String secondary = '',
]) {
  if (primary.trim().isEmpty && secondary.trim().isEmpty) {
    return const ParsedMeasurement.blank();
  }
  int? mm;
  switch (unit) {
    case HeightUnit.cm:
      final cm = _parseNumber(primary);
      if (cm != null) mm = BodyUnits.cmToMm(cm);
    case HeightUnit.ftIn:
      final feet = primary.trim().isEmpty ? 0 : int.tryParse(primary.trim());
      final inches = secondary.trim().isEmpty ? 0.0 : _parseNumber(secondary);
      if (feet != null && inches != null && inches >= 0 && inches < 12) {
        mm = BodyUnits.feetInchesToMm(feet, inches);
      }
  }
  if (mm == null) return const ParsedMeasurement.error('Enter a valid number');
  final error = BodyUnits.validateHeightMm(mm);
  return error == null
      ? ParsedMeasurement.value(mm)
      : ParsedMeasurement.error(error);
}

/// Weight text → grams.
ParsedMeasurement parseWeight(WeightUnit unit, String text) {
  if (text.trim().isEmpty) return const ParsedMeasurement.blank();
  final n = _parseNumber(text);
  if (n == null) return const ParsedMeasurement.error('Enter a valid number');
  final grams = unit == WeightUnit.kg
      ? BodyUnits.kgToGrams(n)
      : BodyUnits.lbToGrams(n);
  final error = BodyUnits.validateWeightGrams(grams);
  return error == null
      ? ParsedMeasurement.value(grams)
      : ParsedMeasurement.error(error);
}

final _decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];

/// Height entry in the selected unit.
class HeightFields extends StatelessWidget {
  const HeightFields({
    super.key,
    required this.unit,
    required this.primary,
    required this.secondary,
    required this.error,
    this.onChanged,
  });

  final HeightUnit unit;
  final TextEditingController primary;
  final TextEditingController secondary;
  final String? error;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    if (unit == HeightUnit.cm) {
      return TextField(
        key: const Key('height-cm'),
        controller: primary,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: _decimal,
        decoration: InputDecoration(
          labelText: 'Height',
          suffixText: 'cm',
          errorText: error,
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) => onChanged?.call(),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: primary,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Height',
              suffixText: 'ft',
              errorText: error,
              errorMaxLines: 2,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => onChanged?.call(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: secondary,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _decimal,
            decoration: const InputDecoration(
              labelText: '',
              suffixText: 'in',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => onChanged?.call(),
          ),
        ),
      ],
    );
  }
}

class WeightField extends StatelessWidget {
  const WeightField({
    super.key,
    required this.unit,
    required this.controller,
    required this.error,
    this.label = 'Weight',
    this.onChanged,
  });

  final WeightUnit unit;
  final TextEditingController controller;
  final String? error;
  final String label;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    key: const Key('weight-field'),
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: _decimal,
    decoration: InputDecoration(
      labelText: label,
      suffixText: unit.storageKey,
      errorText: error,
      errorMaxLines: 2,
      border: const OutlineInputBorder(),
    ),
    onChanged: (_) => onChanged?.call(),
  );
}

/// Pre-fills height controllers from a stored value.
void fillHeight(
  int? mm,
  HeightUnit unit,
  TextEditingController primary,
  TextEditingController secondary,
) {
  if (mm == null) {
    primary.clear();
    secondary.clear();
    return;
  }
  if (unit == HeightUnit.cm) {
    final cm = BodyUnits.mmToCm(mm);
    primary.text = cm % 1 == 0 ? cm.toStringAsFixed(0) : cm.toStringAsFixed(1);
    secondary.clear();
  } else {
    final (feet, inches) = BodyUnits.mmToFeetInches(mm);
    primary.text = '$feet';
    secondary.text = inches % 1 == 0
        ? inches.toStringAsFixed(0)
        : inches.toStringAsFixed(1);
  }
}
