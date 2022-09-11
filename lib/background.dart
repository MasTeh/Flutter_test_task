import 'dart:math';

import 'package:flutter/material.dart';
import 'package:curved_animation_controller/curved_animation_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jedi_test_task/bloc/bloc.dart';
import 'package:jedi_test_task/bloc/state.dart';

class BackgroundAnimated extends StatefulWidget {
  final Widget child;
  const BackgroundAnimated({Key? key, required this.child}) : super(key: key);

  @override
  State<BackgroundAnimated> createState() => _BackgroundAnimatedState();
}

class _BackgroundAnimatedState extends State<BackgroundAnimated>
    with TickerProviderStateMixin {
  final List<MyCircle> circles = [];

  late CurvedAnimationController animationController;
  CurvedAnimationController? sizeAnimationController;
  late Animation animation;
  double animationDimension = 0;
  double animationSize = 0;

  late LoginBloc blocProvider;

  @override
  void didChangeDependencies() {
    blocProvider = BlocProvider.of<LoginBloc>(context);
    blocProvider.stream.listen((state) {
      if (state is LoginIsLoading) {
        sizeAnimationController?.forward();
      } else {
        if (sizeAnimationController != null) {
          if (sizeAnimationController!.isCompleted) {
            sizeAnimationController!.reverse();
          } 
        }        
      }
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    animationController = CurvedAnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
        curve: Curves.easeInCubic)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        }
      })
      ..addListener(() {
        animationDimension = animationController.value;
        setState(() {});
      });

    final List<Color> colors = [
      Colors.indigo.withAlpha(100),
      Colors.deepPurple.withAlpha(100),
      Colors.pink.withAlpha(100)
    ];

    final random = Random();

    for (int i = 0; i <= 200; i++) {
      var paint1 = Paint()
        ..color = colors[random.nextInt(colors.length - 1)]
        ..blendMode = BlendMode.colorBurn;

      circles.add(MyCircle(random.nextDouble(), random.nextDouble(),
          random.nextDouble() * 50, paint1));
    }

    animationController.repeat(reverse: true);

    sizeAnimationController = CurvedAnimationController<double>(
        curve: Curves.easeInQuad,
        vsync: this,
        duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BackgroundPainter(
          circles, animationDimension, 50, sizeAnimationController?.value),
      child: widget.child,
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final List<MyCircle> circles;
  final double dimension;
  final double speed;
  final double? sizeModificator;

  BackgroundPainter(
      this.circles, this.dimension, this.speed, this.sizeModificator);

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in circles) {
      canvas.drawCircle(
          Offset(
              element.posX * size.width,
              element.posY * size.height +
                  dimension * speed * (element.radius / 2)),
          element.radius -
              (sizeModificator != null ? (element.radius * sizeModificator!) + 10 : 0),
          element.paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyCircle {
  final double posX;
  final double posY;
  final double radius;
  final Paint paint;

  MyCircle(this.posX, this.posY, this.radius, this.paint);
}
