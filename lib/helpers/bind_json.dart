bool fromJsonStringYn(String? yn) {
  return yn == "y";
}

String toJsonStringYn(bool? yn) {
  return yn == true ? "y" : "n";
}

int fromJsonInt(dynamic val) {
  if (val == null) return 0;

  if (val.runtimeType == int) {
    return val;
  }

  return int.parse(val);
}

String toJsonInt(int n) {
  return n.toString();
}

String fromJsonString(dynamic val) {
  if (val == null) return "";

  if (val.runtimeType == String) {
    return val;
  }

  return val.toString();
}

double fromJsonDouble(dynamic val) {
  if (val == null) return 0.0;

  if (val.runtimeType == String) {
    return double.parse(val);
  } else if(val.runtimeType == int) {
    return double.parse(val.toString());
  }

  return val;
}