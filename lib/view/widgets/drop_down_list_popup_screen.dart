import 'package:dqapp/controller/managers/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dqapp/view/theme/text_styles.dart';

import '../../../model/core/basic_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../theme/constants.dart';

class DropDownListScreen extends StatefulWidget {
  final double maxWidth;
  final double maxHeight;
  final bool? disableCreate;
  // List<BasicListItem> lst;
  // List<BasicListItem> selectedItems;
  final Function(List<BasicListItem>) fn;
  const DropDownListScreen({
    super.key,
    required this.maxHeight,
    // required this.lst,
    required this.fn,
    this.disableCreate,
    // required this.selectedItems,
    required this.maxWidth,
  });

  @override
  State<DropDownListScreen> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownListScreen> {
  @override
  void dispose() {
    getIt<StateManager>().setSearchQueryValue("", isDispose: true);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double h1p = widget.maxHeight * 0.01;
    // double h10p = widget.maxHeight * 0.1;
    // double w10p = widget.maxWidth * 0.1;
    double w1p = widget.maxWidth * 0.01;

    listItem(String? title) {
      return ListTile(
        title: Text(
          title ?? "",
          style: t400_12.copyWith(color: const Color(0xff474747)),
        ),
        style: ListTileStyle.list,
        tileColor: Colors.white,
        visualDensity: VisualDensity.comfortable,
        trailing: const Icon(Icons.add, color: Colors.black26),
      );
    }

    selectedItem(String? title) {
      return Container(
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: clr444444),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title ?? "",
                style: t400_12.copyWith(
                  color: const Color(0xff474747),
                  height: 1,
                ),
              ),
              horizontalSpace(6),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colours.primaryblue.withOpacity(0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colours.primaryblue.withOpacity(0.8),
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Consumer<StateManager>(
      builder: (context, mgr, child) {
        return SizedBox(
          height: widget.maxHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w1p * 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //   InkWell(
                // onTap: (){
                //    // var i = getPickedItems();
                //    List<BasicListItem> items = mgr.addedItems;
                //    // print("sdfsdfsd");
                //    // items.forEach((z)=>print(z.toJson()));
                //
                //   widget.fn(items);
                //   Navigator.pop(context);
                // },
                // child: Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text("Done",style: TextStyles.donebtn,),
                //   ),
                // ),
                //   )
                //
                // ],),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: mgr.addedItems.reversed
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                getIt<StateManager>().removeFromAddedItems(e);
                              },
                              child: selectedItem(e.item ?? ""),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                verticalSpace(8),

                TextField(
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (val) {
                    getIt<StateManager>().setSearchQueryValue(val);
                  },
                  decoration: inputDec4(hnt: "Search"),
                ),

                verticalSpace(8),

                Builder(
                  builder: (context) {
                    List<BasicListItem> items = mgr.listItems.where((element) {
                      // Filter based on search query and exclusion of addedItems
                      final matchesSearch =
                          mgr.searchQuery.isEmpty ||
                          (element.item != null &&
                              element.item!.toLowerCase().contains(
                                mgr.searchQuery.toLowerCase(),
                              ));
                      final notInAddedItems = !mgr.addedItems.any(
                        (addedItem) => addedItem.item == element.item,
                      );
                      return matchesSearch && notInAddedItems;
                    }).toList();
                    return Expanded(
                      child: SizedBox(
                        child: ListView(
                          children: [
                            ...items
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      getIt<StateManager>().addItems([e]);
                                    },
                                    child: listItem(e.item ?? ""),
                                  ),
                                )
                                .toList(),
                            Visibility(
                              visible:
                                  mgr.searchQuery.trim().isNotEmpty &&
                                  !mgr.addedItems.any(
                                    (addedItem) =>
                                        addedItem.item ==
                                        mgr.searchQuery.trim(),
                                  ) &&
                                  !items.any(
                                    (item) =>
                                        item.item == mgr.searchQuery.trim(),
                                  ) &&
                                  widget.disableCreate != true,
                              child: InkWell(
                                onTap: () {
                                  getIt<StateManager>().addItems([
                                    BasicListItem(
                                      item: mgr.searchQuery,
                                      id: null,
                                    ),
                                  ]);
                                },
                                child: listItem('Create "${mgr.searchQuery}"'),
                              ),
                            ),
                            Visibility(
                              visible:
                                  widget.disableCreate == true && items.isEmpty,
                              child: Text(
                                "No data found",
                                style: t400_12.copyWith(
                                  color: const Color(0xff474747),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                InkWell(
                  onTap: () {
                    // var i = getPickedItems();
                    List<BasicListItem> items = mgr.addedItems;
                    // print("sdfsdfsd");
                    // items.forEach((z)=>print(z.toJson()));
                    widget.fn(items);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: widget.maxWidth,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      color: Colours.primaryblue,
                    ),
                    child: Center(
                      child: Text(
                        "Done",
                        style: t700_16.copyWith(color: const Color(0xffffffff)),
                      ),
                    ),
                  ),
                ),

                // MultipleSearchSelection<BasicListItem>.creatable(showClearAllButton: false,controller: controller,
                //   // The TextField that is used to search items.
                //   //
                //   // You can use this to customize the search field.
                //   // The `onChanged` of the `searchField` is used internally to search items,
                //   // so you can use the `onSearchChanged` callback to get the search query.
                //
                //
                //   searchField: TextField(autofocus: true,
                //     decoration: inputDec4(hnt: "Search",),
                //   ),clearSearchFieldOnSelect: true,
                //   onSearchChanged: (text) {
                //     print('Text is $text');
                //   },showedItemContainerPadding: EdgeInsets.zero,showedItemsBoxDecoration: BoxDecoration(
                //     // border: Border.all(color: Colou)
                //   ),
                //   items: widget.lst,initialPickedItems: widget.selectedItems, // List<Country>
                //   fieldToCheck: (c) {
                //     return c.item!; // String
                //   },
                //   itemBuilder: (item,indx,r) {
                //     return listItem(item.item);
                //   },pickedItemsBoxDecoration: BoxDecoration(),
                //
                //   pickedItemBuilder: (item) {
                //     return selectedItem(item.item);
                //   },
                //   createOptions: CreateOptions<BasicListItem>(allowDuplicates: false,
                //     // You need to create and return the item you want to add since [T] is not always [String].
                //     create: (text) {
                //       return BasicListItem(item: text, id: null);
                //     },
                //     // A callback when the item is succesfully created.
                //     onCreated: (c) => print('Country ${c.item} created'),
                //     // Create item Widget that appears instead of no results.
                //     createBuilder: (text) => listItem('Create "$text"'),
                //     // Whether you want to pick the newly created item or just add it to your list. Defaults to false.
                //     pickCreated: true,
                //   ),
                //   onTapShowedItem: () {},
                //   onPickedChange: (items) {},
                //   onItemAdded: (item) {},
                //   onItemRemoved: (item) {},
                //   sortShowedItems: true,
                //
                //   sortPickedItems: true,
                //   fuzzySearch: FuzzySearch.jaro,
                //   itemsVisibility: ShowedItemsVisibility.alwaysOn,
                //
                //   showSelectAllButton: false,
                //   maximumShowItemsHeight: 400,
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
