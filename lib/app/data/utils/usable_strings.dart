class AppTitle {
  static const String appTitle = 'E-Wallet lite';
}

class AdUnitID {
  static const String androidValueAppID =
      "ca-app-pub-8309697684472469~5667037334";
  static const String bannerHome = 'ca-app-pub-3940256099942544/6300978111';
  static const String bannerMore = 'ca-app-pub-3940256099942544/6300978111';
  static const String intertitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const String appOpen = 'ca-app-pub-3940256099942544/3419835294';
}

class AssetStrings {
  static const cardGlitter = 'assets/images/glitter.jpg';
}

class CardManufacturers {
  static const pickCardManufacturer = 'Pick card manufacturer';
  static const visa = 'Visa';
  static const master = 'MasterCard';
  static const rupay = 'RuPay';
  static const americaExp = 'American Express';
}

class CardType {
  static const String pickCardType = 'Pick card type';
  static const debit = 'Debit';
  static const credit = 'Credit';
}

class TabNames {
  static const home = 'Home';
  static const add = 'Add';
  static const more = 'More';
}

class MainStrings {
  static const String checkFingerprint = 'Check fingerprint';
  static const String name = 'Name';
  static const String confirm = 'Confirm';
  static const String cancel = 'Cancel';
  static const String camera = 'Camera';
  static const String gallery = 'Gallery';
  // static const String profileHeroTag = 'profileicon';
  static const String toggleSecureMode = 'Toggle secure mode';
  static const String addCard = 'Add card';
  static const String removeCard = 'Remove card?';
  static const String cardNumber = 'Card number';
  static const String cvvNumber = 'CVV number';
  static const String expDate = 'Exp date';
  static const String pickDate = 'Pick date';
  static const String mmyy = 'MM/YYYY';
  static const String type = 'Type';
  static const String success = 'Success';
  static const String warning = 'Warning';
}

//! Home Page
class HomeViewPageStrings {
  static const String fabToolTipScrollTop = 'scroll to top';
  static const String fabToolTipScrollBottom = 'scroll to bottom';
  static const String noCardsAdded = "You havn't added any card yet";
  static const String aboutToRemoveCard =
      'You are about to remove this card.\nThis cannot be undone';
}

class HomeControllerPageStrings {
  static const String cardRemovedSucc = 'Card removed successfully';
  static const String exitingApp = 'Exiting the app';
  static const String pressBackAgain =
      'Press back button again to exit the app';
  static const String cardnumberWillBeHidden =
      'Card number will be hidden in 5 seconds';
  static const String cvvnumberWillBeHidden =
      'CVV number will be hidden in 5 seconds';
}
//!

//! Add Page
class AddViewPageStrings {
  static const String manufacturer = 'Manufacturer';
  static const String selectCardColor = 'Select card color';
  static const String tooltipName = 'Name on card';
  static const String tooltipCardNumber =
      'Card number will not be shown to anyone without fingerprint/pin authentication';
  static const String tooltipExpDate = 'Card expiry date';
  static const String tooltipCvvNumber =
      '3 digit number behind your card\nCVV number will not to show to anyone without fingerprint/pin authentication';
  static const String tooltipCardType =
      'Select what type of card this is by using the dropdown below';
  static const String tooltipCardManufacturer =
      'Select your card manufacturer by using the dropdown below';
  static const String note = 'Note';
  static const String noteContent =
      '- Longpress on icons with ? to get tool tip\n- Fields with ? are required and cannot be empty\n- Your card number and cvv number will not be shown to anyone without fingerprint/pin authentication';
}

class AddControllerPageStrings {
  static const String nameEmpty = 'Name cannot be empty';
  static const String noSpclCharc = 'Cannot have special characters or numbers';
  static const String numberEmpty = 'Card number cannot be empty';
  static const String onlyNumbers = 'Only numbers are accepted here';
  static const String noLess16Charc = 'Cannot be less than 16 characters';
  static const String cvvEmpty = 'CVV number cannot be empty';
  static const String noLess3Charc = 'Cannot be less than 3 characters';
  static const String enterAllCardDetails = 'Enter all card details';
  static const String cardAddedSuccess = 'Card added successfully';
}
//!

//! More Page
class MoreViewPageStrings {
  static const String secureCaption =
      'Secure mode prevents users from taking screenshots or screen recording';
}

class MoreControllerPageStrings {
  static const String failedPickImage = 'Failed to pick image';
  static const String fingerAuthSucc = 'Fingerprint authentication successful';
  static const String fingerAuthErr = 'Fingerprint error';
}
//!
