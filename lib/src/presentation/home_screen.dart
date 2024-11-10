import 'package:flutter/material.dart';
import 'package:numbies_animation/src/presentation/widgets/modal_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 251, 238),
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            showModal(context);
          },
          child: const Text('Open Modal'),
        ),
      ),
    );
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return const ModalContent();
      },
    );
  }
}
