import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function onSearchChanged;

  const SearchWidget(
      {Key? key, required this.searchController, required this.onSearchChanged})
      : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style =
        widget.searchController.text.isEmpty ? styleHint : styleActive;
    return Container(
      height: 42,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: widget.searchController,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: style.color),
          suffixIcon: widget.searchController.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    widget.searchController.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                    widget.onSearchChanged();
                  },
                )
              : null,
          hintText: 'Search',
          hintStyle: style,
          border: InputBorder.none,
        ),
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          widget.onSearchChanged();
        },
      ),
    );
  }
}
