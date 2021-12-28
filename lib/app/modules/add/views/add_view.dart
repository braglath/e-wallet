import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:e_wallet/app/data/storage/user_details_storage.dart';
import 'package:e_wallet/app/data/theme/theme_service.dart';
import 'package:e_wallet/app/data/utils/color_resources.dart';
import '../controllers/add_controller.dart';

class AddView extends GetView<AddController> {
  final List<String> cardTypeList = [
    'Pick card type',
    'Debit',
    'Credit',
  ];

  final List<String> cardManufacturerList = [
    'Pick card manufacturer',
    'Visa',
    'MasterCard',
    'RuPay',
    'American Express',
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
            : 'Name';

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            _name(),
            _cardNumber(),
            _cardExpDate(context),
            _cardType(context),
            _cardManufacturer(context),
            _cardColorPicker(context),
            SizedBox(height: 20),
            _addCardButton(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _name() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
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
              labelText: 'Name',
            )),
      );

  Widget _cardNumber() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            validator: (value) => controller.cardValidator(value),
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
              labelText: 'Card number',
            )),
      );

  Widget _cardExpDate(context) => Obx(() {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exp date',
                  style: Theme.of(context).textTheme.headline4,
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
              ? 'MM/YYYY'
              : controller.formattedDate.value.toString(),
          style: Theme.of(context).textTheme.headline5?.copyWith(
              fontSize: 20,
              color: ThemeService().theme == ThemeMode.light
                  ? ColorResourcesLight.mainLIGHTColor
                  : Colors.white),
        ),
        ElevatedButton(
            onPressed: () => controller.selectDate(context),
            child: Text('Pick date'))
      ],
    );
  }

  Widget _cardType(context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type',
              style: Theme.of(context).textTheme.headline4,
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
            Text(
              'Manufacturer',
              style: Theme.of(context).textTheme.headline4,
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
                      'Select card color',
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
        child: Text(
          'Add Card',
          style: Theme.of(context)
              .textTheme
              .headline3
              ?.copyWith(color: Colors.white, fontSize: 22),
        ),
      ));
}
