import 'package:flutter/material.dart';
import 'package:flutter_brahbrah/carousel_slider_with_indicator/carousel_slider_view_model.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'carousel_hook.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainWidget(),
    );
  }
}

class MainWidget extends HookWidget {
  const MainWidget();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final msgList = useProvider(carouselSliderViewModelProvider.state);
    final viewModel = context.read(carouselSliderViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carousel Slider w Indicator'),
      ),
      body: ListView(
        children: [
          const Text(
            'Input text :)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          const Divider(thickness: 2),
          for (int i = 0; i < msgList.length; i++)
            TextFormField(
              initialValue: '',
              onChanged: (text) {
                viewModel.setItem(i, text);
              },
            ),
          Padding(
            padding: EdgeInsets.only(
              right: screenWidth * 0.2,
              left: screenWidth * 0.2,
            ),
          ),
          CarouselSliderWidget(msgList),
        ],
      ),
    );
  }
}
