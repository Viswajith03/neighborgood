import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form.dart';

class SecondStep extends StatelessWidget {
  const SecondStep({super.key});

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text(
            'Are you open to offering rides to your neighbors?',
            overflow: TextOverflow.ellipsis, // Ensures ellipsis for long titles
          ),
          value: formProvider.formModel.rides,
          onChanged: (value) {
            formProvider.updateFormModel('rides', value);
          },
        ),
        if (formProvider.formModel.rides)
          SizedBox(
            width: double.infinity, // Ensures dropdown takes up available width
            child: DropdownButtonFormField<String>(
              value: formProvider.formModel.ridesType.isNotEmpty
                  ? formProvider.formModel.ridesType
                  : null,
              items: [
                'Work Commutes',
                'School Runs',
                'Medical Appointments',
                'Emergency Rides'
              ]
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                formProvider.updateFormModel('ridesType', value);
              },
              hint: const Text(
                "What types of rides are you comfortable offering?",
                overflow: TextOverflow.ellipsis, // Ensures ellipsis here too
              ),
            ),
          ),
        SwitchListTile(
          title: const Text(
            'Would you consider offering childcare support to your neighbors?',
            overflow: TextOverflow.ellipsis, // Ensures ellipsis for long titles
          ),
          value: formProvider.formModel.childcare,
          onChanged: (value) {
            formProvider.updateFormModel('childcare', value);
          },
        ),
        // Include TextOverflow.ellipsis for other titles as well (optional)
      ],
    );
  }
}
