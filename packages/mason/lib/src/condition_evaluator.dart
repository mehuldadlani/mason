/// {@template condition_evaluator}
/// Evaluates conditions for brick variables based on previously collected
/// variables.
/// Supports basic operators like ==, !=, in, not in.
/// {@endtemplate}
class ConditionEvaluator {
  /// {@macro condition_evaluator}
  const ConditionEvaluator();

  /// Evaluates a condition string against the given variables.
  ///
  /// Supports the following operators:
  /// - `==` for equality
  /// - `!=` for inequality
  /// - `in` for checking if a value is in a list
  /// - `not in` for checking if a value is not in a list
  ///
  /// Examples:
  /// - `auth_method == firebase`
  /// - `feature_enabled != false`
  /// - `platform in [android, ios]`
  /// - `auth_type not in [google, apple]`
  bool evaluate(String condition, Map<String, dynamic> variables) {
    try {
      // Remove extra whitespace
      final trimmedCondition = condition.trim();

      // Handle 'not in' operator first (to avoid matching 'in' in 'not in')
      if (trimmedCondition.contains(' not in ')) {
        return _evaluateNotInOperator(trimmedCondition, variables);
      }

      // Handle 'in' operator
      if (trimmedCondition.contains(' in ')) {
        return _evaluateInOperator(trimmedCondition, variables);
      }

      // Handle equality operators
      if (trimmedCondition.contains(' == ')) {
        return _evaluateEqualityOperator(trimmedCondition, variables, true);
      }

      if (trimmedCondition.contains(' != ')) {
        return _evaluateEqualityOperator(trimmedCondition, variables, false);
      }

      // If no operator is found, treat as a boolean variable check
      return _evaluateBooleanCheck(trimmedCondition, variables);
    } catch (e) {
      // If evaluation fails, log a warning and return false
      // This prevents the brick from breaking due to invalid conditions
      return false;
    }
  }

  bool _evaluateInOperator(String condition, Map<String, dynamic> variables) {
    final parts = condition.split(' in ');
    if (parts.length != 2) return false;

    final variableName = parts[0].trim();
    final listPart = parts[1].trim();

    if (!variables.containsKey(variableName)) return false;

    final value = variables[variableName];
    final list = _parseList(listPart);

    return list.contains(value.toString());
  }

  bool _evaluateNotInOperator(
    String condition,
    Map<String, dynamic> variables,
  ) {
    final parts = condition.split(' not in ');
    if (parts.length != 2) return false;

    final variableName = parts[0].trim();
    final listPart = parts[1].trim();

    if (!variables.containsKey(variableName)) return false;

    final value = variables[variableName];
    final list = _parseList(listPart);

    return !list.contains(value.toString());
  }

  bool _evaluateEqualityOperator(
    String condition,
    Map<String, dynamic> variables,
    bool isEqual,
  ) {
    final parts = condition.split(isEqual ? ' == ' : ' != ');
    if (parts.length != 2) return false;

    final variableName = parts[0].trim();
    final expectedValue = parts[1].trim();

    if (!variables.containsKey(variableName)) return false;

    final actualValue = variables[variableName];
    final result = actualValue.toString() == expectedValue;

    return isEqual ? result : !result;
  }

  bool _evaluateBooleanCheck(String condition, Map<String, dynamic> variables) {
    if (!variables.containsKey(condition)) return false;

    final value = variables[condition];
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return false;
  }

  List<String> _parseList(String listPart) {
    // Remove brackets and split by comma
    final cleanList = listPart.replaceAll('[', '').replaceAll(']', '');
    return cleanList.split(',').map((e) => e.trim()).toList();
  }
}
