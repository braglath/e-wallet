import 'package:e_wallet/app/data/model/card_model.dart';
import 'package:e_wallet/app/data/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_wallet/app/modules/add/controllers/add_controller.dart';
import 'package:e_wallet/app/modules/add/views/add_view.dart';
import 'package:e_wallet/app/modules/home/controllers/home_controller.dart';
import 'package:e_wallet/app/modules/more/controllers/more_controller.dart';
import 'package:e_wallet/app/modules/more/views/more_view.dart';
import 'package:e_wallet/app/views/views/top_to_bottom_animation_view.dart';

class HomeView extends GetView<HomeController> {
  @override
  final addController = Get.put<AddController>(AddController());
  final moreController = Get.put<MoreController>(MoreController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TopToBottomAnimationView(
              duration: Duration(milliseconds: 800), child: Text('E-Wallet')),
          titleTextStyle:
              GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
          centerTitle: true,
          actions: <Widget>[
            Obx(() {
              return IconButton(
                  splashRadius: 12,
                  onPressed: () => controller.themeSwitcher(),
                  icon: FaIcon(
                    controller.isDarkMode.value
                        ? FontAwesomeIcons.moon
                        : FontAwesomeIcons.lightbulb,
                    color: controller.isDarkMode.value
                        ? Colors.white
                        : Colors.amber,
                    size: 18,
                  ));
            })
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelStyle: GoogleFonts.roboto(fontSize: 15),
            tabs: controller.myTabs,
            controller: controller.tabController,
          ),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   // extendedPadding: EdgeInsets.symmetric(horizontal: 10),
        //   // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        //   onPressed: () => controller.scrollToAddProductPage(),
        //   label: Text(
        //     'Add product',
        //     style:
        //         GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: TabBarView(
          controller: controller.tabController,
          children: [_homeBody(), AddView(), MoreView()],
        ));
  }

  Widget _homeBody() => SafeArea(
        child: FutureBuilder(
            future: controller.refreshCards(),
            builder: (context, snapshot) {
              return Obx(() {
                return ListView.builder(
                    itemCount: controller.cards.length,
                    itemBuilder: (context, index) {
                      if (controller.cards.isEmpty) {
                        return ElevatedButton(
                          onPressed: () => controller.scrollToAddProductPage(),
                          child: Text(
                            'Add product',
                            style: GoogleFonts.roboto(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        final cardDetails = controller.cards[index];
                        print(index);
                        print('${controller.cards[index].id}');
                        return cardsMain(context, cardDetails, index);
                      }
                    });
              });
            }),
      );

  Padding cardsMain(BuildContext context, CardModel cardDetails, int index) {
    print('card color - ${cardDetails.cardColor}');
    String removeColortext = cardDetails.cardColor.replaceAll('Color', '');
    String removeBracketLeft = removeColortext.replaceAll('(', '');
    String cardColor = removeBracketLeft.replaceAll(')', '');
    print(cardColor);
    String cardNumber = cardDetails.number.toString();
    String firstFourNumbers = cardNumber.substring(0, 4);
    String lastFourNumbers = cardNumber.substring(12);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color(int.parse(cardColor)),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardDetails.name,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  RichText(
                    text: TextSpan(
                      text: firstFourNumbers,
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                          fontWeight: FontWeight.w300, letterSpacing: 2),
                      children: <TextSpan>[
                        TextSpan(
                          text: '********',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 2),
                        ),
                        TextSpan(
                          text: lastFourNumbers,
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Exp on - ',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: cardDetails.expDate.toString(),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () =>
                  controller.deleteCard(controller.cards[index].id!),
              icon: FaIcon(
                FontAwesomeIcons.trash,
                color: Colors.white,
                size: 20,
              )),
          Positioned(
            bottom: 5,
            right: 15,
            child: Stack(
              alignment: Alignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.ccMastercard,
                  size: 50,
                  color: Colors.white,
                ),
                Text(
                  'american express',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 8),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}