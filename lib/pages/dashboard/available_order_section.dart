part of '../pages.dart';

class AvailableOrderSection extends StatefulWidget {
  const AvailableOrderSection({Key? key}) : super(key: key);

  @override
  State<AvailableOrderSection> createState() => _AvailableOrderSectionState();
}

class _AvailableOrderSectionState extends State<AvailableOrderSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
      children: [
        Column(
          children: List.generate(5, (index) {
            return Container();
          }),
        ),
        SizedBox(height: 10.0.w),
      ],
    );
  }
}
