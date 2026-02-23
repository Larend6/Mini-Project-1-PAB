import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../providers/card_provider.dart';

class AddEditPage extends StatefulWidget {
  final TcgCard? card;
  const AddEditPage({super.key, this.card});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController seriesController;
  late TextEditingController priceController;

  File? selectedImage;
  String rarity = "Common";

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.card?.name ?? "");
    seriesController =
        TextEditingController(text: widget.card?.series ?? "");
    priceController =
        TextEditingController(text: widget.card?.price ?? "");
    rarity = widget.card?.rarity ?? "Common";

    if (widget.card?.imagePath != null &&
        widget.card!.imagePath.isNotEmpty) {
      selectedImage = File(widget.card!.imagePath);
    }
  }

  Future<void> pickImage() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void saveData() {
    if (_formKey.currentState!.validate()) {
      final provider =
          Provider.of<CardProvider>(context, listen: false);

      final newCard = TcgCard(
        id: widget.card?.id ?? Random().nextDouble().toString(),
        name: nameController.text,
        series: seriesController.text,
        rarity: rarity,
        price: priceController.text,
        imagePath: selectedImage?.path ?? "",
      );

      if (widget.card == null) {
        provider.addCard(newCard);
      } else {
        provider.updateCard(newCard);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil disimpan!")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        foregroundColor: Colors.white,
        title:
            Text(widget.card == null ? "Tambah Kartu" : "Edit Kartu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: "Nama Kartu"),
                validator: (v) =>
                    v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: seriesController,
                decoration:
                    const InputDecoration(labelText: "Series"),
                validator: (v) =>
                    v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                initialValue: rarity,
                items: const [
                  DropdownMenuItem(value: "Common", child: Text("C")),
                  DropdownMenuItem(value: "Uncommon", child: Text("U")),
                  DropdownMenuItem(value: "Rare", child: Text("R")),
                  DropdownMenuItem(value: "Double Rare", child: Text("RR")),
                  DropdownMenuItem(value: "Ace Spec Rare", child: Text("ACE")),
                  DropdownMenuItem(value: "Illustration Rare", child: Text("AR")),
                  DropdownMenuItem(value: "Ultra Rare", child: Text("UR")),
                  DropdownMenuItem(value: "Special Illustration Rare", child: Text("SAR")),
                  DropdownMenuItem(value: "Hyper Rare", child: Text("UR")),
                  DropdownMenuItem(value: "Shiny Rare", child: Text("S")),
                  DropdownMenuItem(value: "Shiny Ultra Rare", child: Text("SSR")),
                  DropdownMenuItem(value: "Black Star Promo", child: Text("PROMO")),
                ],
                onChanged: (value) {
                  setState(() {
                    rarity = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Rarity"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                decoration:
                    const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 15),
              selectedImage != null
                  ? Image.file(selectedImage!, height: 150)
                  : const Text("Belum ada gambar"),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pilih Gambar"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveData,
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}