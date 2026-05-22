import 'package:flutter/material.dart';
import '../models/favourites_store.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_navigation_bar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  //Stores the indexes of selected items to delete
  final Set<int> selectedIndexes = {};
  //Checks if it shows the loading indicator
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData(); //Load saved items in favourites when the screen opens
  }

  //Loads the saved items from local storage
  Future<void> loadData() async {
    await FavouritesStore.loadFromLocal(); //Read data from SharedPreferences
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Checks if Dark mode is on
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Favourites")),
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),

      //Only show the delete FAB when at least one item is selected
      floatingActionButton: selectedIndexes.isEmpty
          ? null //Hide the FAB when nothing is selected
          : FloatingActionButton(
              onPressed: () async {
                //Show a confirmation dialog before deleting
                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text("Remove selected item(s)?"),
                      actions: [
                        //Return false if cancelled
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        //Return ture if the user selects "delete"
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );

                //Only delete if the user select "delete"
                if (confirm == true) {
                  //Sort indexes in desending order
                  final List<int> itemsToRemove = selectedIndexes.toList()
                    ..sort((int b, int a) => a.compareTo(b));

                  //Remove each item selected
                  for (final int index in itemsToRemove) {
                    await FavouritesStore.remove(index);
                  }

                  selectedIndexes.clear();
                  setState(() {});
                }
              },
              child: const Icon(Icons.delete),
            ),

      //Show a loading indicator while data is being loaded
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: FavouritesStore.items.length, //Number of saved items
              itemBuilder: (BuildContext context, int index) {
                final FavouriteItem item =
                    FavouritesStore.items[index]; //Get the item at this index
                final bool isSelected = selectedIndexes.contains(
                  index,
                ); //Check if this item is selected

                return ListTile(
                  leading: Icon(
                    isSelected
                        ? Icons
                              .check_circle //Shows a tick when an item is selected
                        : item.isVideo
                        ? Icons.video_library
                        : Icons.image,
                    color: isDark ? Colors.white : Colors.black87,
                  ),

                  //Display the title of the saved item
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),

                  //Displays the date of the saved item
                  subtitle: Text(
                    item.date,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),

                  //Long press to select or deselect an item
                  onLongPress: () {
                    setState(() {
                      if (isSelected) {
                        selectedIndexes.remove(index);
                      } else {
                        selectedIndexes.add(index);
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}
