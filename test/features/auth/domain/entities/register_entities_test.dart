import 'package:fitness_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('register response entities compare all values', () {
    const first = RegisterResponseEntity(
      message: 'success',
      user: UserEntity(id: 'user-id', firstName: 'John'),
      token: 'token',
    );
    const second = RegisterResponseEntity(
      message: 'success',
      user: UserEntity(id: 'user-id', firstName: 'John'),
      token: 'token',
    );

    expect(first, second);
  });

  test('user entities differ when an equality field changes', () {
    const first = UserEntity(id: 'user-id', firstName: 'John');
    const second = UserEntity(id: 'user-id', firstName: 'Jane');

    expect(first, isNot(second));
  });
}
