import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form.dart';

class FirstStep extends StatelessWidget {
  const FirstStep({super.key});

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context);

    return Scaffold(
      // Added Scaffold here
      appBar: AppBar(
          title: const Text('First Step')), // Optionally include an AppBar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text(
                  'Do you find joy in taking leisurely walks?',
                  style: TextStyle(color: Colors.black, fontFamily: 'poppins'),
                ),
                value: formProvider.formModel.walking,
                onChanged: (value) {
                  formProvider.updateFormModel('walking', value);
                },
              ),
              if (formProvider.formModel.walking)
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "What's your walking tempo?",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                            color: Colors.white, fontFamily: 'poppins'),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: formProvider.formModel.walkingSpeed.isNotEmpty
                              ? formProvider.formModel.walkingSpeed
                              : null,
                          items: ['Slow', 'Moderate', 'Fast']
                              .map((speed) => DropdownMenuItem(
                                  value: speed, child: Text(speed)))
                              .toList(),
                          style: const TextStyle(
                              color: Colors.black, fontFamily: 'poppins'),
                          onChanged: (value) {
                            formProvider.updateFormModel('walkingSpeed', value);
                          },
                          dropdownColor: const Color(0xff282929),
                        ),
                      ),
                    );
                  },
                ),
              // Add more fields similarly as needed
            ],
          ),
        ),
      ),
    );
  }
}
