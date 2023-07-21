part of 'widgets.dart';

class OrderPreviewWidget extends StatelessWidget {
  final String? status;
  final TransactionPreview data;
  const OrderPreviewWidget({Key? key, required this.data, this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildAddressPreview(String title, Map<String, dynamic> json) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: FontTheme.regularBaseFont
                  .copyWith(fontSize: 8.0.sp, color: ColorPallette.baseBlue),
            ),
            Text(
              json['address'],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: FontTheme.regularBaseFont
                  .copyWith(fontSize: 8.0.sp, color: Colors.black54),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 3.0.w),
              width: double.infinity,
              height: 0.5,
              color: Colors.black38,
            )
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (data.transactionStatus == 1 || data.transactionStatus == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DetailOrderPage(
                        data: data,
                      )));
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 5.0.w),
        padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 3.0.w),
        decoration: BoxDecoration(
            color: ColorPallette.secondaryGrey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26)),
        child: Column(
          children: [
            data.transactionStatus == 1 || data.transactionStatus == 2
                ? Container()
                : SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateToReadable(data.createdAt.substring(0, 10)) +
                              ' ' +
                              data.createdAt.substring(11, 16),
                          style: FontTheme.regularBaseFont
                              .copyWith(fontSize: 10.0.sp),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0.w, vertical: 1.0.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: data.transactionStatus == 3
                                  ? ColorPallette.baseBlue
                                  : Colors.red),
                          child: Text(
                            data.transactionStatus == 3
                                ? 'Selesai'
                                : 'Dibatalkan',
                            style: FontTheme.mediumBaseFont.copyWith(
                                fontSize: 9.0.sp, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: 3.0.w,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black26)),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 3.0.w),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.service,
                          style: FontTheme.boldBaseFont.copyWith(
                              fontSize: 10.0.sp, color: Colors.black87),
                        ),
                        Text(
                          data.addressReceiver2 == null
                              ? '1 Alamat Tujuan'
                              : data.addressReceiver3 == null
                                  ? '2 Alamat Tujuan'
                                  : '3 Alamat Tujuan',
                          style: FontTheme.mediumBaseFont.copyWith(
                              fontSize: 10.0.sp, color: Colors.black87),
                        ),
                      ],
                    ),
                    Text(
                      getDistance(data) + ' KM',
                      style: FontTheme.boldBaseFont
                          .copyWith(fontSize: 10.0.sp, color: Colors.black87),
                    ),
                  ],
                ),
                children: [
                  Container(
                    height: 0.5,
                    margin: EdgeInsets.only(bottom: 3.0.w),
                    width: double.infinity,
                    color: Colors.black38,
                  ),
                  buildAddressPreview('Alamat 1', data.addressSender),
                  buildAddressPreview('Alamat 2', data.addressReceiver1),
                  data.addressReceiver2 != null
                      ? buildAddressPreview('Alamat 3', data.addressReceiver2!)
                      : Container(),
                  data.addressReceiver3 != null
                      ? buildAddressPreview('Alamat 4', data.addressReceiver3!)
                      : Container(),
                  SizedBox(
                    height: 3.0.w,
                  )
                ],
              ),
            ),
            SizedBox(height: 3.0.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Catatan',
                  style: FontTheme.regularBaseFont
                      .copyWith(fontSize: 8.0.sp, color: Colors.black87),
                ),
                SizedBox(
                  width: 40.0.w,
                  child: Text(
                    data.item['note'].isEmpty
                        ? 'Tidak Ada Catatan'
                        : data.item['note'],
                    textAlign: TextAlign.right,
                    style: FontTheme.regularBaseFont.copyWith(
                        fontSize: 8.0.sp, color: ColorPallette.baseBlack),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.0.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Barang Pecah Belah',
                  style: FontTheme.regularBaseFont
                      .copyWith(fontSize: 8.0.sp, color: Colors.black87),
                ),
                SizedBox(
                  width: 40.0.w,
                  child: Text(
                    data.item['isBrokenItem'] ? 'Ya' : 'Bukan',
                    textAlign: TextAlign.right,
                    style: FontTheme.regularBaseFont.copyWith(
                        fontSize: 8.0.sp, color: ColorPallette.baseBlack),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.0.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.item['name'] +
                      ' - ' +
                      data.item['weight'].toString() +
                      ' KG',
                  style: FontTheme.regularBaseFont
                      .copyWith(fontSize: 8.0.sp, color: Colors.black87),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    data.discount > 0
                        ? Text(
                            moneyChanger(data.price),
                            style: FontTheme.regularBaseFont.copyWith(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 10.0.sp,
                                color: Colors.black87),
                          )
                        : Container(),
                    Text(
                      moneyChanger(data.price - data.discount),
                      style: FontTheme.boldBaseFont.copyWith(
                          fontSize: 12.0.sp, color: ColorPallette.baseBlue),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
