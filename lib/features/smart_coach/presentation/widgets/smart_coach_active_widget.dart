import 'dart:io';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/chat_message_entity.dart';
import 'smart_coach_bubble_widget.dart';

class SmartCoachActiveWidget extends StatefulWidget {
  final List<ChatMessageEntity> messages;
  final bool isLoadingAi;
  final String? userPhotoUrl;
  final String? attachedImagePath;
  final Function(String text, String? imagePath) onSendMessage;
  final Function(String imagePath) onImageAttached;
  final VoidCallback onClearImage;

  const SmartCoachActiveWidget({
    super.key,
    required this.messages,
    required this.isLoadingAi,
    required this.onSendMessage,
    required this.onImageAttached,
    required this.onClearImage,
    this.userPhotoUrl,
    this.attachedImagePath,
  });

  @override
  State<SmartCoachActiveWidget> createState() => _SmartCoachActiveWidgetState();
}

class _SmartCoachActiveWidgetState extends State<SmartCoachActiveWidget> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void didUpdateWidget(covariant SmartCoachActiveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length ||
        widget.isLoadingAi != oldWidget.isLoadingAi) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildMessageList()),
        if (widget.attachedImagePath != null) _buildImagePreviewBar(),
        _buildInputBar(context),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: widget.messages.length + (widget.isLoadingAi ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < widget.messages.length) {
          return SmartCoachBubbleWidget(
            message: widget.messages[index],
            userPhotoUrl: widget.userPhotoUrl,
          );
        }
        return _buildTypingIndicator();
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.lightBlack,
            backgroundImage: AssetImage(Assets.botAvatar),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightBlack,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.orange,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildImagePreviewBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.lightBlack,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(widget.attachedImagePath!),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.white),
            onPressed: widget.onClearImage,
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.black,
        border: Border(top: BorderSide(color: AppColors.lightBlack)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppColors.orange),
            onPressed: () => _showAttachmentModal(context),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: AppStrings.typeYourMessage,
                hintStyle: TextStyle(color: AppColors.lightGray),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.orange),
            onPressed: _handleSend,
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty && widget.attachedImagePath == null) return;
    FocusScope.of(context).unfocus();
    widget.onSendMessage(text, widget.attachedImagePath);
    _textController.clear();
  }

  void _showAttachmentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.lightBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: AppColors.orange),
            title: Text(AppStrings.camera, style: TextStyles.bodyRegular16),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppColors.orange),
            title: Text(AppStrings.gallery, style: TextStyles.bodyRegular16),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    if (file != null) {
      widget.onImageAttached(file.path);
    }
  }
}
