import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/main.dart';

void main() {
  test('initials returns first letters of first and last names', () {
    expect(const User('Aisha Al Harbi').initials, 'AH');
  });

  test('initials returns first letter of single name', () {
    expect(const User('Maya').initials, 'M');
  });

  test('initials handles extra whitespace', () {
    expect(const User('  Omar   Khan  ').initials, 'OK');
  });

  test('initials returns ? for empty name', () {
    expect(const User('   ').initials, '?');
  });
}
