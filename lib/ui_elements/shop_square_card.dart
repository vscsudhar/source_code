import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShopSquareCard extends StatefulWidget {
  int id;
  String image;
  String name;
  double stars;

  ShopSquareCard({Key key,this.id, this.image, this.name,this.stars}) : super(key: key);

  @override
  _ShopSquareCardState createState() => _ShopSquareCardState();
}

class _ShopSquareCardState extends State<ShopSquareCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SellerDetails(id: widget.id,);
        }));
      },
      child: Container(
        decoration: BoxDecorations.buildBoxDecoration_1(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(

                  width: double.infinity,
                  height: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16), bottom: Radius.zero),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image:  widget.image,
                        fit: BoxFit.scaleDown,
                      ))),

              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: MyTheme.dark_font_grey,
                        fontSize: 13,
                        height: 1.6,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(

                  height: 15,
                  child: RatingBar(
                    ignoreGestures: true,
                      initialRating: widget.stars,
                      maxRating: 5,
                      direction: Axis.horizontal,
                      itemSize: 15.0,
                      itemCount: 5,
                      ratingWidget:RatingWidget(full: Icon(Icons.star,color: Colors.amber,),
                        half:Icon(Icons.star_half),
                        empty: Icon(Icons.star,
                            color: Color.fromRGBO(224, 224, 225, 1)),
                      ), onRatingUpdate:( newValue){

                  }),
                ),
              ),
              Container(
                height: 23,
                  width: 103,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber),
                    color: MyTheme.amber,
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: Text("Visit Store",style: TextStyle(fontSize: 10,color:Colors.amber.shade700,fontWeight: FontWeight.w500 ),))
            ]),
      ),
    );
  }
}
