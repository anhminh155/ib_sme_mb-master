import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController searchController;
  final dynamic searchAction;
  const SearchInput(
      {super.key, required this.searchController, this.searchAction});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      cursorColor: primaryColor,
      decoration: const InputDecoration(
        iconColor: primaryColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        prefixIcon: Icon(
          Icons.search,
          color: primaryColor,
        ),
        hintText: 'Tìm kiếm',
        focusColor: primaryColor,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: colorBlack_EAEBEC),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gapPadding: 1.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gapPadding: 4.0,
        ),
      ),
      onChanged: searchAction,
      // onEditingComplete: searchAction,
    );
  }
}
