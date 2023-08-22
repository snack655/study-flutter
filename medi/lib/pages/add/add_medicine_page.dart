import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medi/components/medi_constants.dart';
import 'package:medi/components/medi_page_route.dart';
import 'package:medi/components/medi_widgets.dart';
import 'package:medi/main.dart';
import 'package:medi/models/medicine.dart';
import 'package:medi/pages/add/add_alarm_page.dart';

import '../bottomsheet/pick_image_bottomsheet.dart';
import 'components/add_page_widget.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({
    super.key,
    this.updateMedicineId = -1,
  });

  final int updateMedicineId;

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  late TextEditingController _nameController;
  File? _medicineImage;

  bool get _isUpdate => widget.updateMedicineId != -1;
  Medicine get _updateMedicine =>
      medicineRepository.medicineBox.values.singleWhere(
        (medicine) => medicine.id == widget.updateMedicineId,
      );

  @override
  void initState() {
    super.initState();

    if (_isUpdate) {
      _nameController = TextEditingController(text: _updateMedicine.name);
      if (_updateMedicine.imagePath != null) {
        _medicineImage = File(_updateMedicine.imagePath!);
      }
    } else {
      _nameController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const CloseButton()),
      body: SingleChildScrollView(
        child: AddPageBody(
          children: [
            Text(
              "어떤 약이예요?",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: largeSpace),
            Center(
                child: MedicineImageButton(
              updateImage: _medicineImage,
              changeImageFile: (File? value) {
                _medicineImage = value;
              },
            )),
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
              onChanged: (_) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: _nameController.text.isEmpty ? null : _onAddAlarmPage,
        text: "다음",
      ),
    );
  }

  void _onAddAlarmPage() {
    Navigator.push(
      context,
      FadePageRoute(
        page: AddAlarmPage(
          medicineImage: _medicineImage,
          medicineName: _nameController.text,
          updateMedicineId: widget.updateMedicineId,
        ),
      ),
    );
  }
}

class MedicineImageButton extends StatefulWidget {
  const MedicineImageButton(
      {super.key, required this.changeImageFile, this.updateImage});

  final ValueChanged<File?> changeImageFile;
  final File? updateImage;

  @override
  State<MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<MedicineImageButton> {
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _pickedImage = widget.updateImage;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: MaterialButton(
        padding: _pickedImage == null ? null : EdgeInsets.zero,
        onPressed: _showBottomSheet,
        child: _pickedImage == null
            ? const Icon(
                Icons.photo_camera,
                size: 30,
                color: Colors.white,
              )
            : CircleAvatar(
                radius: 40,
                foregroundImage: FileImage(_pickedImage!),
              ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PickImageBottomSheet(
            onPressedCamera: () => _onPressedModalButton(ImageSource.camera),
            onPressedGallery: () => _onPressedModalButton(ImageSource.gallery),
          );
        });
  }

  void _onPressedModalButton(ImageSource source) {
    ImagePicker().pickImage(source: source).then((xfile) {
      if (xfile == null) {
        Navigator.maybePop(context);
        return;
      } else {
        setState(() {
          _pickedImage = File(xfile.path);
          widget.changeImageFile(_pickedImage);
          Navigator.maybePop(context);
        });
      }
    }).onError((error, stackTrace) {
      // show setting
      Navigator.pop(context);
      showPermissionDenied(context, permission: '카메라 및 갤러리 접근');
    });
  }
}
