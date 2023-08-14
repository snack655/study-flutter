import 'package:flutter/material.dart';
import 'package:medi/components/medi_constants.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const CloseButton()),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "어떤 약이예요?",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: largeSpace),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  child: MaterialButton(
                    onPressed: () {},
                    child: const Icon(
                      Icons.photo_camera,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: largeSpace + regularSpace),
              Text(
                "약 이름",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextFormField(
                controller: _nameController,
                maxLength: 20,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: "복용할 약 이름을 기입해주세요.",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  contentPadding: textFieldContentPadding,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: submitButtonBoxPadding,
          child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
              child: const Text('다음'),
            ),
          ),
        ),
      ),
    );
  }
}