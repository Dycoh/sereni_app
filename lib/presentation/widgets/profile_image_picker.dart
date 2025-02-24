// lib/widgets/common/profile_image_picker.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileImagePicker extends StatefulWidget {
  final String? currentImageUrl;
  final Function(File) onImageSelected;

  const ProfileImagePicker({
    super.key,
    this.currentImageUrl,
    required this.onImageSelected,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      widget.onImageSelected(_selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.kGray300,
          shape: BoxShape.circle,
          image: _selectedImage != null
              ? DecorationImage(
                  image: FileImage(_selectedImage!),
                  fit: BoxFit.cover,
                )
              : widget.currentImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(widget.currentImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: AssetImage('assets/images/placeholder_profile.png'),
                      fit: BoxFit.cover,
                    ),
        ),
        child: _selectedImage == null && widget.currentImageUrl == null
            ? const Icon(
                Icons.add_a_photo,
                color: AppTheme.kGray600,
                size: 20,
              )
            : null,
      ),
    );
  }
}