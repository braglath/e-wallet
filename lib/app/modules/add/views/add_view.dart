import 'package:e_wallet/app/data/utils/usable_strings.dart';
import 'package:e_wallet/app/views/views/customtooltip_view.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:e_wallet/app/data/storage/user_details_storage.dart';
import 'package:e_wallet/app/data/theme/theme_service.dart';
import 'package:e_wallet/app/data/utils/color_resources.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/add_controller.dart';

class AddView extends GetView<AddController> {
  final List<String> cardTypeList = [
    CardType.pickCardType,
    CardType.debit,
    CardType.credit,
  ];

  final List<String> cardManufacturerList = [
    CardManufacturers.pickCardManufacturer,
    CardManufacturers.visa,
    CardManufacturers.master,
    CardManufacturers.rupay,
    CardManufacturers.americaExp,
  ];

  final List<IconData> cardManufacturerIconList = [
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.ccVisa,
    FontAwesomeIcons.ccMastercard,
    FontAwesomeIcons.moneyBillWaveAlt,
    FontAwesomeIcons.ccAmex,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainBody(context),
    );
  }

  SingleChildScrollView _mainBody(BuildContext context) {
    controller.nameController.text =
        UserDetails().readUserNamefromBox().contains('')
            ? UserDetails().readUserNamefromBox()
            : MainStrings.name;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            _note(context),
            SizedBox(height: 20),
            _name(context),
            _cardNumber(context),
            _cardExpDate(context),
            _cvvNumber(context),
            _cardType(context),
            _cardManufacturer(context),
            _cardColorPicker(context),
            SizedBox(height: 20),
            _addCardButton(context),
            SizedBox(height: 85),
          ],
        ),
      ),
    );
  }

  Widget _name(context) => Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                validator: (value) => controller.nameValidator(value),
                cursorColor: ThemeService().theme == ThemeMode.light
                    ? ColorResourcesLight.mainLIGHTColor
                    : Colors.white,
                style: TextStyle(
                    color: ThemeService().theme == ThemeMode.light
                        ? ColorResourcesLight.mainLIGHTColor
                        : Colors.white),
                controller: controller.nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: MainStrings.name,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Customtooltip(
              message: AddViewPageStrings.tooltipName,
            ),
          ),
        ],
      );

  Widget _cardNumber(context) => Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                validator: (value) => controller.cardValidator(value),
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                cursorColor: ThemeService().theme == ThemeMode.light
                    ? ColorResourcesLight.mainLIGHTColor
                    : Colors.white,
                style: TextStyle(
                    color: ThemeService().theme == ThemeMode.light
                        ? ColorResourcesLight.mainLIGHTColor
                        : Colors.white),
                controller: controller.numberController,
                maxLength: 16,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: MainStrings.cardNumber,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Customtooltip(
              message: AddViewPageStrings.tooltipCardNumber,
            ),
          ),
        ],
      );

  Widget _cardExpDate(context) => Obx(() {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      MainStrings.expDate,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Customtooltip(
                        message: AddViewPageStrings.tooltipExpDate,
                      ),
                    ),
                  ],
                ),
                expDate(context)
              ],
            ));
      });

  Row expDate(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          controller.formattedDate.value.isEmpty
              ? MainStrings.mmyy
              : controller.formattedDate.value.toString(),
          style: Theme.of(context).textTheme.headline5?.copyWith(
              fontSize: 20,
              color: ThemeService().theme == ThemeMode.light
                  ? ColorResourcesLight.mainLIGHTColor
                  : Colors.white),
        ),
        ElevatedButton(
          onPressed: () => controller.selectDate(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                MainStrings.pickDate,
              ),
              SizedBox(width: 10),
              FaIcon(FontAwesomeIcons.calendarAlt)
            ],
          ),
        )
      ],
    );
  }

  Widget _cvvNumber(context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              onEditingComplete: () => FocusScope.of(context).unfocus(),
              validator: (value) => controller.cvvValidator(value),
              cursorColor: ThemeService().theme == ThemeMode.light
                  ? ColorResourcesLight.mainLIGHTColor
                  : Colors.white,
              style: TextStyle(
                  color: ThemeService().theme == ThemeMode.light
                      ? ColorResourcesLight.mainLIGHTColor
                      : Colors.white),
              controller: controller.cvvController,
              maxLength: 3,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: MainStrings.cvvNumber,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Customtooltip(
            message: AddViewPageStrings.tooltipCvvNumber,
          ),
        ),
      ],
    );
  }

  Widget _cardType(context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  MainStrings.type,
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Customtooltip(
                    message: AddViewPageStrings.tooltipCardType,
                  ),
                ),
              ],
            ),
            cardTypePicker(),
          ],
        ),
      );

  Obx cardTypePicker() {
    return Obx(
      () {
        return DropdownButton<String>(
          isExpanded: true,
          value: controller.cardtype.toString(),
          icon: const Icon(Icons.arrow_downward_rounded),
          dropdownColor: ThemeService().theme == ThemeMode.light
              ? ColorResourcesLight.mainLIGHTColor
              : ColorResourcesDark.mainDARKColor,
          iconSize: 20,
          elevation: 16,
          underline: Container(),
          onChanged: (newValue) {
            controller.setCardType(newValue);
            // dropdownVal = newValue.toString();
          },
          items: List.generate(
            cardTypeList.length,
            (index) => DropdownMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  cardTypeList[index],
                  style: TextStyle(
                    color: ThemeService().theme == ThemeMode.light
                        ? ColorResourcesLight.mainTextHEADINGColor
                        : ColorResourcesDark.mainDARKTEXTICONcolor,
                    fontSize: 17,
                  ),
                ),
              ),
              value: cardTypeList[index],
            ),
          ),
        );
      },
    );
  }

  Widget _cardManufacturer(context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AddViewPageStrings.manufacturer,
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Customtooltip(
                    message: AddViewPageStrings.tooltipCardManufacturer,
                  ),
                ),
              ],
            ),
            cardManufacturerPicker(),
          ],
        ),
      );

  Obx cardManufacturerPicker() {
    return Obx(
      () {
        return DropdownButton<String>(
          dropdownColor: ThemeService().theme == ThemeMode.light
              ? ColorResourcesLight.mainLIGHTColor
              : ColorResourcesDark.mainDARKColor,
          isExpanded: true,
          value: controller.cardManufacturer.toString(),
          icon: const Icon(Icons.arrow_downward_rounded),
          iconSize: 20,
          elevation: 16,
          underline: Container(),
          onChanged: (newValue) {
            controller.setCardManufacturer(newValue);
            // dropdownVal = newValue.toString();
          },
          items: List.generate(
            cardManufacturerList.length,
            (index) => DropdownMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardManufacturerList[index],
                      style: TextStyle(
                        color: ThemeService().theme == ThemeMode.light
                            ? ColorResourcesLight.mainTextHEADINGColor
                            : ColorResourcesDark.mainDARKTEXTICONcolor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(cardManufacturerIconList[index])
                  ],
                ),
              ),
              value: cardManufacturerList[index],
            ),
          ),
        );
      },
    );
  }

  _cardColorPicker(context) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AddViewPageStrings.selectCardColor,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: controller.screenPickerColor.value,
                    ),
                  ],
                );
              }),
              SizedBox(
                height: 5,
              ),
              Card(
                color: ThemeService().theme == ThemeMode.light
                    ? ColorResourcesLight.mainLIGHTColor
                    : ColorResourcesDark.mainDARKColor,
                elevation: 4,
                child: ColorPicker(
                  pickersEnabled: {
                    ColorPickerType.accent: false,
                  },
                  enableShadesSelection: false,
                  // Use the screenPickerColor as start color.
                  color: controller.screenPickerColor.value,
                  // Update the screenPickerColor using the callback.
                  onColorChanged: (Color color) =>
                      controller.colorPicker(color),
                  width: 30,
                  height: 30,
                  borderRadius: 22,
                ),
              ),
            ],
          ),
        ),
      );

  _addCardButton(context) => ElevatedButton(
      onPressed: () => controller.addCard(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              MainStrings.addCard,
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  ?.copyWith(color: Colors.white, fontSize: 22),
            ),
            SizedBox(
              width: 10,
            ),
            FaIcon(FontAwesomeIcons.creditCard)
          ],
        ),
      ));

  Widget _note(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AddViewPageStrings.note,
              style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ThemeService().theme == ThemeMode.light
                      ? ColorResourcesLight.mainLIGHTColor
                      : ColorResourcesDark.mainDARKColor),
            ),
            Text(
              AddViewPageStrings.noteContent,
              style:
                  Theme.of(context).textTheme.caption?.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
}
