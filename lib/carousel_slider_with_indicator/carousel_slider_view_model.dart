import 'package:hooks_riverpod/hooks_riverpod.dart';

final carouselSliderViewModelProvider =
    StateNotifierProvider((_) => CarouselSliderViewModel());

class CarouselSliderViewModel extends StateNotifier<List<String>> {
  CarouselSliderViewModel() : super(['none', 'none', 'none', 'none', 'none']);
  void setItem(int index, String text) => state[index] = text;
}
