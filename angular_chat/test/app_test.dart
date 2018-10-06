@TestOn('browser')
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';
import 'package:angular_chat/app_component.dart';
import 'package:angular_chat/app_component.template.dart' as ng;

void main() {
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  test('heading', () {
//    expect(fixture.content, contains('My First AngularDart App'));
  });

  // Testing info: https://webdev.dartlang.org/angular/guide/testing
}
