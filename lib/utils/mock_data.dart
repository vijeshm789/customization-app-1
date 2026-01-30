import '../models/fabric.dart';
import '../models/fabric_category.dart';
import '../models/uniform_model.dart';
import '../models/garment_zone.dart';

class MockData {
  MockData._();

  static List<FabricCategory> getCategories() {
    return [
      FabricCategory(
        id: 'cat_1',
        name: 'Ais',
        description: 'Premium Ais collection fabrics',
        folders: [
          const FabricFolder(
            id: 'folder_1_1',
            name: 'Bentley',
            categoryId: 'cat_1',
            fabricCount: 12,
          ),
          const FabricFolder(
            id: 'folder_1_2',
            name: 'Zoom',
            categoryId: 'cat_1',
            fabricCount: 8,
          ),
          const FabricFolder(
            id: 'folder_1_3',
            name: 'Classic',
            categoryId: 'cat_1',
            fabricCount: 15,
          ),
        ],
      ),
      FabricCategory(
        id: 'cat_2',
        name: 'Eco-Kids',
        description: 'Eco-friendly fabrics for children',
        folders: [
          const FabricFolder(
            id: 'folder_2_1',
            name: 'Cotton Blend',
            categoryId: 'cat_2',
            fabricCount: 10,
          ),
          const FabricFolder(
            id: 'folder_2_2',
            name: 'Organic',
            categoryId: 'cat_2',
            fabricCount: 6,
          ),
          const FabricFolder(
            id: 'folder_2_3',
            name: 'Comfort Weave',
            categoryId: 'cat_2',
            fabricCount: 9,
          ),
        ],
      ),
      FabricCategory(
        id: 'cat_3',
        name: 'Premium Combinations',
        description: 'Premium fabric combinations',
        folders: [
          const FabricFolder(
            id: 'folder_3_1',
            name: 'Executive',
            categoryId: 'cat_3',
            fabricCount: 7,
          ),
          const FabricFolder(
            id: 'folder_3_2',
            name: 'Elite',
            categoryId: 'cat_3',
            fabricCount: 11,
          ),
          const FabricFolder(
            id: 'folder_3_3',
            name: 'Royal',
            categoryId: 'cat_3',
            fabricCount: 5,
          ),
        ],
      ),
      FabricCategory(
        id: 'cat_4',
        name: 'Medical',
        description: 'Fabrics for medical uniforms',
        folders: [
          const FabricFolder(
            id: 'folder_4_1',
            name: 'Scrubs Pro',
            categoryId: 'cat_4',
            fabricCount: 8,
          ),
          const FabricFolder(
            id: 'folder_4_2',
            name: 'Lab Coat',
            categoryId: 'cat_4',
            fabricCount: 4,
          ),
        ],
      ),
      FabricCategory(
        id: 'cat_5',
        name: 'Corporate',
        description: 'Professional corporate fabrics',
        folders: [
          const FabricFolder(
            id: 'folder_5_1',
            name: 'Formal',
            categoryId: 'cat_5',
            fabricCount: 12,
          ),
          const FabricFolder(
            id: 'folder_5_2',
            name: 'Business Casual',
            categoryId: 'cat_5',
            fabricCount: 9,
          ),
        ],
      ),
    ];
  }

  static List<Fabric> getAllFabrics() {
    final List<Fabric> fabrics = [];
    int fabricId = 1;

    // Ais - Bentley
    final bentleyColors = ['Navy Blue', 'Royal Blue', 'Sky Blue', 'White', 'Grey', 'Black', 'Maroon', 'Green', 'Yellow', 'Red', 'Purple', 'Orange'];
    for (var color in bentleyColors) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Bentley $color',
        code: 'BNT-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_1',
        folderId: 'folder_1_1',
        material: 'Polyester Cotton Blend',
        colors: [color],
      ));
    }

    // Ais - Zoom
    final zoomColors = ['Navy', 'White', 'Grey', 'Black', 'Blue', 'Green', 'Maroon', 'Red'];
    for (var color in zoomColors) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Zoom $color',
        code: 'ZM-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_1',
        folderId: 'folder_1_2',
        material: 'Premium Polyester',
        colors: [color],
      ));
    }

    // Ais - Classic
    final classicPatterns = ['Stripes Blue', 'Stripes Grey', 'Checks Blue', 'Checks Grey', 'Solid Navy', 'Solid White', 'Solid Grey', 'Solid Black', 'Herringbone', 'Twill Blue', 'Twill Grey', 'Oxford Blue', 'Oxford White', 'Pinstripe Navy', 'Pinstripe Grey'];
    for (var pattern in classicPatterns) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Classic $pattern',
        code: 'CLS-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_1',
        folderId: 'folder_1_3',
        material: 'Cotton',
        colors: [pattern.split(' ').last],
      ));
    }

    // Eco-Kids - Cotton Blend
    final cottonBlendColors = ['Sky Blue', 'Pink', 'Yellow', 'Green', 'White', 'Navy', 'Grey', 'Lavender', 'Mint', 'Peach'];
    for (var color in cottonBlendColors) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Cotton Blend $color',
        code: 'ECB-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_2',
        folderId: 'folder_2_1',
        material: 'Organic Cotton Blend',
        colors: [color],
      ));
    }

    // Eco-Kids - Organic
    final organicColors = ['Natural White', 'Sky Blue', 'Sage Green', 'Soft Pink', 'Cream', 'Light Grey'];
    for (var color in organicColors) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Organic $color',
        code: 'ECO-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_2',
        folderId: 'folder_2_2',
        material: '100% Organic Cotton',
        colors: [color],
      ));
    }

    // Eco-Kids - Comfort Weave
    final comfortColors = ['Blue', 'Pink', 'Green', 'Yellow', 'White', 'Grey', 'Navy', 'Maroon', 'Purple'];
    for (var color in comfortColors) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Comfort $color',
        code: 'ECW-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_2',
        folderId: 'folder_2_3',
        material: 'Soft Weave Cotton',
        colors: [color],
      ));
    }

    // Premium Combinations - Executive
    final executiveStyles = ['Charcoal Grey', 'Navy Blue', 'Black', 'Dark Grey', 'Midnight Blue', 'Oxford Grey', 'Steel Blue'];
    for (var style in executiveStyles) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Executive $style',
        code: 'EXE-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_3',
        folderId: 'folder_3_1',
        material: 'Premium Wool Blend',
        colors: [style],
      ));
    }

    // Premium Combinations - Elite
    final eliteStyles = ['Platinum', 'Silver', 'Gold Weave', 'Diamond Check', 'Pearl White', 'Onyx Black', 'Sapphire Blue', 'Ruby Red', 'Emerald Green', 'Topaz Yellow', 'Amethyst Purple'];
    for (var style in eliteStyles) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Elite $style',
        code: 'ELT-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_3',
        folderId: 'folder_3_2',
        material: 'Luxury Silk Blend',
        colors: [style],
      ));
    }

    // Premium Combinations - Royal
    final royalStyles = ['Imperial Blue', 'Regal Purple', 'Majestic Gold', 'Crown Silver', 'Noble Grey'];
    for (var style in royalStyles) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Royal $style',
        code: 'RYL-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_3',
        folderId: 'folder_3_3',
        material: 'Italian Silk',
        colors: [style],
      ));
    }

    // Medical - Scrubs Pro
    final scrubsColors = ['Ceil Blue', 'Navy', 'Caribbean Blue', 'Hunter Green', 'Burgundy', 'Black', 'Grey', 'White'];
    for (var color in scrubsColors) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Scrubs $color',
        code: 'SCR-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_4',
        folderId: 'folder_4_1',
        material: 'Medical Grade Polyester',
        colors: [color],
      ));
    }

    // Medical - Lab Coat
    final labCoatStyles = ['Classic White', 'Bright White', 'Off White', 'Light Blue'];
    for (var style in labCoatStyles) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Lab Coat $style',
        code: 'LAB-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_4',
        folderId: 'folder_4_2',
        material: 'Premium Cotton Twill',
        colors: [style],
      ));
    }

    // Corporate - Formal
    final formalStyles = ['Navy Pinstripe', 'Charcoal Solid', 'Black Solid', 'Grey Pinstripe', 'Dark Navy', 'Slate Grey', 'Midnight Black', 'Steel Blue', 'Oxford Blue', 'Graphite', 'Deep Charcoal', 'Classic Navy'];
    for (var style in formalStyles) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Formal $style',
        code: 'FRM-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_5',
        folderId: 'folder_5_1',
        material: 'Wool Polyester Blend',
        colors: [style],
      ));
    }

    // Corporate - Business Casual
    final casualStyles = ['Khaki', 'Navy Chino', 'Stone', 'Olive', 'Tan', 'Light Grey', 'Blue Check', 'Grey Heather', 'Denim Blue'];
    for (var style in casualStyles) {
      fabrics.add(Fabric(
        id: 'fab_${fabricId++}',
        name: 'Casual $style',
        code: 'CAS-${fabricId.toString().padLeft(3, '0')}',
        imageUrl: 'assets/images/fabrics/fabric_$fabricId.png',
        categoryId: 'cat_5',
        folderId: 'folder_5_2',
        material: 'Cotton Stretch',
        colors: [style],
      ));
    }

    return fabrics;
  }

  static List<UniformModel> getUniformModels() {
    return [
      // Boys models
      UniformModel(
        id: 'model_boy_1',
        name: 'Boys Shirt & Pants',
        category: ModelCategory.boys,
        imageUrl: 'assets/images/models/boy_shirt_pants.png',
        overlayImageUrl: 'assets/images/models/boy_shirt_pants_overlay.png',
        availableZones: [
          GarmentZoneType.collar,
          GarmentZoneType.leftSleeve,
          GarmentZoneType.rightSleeve,
          GarmentZoneType.body,
          GarmentZoneType.pant,
        ],
      ),
      UniformModel(
        id: 'model_boy_2',
        name: 'Boys Kurta Pajama',
        category: ModelCategory.boys,
        imageUrl: 'assets/images/models/boy_kurta_pajama.png',
        overlayImageUrl: 'assets/images/models/boy_kurta_pajama_overlay.png',
        availableZones: [
          GarmentZoneType.collar,
          GarmentZoneType.kurta,
          GarmentZoneType.pajama,
          GarmentZoneType.pajamaStrip,
        ],
      ),
      UniformModel(
        id: 'model_boy_3',
        name: 'Boys Polo',
        category: ModelCategory.boys,
        imageUrl: 'assets/images/models/boy_polo.png',
        overlayImageUrl: 'assets/images/models/boy_polo_overlay.png',
        availableZones: [
          GarmentZoneType.collar,
          GarmentZoneType.leftSleeve,
          GarmentZoneType.rightSleeve,
          GarmentZoneType.body,
        ],
      ),
      // Girls models
      UniformModel(
        id: 'model_girl_1',
        name: 'Girls Shirt & Skirt',
        category: ModelCategory.girls,
        imageUrl: 'assets/images/models/girl_shirt_skirt.png',
        overlayImageUrl: 'assets/images/models/girl_shirt_skirt_overlay.png',
        availableZones: [
          GarmentZoneType.collar,
          GarmentZoneType.leftSleeve,
          GarmentZoneType.rightSleeve,
          GarmentZoneType.body,
        ],
      ),
      UniformModel(
        id: 'model_girl_2',
        name: 'Girls Salwar Kameez',
        category: ModelCategory.girls,
        imageUrl: 'assets/images/models/girl_salwar_kameez.png',
        overlayImageUrl: 'assets/images/models/girl_salwar_kameez_overlay.png',
        availableZones: [
          GarmentZoneType.collar,
          GarmentZoneType.kurta,
          GarmentZoneType.pajama,
        ],
      ),
      UniformModel(
        id: 'model_girl_3',
        name: 'Girls Pinafore',
        category: ModelCategory.girls,
        imageUrl: 'assets/images/models/girl_pinafore.png',
        overlayImageUrl: 'assets/images/models/girl_pinafore_overlay.png',
        availableZones: [
          GarmentZoneType.body,
          GarmentZoneType.buttonStrip,
        ],
      ),
      // Corporate models
      UniformModel(
        id: 'model_corp_1',
        name: 'Corporate Shirt',
        category: ModelCategory.corporate,
        imageUrl: 'assets/images/models/corporate_shirt.png',
        overlayImageUrl: 'assets/images/models/corporate_shirt_overlay.png',
        availableZones: [
          GarmentZoneType.collar,
          GarmentZoneType.leftSleeve,
          GarmentZoneType.rightSleeve,
          GarmentZoneType.buttonStrip,
          GarmentZoneType.body,
        ],
      ),
      UniformModel(
        id: 'model_corp_2',
        name: 'Corporate Suit',
        category: ModelCategory.corporate,
        imageUrl: 'assets/images/models/corporate_suit.png',
        overlayImageUrl: 'assets/images/models/corporate_suit_overlay.png',
        availableZones: [
          GarmentZoneType.collar,
          GarmentZoneType.body,
          GarmentZoneType.pant,
        ],
      ),
      // Medical models
      UniformModel(
        id: 'model_med_1',
        name: 'Medical Scrubs',
        category: ModelCategory.medical,
        imageUrl: 'assets/images/models/medical_scrubs.png',
        overlayImageUrl: 'assets/images/models/medical_scrubs_overlay.png',
        availableZones: [
          GarmentZoneType.body,
          GarmentZoneType.pant,
        ],
      ),
      UniformModel(
        id: 'model_med_2',
        name: 'Lab Coat',
        category: ModelCategory.medical,
        imageUrl: 'assets/images/models/lab_coat.png',
        overlayImageUrl: 'assets/images/models/lab_coat_overlay.png',
        availableZones: [
          GarmentZoneType.collar,
          GarmentZoneType.leftSleeve,
          GarmentZoneType.rightSleeve,
          GarmentZoneType.body,
        ],
      ),
    ];
  }

  static List<String> getBannerImages() {
    return [
      'assets/images/banners/banner_1.png',
      'assets/images/banners/banner_2.png',
      'assets/images/banners/banner_3.png',
    ];
  }
}
