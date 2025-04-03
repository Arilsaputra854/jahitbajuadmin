import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/model/note.dart';
import 'package:jahit_baju_admin/data/model/product.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/product_note_response.dart';
import 'package:jahit_baju_admin/data/remote/response/term_condition_response.dart';

class NoteController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;

  Note? _customNote;
  Note? get customNote => _customNote;

  Note? _rtwNote;
  Note? get rtwNote => _rtwNote;

  NoteController(this.apiService);

  Future<void> fetchNote() async {
    _errorMsg = null;
    if (_customNote == null) {
      _loading = true;
      notifyListeners();
      ProductNoteResponse response = await apiService.getNoteProduct(
        Product.CUSTOM,
      );
      if (response.error) {
        _errorMsg = "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _loading = false;
        notifyListeners();
      } else {
        _customNote = response.data;
        _loading = false;
        notifyListeners();
      }
    }

    if (_rtwNote == null) {
      _loading = true;
      notifyListeners();
      ProductNoteResponse response = await apiService.getNoteProduct(
        Product.READY_TO_WEAR,
      );
      if (response.error) {
        _errorMsg = "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _loading = false;
        notifyListeners();
      } else {
        _rtwNote = response.data;
        _loading = false;
        notifyListeners();
      }
    }
  }

  updateNote(Note note,String updatedData) async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    ProductNoteResponse 
      response = await apiService.updateNoteProduct(Note(id: note.id,data: updatedData)); 

    if (response.error) {
      _errorMsg = "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      _rtwNote = response.data;
      _loading = false;
      refresh();
    }
  }

  void refresh() {
    _customNote = null;
    _rtwNote = null;
    fetchNote();
  }
}
