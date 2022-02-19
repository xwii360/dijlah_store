import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryImage extends StatefulWidget {

  final List<String> imagesUrls;

  const GalleryImage({Key key, this.imagesUrls}) : super(key: key);

  @override
  State<GalleryImage> createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {

  @override
  Widget build(BuildContext context) {
    print(widget.imagesUrls);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.clear)),
      ),
                body:Container(
                    child: PhotoViewGallery.builder(
                      scrollDirection: Axis.horizontal,
                     itemCount: widget.imagesUrls.length,
                      builder: (context,index){
                         final urlImage=widget.imagesUrls[index];
                         return PhotoViewGalleryPageOptions(imageProvider: NetworkImage(IMAGE_URL+urlImage),
                         minScale: PhotoViewComputedScale.contained,
                         maxScale: PhotoViewComputedScale.contained*4,
                          );
                      },
                    )
                )
    );
  }
}
