import 'package:AirTours/views/Global/global_var.dart';
import 'package:AirTours/views/Global/ticket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/pages_route.dart';
import '../../services/cloud/cloud_booking.dart';
import '../../services/cloud/firestore_booking.dart';
import '../../services/cloud/firestore_ticket.dart';

class Creditcard extends StatefulWidget {
  final String id1;
  final String paymentFor;
  final String id2;
  final String flightClass;
  final List<Ticket> tickets;
  const Creditcard(
      {super.key,
      required this.id1,
      required this.id2,
      required this.flightClass,
      required this.tickets,
      required this.paymentFor});

  @override
  State<Creditcard> createState() => _CreditcardState();
}

class _CreditcardState extends State<Creditcard> {
  final formKey = GlobalKey<FormState>();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardName = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  late final TicketFirestore _ticketService;
  late final BookingFirestore _bookingService;
  CloudBooking? booking;

  @override
  void initState() {
    super.initState();
    _bookingService = BookingFirestore();
    _ticketService = TicketFirestore();
  }

  Future<String> createBooking(double totalPrice) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final bookingUserId = user!.uid;
    if (widget.id2 == 'none') {
      booking = await _bookingService.createNewBooking(
          bookingClass: widget.flightClass,
          bookingPrice: totalPrice,
          departureFlight: widget.id1,
          returnFlight: 'none',
          numOfSeats: count,
          bookingUserId: bookingUserId);
      final bookingRef = booking!.documentId;
      return bookingRef;
    } else {
      booking = await _bookingService.createNewBooking(
          bookingClass: widget.flightClass,
          bookingPrice: totalPrice,
          departureFlight: widget.id1,
          returnFlight: widget.id2,
          numOfSeats: count,
          bookingUserId: bookingUserId);
      final bookingRef = booking!.documentId;
      return bookingRef;
    }
  }

  void toNext(List<Ticket> alltickets) async {
    double totalBookingPrice = 0;
    for (var x in alltickets) {
      totalBookingPrice = totalBookingPrice + x.ticketPrice;
    }

    final tmp = await createBooking(totalBookingPrice);

    alltickets.forEach((ticket) async {
      await _ticketService.createNewTicket(
          firstName: ticket.firstName,
          middleName: ticket.middleName,
          checkInStatus: ticket.checkInStatus,
          bagQuantity: ticket.bagQuantity,
          mealType: ticket.mealType,
          lastName: ticket.lastName,
          ticketPrice: ticket.ticketPrice,
          bookingReference: tmp,
          ticketUserId: '1',
          birthDate: ticket.birthDate,
          flightReference: ticket.flightReference,
          ticketClass: widget.flightClass);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Form(
            key: formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          CardNumber(),
                        ],
                        controller: cardNumber,
                        decoration: const InputDecoration(
                          labelText: "Card Number",
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a card number";
                          }
                          // if (!RegExp(r'^\d{19}$').hasMatch(value)) {
                          //   return "Enter a valid card number aziz";
                          // }
                          if (value.length != 22) {
                            return "Enter a valid card number";
                          }
                          return null;
                        },
                      ),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        controller: cardName,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "You did not enter your first name";
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return 'Please enter a valid name';
                          }
                          return null;
                        },
                      ),
                    )),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              controller: cvv,
                              decoration: const InputDecoration(
                                labelText: "CVV",
                                hintText: "Enter the 3 digit number",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter enter a CVV";
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                CardExpiry(),
                              ],
                              controller: expiryDate,
                              decoration: const InputDecoration(
                                labelText: "Expiry date",
                                hintText: "MM/YY",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                int month = int.parse(value!.substring(0, 2));
                                int year = int.parse(value.substring(3, 5));

                                if (value.isEmpty) {
                                  return "Enter a Expiry Date";
                                }
                                if (month > 12 && year < 23) {
                                  return "Enter Expiry Date correctly";
                                }
                                if (month > 12) {
                                  return "Enter month Date correctly";
                                }
                                if (year < 23) {
                                  return "Enter year Date correctly";
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue),
                            child: const Center(
                                child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ))),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (formKey.currentState!.validate()) {
                              if (widget.paymentFor == 'booking') {
                                toNext(widget.tickets);
                              } else if (widget.paymentFor == "upgrade") {}
                            }
                          });
                        },
                        child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue),
                            child: const Center(
                                child: Text(
                              "Confirm Payment",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ))),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}

class CardNumber extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;
      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  ");
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}

class CardExpiry extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (var i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var index = i + 1;
      if (index % 2 == 0 && index != newText.length) {
        buffer.write("/");
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}
