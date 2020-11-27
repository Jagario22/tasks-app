enum EPriority { HIGH, LOW, MEDIUM }

class EnumUtil {
  static EPriority fromStringToEnum(String value) {
    if (value == "HIGH") return EPriority.HIGH;

    if (value == "LOW") return EPriority.LOW;

    if (value == "MEDIUM") return EPriority.MEDIUM;

    return null;
  }

  static String fromEnumToString(EPriority value) {
    return value.toString().substring(value.toString().indexOf('.') + 1);
  }
}
