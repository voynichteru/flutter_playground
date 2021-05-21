enum Locations {
  tokyo,
  ny,
  london,
  berlin,
  rio,
  melbourne,
  moscow,
  seoul,
  rome,
  capeTown,
}

extension Extension on Locations {
  static final locations = {
    Locations.tokyo: 'Tokyo',
    Locations.ny: 'New York',
    Locations.london: 'London',
    Locations.berlin: 'Berlin',
    Locations.rio: 'Rio de Janeiro',
    Locations.melbourne: 'Melbourne',
    Locations.moscow: 'Moscow',
    Locations.seoul: 'Seoul',
    Locations.rome: 'Rome',
    Locations.capeTown: 'Cape Town',
  };
  static final woied = {
    Locations.tokyo: '1118370',
    Locations.ny: '2459115',
    Locations.london: '44418',
    Locations.berlin: '638242',
    Locations.rio: '455825',
    Locations.melbourne: '1103816',
    Locations.moscow: '2122265',
    Locations.seoul: '1132599',
    Locations.rome: '721943',
    Locations.capeTown: '1591691',
  };

  String get asString => locations[this]!;
  String get getWoied => woied[this]!;
}
