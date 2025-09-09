import 'package:flutter/material.dart';
import 'package:flutter_haptic_feedback/flutter_haptic_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roku_remote/features/remote_control/presentation/riverpod/providers.dart';

class RemoteScreen extends ConsumerWidget {
  const RemoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A helper function to send a keypress and trigger haptics.
    void _onKeyPress(String key) {
      // We don't need to handle the result here for simple key presses,
      // but you could add error handling.
      ref.read(sendKeypressProvider)(key);
      FlutterHapticFeedback.mediumImpact();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Top navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(icon: Icons.home, onPressed: () => _onKeyPress('Home')),
                _buildIconButton(icon: Icons.arrow_back, onPressed: () => _onKeyPress('Back')),
              ],
            ),
            // D-Pad
            _buildDPad(_onKeyPress),
            
            // Special buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(icon: Icons.replay, onPressed: () => _onKeyPress('InstantReplay')),
                _buildIconButton(icon: Icons.star_border, onPressed: () => _onKeyPress('Info')), // '*' button
              ],
            ),

            // Media Transport Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(icon: Icons.fast_rewind, onPressed: () => _onKeyPress('Rev')),
                _buildIconButton(icon: Icons.play_arrow, onPressed: () => _onKeyPress('Play')),
                _buildIconButton(icon: Icons.fast_forward, onPressed: () => _onKeyPress('Fwd')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDPad(void Function(String) onKeyPress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Column(
        children: [
          _buildIconButton(icon: Icons.keyboard_arrow_up, onPressed: () => onKeyPress('Up')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconButton(icon: Icons.keyboard_arrow_left, onPressed: () => onKeyPress('Left')),
              // The OK button
              GestureDetector(
                onTap: () => onKeyPress('Select'),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              _buildIconButton(icon: Icons.keyboard_arrow_right, onPressed: () => onKeyPress('Right')),
            ],
          ),
          _buildIconButton(icon: Icons.keyboard_arrow_down, onPressed: () => onKeyPress('Down')),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 30),
      ),
    );
  }
}