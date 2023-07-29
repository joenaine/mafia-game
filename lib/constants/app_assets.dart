abstract class AppAssets {
  static const images = _Images();
  static const svg = _Svg();
  static const avatar = _Avatar();
}

class _Images {
  const _Images();
  final String logoMafia = 'assets/images/logomafia.jpg';
  final String logoHome = 'assets/images/logoHome.png';
  final String mafiaIcon = 'assets/images/mafiaIcon.png';
  final String citybg = 'assets/images/citybg.jpg';
  final String mafia = 'assets/images/mafia.png';
  final String godfather = 'assets/images/godfather.png';
}

class _Svg {
  const _Svg();
  final String arrowleft = 'assets/icons/careleft.svg';
}

class _Avatar {
  const _Avatar();
  final String icon = 'assets/avatars/';
}
