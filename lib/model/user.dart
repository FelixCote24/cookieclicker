

class User {
  int id;
  String nom;
  String motDePasse;
  int nombreCookies;
  int nombreClics;
  int nombreGrandMeres;
  int nombreUsines;
  int cookiesGeneresDepuisCreation;
  bool cookieMaster;

  // Modify the constructor to accept the id as an optional parameter
  User({
    required this.nom,
    required this.motDePasse,
    this.id = -1,  // Default id is -1 (which indicates a new user)
    this.nombreCookies = 0,
    this.nombreClics = 0,
    this.nombreGrandMeres = 0,
    this.nombreUsines = 0,
    this.cookiesGeneresDepuisCreation = 0,
    this.cookieMaster = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'motDePasse': motDePasse,
      'nombreCookies': nombreCookies,
      'nombreClics': nombreClics,
      'nombreGrandMeres': nombreGrandMeres,
      'nombreUsines': nombreUsines, 
      'cookiesGeneresDepuisCreation': cookiesGeneresDepuisCreation,
      'cookieMaster': cookieMaster,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      nom: map['nom'] as String,
      motDePasse: map['motDePasse'] as String,
      nombreCookies: map['nombreCookies'] is int ? map['nombreCookies'] as int : 0,
      nombreClics: map['nombreClics'] is int ? map['nombreClics'] as int : 0,
      nombreGrandMeres: map['nombreGrandMeres'] is int ? map['nombreGrandMeres'] as int : 0,
      nombreUsines: map['nombreUsines'] is int ? map['nombreUsines'] as int : 0,
      cookiesGeneresDepuisCreation: map['cookiesGeneresDepuisCreation'] is int 
         ? map['cookiesGeneresDepuisCreation'] as int 
          : 0,
      cookieMaster: map['cookieMaster'] is bool ? map['cookieMaster'] as bool : false,
    );
  }

  void validate() {
    if (nom.isEmpty) throw ArgumentError('User name cannot be empty');
    if (motDePasse.length < 6) throw ArgumentError('Password must be at least 6 characters long');
    if (nombreCookies < 0) throw ArgumentError('Number of cookies cannot be negative');
  }
}
