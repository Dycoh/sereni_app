# File Development/Improvement Standards

## Required File Header Format
Every file must include these three comment blocks at the top:

1. **File Path**
   ```
   // Path: lib/presentation/screens/welcome_screen.dart
   ```

2. **Author & Description**
   ```
   // Author: Dycoh Gacheri (https://github.com/Dycoh)
   // Description: A customizable scaffold widget that provides a consistent layout structure 
   // across the app. This component handles responsive layouts, theme adaptation, and 
   // standardized navigation elements.
   ```

3. **Timestamp**
   ```
   // Last Modified: Monday, 24 February 2025 16:35
   ```
   *Note: Always use the current date and time when generating/modifying the file.*

## Import Organization
Organize imports into logical groups with clear section headers:
```
// Core/Framework imports
import 'dart:async';
import 'package:flutter/material.dart';

// External package imports
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports - Models
import '../../domain/models/user_model.dart';

// Project imports - Services
import '../../data/services/auth_service.dart';

// Project imports - UI Components
import '../widgets/custom_button.dart';
```

## Asset & Constants Declaration
Define all file assets, constants, and configuration variables in a dedicated section:
```dart
class _WelcomeScreenState extends State<WelcomeScreen> {
  // Asset paths
  static const String _gifPath = 'assets/gifs/welcome_sereni_bot.gif';
  static const String _logoPath = 'assets/logos/sereni_logo.png';
  
  // Content constants
  static const String _fullTitle = "Hello. I'm Sereni...";
  static const String _fullSubtitle = "Your dedicated companion for mental wellness...";
  
  // Configuration parameters
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const double _defaultPadding = 16.0;
```

## Documentation & Comments
Include strategic comments that enhance code understanding:
1. **Purpose comments** - Explain WHY, not just WHAT
2. **Complex logic explanations** - Clarify non-obvious implementations
3. **API usage notes** - Document expected parameters/return values
4. **Edge case handling** - Note how boundary conditions are managed

## Code Quality Standards
- Use consistent naming conventions
- Implement proper error handling
- Avoid deeply nested code blocks
- Extract reusable functionality into methods
- Apply performance optimizations where appropriate

## Delivery Requirements
When providing updated code:
1. Include the complete file with all header elements
2. Maintain all existing functionality unless explicitly directed otherwise
3. Format code according to project style guidelines
4. Include all imports, logic, layout elements, and enhanced comments
5. Follow best practices for the specific language/framework

## Improvement Recommendations
After each code update, provide a brief section with:
1. Suggested optimizations for performance/maintainability
2. Potential edge cases that might require attention
3. Alternative implementation approaches if relevant
4. Recommendations for improved testing/validation
