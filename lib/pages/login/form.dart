import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neighborgood/pages/login/second_step.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/constants.dart';
import 'first_step.dart';
import 'formproviders.dart';

class FormProvider with ChangeNotifier {
  final FormModel _formModel = FormModel();

  FormModel get formModel => _formModel;

  void updateFormModel(String key, dynamic value) {
    switch (key) {
      case 'walking':
        _formModel.walking = value;
        break;
      case 'walkingSpeed':
        _formModel.walkingSpeed = value;
        break;
      case 'running':
        _formModel.running = value;
        break;
      case 'runningType':
        _formModel.runningType = value;
        break;
      case 'dog':
        _formModel.dog = value;
        break;
      case 'dogWalks':
        _formModel.dogWalks = value;
        break;
      case 'gardening':
        _formModel.gardening = value;
        break;
      case 'swimming':
        _formModel.swimming = value;
        break;
      case 'swimmingPlace':
        _formModel.swimmingPlace = value;
        break;
      case 'coffeeTea':
        _formModel.coffeeTea = value;
        break;
      case 'coffeeTeaPlace':
        _formModel.coffeeTeaPlace = value;
        break;
      case 'art':
        _formModel.art = value;
        break;
      case 'artType':
        _formModel.artType = value;
        break;
      case 'foodGathering':
        _formModel.foodGathering = value;
        break;
      case 'foodGatheringType':
        _formModel.foodGatheringType = value;
        break;
      case 'sports':
        _formModel.sports = value;
        break;
      case 'sportsType':
        _formModel.sportsType = value;
        break;
      case 'movies':
        _formModel.movies = value;
        break;
      case 'movieType':
        _formModel.movieType = value;
        break;
      case 'shopping':
        _formModel.shopping = value;
        break;
      case 'shoppingType':
        _formModel.shoppingType = value;
        break;
      case 'happyHours':
        _formModel.happyHours = value;
        break;
      case 'happyHoursType':
        _formModel.happyHoursType = value;
        break;
      case 'rides':
        _formModel.rides = value;
        break;
      case 'ridesType':
        _formModel.ridesType = value;
        break;
      case 'childcare':
        _formModel.childcare = value;
        break;
      case 'childcareType':
        _formModel.childcareType = value;
        break;
      case 'eldercare':
        _formModel.eldercare = value;
        break;
      case 'eldercareType':
        _formModel.eldercareType = value;
        break;
      case 'petcare':
        _formModel.petcare = value;
        break;
      case 'petcareType':
        _formModel.petcareType = value;
        break;
      case 'repairAdvice':
        _formModel.repairAdvice = value;
        break;
      case 'repairAdviceType':
        _formModel.repairAdviceType = value;
        break;
      case 'tutoring':
        _formModel.tutoring = value;
        break;
      case 'tutoringType':
        _formModel.tutoringType = value;
        break;
    }
    notifyListeners();
  }
}

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context);

    void submitForm() async {
      setState(() {
        _isLoading = true;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        if (token == null) {
          throw Exception('Token not found');
        }

        final formData = formProvider.formModel.toJson();

        final response = await http.post(
          Uri.parse("${Constants.apiUrl}/update_interests/"),
          body: jsonEncode(formData),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        print('API Response: ${response.body}');
        print('Data Sent: $formData');

        setState(() {
          _isLoading = false;
        });

        // Handle response and navigation here
      } catch (error) {
        setState(() {
          _isLoading = false;
        });

        print('API Error: $error');
        // Handle error
        // toast.error(error.toString());
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Neighborgood",
          style: TextStyle(
            fontFamily: 'poppins',
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xffE49C17),
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Theme(
        data: ThemeData(
          dividerColor: const Color(0xffE49C17),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 1) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              submitForm();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          steps: [
            Step(
              title: const Text(
                'Step 1',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'poppinsbold',
                  fontSize: 18, // Customize the font size
                ),
              ),
              content: FirstStep(), // Use FirstStep widget here
            ),
            Step(
              title: const Text(
                'Step 2',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'poppinsbold',
                  fontSize: 18, // Customize the font size
                ),
              ),
              content: SecondStep(), // Use SecondStep widget here
            ),
          ],
        ),
      ),
      floatingActionButton: _currentStep == 1
          ? FloatingActionButton(
              onPressed: submitForm,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : const Icon(Icons.check),
            )
          : null,
    );
  }
}
