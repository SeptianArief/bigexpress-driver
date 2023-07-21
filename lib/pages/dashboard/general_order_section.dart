part of '../pages.dart';

class GeneralOrderSection extends StatefulWidget {
  final UtilCubit transactionCubit;

  final Function onRefresh;
  const GeneralOrderSection(
      {Key? key, required this.onRefresh, required this.transactionCubit})
      : super(key: key);

  @override
  State<GeneralOrderSection> createState() => _GeneralOrderSectionState();
}

class _GeneralOrderSectionState extends State<GeneralOrderSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UtilCubit, UtilState>(
      bloc: widget.transactionCubit,
      builder: (context, state) {
        if (state is UtilLoading) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            children: List.generate(8, (index) {
              return PlaceHolder(
                child: Container(
                  width: 90.0.w,
                  height: 30.0.w,
                  margin: EdgeInsets.only(top: index == 0 ? 3.0.w : 2.0.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                ),
              );
            }),
          );
        } else if (state is TransactionLoaded) {
          return RefreshIndicator(
              onRefresh: () async {
                widget.onRefresh();
              },
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                children: state.data.isEmpty
                    ? [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 40.0.h),
                          child: Center(
                            child: Text('Data Kosong'),
                          ),
                        )
                      ]
                    : [
                        Column(
                          children: List.generate(state.data.length, (index) {
                            return OrderPreviewWidget(
                              data: state.data[index],
                            );
                          }),
                        ),
                        SizedBox(height: 10.0.w),
                      ],
              ));
        } else {
          return FailedRequest(
            onTap: () {
              widget.onRefresh();
            },
          );
        }
      },
    );
  }
}
