import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardProvider with ChangeNotifier {
  final List<TcgCard> _cards = [];
  String _selectedFilter = "All";

  List<TcgCard> get cards {
    if (_selectedFilter == "All") return _cards;
    return _cards.where((card) => card.rarity == _selectedFilter).toList();
  }

  String get selectedFilter => _selectedFilter;

  void setFilter(String rarity) {
    _selectedFilter = rarity;
    notifyListeners();
  }

  void addCard(TcgCard card) {
    _cards.add(card);
    notifyListeners();
  }

  void updateCard(TcgCard updatedCard) {
    int index = _cards.indexWhere((c) => c.id == updatedCard.id);
    _cards[index] = updatedCard;
    notifyListeners();
  }

  void deleteCard(String id) {
    _cards.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}