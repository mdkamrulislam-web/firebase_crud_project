import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:firebase_crud_project/constants/const.dart'
    as cons;
import 'package:firebase_crud_project/models/display_data.dart';
import 'package:firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:firebase_crud_project/widgets/background_widget.dart';
import 'package:firebase_crud_project/widgets/numpad_widget.dart';

class PasscodeScreen extends StatefulWidget {
  static const String id = "passcode_screen";
  final String? userPasscode;

  const PasscodeScreen({Key? key, @required this.userPasscode})
      : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen>
    with TickerProviderStateMixin {
  bool? isShowNumpad = false;
  late AnimationController logoController;
  late Animation<Offset> logoOffset;

  AnimationController? dotController;
  late Animation<double> dotAnimation;

  String inputPasscode = '';

  @override
  void initState() {
    super.initState();
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ),
    );
    logoOffset = Tween<Offset>(
      begin: const Offset(0, 1.7),
      end: const Offset(0, -2),
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: Curves.easeInOutExpo,
      ),
    );
    dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    dotAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(
          CurveTween(curve: Curves.elasticIn),
        )
        .animate(dotController!);
    dotAnimation.addStatusListener(_showDotShake);
  }

  void _showDotShake(AnimationStatus aAnimationStatus) {
    if (aAnimationStatus == AnimationStatus.completed) dotController!.reverse();
  }

  Widget logoWidget() {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3.0,
            color: Colors.black26,
            offset: Offset(3.0, 3.0),
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: doOnLogoTap,
          child: const Image(
            image: AssetImage(
              cons.cLogoImage,
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void doOnLogoTap() {
    isShowNumpad = !isShowNumpad!;
    setState(() {
      if (isShowNumpad!) {
        logoController.forward();
      } else {
        logoController.reverse();
      }
    });
  }

  @override
  void dispose() {
    logoController.dispose();
    super.dispose();
  }

  List<Widget> _buildDotList() {
    var doList = <Widget>[];
    for (int i = 0; i < widget.userPasscode!.length; i++) {
      doList.add(
        Container(
          margin: const EdgeInsets.all(6.0),
          alignment: Alignment.center,
          child: PasscodeDot(
            filled: i < inputPasscode.length,
          ),
        ),
      );
    }
    return doList;
  }

  Widget _buildPasscodeDotWidget() {
    return AnimatedBuilder(
        animation: dotAnimation,
        builder: (context, _) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Container(
              height: 30.0,
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildDotList(),
              ),
            ),
          );
        });
  }

  Widget _showInputWidget(Widget aWidget) {
    return Animator(
      tweenMap: {
        'opacity': Tween<double>(begin: -3.0, end: 1.0),
        'motion': Tween<Offset>(
          begin: const Offset(0, 80.0),
          end: const Offset(0, 0),
        ),
      },
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 800),
      cycles: 1,
      builder: (_, anim, __) => FadeTransition(
        opacity: anim.getAnimation('opacity'),
        child: Transform.translate(
          offset: anim.getValue('motion'),
          child: aWidget,
        ),
      ),
    );
  }

  Widget _buildInputWidgets() {
    return _showInputWidget(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: displayWidth()! * 0.30,
          ),
          Container(
            child: _buildPasscodeDotWidget(),
          ),
          SizedBox(
            width: displayWidth()! * 0.8,
            child: NumpadWidget(
              onNumpadTap: _doOnNumpadTap,
            ),
          ),
        ],
      ),
    );
  }

  void _doOnNumpadTap(NumpadData aNumpad) {
    if (aNumpad == NumpadData.delete) {
      _deletePasscode();
    } else {
      _insertPasscode('${aNumpad.index}');
    }
  }

  void _deletePasscode() {
    if (inputPasscode.isNotEmpty) {
      setState(() {
        inputPasscode = inputPasscode.substring(0, inputPasscode.length - 1);
      });
    }
  }

  void _insertPasscode(String aInputNumber) {
    setState(() {
      if (inputPasscode.length < widget.userPasscode!.length) {
        inputPasscode += aInputNumber;
      }
    });
    if (inputPasscode.length == widget.userPasscode!.length) {
      _verifyPasscode();
    }
  }

  void _verifyPasscode() {
    if (inputPasscode != widget.userPasscode) {
      _shakeAndReset();
      ScaffoldMessenger.of(context)
          .showSnackBar(_snackBar("Incorrect Password!"));
    } else {
      Navigator.pushNamed(context, HomeScreen.id);
      ScaffoldMessenger.of(context)
          .showSnackBar(_snackBar("Correct Password!"));
      Future.delayed(const Duration(seconds: 4))
          .then((value) => _resetPasscode());
    }
  }

  void _resetPasscode() {
    setState(() {
      inputPasscode = '';
    });
  }

  void _shakeAndReset() {
    dotController!.forward().then((_) {
      _resetPasscode();
    });
  }

  SnackBar _snackBar(String x) {
    final resultSnackBar = SnackBar(
      content: Container(
        padding: const EdgeInsets.all(2),
        child: Text(
          x,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: Colors.blueAccent,
      behavior: SnackBarBehavior.floating,
      elevation: 10.0,
      margin: const EdgeInsets.all(6),
      duration: const Duration(seconds: 3),
    );
    return resultSnackBar;
  }

  @override
  Widget build(BuildContext context) {
    DisplayData().init(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            BackgroundWidget(
              isBlur: isShowNumpad!,
            ),
            Center(
              child: SlideTransition(
                position: logoOffset,
                child: logoWidget(),
              ),
            ),
            if (isShowNumpad!) _buildInputWidgets() else const SizedBox(),
          ],
        ),
      ),
    );
  }
}
