import 'package:flutter/material.dart';
import 'package:jamii_check/data/search/provider/search_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  final String? hintText;
  final Function? onTextChanged;
  final Function? onClearPressed;
  final Function? onSubmit;
   const SearchWidget({Key? key, @required this.hintText, this.onTextChanged, @required this.onClearPressed, this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(text: Provider.of<SearchProvider>(context).searchText);
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        height: 80,
        color: JAMII_PRIMARY_COLOR,
        alignment: Alignment.center,
        child: Row(children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(8.0)),
              child: TextFormField(
                controller: _controller,
                autofocus: false,
                onFieldSubmitted: (query) {
                  FocusScope.of(context).unfocus();
                  onSubmit!(query);
                },
                onChanged: (query) {
                  onTextChanged!(query);
                },
                textInputAction: TextInputAction.search,
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: hintText,
                  isDense: true,
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: JAMII_PRIMARY_COLOR, size: Dimensions.ICON_SIZE_DEFAULT),
                  suffixIcon: Provider.of<SearchProvider>(context).searchText.isNotEmpty ? IconButton(
                    icon: const Icon(Icons.clear, color:  Colors.red),
                    onPressed: () {
                      onClearPressed!();
                      _controller.clear();
                    },
                  ) : _controller.text.isNotEmpty ? IconButton(
                    icon: const Icon(Icons.clear, color: JAMII_PRIMARY_COLOR),
                    onPressed: () {
                      onClearPressed!();
                      _controller.clear();
                    },
                  ) : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ]),
      ),
    ]);
  }
}
