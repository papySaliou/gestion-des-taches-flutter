// import 'package:flutter/material.dart';

// class MyButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final String buttontext;
//   final Color? color;

//   const MyButton({
//     super.key, 
//     required this.onTap, 
//     required this.buttontext, 
//     this.color = Colors.blueAccent});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12,),
//         backgroundColor: color,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       onPressed: onTap, 
//       child: Text(
//         buttontext, 
//         style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.w600,
//         color: Colors.white,
//         ),
//         ),
//         );
//   }
// }

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttontext;
  final Color? color;
  final double? width;
  final double? height;

  const MyButton({
    super.key,
    required this.onTap,
    required this.buttontext,
    this.color = Colors.blueAccent,
    this.width,
    this.height = 50, // Hauteur définie pour conserver l'apparence précédente
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Utilise toute la largeur par défaut
      height: height, // Hauteur personnalisée ou 50 par défaut
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttontext,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
