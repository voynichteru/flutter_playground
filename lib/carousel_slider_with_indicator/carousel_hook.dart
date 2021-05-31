import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class CarouselSliderWidget extends HookWidget {
  const CarouselSliderWidget(this.msgList);
  final List<String> msgList;

  @override
  Widget build(BuildContext context) {
    final indicator = useState(0);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Indicator part
              // ignore: sized_box_for_whitespace
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < msgList.length; i++)
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 2,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: indicator.value == i
                                  ? colorScheme.background
                                  : Colors.white,
                            ),
                          ),
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 25,
                            height: 25,
                            child: Text(
                              '${i + 1}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
          // Carousel part
          CarouselSlider(
            options: CarouselOptions(
                enableInfiniteScroll: false,
                height: 300,
                onPageChanged: (index, _) {
                  indicator.value = index;
                }),
            items: msgList.map((msg) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        color: colorScheme.background,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            msg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 50,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
