import 'package:flutter/material.dart';

class DialogSuccess extends StatelessWidget {
  final String title;
  const DialogSuccess({Key? key, this.title = ''}) : super(key: key);

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
              'assets/images/dialog_success.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          const Text(
            'Success!',
            style: TextStyle(
              color: Color(0xFF344054),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 32),
            child: Text(
              title,
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
              color: const Color(0xFF3CC19D),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.transparent)),
              child: const Text(
                'Done',
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
