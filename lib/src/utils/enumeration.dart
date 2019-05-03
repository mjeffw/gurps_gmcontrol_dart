///
/// Mix-in class to represent an entity whose state can be identified as one of
/// a limited number of String values.
///
abstract class Enumeration {
  /// Returns all possible values.
  List<String> get allValues;

  /// Returns the index of the current value in the list of all values.
  int get valueIndex;

  /// Returns the current text value.
  String get textValue;
}
