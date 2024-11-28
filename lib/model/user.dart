import 'dart:math';

class User {
  int id = Random().nextInt(1000000);
  String nom;
  String motDePasse;
  int nombreCookies;
  int nombreClics;
  int nombreGrandMeres;
  int cookiesGeneresDepuisCreation;

  User({
    required this.nom,
    required this.motDePasse,
    this.nombreCookies = 0,
    this.nombreClics = 0,
    this.nombreGrandMeres = 0,
    this.cookiesGeneresDepuisCreation = 0
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'motDePasse': motDePasse,
      'nombreCookies': nombreCookies,
      'nombreClics': nombreClics,
      'nombreGrandMeres': nombreGrandMeres,
      'cookiesGeneresDepuisCreation': cookiesGeneresDepuisCreation,
    };
  }

  // Create a User object from a Map<String, dynamic>
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      nom: map['nom'] as String,
      motDePasse: map['motDePasse'] as String,
      nombreCookies: map['nombreCookies'] as int,
      nombreClics: map['nombreClics'] as int,
      nombreGrandMeres: map['nombreGrandMeres'] as int,
      cookiesGeneresDepuisCreation: map['cookiesGeneresDepuisCreation'] as int,
    );
  }
}
