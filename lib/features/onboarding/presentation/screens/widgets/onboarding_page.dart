import 'package:flutter/cupertino.dart';

class OnboardingPage extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  const OnboardingPage({super.key, this.image, this.description, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 532,
          width: 390,
          child: Image.asset(image!, fit: BoxFit.fill),
        ),
        const SizedBox(height: 28.5),
        Center(
          child: Text(
            title!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff374151),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              description!,
              style: const TextStyle(
                color: Color(0xff6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
