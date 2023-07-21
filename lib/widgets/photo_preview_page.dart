part of 'widgets.dart';

class PhotoPreviewPage extends StatelessWidget {
  final String urlPhoto;
  const PhotoPreviewPage({Key? key, required this.urlPhoto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: NetworkImage(urlPhoto),
            ),
            Positioned(
              top: 3.0.w,
              right: 3.0.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(2.0.w),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black54),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
