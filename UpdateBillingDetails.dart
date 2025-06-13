import 'package:flutter/material.dart';

class UpdateBillingDetailsScreen extends StatefulWidget {
  const UpdateBillingDetailsScreen({super.key});

  @override
  State<UpdateBillingDetailsScreen> createState() => _UpdateBillingDetailsScreenState();
}

class _UpdateBillingDetailsScreenState extends State<UpdateBillingDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameOnCardController = TextEditingController();
  String _paymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Billing Details"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(labelText: "Payment Method"),
                items: ['Credit Card', 'PayPal'] // not sure about Paypal? if needs to be included
                    .map((method) => DropdownMenuItem(
                  value: method,
                  child: Text(method),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              if (_paymentMethod == 'Credit Card') ...[
                TextFormField(
                  controller: _nameOnCardController,
                  decoration: const InputDecoration(labelText: 'Name on Card'),
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter cardholder name' : null,
                ),
                TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter card number' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryDateController,
                        decoration: const InputDecoration(labelText: 'MM/YY'),
                        validator: (value) =>
                        value!.isEmpty ? 'Enter expiry date' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: const InputDecoration(labelText: 'CVV'),
                        validator: (value) =>
                        value!.isEmpty ? 'Enter CVV' : null,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton.icon(
                // icon: const Icon(Icons.check),
                label: const Text("SAVE",
                style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
                ),


                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Need to Integrate with backend Stripe. not sure about paypal though if needs to be inclued as HLR doc mentiones it.

                    ScaffoldMessenger.of(context).showSnackBar( // this needs to be async with backend
                      const SnackBar(content: Text('Billing details updated')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.zero,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _nameOnCardController.dispose();
    super.dispose();
  }
}
