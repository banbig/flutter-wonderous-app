Flutter Photo Management App: Incremental MVP Prompts
Introduction
This document outlines a series of prompts for building a Flutter photo management and recommendation application in incremental, runnable Minimum Viable Products (MVPs). Each MVP builds upon the previous one, following a layered architecture (Presentation, Domain, Data, Core).

Assumed Project Setup:

A Flutter project is created.

The provider package (or your chosen state management solution) will be used. Add it to pubspec.yaml if not already present:

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0 # Or latest
  # Add other packages as MVPs progress (e.g., intl, photo_gallery, permission_handler, sqflite/floor/isar, shared_preferences)


Run flutter pub get after adding any new package.

---

MVP 1: Basic Application Shell & Navigation
Goal:
Create the fundamental structure of the Flutter application, including the main app setup, a functional bottom navigation bar, and empty placeholder screens for each main section. This MVP focuses solely on the presentation layer's navigation and basic screen setup.

1. Directory Structure (Presentation Layer Focus):
Create/ensure the following basic directory structure within lib/:

lib/
|-- main.dart
|-- presentation/
|   |-- screens/
|   |   |-- dashboard_screen.dart
|   |   |-- album_screen.dart
|   |   |-- clustering_screen.dart
|   |   |-- recommended_screen.dart
|   |   |-- settings_screen.dart
|   |-- widgets/
|   |   |-- common/ # For later common widgets
|   |   |-- bottom_nav_bar.dart
|   |-- providers/
|   |   |-- navigation_provider.dart


2. main.dart Implementation:

Create MyApp StatelessWidget.

Use MultiProvider to provide NavigationProvider.

Set up MaterialApp with a basic theme (e.g., ThemeData(primarySwatch: Colors.blue, useMaterial3: true, fontFamily: 'Inter', scaffoldBackgroundColor: Color(0xFFF3F4F6))).

The home of MaterialApp should be a MainScreen StatelessWidget.

MainScreen will use Scaffold and will display the current page based on NavigationProvider and include the BottomNavBar.

3. presentation/providers/navigation_provider.dart:

Create NavigationProvider extends ChangeNotifier.

Manages _currentIndex (default 0) and provides changePage(int index).

4. presentation/widgets/bottom_nav_bar.dart:

Create BottomNavBar StatelessWidget.

Uses BottomNavigationBar with 5 BottomNavigationBarItems (首页, 相册, 清理, 推荐, 设置) with appropriate icons (e.g., Icons.home_outlined, Icons.home).

currentIndex from NavigationProvider, onTap calls navigationProvider.changePage(index).

Style: type: BottomNavigationBarType.fixed.

5. presentation/screens/ (Placeholder Screens):

For each screen (dashboard_screen.dart, etc.), create a StatelessWidget.

Each screen displays a Scaffold with an AppBar (showing the screen's title: "首页", "相册", etc.) and a Center widget in the body displaying a Text widget with the screen's name (e.g., "Dashboard Screen Content").

6. MainScreen Widget (in main.dart or a new file presentation/screens/main_screen.dart):

Uses Consumer<NavigationProvider> for currentIndex.

Scaffold body uses an IndexedStack with a List<Widget> of your five screen instances.

Scaffold bottomNavigationBar is an instance of BottomNavBar.

Expected Outcome: A runnable app with basic navigation between 5 placeholder screens.

---

MVP 2: Core Data Models & Settings UI (Static)
Goal:
Define the core data entities (Photo, PhotoGroup, RecommendationSettings) and build the static UI for the Settings screen to display (but not yet save or fully interact with) recommendation settings.

Pre-requisites: MVP 1 completed.

1. New Directory Structure (Domain Layer Focus):
Create lib/domain/entities/.

2. domain/entities/photo.dart:

Create Photo class: id (String), url (String, or path), name (String), size (double), dateTimeOriginal (DateTime, optional), latitude (double, optional), longitude (double, optional), clarity (double), exposure (double), faces (int), composition (double), colorfulness (double), recommendationScore (double), isBestCandidate (bool). Initialize appropriately.

3. domain/entities/photo_group.dart:

Create PhotoGroup class: id (String), date (String or DateTime), List<Photo> photos.

4. domain/entities/recommendation_settings.dart:

Create RecommendationMode enum (singleBest, topN).

Create RecommendationCriterion class: enabled (bool), weight (double).

Create RecommendationSettings class: mode (RecommendationMode), topNValue (int), Map<String, RecommendationCriterion> criteria. Initialize with default criteria (clarity, exposure, faces, composition, colorfulness) and their default enabled/weight values (similar to the full Flutter demo).

5. presentation/providers/settings_view_provider.dart (Initial Version):

Create SettingsViewProvider extends ChangeNotifier.

Hold an instance of RecommendationSettings. Initialize it with default values.

Provide getters for settings properties needed by the UI (e.g., currentMode, topNValue, isCriterionEnabled(String key), getCriterionWeight(String key)).

For now, methods to update settings in this provider can just update its internal _settings object and call notifyListeners(). Persistence will come in MVP 3.

6. presentation/screens/settings_screen.dart (UI Implementation):

Replace the placeholder content. Use Consumer<SettingsViewProvider> (or Provider.of) to get settings data.

Build the UI as described in the full Flutter demo prompt:

Sections for "推荐标准设置", "通用", "关于".

"推荐标准设置" section:

DropdownButtonFormField for "推荐模式" (bound to settingsProvider.settings.mode).

TextFormField for "Top-N 数量" (conditionally visible, bound to settingsProvider.settings.topNValue).

For each criterion (clarity, exposure, etc.):

A Row containing:

Text label for the criterion name.

Checkbox (bound to settingsProvider.isCriterionEnabled(key)).

Slider (bound to settingsProvider.getCriterionWeight(key)).

Text to display the current weight.

An "应用推荐设置" button (for now, it can just print current settings or show a SnackBar).

"通用" section: Placeholder "智能选择默认开启" switch, "语言".

"关于" section: Placeholder "版本号", links.

Use ListView for scrollability. Use Card widgets for sectioning.

setState within SettingsScreen (if it's a StatefulWidget) or methods in SettingsViewProvider will handle UI changes for local interactions (like toggling checkboxes or moving sliders before "applying").

Expected Outcome: The Settings screen displays recommendation options based on default values in SettingsViewProvider. UI elements for changing settings are present but don't persist changes yet.

--- 

MVP 3: Settings Persistence & Basic Repository
Goal:
Implement saving and loading of recommendation settings using shared_preferences by introducing the repository pattern for settings.

Pre-requisites: MVP 2 completed. Add shared_preferences: ^2.0.0 (or latest) to pubspec.yaml and run flutter pub get.

1. New Directory Structure (Domain & Data Layer Focus):
Create:

lib/domain/repositories/
lib/data/
|-- data_sources/
|   |-- local/
|       |-- local_settings_data_source.dart
|-- repositories_impl/
|   |-- settings_repository_impl.dart
lib/core/error/ # If not already created
|-- failures.dart
|-- exceptions.dart


2. core/error/failures.dart & exceptions.dart:

Define a base Failure class (e.g., abstract class Failure { final String message; Failure(this.message); }).

Define specific failures (e.g., CacheFailure extends Failure).

Define specific exceptions (e.g., CacheException implements Exception).

3. domain/repositories/i_settings_repository.dart:

Create abstract class ISettingsRepository.

Define methods:

Future<Either<Failure, RecommendationSettings>> getRecommendationSettings();

Future<Either<Failure, void>> saveRecommendationSettings(RecommendationSettings settings);
(You'll need a package for Either, like dartz. Add dartz: ^0.10.0 or latest to pubspec.yaml)

4. data/data_sources/local/local_settings_data_source.dart:

Create LocalSettingsDataSource abstract class.

Define methods:

Future<RecommendationSettings> getLastRecommendationSettings();

Future<void> cacheRecommendationSettings(RecommendationSettings settings);

Create LocalSettingsDataSourceImpl implements LocalSettingsDataSource:

Use SharedPreferences to store/retrieve settings (serialize RecommendationSettings to JSON string or individual keys).

5. data/repositories_impl/settings_repository_impl.dart:

Create SettingsRepositoryImpl implements ISettingsRepository.

Inject LocalSettingsDataSource.

Implement getRecommendationSettings and saveRecommendationSettings:

Call corresponding LocalSettingsDataSource methods.

Handle CacheException from data source and return Left(CacheFailure(...)).

Return Right(data) on success.

6. Update presentation/providers/settings_view_provider.dart:

Inject ISettingsRepository into its constructor.

Add methods Future<void> loadSettings() and Future<void> saveSettings():

loadSettings(): Calls repository.getRecommendationSettings(). On success, updates its internal _settings and notifies listeners. On failure, handles the error (e.g., logs it or sets an error state). Call this in initState (or equivalent for Provider).

saveSettings(): Calls repository.saveRecommendationSettings() with its current internal _settings. Shows a SnackBar on success/failure.

The "应用推荐设置" button in SettingsScreen should now call provider.saveSettings().

Ensure MultiProvider in main.dart correctly provides SettingsRepositoryImpl and then SettingsViewProvider (which depends on the repository).

Expected Outcome: Settings made on the Settings screen are persisted using shared_preferences and reloaded when the app starts or the screen is loaded.

---

MVP 4: Photo Display & Basic Photo Repository (Mock Data)
Goal:
Display mock photo data grouped by date on the "Clustering" (清理) screen. Set up a basic PhotoProvider (or ClusteringViewProvider) and IPhotoRepository with mock PhotoGroup data.

Pre-requisites: MVP 3 completed.

1. New Directory Structure (Domain & Data Layer Focus):
Create/ensure:

lib/domain/repositories/i_photo_repository.dart
lib/data/repositories_impl/photo_repository_impl.dart
lib/data/data_sources/local/local_photo_data_source.dart # (Empty for now, or basic structure)
lib/presentation/providers/clustering_view_provider.dart
lib/presentation/widgets/photo_group_widget.dart
lib/presentation/widgets/photo_card_widget.dart


2. domain/repositories/i_photo_repository.dart:

Create IPhotoRepository abstract class.

Define initial method: Future<Either<Failure, List<PhotoGroup>>> getPhotoGroups();

(Add more methods like deletePhotos, cachePhotoMetadata in later MVPs).

3. data/data_sources/local/local_photo_data_source.dart:

Create LocalPhotoDataSource abstract class: Future<List<PhotoGroup>> getMockPhotoGroups();

Create LocalPhotoDataSourceImpl implements LocalPhotoDataSource:

Implement getMockPhotoGroups() to return hardcoded List<PhotoGroup> with mock Photo data (similar to the full Flutter demo's _loadMockData()). Include clarity, exposure, faces, etc. attributes in Photo objects.

4. data/repositories_impl/photo_repository_impl.dart:

Create PhotoRepositoryImpl implements IPhotoRepository.

Inject LocalPhotoDataSource.

Implement getPhotoGroups(): Call localDataSource.getMockPhotoGroups(), handle exceptions, return Either.

5. presentation/providers/clustering_view_provider.dart (Initial Version):

Create ClusteringViewProvider extends ChangeNotifier.

Inject IPhotoRepository and SettingsProvider (or ISettingsRepository if settings are needed directly for display logic here, though recommendation logic is MVP5).

State: isLoading (bool), error (String?), List<PhotoGroup> displayedGroups, Set<String> selectedPhotoIds, isSmartSelectEnabled (bool, initialize from SettingsProvider.generalSmartSelectToggle).

Method Future<void> fetchPhotoGroups():

Sets isLoading = true.

Calls photoRepository.getPhotoGroups().

On success, updates displayedGroups and sets isLoading = false.

On failure, sets error message and isLoading = false.

Calls notifyListeners().

Call this method when the provider is initialized or the screen is first built.

Basic methods: togglePhotoSelection(String photoId), setSmartSelectEnabled(bool value).

6. presentation/screens/clustering_screen.dart (UI Implementation):

Replace placeholder. Use Consumer<ClusteringViewProvider>.

Show a loading indicator if provider.isLoading.

Show an error message if provider.error is not null.

If data is available (provider.displayedGroups), display:

Top control area: "发现 X 组..." and "智能选择" Switch (bound to provider.isSmartSelectEnabled and calls provider.setSmartSelectEnabled).

ListView.builder to render PhotoGroupWidget for each group in provider.displayedGroups.

Bottom action bar (static for now): "已选 X 张..." and "立即清理" button (disabled).

7. presentation/widgets/photo_group_widget.dart:

StatelessWidget taking PhotoGroup photoGroup.

Displays group date and a GridView.builder of PhotoCardWidget for photoGroup.photos.

8. presentation/widgets/photo_card_widget.dart (Initial Version):

StatelessWidget taking Photo photo.

Displays the photo image (Image.network(photo.url)).

Includes a Checkbox (top right, state managed by ClusteringViewProvider.selectedPhotoIds).

Placeholder for "best photo" badge.

Basic tap gesture to call clusteringViewProvider.togglePhotoSelection(photo.id).

Style it to be selectable (e.g., border changes when selected).

9. Update main.dart:

Provide PhotoRepositoryImpl and ClusteringViewProvider (which depends on PhotoRepository and SettingsProvider).

Expected Outcome: The "Clustering" (清理) screen fetches and displays mock photo groups and photos. Users can toggle the "智能选择" switch (no logic yet) and select/deselect individual photos.

---

MVP 5: Basic Recommendation Logic & Smart Selection UI
Goal:
Implement basic recommendation scoring and the "smart select" feature on the Clustering screen. This involves calculating scores for mock photos and automatically selecting non-best photos when "Smart Select" is enabled.

Pre-requisites: MVP 4 completed.

1. New Directory Structure (Domain Layer Focus):
Create/ensure:

lib/domain/use_cases/collection_management/
|-- get_photo_recommendations_use_case.dart
lib/core/usecase/ # If not already from MVP3
|-- usecase.dart  # Define abstract class UseCase<Type, Params>


2. core/usecase/usecase.dart:

abstract class UseCase<Type, Params> { Future<Either<Failure, Type>> call(Params params); }

class NoParams {} (for use cases that don't need parameters).

3. domain/use_cases/collection_management/get_photo_recommendations_use_case.dart:

Create GetPhotoRecommendationsUseCase implements UseCase<List<Photo>, GetRecommendationsParams>.

GetRecommendationsParams class: contains List<Photo> photosInGroup and RecommendationSettings settings.

call(GetRecommendationsParams params) method:

Iterates through params.photosInGroup.

For each photo, calculates recommendationScore based on params.settings and its attributes (clarity, exposure, faces, etc. - similar to _calculateRecommendationScore from the full Flutter demo's PhotoProvider).

Sorts photos by score.

Based on params.settings.mode (singleBest or topN) and params.settings.topNValue, identifies the "best" photo(s) in the group.

Returns the List<Photo> that are considered best (these are the ones to keep).

Does not modify the input List<Photo> directly but can return a new list or a list of IDs of best photos. For simplicity, let's say it updates an isBestCandidate flag on the photo objects within the input list and returns the list of best photos.

4. Update presentation/providers/clustering_view_provider.dart:

Inject GetPhotoRecommendationsUseCase.

Modify/Create applySmartSelection():

If isSmartSelectEnabled is true:

Clear selectedPhotoIds.

For each PhotoGroup in displayedGroups:

Get current RecommendationSettings (from SettingsProvider via constructor injection or direct access if provider is listened to).

Call getPhotoRecommendationsUseCase.call(GetRecommendationsParams(photosInGroup: group.photos, settings: currentSettings)).

On success (Right side of Either):

Get the list of best photos to keep.

Iterate through group.photos. Update each photo.isBestCandidate flag.

Add IDs of photos not in the "best to keep" list to selectedPhotoIds.

If isSmartSelectEnabled is false:

Clear selectedPhotoIds (or retain manual selections, choose one behavior).

Clear all isBestCandidate flags on photos.

Call notifyListeners().

Ensure applySmartSelection() is called when isSmartSelectEnabled changes, or when settings change (via SettingsProvider listener in ClusteringViewProvider or a callback).

The fetchPhotoGroups() method, after getting groups, should also trigger applySmartSelection() or the recommendation logic for each group.

5. Update presentation/widgets/photo_card_widget.dart:

Take Photo photo as input (which now should have isBestCandidate and recommendationScore populated by ClusteringViewProvider's logic).

Display the "best photo" badge (crown icon or "Top N" text) if photo.isBestCandidate is true.

The badge text ("Top N") can access N from SettingsProvider.settings.topNValue if needed.

Optionally, display photo.recommendationScore on hover/tooltip for debugging.

6. Update main.dart:

Provide GetPhotoRecommendationsUseCase and update ClusteringViewProvider's dependencies.

Expected Outcome: On the Clustering screen, when "Smart Select" is on, photos that are not deemed "best" (based on settings and recommendation logic) are automatically checked. The "best" photos have a visual indicator. Changing settings (MVP2/3) and then re-applying smart select (e.g., by toggling the switch or a refresh mechanism) should change the selections.

---

MVP 6: Photo Cleanup Logic (Mock Deletion)
Goal:
Implement the UI and logic for selecting photos and "deleting" them (removing from the in-memory mock data list). Update the "Recommended" screen to show remaining photos.

Pre-requisites: MVP 5 completed.

1. New Directory Structure (Domain Layer Focus):
Create/ensure:

lib/domain/use_cases/storage_management/
|-- cleanup_photos_use_case.dart


2. domain/use_cases/storage_management/cleanup_photos_use_case.dart:

Create CleanupPhotosUseCase implements UseCase<void, CleanupPhotosParams>.

CleanupPhotosParams class: contains List<String> photoIdsToClean.

call(CleanupPhotosParams params) method:

Will interact with IPhotoRepository to mark photos as deleted or remove their records.

For this MVP (mock deletion), it might just return Right(null). The actual data manipulation will happen in the repository's mock implementation.

3. Update domain/repositories/i_photo_repository.dart:

Add method: Future<Either<Failure, void>> deletePhotos(List<String> photoIds);

4. Update data/repositories_impl/photo_repository_impl.dart:

Implement deletePhotos(List<String> photoIds):

For this MVP, this method will modify its internal (mock) List<PhotoGroup> by removing the photos with the given IDs.

It should simulate success by returning Right(null).

Important: This implies PhotoRepositoryImpl needs to hold the mutable list of PhotoGroups for the mock scenario, or receive it and return a new modified list.

5. Update presentation/providers/clustering_view_provider.dart:

Inject CleanupPhotosUseCase.

Add method Future<void> performCleanup():

If selectedPhotoIds is not empty:

Sets isLoading = true (optional, for cleanup).

Calls cleanupPhotosUseCase.call(CleanupPhotosParams(photoIdsToClean: selectedPhotoIds.toList())).

On success:

Clear selectedPhotoIds.

Call fetchPhotoGroups() again to get the updated list (or manually update displayedGroups based on the repository's change if the repository directly modifies its held data and notifies). This ensures the UI reflects the deletion.

Store the remaining photos in a list like allPhotosKeptAfterCleaning (this list will be used by the Recommended screen). This might involve iterating through the new displayedGroups.

Show a success SnackBar.

On failure: Set error message, show error SnackBar.

Sets isLoading = false.

Call notifyListeners().

The "立即清理" button in ClusteringScreen should call provider.performCleanup() and be enabled only if selectedPhotoIds is not empty.

ClusteringViewProvider should also expose allPhotosKeptAfterCleaning (or a getter for it).

6. presentation/screens/recommended_screen.dart (UI Implementation):

Replace placeholder. Use Consumer<ClusteringViewProvider> (or a new dedicated RecommendedViewProvider that gets allPhotosKeptAfterCleaning from ClusteringViewProvider or PhotoRepository).

If provider.allPhotosKeptAfterCleaning is empty, show "暂无推荐照片。请先在“清理”页面处理照片。"

Otherwise, display a GridView.builder of the photos in provider.allPhotosKeptAfterCleaning.

Each photo can be displayed using a simplified PhotoCardWidget (no checkbox needed, but can show the "best" badge if that info is preserved).

Photos can be sorted by their recommendationScore.

7. Update main.dart:

Provide CleanupPhotosUseCase and update ClusteringViewProvider's dependencies if needed.

Expected Outcome: Users can select photos on the Clustering screen and click "立即清理". Selected photos are removed from the displayed list. The "Recommended" screen then shows the photos that were not deleted.

---

MVP 7: Platform Photo Gallery Integration (Read-Only)
Goal:
Integrate a Flutter plugin (e.g., photo_gallery or image_picker) to read actual photo metadata and thumbnails from the device's gallery, replacing the mock data source for photos.

Pre-requisites: MVP 6 completed.

Add photo_gallery: ^2.0.0 (or latest) and permission_handler: ^10.0.0 (or latest) to pubspec.yaml. Run flutter pub get.

Configure necessary platform permissions (iOS: Info.plist for photo library access; Android: AndroidManifest.xml for storage permissions).

1. New Directory Structure (Core Layer Focus):
Create/ensure:

lib/core/platform_services/
|-- photo_gallery_service.dart
lib/core/utils/
|-- permission_handler.dart # (May not need a separate file, logic can be in PhotoGalleryService)


2. core/platform_services/photo_gallery_service.dart:

Create PhotoGalleryService class.

Method Future<List<Medium>> fetchDevicePhotos({Album? album, MediumType? mediumType, bool? newest}):

Uses permission_handler to request photo library permissions. If not granted, return empty or throw an exception/Failure.

Uses photo_gallery plugin to:

List albums (PhotoGallery.listAlbums).

List media in an album or all media (album.listMedia or PhotoGallery.listMedia).

For each Medium from photo_gallery, extract relevant info: id, filePath (via medium.getFile()), creationDate, width, height, size, mimeType.

Returns a list of Medium objects (or a custom simpler Photo DTO).

Method Future<Uint8List> getThumbnail({required String mediumId, int? width, int? height}):

Uses PhotoGallery.getThumbnail to fetch thumbnail byte data.

Method Future<File> getFile({required String mediumId}):

Uses PhotoGallery.getFile.

3. domain/use_cases/photo_acquisition/scan_device_photos_use_case.dart (Update):

(If not already created from a previous prompt, create it now: ScanDevicePhotosUseCase implements UseCase<List<Photo>, NoParams>).

Inject PhotoGalleryService and ExtractMetadataUseCase.

call(NoParams params):

Calls photoGalleryService.fetchDevicePhotos().

For each fetched Medium, create a Photo entity.

Map Medium.id to Photo.id.

Get file path using photoGalleryService.getFile(), then use path for Photo.path (or URL if applicable).

Photo.dateTimeOriginal from Medium.creationDate or modifiedDate.

Photo.size from Medium.size.

Other metadata (lat/long) might require EXIF extraction (see ExtractMetadataUseCase).

Simulate clarity, exposure, etc., for now, or leave them as defaults.

Optionally, call extractMetadataUseCase for more details for each photo.

Returns Right(List<Photo>).

4. domain/use_cases/photo_analysis/extract_metadata_use_case.dart (Basic):

(If not already created: ExtractMetadataUseCase implements UseCase<Photo, Photo>).

call(Photo photo):

Takes a Photo object (which should have a path).

(Future: Use an EXIF package like flutter_exif_rotation or custom platform channels to read detailed EXIF).

For this MVP, it might just copy existing date/size or simulate extracting a few more details if photo_gallery doesn't provide them.

Returns the updated Photo object.

5. Update data/data_sources/local/local_photo_data_source.dart:

Remove getMockPhotoGroups().

Add Future<List<Photo>> fetchPhotosFromDevice() (or similar, to be called by PhotoRepositoryImpl).

LocalPhotoDataSourceImpl:

Inject PhotoGalleryService.

Implement fetchPhotosFromDevice(): This might not be directly needed if the ScanDevicePhotosUseCase directly uses PhotoGalleryService and the repository's role is more about groups of photos or cached photos.

For now, PhotoRepositoryImpl might directly use ScanDevicePhotosUseCase or PhotoGalleryService to fetch photos initially if there's no caching yet.

6. Update data/repositories_impl/photo_repository_impl.dart:

Modify getPhotoGroups():

Instead of returning mock data, it should now orchestrate fetching photos from the device if no cached groups exist.

This might involve:

Checking a local cache (DB - MVP9) for existing photo groups.

If not found or refresh needed:

Call ScanDevicePhotosUseCase to get a flat list of Photo objects from the device.

(MVP8 will add clustering here). For now, you could create one large PhotoGroup or group by date naively.

(Future: Cache these new photos and groups).

For this MVP, simply have getPhotoGroups() call ScanDevicePhotosUseCase and then very naively group the resulting List<Photo> into List<PhotoGroup> (e.g., one group per day, or one massive group). This is a temporary step before proper clustering in MVP8.

7. Update presentation/widgets/photo_card_widget.dart:

Instead of Image.network(photo.url), if photo.url now contains a local file path, use Image.file(File(photo.path)).

Or, use PhotoGallery.getThumbnail via PhotoGalleryService to display thumbnails for better performance:

FutureBuilder<Uint8List?>(
  future: photoGalleryService.getThumbnail(mediumId: photo.id, width: 200, height: 200), // Assuming photo.id is the mediumId
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
      return Image.memory(snapshot.data!);
    }
    return Container(color: Colors.grey[300]); // Placeholder
  },
)


(This requires PhotoGalleryService to be accessible, e.g., via Provider or passed down).

8. Update presentation/providers/clustering_view_provider.dart:

fetchPhotoGroups() should now trigger the updated repository method which in turn uses ScanDevicePhotosUseCase.

The Photo objects will now have actual device data (path, creation date).

Expected Outcome: The "Clustering" screen now displays photos and basic metadata from the user's device gallery (after permissions are granted). Mock data is replaced. Thumbnails are shown.

---

MVP 8: Similarity Calculation & Clustering (Basic)
Goal:
Implement a basic similarity calculation (e.g., based on time and optionally location proximity) and a simple clustering algorithm to group the photos fetched from the device.

Pre-requisites: MVP 7 completed.

1. domain/use_cases/photo_analysis/calculate_similarity_use_case.dart (Update/Implement):

(If not created: CalculateSimilarityUseCase implements UseCase<List<SimilarityPair>, List<Photo>>, where SimilarityPair could be a class class SimilarityPair { Photo photoA; Photo photoB; double score; }).

call(List<Photo> photos):

Iterate through pairs of photos.

Calculate a similarity score:

Time-based: High score if photoA.dateTimeOriginal and photoB.dateTimeOriginal are very close (e.g., within a few minutes or seconds).

Location-based (Optional): If photoA.latitude/longitude and photoB.latitude/longitude are available and close, increase score.

(Future: This is where feature vector comparison would go).

Return a list of pairs with their similarity scores (or a similarity matrix).

2. domain/use_cases/collection_management/cluster_similar_photos_use_case.dart (Update/Implement):

(If not created: ClusterSimilarPhotosUseCase implements UseCase<List<PhotoGroup>, ClusterParams>, where ClusterParams might contain List<Photo> photos and List<SimilarityPair> similarityData).

call(ClusterParams params):

Takes the list of all photos and their similarity data.

Implement a basic clustering algorithm:

E.g., iterate through photos. If a photo is highly similar to an existing group's photos (or photos taken around the same short time window), add it to that group. Otherwise, create a new group.

A simple approach: group photos taken within X minutes of each other.

The output should be List<PhotoGroup>. Each PhotoGroup's date can be derived from the photos within it.

3. Update data/repositories_impl/photo_repository_impl.dart (or PhotoProcessingService if created):

Modify getPhotoGroups() (or a new method like processAndGroupPhotos):

After ScanDevicePhotosUseCase provides List<Photo>:

Call CalculateSimilarityUseCase with the list of photos.

Call ClusterSimilarPhotosUseCase with the photos and their similarity data.

The result is List<PhotoGroup>.

(Future: Cache these groups in MVP9).

Return these generated List<PhotoGroup>.

4. Update presentation/providers/clustering_view_provider.dart:

fetchPhotoGroups() will now get properly clustered groups based on the new use cases.

After clustering, for each group, ensure GetPhotoRecommendationsUseCase is called to identify best photos and set isBestCandidate flags.

Then applySmartSelection() should run.

Expected Outcome: Photos displayed on the Clustering screen are now grouped based on time (and optionally location) similarity, not just naively by day. Smart selection logic will apply to these new, more meaningful groups.

---

MVP 9: Local Database for Metadata Caching
Goal:
Implement a local SQLite database (using sqflite or a higher-level abstraction like floor or isar) to cache photo metadata, recommendation scores, and isBestCandidate flags. This will improve performance by avoiding re-scanning and re-analyzing all photos every time.

Pre-requisites: MVP 8 completed.

Add sqflite: ^2.0.0 and path_provider: ^2.0.0 (or latest for floor/isar) to pubspec.yaml. Run flutter pub get.

1. New Directory Structure (Data Layer Focus):
Create/ensure:

lib/data/data_sources/local/db/
|-- app_database.dart   # SQLite helper, table definitions, open/close DB
|-- photo_dao.dart      # Data Access Object for Photo entity
|-- photo_group_dao.dart # (Optional) DAO for PhotoGroup entity if groups are persisted as such


2. data/data_sources/local/db/app_database.dart:

Class AppDatabase.

Method Future<Database> get database async: Initializes and opens the SQLite database (e.g., photos.db).

onCreate script: Defines tables for photos (id, path, name, size, dateTimeOriginal, lat, long, clarity, exposure, faces, composition, colorfulness, recommendationScore, isBestCandidate, groupId_fk - optional) and potentially photo_groups (id, date).

3. data/data_sources/local/db/photo_dao.dart:

Class PhotoDao.

Takes Database instance.

Methods:

Future<void> insertPhoto(Photo photo)

Future<void> insertPhotos(List<Photo> photos) (batch insert)

Future<Photo?> getPhotoById(String id)

Future<List<Photo>> getAllPhotos()

Future<List<Photo>> getPhotosByGroupId(String groupId) (if grouping info is stored with photos)

Future<void> updatePhoto(Photo photo) (e.g., to update scores, isBestCandidate)

Future<int> deletePhoto(String id)

Future<int> deletePhotos(List<String> ids)

4. Update data/data_sources/local/local_photo_data_source.dart:

Inject AppDatabase (or PhotoDao).

Implement methods to interact with PhotoDao:

Future<void> cachePhotos(List<Photo> photos)

Future<List<Photo>> getCachedPhotos()

Future<void> updateCachedPhoto(Photo photo)

Future<void> deleteCachedPhotos(List<String> ids)

(Similar methods for PhotoGroup if you cache groups directly).

5. Update data/repositories_impl/photo_repository_impl.dart:

Inject LocalPhotoDataSource (which now uses the DB).

Modify getPhotoGroups():

Try to fetch processed PhotoGroups from localDataSource (which reads from DB).

If DB is empty or data is stale (implement a check or refresh logic):

Call ScanDevicePhotosUseCase (gets from device gallery).

Call CalculateSimilarityUseCase.

Call ClusterSimilarPhotosUseCase.

For each group, call GetPhotoRecommendationsUseCase.

Cache the newly processed List<Photo> (with scores and isBestCandidate) and the List<PhotoGroup> structure using localDataSource.

Return the List<PhotoGroup>.

Implement deletePhotos(List<String> photoIds):

Calls localDataSource.deleteCachedPhotos(photoIds).

(Future: also delete from device gallery if that's a feature).

6. Update Use Cases:

ScanDevicePhotosUseCase might now primarily focus on getting raw data from the device. The caching decision can be in the repository or a coordinating service.

CleanupPhotosUseCase would call repository.deletePhotos(), which now updates the database.

Expected Outcome:

Photo metadata and analysis results (scores, isBestCandidate) are persisted in a local SQLite database.

On subsequent app launches, data is loaded from the database, making the "Clustering" screen load faster.

A "refresh" mechanism might be needed to re-scan the device gallery and update the database.

Deleting photos updates the database.

This set of MVP prompts provides a structured, incremental path to building your Flutter application with a robust architecture. Each MVP delivers a runnable piece of functionality, allowing for testing and refinement along the way. Good luck!