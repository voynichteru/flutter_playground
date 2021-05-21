enum Locations {
  tokyo,
  ny,
  london,
  berlin,
  rio,
  melbourne,
  moscow,
  beijing,
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
    Locations.beijing: 'Beijing',
    Locations.rome: 'Rome',
    Locations.capeTown: 'Cape Town',
  };
  String get asString => locations[this]!;
}
