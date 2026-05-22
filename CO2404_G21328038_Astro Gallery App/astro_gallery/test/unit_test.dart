import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astro_gallery/models/favourites_store.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FavouritesStore.items.clear();
  });

  test('should add an item to the favourites list', () async {
    //Arrange
    final FavouriteItem item = FavouriteItem(
      title: 'Hubble Deep Field',
      date: '2026-03-06',
      url: 'https://example.com/image.jpg',
      description: 'A deep field image from Hubble.',
      isVideo: false,
    );

    //Act
    await FavouritesStore.add(item);

    //Assert
    expect(FavouritesStore.items.length, 1);
  });

  test('should not add a duplicate item with the same url', () async {
    //Arrange
    final FavouriteItem item = FavouriteItem(
      title: 'Hubble Deep Field',
      date: '2026-03-06',
      url: 'https://example.com/image.jpg',
      description: 'A deep field image from Hubble.',
      isVideo: false,
    );

    //Act
    await FavouritesStore.add(item);
    await FavouritesStore.add(item);

    //Assert
    expect(FavouritesStore.items.length, 1);
  });

  test('should remove an item from the favourites list', () async {
    //Arrange
    final FavouriteItem item = FavouriteItem(
      title: 'Hubble Deep Field',
      date: '2026-03-06',
      url: 'https://example.com/image.jpg',
      description: 'A deep field image from Hubble.',
      isVideo: false,
    );
    await FavouritesStore.add(item);

    //Act
    await FavouritesStore.remove(0);

    //Assert
    expect(FavouritesStore.items.length, 0);
  });

  test(
    'should return true when an item with the same url already exists',
    () async {
      //Arrange
      final FavouriteItem item = FavouriteItem(
        title: 'Hubble Deep Field',
        date: '2026-03-06',
        url: 'https://example.com/image.jpg',
        description: 'A deep field image from Hubble.',
        isVideo: false,
      );
      await FavouritesStore.add(item);

      //Act
      final bool result = FavouritesStore.exists(
        'https://example.com/image.jpg',
      );

      //Assert
      expect(result, true);
    },
  );
}
