part of '../widgets.dart';

class CustomButton extends StatefulWidget {
  final double? minWidth;
  final VoidCallback onTap;
  final bool pressAble;
  final Widget? trailing;
  final String text;
  final EdgeInsetsGeometry? padding;
  final LinearGradient? gradient;
  const CustomButton(
      {Key? key,
      this.minWidth,
      required this.onTap,
      this.trailing,
      required this.text,
      required this.pressAble,
      this.padding,
      this.gradient})
      : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  var duration = Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      decoration: BoxDecoration(
          gradient: !widget.pressAble
              ? LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(0.6),
                    Colors.grey.withOpacity(0.6)
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
              : widget.gradient ??
                  const LinearGradient(
                    colors: [
                      ColorPallette.baseBlue,
                      ColorPallette.baseBlue,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
          borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: InkWell(
          onTap: widget.pressAble ? widget.onTap : () {},
          splashColor: !widget.pressAble
              ? Colors.transparent
              : Colors.white.withOpacity(0.3),
          highlightColor: !widget.pressAble
              ? Colors.transparent
              : Colors.white.withOpacity(0.3),
          child: Container(
              constraints: BoxConstraints(minWidth: widget.minWidth ?? 0),
              padding: widget.padding ??
                  EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.0.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: FontTheme.regularBaseFont.copyWith(
                        color: !widget.pressAble
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 13.0.sp),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: widget.trailing ?? SizedBox(),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
