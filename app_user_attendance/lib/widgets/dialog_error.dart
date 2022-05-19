import 'package:flutter/material.dart';

class DialogError extends StatelessWidget {
  final String title;
  const DialogError({Key? key, this.title = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        height: 422,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/dialog_error.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          const Text(
            'Error!',
            style: TextStyle(
              color: Color(0xFF344054),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 32, left: 10, right: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF667085),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: MaterialButton(
              onPressed: () => Navigator.pop(context),
              height: 44,
              minWidth: 155,
              color: const Color(0xFFEE4D69),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.transparent)),
              child: const Text(
                'Try again',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
