class CollectionName {
  static const rooms = 'rooms';
  static const characters = 'characters';
  static const selectedChars = 'selectedChars';
  static const votes = 'votes';
}

class CharacterId {
  static const civilian = 1;
  static const mafia = 2;
  static const doctor = 3;
  static const detective = 4;
  static const silencer = 5;

  static const List<String> characterListEng = [
    'Civilian',
    'Mafia',
    'Doctor',
    'Detective',
    'Silencer'
  ];
}

class CharacterStatus {
  static const alive = 1;
  static const dead = 2;
  static const muted = 3;

  static const List<String> statusListEnd = ['Alive', 'Dead', 'Muted'];
}
