import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import 'add_edit_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémon TCG Collection", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField(
              initialValue: provider.selectedFilter,
              items: const [
                DropdownMenuItem(value: "All", child: Text("All")),
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
              onChanged: (value) => provider.setFilter(value!),
              decoration: const InputDecoration(
                fillColor: Colors.white,
                labelText: "Filter by Rarity",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: provider.cards.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada kartu\nTambah koleksimu sekarang!",
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.cards.length,
                    itemBuilder: (context, index) {
                      final card = provider.cards[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Color(0xFFFFDE00),
                            width: 2,
                          ),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: card.imagePath.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(card.imagePath),
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.image),
                          title: Text(card.name),
                          subtitle: Text(
                            "${card.series} • ${card.rarity}\nRp ${card.price}",
                          ),
                          isThreeLine: true,

                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Color.fromARGB(255, 109, 109, 109)),
                                onPressed: () => provider.deleteCard(card.id),
                              ),
                            ],
                          ),

                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (card.imagePath.isNotEmpty)
                                          Image.file(
                                            File(card.imagePath),
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),

                                        const SizedBox(height: 12),

                                        Text(
                                          card.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text("Series: ${card.series}"),
                                        Text("Rarity: ${card.rarity}"),
                                        Text("Price: Rp ${card.price}"),

                                        const SizedBox(height: 16),

                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => AddEditPage(card: card),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.edit),
                                          label: const Text("Edit"),
                                        ),

                                        const SizedBox(height: 8),

                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(255, 255, 109, 109),
                                          ),
                                          onPressed: () {
                                            provider.deleteCard(card.id);
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.delete),
                                          label: const Text("Delete"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3B4CCA),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}