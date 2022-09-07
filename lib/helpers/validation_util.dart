bool validEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

bool validUrl(String url) {
  String pattern =
      r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(url);
}

bool validNickname(String nickname) {
  return RegExp(r"^\w{4}\d{4}").hasMatch(nickname);
  // return RegExp(r"^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|]+$").hasMatch(nickname);
}

bool validPwd(String pwd) {
  String pattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,20}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(pwd);
}

bool validPhone(String phone) {
  String pattern = r"^01(?:0|1|[6-9])[-\\s\\.]?[0-9]{4}[-\\s\\.]?[0-9]{4}$";
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(phone);
}

bool validID(String id) {
  String pattern = r"[^a-zA-Z0-9]";
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(id);
}

bool validLocation(String latitude, String longitude) {
  String pattern = r"^(\-?\d+(\.\d+)?)$";
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(latitude) && regExp.hasMatch(longitude);
}
