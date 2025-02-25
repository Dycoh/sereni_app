// Path: lib/modules/onboarding/widgets/onboarding_input_widgets.dart

// Core/Framework imports
import 'package:flutter/material.dart';

// Project imports - Theme
import '../../../app/theme.dart';

/// Name input field with validation
class NameInputField extends StatefulWidget {
  final String? initialValue;
  final bool showError;
  final ValueChanged<String> onChanged;

  const NameInputField({
    super.key,
    this.initialValue,
    this.showError = false,
    required this.onChanged,
  });

  @override
  State<NameInputField> createState() => _NameInputFieldState();
}

class _NameInputFieldState extends State<NameInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            border: widget.showError
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.red),
                  )
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: AppTheme.kPrimaryGreen),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: AppTheme.kGray200),
            ),
            filled: true,
            fillColor: AppTheme.kWhite,
            contentPadding: const EdgeInsets.all(AppTheme.kSpacing2x),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
            // Add shadow to input field
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12.0, right: 8.0),
              child: Icon(Icons.person_outline, color: AppTheme.kPrimaryGreen),
            ),
          ),
          style: const TextStyle(
            color: AppTheme.kTextBrown,
            fontSize: 16,
          ),
        ),
        if (widget.showError) ...[
          SizedBox(height: AppTheme.kSpacing),
          const Text(
            'Please enter your name',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Gender selection widget with animated button states
class GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String> onGenderChanged;

  const GenderSelector({
    super.key,
    this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we should use a vertical layout based on width
        final bool useVerticalLayout = constraints.maxWidth < 350;
        
        if (useVerticalLayout) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _GenderButton(
                label: 'Male',
                isSelected: selectedGender == 'Male',
                isEnabled: selectedGender == null || selectedGender == 'Male',
                onTap: () => onGenderChanged('Male'),
                icon: Icons.male,
              ),
              SizedBox(height: AppTheme.kSpacing2x),
              _GenderButton(
                label: 'Female',
                isSelected: selectedGender == 'Female',
                isEnabled: selectedGender == null || selectedGender == 'Female',
                onTap: () => onGenderChanged('Female'),
                icon: Icons.female,
              ),
              SizedBox(height: AppTheme.kSpacing2x),
              _GenderButton(
                label: 'Other',
                isSelected: selectedGender == 'Other',
                isEnabled: selectedGender == null || selectedGender == 'Other',
                onTap: () => onGenderChanged('Other'),
                icon: Icons.person,
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: _GenderButton(
                  label: 'Male',
                  isSelected: selectedGender == 'Male',
                  isEnabled: selectedGender == null || selectedGender == 'Male',
                  onTap: () => onGenderChanged('Male'),
                  icon: Icons.male,
                ),
              ),
              SizedBox(width: AppTheme.kSpacing2x),
              Expanded(
                child: _GenderButton(
                  label: 'Female',
                  isSelected: selectedGender == 'Female',
                  isEnabled: selectedGender == null || selectedGender == 'Female',
                  onTap: () => onGenderChanged('Female'),
                  icon: Icons.female,
                ),
              ),
              SizedBox(width: AppTheme.kSpacing2x),
              Expanded(
                child: _GenderButton(
                  label: 'Other',
                  isSelected: selectedGender == 'Other',
                  isEnabled: selectedGender == null || selectedGender == 'Other',
                  onTap: () => onGenderChanged('Other'),
                  icon: Icons.person,
                ),
              ),
            ],
          );
        }
      }
    );
  }
}

/// Animated button for gender selection
class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;
  final IconData icon;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.kSpacing2x,
          vertical: AppTheme.kSpacing2x,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.kPrimaryGreen
              : isEnabled
                  ? AppTheme.kWhite
                  : AppTheme.kGray100,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? AppTheme.kPrimaryGreen
                : isEnabled
                    ? AppTheme.kGray200
                    : AppTheme.kGray100,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.kPrimaryGreen.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppTheme.kWhite
                  : isEnabled
                      ? AppTheme.kPrimaryGreen
                      : AppTheme.kGray400,
              size: 20,
            ),
            SizedBox(width: AppTheme.kSpacing),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.kWhite
                    : isEnabled
                        ? AppTheme.kTextBrown
                        : AppTheme.kGray400,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Age selector with slider and numeric display
class AgeSelector extends StatelessWidget {
  final double selectedAge;
  final ValueChanged<double> onAgeChanged;

  const AgeSelector({
    super.key,
    required this.selectedAge,
    required this.onAgeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Age display with card background
        Container(
          padding: EdgeInsets.all(AppTheme.kSpacing2x),
          decoration: BoxDecoration(
            color: AppTheme.kWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.kGray200.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedAge.toInt().toString(),
                style: TextStyle(
                  color: AppTheme.kPrimaryGreen,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: AppTheme.kSpacing),
              Text(
                'years',
                style: TextStyle(
                  color: AppTheme.kTextBrown,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppTheme.kSpacing3x),
        
        // Age slider with custom theme
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.kPrimaryGreen,
            inactiveTrackColor: AppTheme.kGray100,
            thumbColor: AppTheme.kWhite,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 15,
              elevation: 4,
            ),
            overlayColor: AppTheme.kPrimaryGreen.withOpacity(0.2),
            trackHeight: 8,
          ),
          child: Slider(
            value: selectedAge,
            min: 13.0, // Minimum age
            max: 100.0, // Maximum age
            divisions: 87, // (max - min)
            onChanged: onAgeChanged,
          ),
        ),
        
        // Min and max labels with improved styling
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.kSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.kSpacing,
                  vertical: AppTheme.kSpacing / 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.kGray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '13',
                  style: TextStyle(
                    color: AppTheme.kGray600,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.kSpacing,
                  vertical: AppTheme.kSpacing / 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.kGray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '100',
                  style: TextStyle(
                    color: AppTheme.kGray600,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
