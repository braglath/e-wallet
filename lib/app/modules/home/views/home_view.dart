import 'dart:io';
import 'package:e_wallet/app/data/services/google_ad_service.dart';
import 'package:e_wallet/app/views/views/custom_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_wallet/app/data/model/card_model.dart';
import 'package:e_wallet/app/data/storage/user_details_storage.dart';
import 'package:e_wallet/app/data/theme/theme_service.dart';
import 'package:e_wallet/app/data/utils/color_resources.dart';
import 'package:e_wallet/app/modules/add/controllers/add_controller.dart';
import 'package:e_wallet/app/modules/add/views/add_view.dart';
import 'package:e_wallet/app/modules/home/controllers/home_controller.dart';
import 'package:e_wallet/app/modules/more/controllers/more_controller.dart';
import 'package:e_wallet/app/modules/more/views/more_view.dart';
import 'package:e_wallet/app/views/views/faded_scale_animation.dart';
import 'package:e_wallet/app/views/views/top_to_bottom_animation_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeView extends GetView<HomeController> {
  @override
  final addController = Get.put<AddController>(AddController());
  final moreController = Get.put<MoreController>(MoreController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.pressBackAgainToExit(),
      child: Scaffold(
          appBar: AppBar(
            title: TopToBottomAnimationView(
                duration: Duration(milliseconds: 800),
                child: RichText(
                  text: TextSpan(
                    text: 'E-',
                    style: GoogleFonts.roboto(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Wallet',
                      ),
                      TextSpan(
                          text: ' lite',
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                          )),
                    ],
                  ),
                )),
            titleTextStyle:
                GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
            centerTitle: true,
            leading: Obx(() {
              return IconButton(
                  splashRadius: 12,
                  onPressed: () => controller.themeSwitcher(),
                  icon: FaIcon(
                    controller.isDarkMode.value
                        ? FontAwesomeIcons.lightbulb
                        : FontAwesomeIcons.moon,
                    color: Colors.white,
                    size: 18,
                  ));
            }),
            actions: <Widget>[_profileImage(context)],
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4,
              labelStyle: GoogleFonts.roboto(fontSize: 15),
              tabs: controller.myTabs,
              controller: controller.tabController,
            ),
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: Obx(() {
            return controller.shouldAutoscroll.value &&
                    controller.tabController.index == 0
                ? FadedScaleAnimation(
                    FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        tooltip: 'scroll to top',
                        child: FaIcon(
                          FontAwesomeIcons.chevronUp,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.scrollToTop();
                          // print(controller.scrollController.value);
                        }),
                  )
                : controller.cards.length > 3 &&
                        controller.tabController.index == 0
                    ? FadedScaleAnimation(
                        FloatingActionButton(
                            heroTag: null,
                            mini: true,
                            tooltip: 'scroll to bottom',
                            child: FaIcon(
                              FontAwesomeIcons.chevronDown,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              controller.scrollToBottomm();
                              // print(controller.scrollController.value);
                            }),
                      )
                    : SizedBox.shrink();
          }),
          body: TabBarView(
            controller: controller.tabController,
            children: [_homeBody(), AddView(), MoreView()],
          )),
    );
  }

  Widget _homeBody() => Scaffold(
        bottomNavigationBar: SizedBox(
          height: 100,
          child: AdWidget(
            key: UniqueKey(),
            ad: AdMobService.createHomeBannerAd()..load(),
          ),
        ),
        extendBody: true,
        body: Obx(() {
          return Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder(
                  future: controller.refreshCards(),
                  builder: (context, snapshot) {
                    return Scrollbar(
                      child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 110),
                          controller: controller.scrollController.value,
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.cards.length,
                          itemBuilder: (context, index) {
                            final cardDetails = controller.cards[index];
                            // print(index);
                            // print('${controller.cards[index].id}');
                            return cardsMain(context, cardDetails, index);
                          }),
                    );
                  }),
              controller.cards.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You havn't added any card yet",
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ThemeService().theme == ThemeMode.light
                                  ? ColorResourcesLight.mainLIGHTColor
                                  : Colors.white),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () => controller.scrollToAddProductPage(1),
                          child: Text(
                            'Add card',
                            style: GoogleFonts.roboto(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink()
            ],
          );
        }),
      );

  Widget cardsMain(BuildContext context, CardModel cardDetails, int index) {
    // print('card color - ${cardDetails.cardColor}');
    String removeColortext = cardDetails.cardColor.replaceAll('Color', '');
    String removeBracketLeft = removeColortext.replaceAll('(', '');
    String cardColor = removeBracketLeft.replaceAll(')', '');
    // print(cardColor);
    String cardNumber = cardDetails.number.toString();
    String firstFourNumbers = cardNumber.substring(0, 4);
    String lastFourNumbers = cardNumber.substring(12);
    String middleFirstFourNumbers = cardNumber.substring(4, 8);
    String middleSecondFourNumbers = cardNumber.substring(8, 12);

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
              ],
              image: DecorationImage(
                image: AssetImage('assets/images/glitter.jpg'),
                fit: BoxFit.cover,
                invertColors: false,
                opacity: 0.1,
                colorFilter: ColorFilter.mode(
                    Color(int.parse(cardColor)), BlendMode.lighten),
              ),
            ),
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
                  GestureDetector(
                    onTap: () => controller.cardNumberAuthentication(),
                    child: Obx(() {
                      return RichText(
                        text: TextSpan(
                          text: firstFourNumbers,
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 2),
                          children: <TextSpan>[
                            TextSpan(
                              text: controller.showCardNumber.isFalse
                                  ? ' **** '
                                  : ' $middleFirstFourNumbers ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 2),
                            ),
                            TextSpan(
                              text: controller.showCardNumber.isFalse
                                  ? ' **** '
                                  : ' $middleSecondFourNumbers ',
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
                      );
                    }),
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Exp on - ',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              text: cardDetails.expDate.toString(),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      GestureDetector(
                        onTap: () => controller.cvvAuthentication(),
                        child: Obx(() {
                          return RichText(
                            text: TextSpan(
                              text: 'CVV - ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                  text: controller.showCvvNumber.isFalse
                                      ? ' *** '
                                      : ' ${cardDetails.cvvNumber.toString()} ',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                AdMobService().createInterAd();
                CustomDialogue(
                  title: 'Remove card?',
                  textConfirm: 'Confim',
                  textCancel: 'Cancel',
                  onpressedConfirm: () {
                    controller.deleteCard(controller.cards[index].id!);
                    AdMobService().showInterad();
                  },
                  onpressedCancel: () => Get.back(),
                  contentWidget: Text(
                    'You are about to remove this card.\nThis cannot be undone',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Colors.white),
                  ),
                  isDismissible: true,
                ).showDialogue();
              },
              icon: FaIcon(
                FontAwesomeIcons.trash,
                color: Colors.white,
                size: 20,
              )),
          Positioned(
            bottom: 5,
            right: 15,
            child: FaIcon(
              cardDetails.cardManufacturer.contains('Visa')
                  ? FontAwesomeIcons.ccVisa
                  : cardDetails.cardManufacturer.contains('MasterCard')
                      ? FontAwesomeIcons.ccMastercard
                      : cardDetails.cardManufacturer.contains('RuPay')
                          ? FontAwesomeIcons.moneyBillWaveAlt
                          : FontAwesomeIcons.ccAmex,
              size: 50,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _profileImage(BuildContext context) {
    // print('user profile pic ${UserDetails().readUserProfilePicfromBox()}');

    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          radius: 15,
          borderRadius: BorderRadius.circular(50),
          onTap: () => controller.scrollToAddProductPage(2),
          child: Hero(
            tag: 'profileicon',
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 14,
                child: CircleAvatar(
                  radius: 12,
                  child: UserDetails().readUserProfilePicfromBox().isEmpty
                      ? Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 18,
                        )
                      : null,
                  backgroundColor: ThemeService().theme == ThemeMode.light
                      ? ColorResourcesLight.mainLIGHTColor
                      : ColorResourcesDark.mainDARKColor,
                  foregroundImage: moreController.profilePicture.value.isEmpty
                      ? UserDetails().readUserProfilePicfromBox().isEmpty
                          ? null
                          : FileImage(
                              File(UserDetails().readUserProfilePicfromBox()),
                            )
                      : FileImage(
                          File(moreController.profilePicture.value),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
