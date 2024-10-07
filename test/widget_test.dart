import 'package:flutter_test/flutter_test.dart';
import 'package:decora/main.dart';

void main() {
  test('Generate next sequence', () {
    final game = DecoraGameState();

    // Gera a próxima sequência
    game.generateNextSequence();

    // Verifica se a sequência foi gerada corretamente
    expect(game.sequence.isNotEmpty, true);
    
  });
}