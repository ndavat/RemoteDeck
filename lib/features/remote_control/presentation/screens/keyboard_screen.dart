import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roku_remote/features/remote_control/presentation/riverpod/providers.dart';

class KeyboardScreen extends ConsumerStatefulWidget {
  const KeyboardScreen({super.key});

  @override
  ConsumerState<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends ConsumerState<KeyboardScreen> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // This is a simple implementation. A more robust solution would handle
    // backspaces and send the entire string at once.
    // For now, we send each character as it's typed.
    final text = _textController.text;
    if (text.isNotEmpty) {
      final lastChar = text.substring(text.length - 1);
      ref.read(rokuRepositoryProvider).sendText(lastChar);
    } else {
      // Handle backspace
      ref.read(sendKeypressProvider)('Backspace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roku Keyboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Enter text to send to Roku',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Text will be sent to your Roku as you type.'),
          ],
        ),
      ),
    );
  }
}