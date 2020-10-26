bool isEmptyString(String input) {
  if (input == '' || input.length == 0) {
    return true;
  }
  return false;
}

String emptyStringPlaceholder(String input, String returnTxt) {
  if (input == null || input == '' || input.length == 0) {
    return returnTxt ?? 'na';
  }
  return input;
}
