import 'dart:io';

import 'package:checkout_screen_ui/checkout_page.dart';
import 'package:flutter/material.dart';

class MyDemoPage extends StatelessWidget {
  final int? money;
  const MyDemoPage({Key? key, this.money}) : super(key: key);

  /// REQUIRED: (If you are using native pay option)
  ///
  /// A function to handle the native pay button being clicked. This is where
  /// you would interact with your native pay api
  Future<void> _nativePayClicked(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Native Pay requires setup')),
    );
  }

  /// REQUIRED: (If you are using cash pay option)
  ///
  /// A function to handle the cash pay button being clicked. This is where
  /// you would integrate whatever logic is needed for recording a cash transaction
  Future<void> _cashPayClicked(BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cash Pay requires setup')));
  }

  @override
  Widget build(BuildContext context) {
    final demoOnlyStuff = DemoOnlyStuff();

    /// RECOMENDED: A global Key to access the credit card pay button options
    ///
    /// If you want to interact with the payment button icon, you will need to
    /// create a global key to pass to the checkout page. Without this key
    /// the the button will always display 'Pay'. You may view several ways to
    /// interact with the button elsewhere within this example.
    final GlobalKey<CardPayButtonState> payBtnKey =
        GlobalKey<CardPayButtonState>();

    /// REQUIRED: A function to handle submission of credit card form
    ///
    /// A function is needed to handle your caredit card api calls.
    ///
    /// NOTE: This function in our demo example is under the widget's 'build'
    /// method only becuase it needs access to an instance variable. There is
    /// no requirement to have this function built here in live code.
    Future<void> _creditPayClicked(CardFormResults results) async {
      // you can update the pay button to show somthing is happening
      payBtnKey.currentState?.updateStatus(CardPayButtonStatus.processing);

      // This is where you would implement you Third party credit card
      // processing api
      demoOnlyStuff.callTransactionApi(payBtnKey);

      // ignore: avoid_print
      print(results);
      // WARNING: you should NOT print the above out using live code
    }

    /// REQUIRED: A list of what the user is buying
    ///
    /// A list of item will be needed to pass into the checkout page. This is a
    /// simple demo array of [PriceItem]s used to make the demo work. The total
    /// price is automatically added later.
    ///
    /// **NOTE:**
    /// It is recomended to have no more that 10 items when using the
    /// current version due to limits of scrollability
    final List<PriceItem> priceItems = [
      PriceItem(
        name: 'Donation',
        quantity: 1,
        totalPriceCents: money!,
      ),
    ];

    /// REQUIRED: A name representing the reciever of the funds from user
    ///
    /// Demo vendor name provided here. User's need to know who is recieving
    /// their money
    const String payToName = 'Cherty';

    /// REQUIRED: (if you are using the native pay options)
    ///
    /// Determine whether this platform is iOS. This affects which native pay
    /// option appears. This is the most basic form of logic needed. You adjust
    /// this logic based on your app's needs and the platforms you are
    /// developing for.
    final isApple = Platform.isIOS;

    /// RECOMENDED: widget to display at footer of page
    ///
    /// Apple and Google stores typically require a link to privacy and terms when
    /// your app is collecting and/or transmitting sensitive data. This link is
    /// expected on the same page as the form that the user is filling out. You
    /// can make this any type of widget you want, but we have created a prebuilt
    /// [CheckoutPageFooter] widget that just needs the corresponding links
    const footer = CheckoutPageFooter(
      // These are example url links only. Use your own links in live code
      privacyLink: 'https://stripe.com/privacy',
      termsLink: 'https://stripe.com/payment-terms/legal',
      note: 'Powered By Stripe',
      noteLink: 'https://stripe.com/',
    );

    /// OPTIONAL: A function for the back button
    ///
    /// This to be used as needed. If you have another back button built into your
    /// app, you can leave this function null. If you need a back button function,
    /// simply add the needed logic here. The minimum required in a simple
    /// Navigator.of(context).pop() request
    Function? onBack = Navigator.of(context).canPop()
        ? () => Navigator.of(context).pop()
        : null;

    // Put it all together
    return Scaffold(
      appBar: null,
      body: CheckoutPage(
        priceItems: priceItems,
        payToName: payToName,
        displayNativePay: true,
        onNativePay: () => _nativePayClicked(context),
        displayCashPay: true,
        onCashPay: () => _cashPayClicked(context),
        isApple: isApple,
        onCardPay: (results) => _creditPayClicked(results),
        onBack: onBack,
        payBtnKey: payBtnKey,
        displayTestData: true,
        footer: footer,
      ),
    );
  }
}

/// This class is meant to help separate logic that is only used within this demo
/// and not expected to resemble logic needed in live code. That said there may
/// exist some logic that is help to use in live code, such as calls to the
/// [CardPayButtonState] key to update its displayed color and icon.
class DemoOnlyStuff {
  // DEMO ONLY:
  // this variable is only used for this demo.
  bool shouldSucceed = true;

  // DEMO ONLY:
  // In this demo, this function is used to delay the reseting of the pay
  // button state in order to allow the user to resubmit the form.
  // If you API calls a failing a transaction, you may need a similar function
  // to update the button from CardPayButtonStatus.fail to
  // CardPayButtonStatus.success. The user will not be able to submit another
  // payment until the button is reset.
  Future<void> provideSomeTimeBeforeReset(
    GlobalKey<CardPayButtonState> payBtnKey,
  ) async {
    await Future.delayed(const Duration(seconds: 2), () {
      payBtnKey.currentState?.updateStatus(CardPayButtonStatus.ready);
      return;
    });
  }

  Future<void> callTransactionApi(
    GlobalKey<CardPayButtonState> payBtnKey,
  ) async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (shouldSucceed) {
        payBtnKey.currentState?.updateStatus(CardPayButtonStatus.success);
        shouldSucceed = false;
      } else {
        payBtnKey.currentState?.updateStatus(CardPayButtonStatus.fail);
        shouldSucceed = true;
      }
      provideSomeTimeBeforeReset(payBtnKey);
      return;
    });
  }
}
