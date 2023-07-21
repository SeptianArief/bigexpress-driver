part of '../widgets.dart';

Future<bool> yesOrNoDialog(BuildContext context,
    {required String title,
    required String desc,
    String? customYes,
    String? customNo}) async {
  bool? result = await showDialog(
      context: context,
      builder: (context) {
        return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black12,
            alignment: Alignment.center,
            child: Container(
                width: 80.0.w,
                padding: EdgeInsets.all(5.0.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 12.0.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3.0.w),
                    Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: FontTheme.regularBaseFont.copyWith(
                        fontSize: 11.0.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 3.0.w),
                    Row(children: [
                      Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 3.0.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor)),
                              child: Text(
                                customNo ?? 'Tidak',
                                style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 12.0.sp,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      SizedBox(width: 2.0.w),
                      Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 3.0.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor),
                              alignment: Alignment.center,
                              child: Text(
                                customYes ?? 'Ya',
                                style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 12.0.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    ])
                  ],
                )));
      });

  return result != null;
}

class CustomDropdown extends StatelessWidget {
  final String? hintText;
  final String? value;
  const CustomDropdown({Key? key, this.hintText, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.0.w, horizontal: 5.0.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black87)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value == null ? hintText ?? '' : value!,
              style: FontTheme.regularBaseFont.copyWith(
                  fontSize: 12.sp,
                  color: value == null ? Colors.black54 : Colors.black87),
            ),
          ),
          SizedBox(width: 2.0.w),
          Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.black87,
          )
        ],
      ),
    );
  }
}

Future<dynamic> modalBottomSheet(BuildContext context,
    {required List<String> data,
    required String title,
    Widget? customWidget}) async {
  List<Widget> listingDataWidget = [];
  dynamic returnValue;

  for (var i = 0; i < data.length; i++) {
    listingDataWidget.add(Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context, i);
          },
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(5.0.w),
              width: 100.0.w,
              child: Text(data[i],
                  style: FontTheme.regularBaseFont
                      .copyWith(fontSize: 11.0.sp, color: Colors.black87))),
        ),
        Container(width: 100.0.w, height: 0.3.w, color: Colors.black12)
      ],
    ));
  }

  returnValue = await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                  width: 100.0.w,
                  height: 50.0.h,
                  padding: EdgeInsets.only(
                    top: 7.0.h,
                  ),
                  child: customWidget ??
                      ListView(
                        children: listingDataWidget,
                      )),
            ),
            Positioned(
                top: 0,
                child: Container(
                    width: 100.0.w,
                    height: 7.0.h,
                    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title,
                            style: FontTheme.regularBaseFont.copyWith(
                                fontSize: 12.0.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close, color: Colors.black87))
                      ],
                    )))
          ],
        );
      });
  return returnValue;
}
