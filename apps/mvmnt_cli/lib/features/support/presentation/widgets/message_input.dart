import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mvmnt_cli/core/util/device/image_picker_service.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class MessageInput extends StatefulWidget {
  final Function onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final ImagePickerService _pickerService = ImagePickerService();
  final TextEditingController _messageController = TextEditingController();
  List<File> _selectedImages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsetsGeometry.only(left: 8, right: 12, bottom: 16),
              child: SvgIcon(name: 'camera'),
            ),
            onTap: () async {
              final images = await _pickerService.pickImages(
                source: PickerSource.camera,
                allowMultiple: false,
              );
              if (images.isNotEmpty) {
                setState(() {
                  _selectedImages = [..._selectedImages, ...images];
                });
              }
            },
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsetsGeometry.only(right: 12, bottom: 16),
              child: SvgIcon(name: 'image'),
            ),
            onTap: () async {
              final images = await _pickerService.pickImages(
                source: PickerSource.gallery,
                allowMultiple: true,
              );

              if (images.isNotEmpty) {
                setState(() {
                  _selectedImages = [..._selectedImages, ...images];
                });
              }
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedImages.isEmpty) ...[
                  SizedBox.shrink(),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          var image = _selectedImages[index];
                          return _ImagePreview(
                            key: Key(image.path),
                            image: image,
                            onDelete: (image) {
                              setState(() {
                                _selectedImages.remove(image);
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],

                CustomTextField(
                  controller: _messageController,
                  hintText: 'Type message',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (_messageController.text.trim().isNotEmpty) {
                        widget.onSend(_messageController.text.trim());
                        _messageController.clear();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [SvgIcon(name: 'send')],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final File image;
  final Function onDelete;

  const _ImagePreview({super.key, required this.onDelete, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(image.path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: () {
              onDelete(image);
            },
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.6),
              child: SvgIcon(
                name: 'x',
                size: 14,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
