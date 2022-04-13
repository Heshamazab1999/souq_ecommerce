import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/flash_deal_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../data/model/response/product_model.dart';

class FlashDealsView extends StatefulWidget {
  final bool isHomeScreen;

  FlashDealsView({this.isHomeScreen = true});

  @override
  State<FlashDealsView> createState() => _FlashDealsViewState();
}

class _FlashDealsViewState extends State<FlashDealsView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FlashDealProvider>(
      builder: (context, megaProvider, child) {
        return Provider.of<FlashDealProvider>(context).flashDealList.length != 0
            ? ListView.builder(
                padding: EdgeInsets.all(0),
                scrollDirection:
                    widget.isHomeScreen ? Axis.horizontal : Axis.vertical,
                itemCount: megaProvider.flashDealList.length == 0
                    ? 2
                    : megaProvider.flashDealList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 1000),
                            pageBuilder: (context, anim1, anim2) =>
                                ProductDetails(
                                    product: megaProvider.flashDealList[index]),
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: widget.isHomeScreen ? 300 : null,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).highlightColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5)
                          ]),
                      child: Stack(children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    color: ColorResources.getIconBg(context),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder,
                                    fit: BoxFit.cover,
                                    image:
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}'
                                        '/${megaProvider.flashDealList[index].thumbnail}',
                                    imageErrorBuilder: (c, o, s) => Image.asset(
                                        Images.placeholder,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        megaProvider.flashDealList[index].name,
                                        style: robotoRegular,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                        PriceConverter.convertPrice(
                                            context,
                                            megaProvider
                                                .flashDealList[index].unitPrice,
                                            discountType: megaProvider
                                                .flashDealList[index]
                                                .discountType,
                                            discount: megaProvider
                                                .flashDealList[index].discount),
                                        style: robotoBold.copyWith(
                                            color: ColorResources.getPrimary(
                                                context)),
                                      ),
                                      SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Row(children: [
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (con) =>
                                                    CartBottomSheet(
                                                        product: megaProvider
                                                                .flashDealList[
                                                            index],
                                                        callback: () {
                                                          showCustomSnackBar(
                                                              getTranslated(
                                                                  'added_to_cart',
                                                                  context),
                                                              context,
                                                              isError: false);
                                                        }));
                                          },
                                          child: Icon(
                                              Icons.add_shopping_cart_sharp,
                                              color: Provider.of<ThemeProvider>(
                                                          context)
                                                      .darkTheme
                                                  ? Colors.white
                                                  : Colors.orange,
                                              size: 25),
                                        ),
                                        Expanded(
                                          child: Text(
                                            megaProvider.flashDealList[index]
                                                        .discount >
                                                    0
                                                ? PriceConverter.convertPrice(
                                                    context,
                                                    megaProvider
                                                        .flashDealList[index]
                                                        .unitPrice)
                                                : '',
                                            style: robotoBold.copyWith(
                                              color: ColorResources
                                                  .HINT_TEXT_COLOR,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          megaProvider.flashDealList[index]
                                                      .rating.length !=
                                                  0
                                              ? double.parse(megaProvider
                                                      .flashDealList[index]
                                                      .rating[0]
                                                      .average)
                                                  .toStringAsFixed(1)
                                              : '0.0',
                                          style: robotoRegular.copyWith(
                                              color: Provider.of<ThemeProvider>(
                                                          context)
                                                      .darkTheme
                                                  ? Colors.white
                                                  : Colors.orange,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                        ),
                                        Icon(Icons.star,
                                            color: Provider.of<ThemeProvider>(
                                                        context)
                                                    .darkTheme
                                                ? Colors.white
                                                : Colors.orange,
                                            size: 15),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            ]),

                        // Off
                        megaProvider.flashDealList[index].discount >= 1
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 60,
                                  height: 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: ColorResources.getPrimary(context),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                  child: Text(
                                    PriceConverter.percentageCalculation(
                                      context,
                                      megaProvider
                                          .flashDealList[index].unitPrice,
                                      megaProvider
                                          .flashDealList[index].discount,
                                      megaProvider
                                          .flashDealList[index].discountType,
                                    ),
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).highlightColor,
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ]),
                    ),
                  );
                },
              )
            : MegaDealShimmer(isHomeScreen: widget.isHomeScreen);
      },
    );
  }
}

class MegaDealShimmer extends StatelessWidget {
  final bool isHomeScreen;

  MegaDealShimmer({@required this.isHomeScreen});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: isHomeScreen ? Axis.horizontal : Axis.vertical,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorResources.WHITE,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5)
              ]),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled:
                Provider.of<FlashDealProvider>(context).flashDealList.length ==
                    0,
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  decoration: BoxDecoration(
                    color: ColorResources.ICON_BG,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20, color: ColorResources.WHITE),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Row(children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 20,
                                      width: 50,
                                      color: ColorResources.WHITE),
                                ]),
                          ),
                          Container(
                              height: 10,
                              width: 50,
                              color: ColorResources.WHITE),
                          Icon(Icons.star, color: Colors.orange, size: 15),
                        ]),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
