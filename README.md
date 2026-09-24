# Product Catalog App

A multi-screen mobile product catalog application built using Flutter, strict Clean Architecture, and Unidirectional State Management via `flutter_bloc`.

---

## 📱 Features

1. **Product List:** Displays products with title, category, price, and cached thumbnails.
2. **Infinite Pagination:** Automatically detects when the user scrolls near the bottom (90% threshold) and appends the next 20 items from DummyJSON (`limit=20&skip=X`) without resetting scroll position or replacing existing items.
3. **Debounced Search:** Reactive search bar with a **300ms debounce transformer** to rate-limit outbound network calls while typing.
4. **Product Detail Screen:** Features a multi-image swipeable carousel with indicator dots, full descriptions, pricing, customer rating badges, and live inventory status.
5. **Robust State Handling:** Discrete visual states for:
   - **Loading:** Shimmer skeleton placeholders.
   - **Loaded:** Full content display with pull-to-refresh.
   - **Error:** User-friendly error message with an interactive **Retry** button.
   - **Empty:** Informative empty-state view for zero search results.
6. **Optimized Network & Image Caching:** Built with `dio` (timeouts & logging interceptors) and `cached_network_image` for offline memory & disk caching.

---

## 🏛️ Architecture & Folder Structure

This application strictly implements **Uncle Bob's Clean Architecture**, enforcing the **Dependency Inversion Principle**: the domain layer remains pure Dart, completely decoupled from UI widgets, JSON parsing, or network frameworks.

```
lib/
├── core/
│   ├── constants/             # Centralized API URLs & endpoints
│   ├── error/                 # Failure abstractions (ServerFailure, NetworkFailure)
│   └── network/               # Configured DioClient with timeouts and LogInterceptor
├── data/
│   ├── datasources/           # ProductRemoteDataSource hitting DummyJSON endpoints
│   ├── models/                # ProductModel DTO with defensive fromJson/toJson parsing
│   └── repositories/          # ProductRepositoryImpl mapping DTOs to Entities & catching Failures
├── domain/
│   ├── entities/              # Pure Dart Product entity extending Equatable
│   └── repositories/          # Abstract ProductRepository contract
├── presentation/
│   ├── bloc/                  # ProductBloc, ProductEvent, and ProductState (with 300ms debounce)
│   ├── pages/                 # ProductListPage and ProductDetailPage
│   └── widgets/               # ProductCard, ProductSearchBar, ProductShimmerList, ErrorView, EmptyView
└── main.dart                  # Dependency injection root & app runner
```

---

## 🌐 DummyJSON API Integration

| Feature | HTTP Method & Endpoint | Description |
| :--- | :--- | :--- |
| **List** | `GET https://dummyjson.com/products?limit=20&skip=0` | Paginated product list |
| **Detail** | `GET https://dummyjson.com/products/{id}` | Complete product specifications & gallery |
| **Search** | `GET https://dummyjson.com/products/search?q={query}` | Query-based product search |

---

## 🛠️ Tech Stack & Key Libraries

- **Framework:** Flutter (Channel stable, Dart 3.x)
- **State Management:** `flutter_bloc` (^9.1.1)
- **Networking:** `dio` (^5.11.1)
- **Value Equality:** `equatable` (^3.0.0)
- **Image Caching:** `cached_network_image` (^3.4.1)
- **Skeleton Loading:** `shimmer` (^3.0.0)
- **Testing:** `flutter_test`, `bloc_test` (^10.0.0), `mocktail` (^1.0.5)

---

## 🚀 Getting Started

### 1. Clone & Install Dependencies
```bash
git clone https://github.com/Afif2473/myProductCatalog.git
cd myProductCatalog
flutter pub get
```

### 2. Run the Application
```bash
# Run on Chrome
flutter run -d chrome

# Or run on connected Android/iOS device or emulator
flutter run
```

---

## 🧪 Running Unit & Widget Tests

Run the complete test suite across domain, data, BLoC, and presentation layers:

```bash
flutter test
```

### Test Coverage Highlights:
- `test/domain/product_test.dart`: Validates entity value equality via `Equatable`.
- `test/data/product_data_layer_test.dart`: Validates all 3 remote endpoints (List, Detail, Search) against DummyJSON.
- `test/presentation/bloc/product_bloc_test.dart`: Verifies state transitions (`ProductLoading`, `ProductLoaded`, `ProductError`) and pagination append logic using `bloc_test` and `mocktail`.
- `test/presentation/pages/product_list_page_test.dart`: Widget test confirming shimmer rendering and loaded product cards.
- `test/presentation/pages/product_detail_page_test.dart`: Widget test verifying product detail specifications.

---

## 🎥 Video Walkthrough Supplement

> **Note on Video Time-Box:** To respect the strict **5-minute time limit** for the video submission, the screen recording covers the **live application demo**, the **Clean Architecture file structure**, and the primary **Pagination Append Logic**. Below is the technical breakdown of the remaining architectural decisions and edge-case handling.

### 1. Native 300ms Debounce Transformer on Search
- **File & Lines:** [`lib/presentation/bloc/product_bloc.dart` (lines 9–29)](lib/presentation/bloc/product_bloc.dart#L9-L29)
- **Technique:** Implemented a custom `EventTransformer` using pure Dart `Stream.multi` and `Timer` rather than importing external stream libraries.
- **Why Server-Side Search Endpoint over Client-Side Filtering:** Client-side filtering can only filter products already fetched in memory (e.g. the first 20 items), whereas the server-side Search API (`/products/search?q={query}`) queries DummyJSON's entire product database.
- **Analogy:** *Think of an elevator door with a motion sensor. If passengers keep stepping through, the door timer resets. Only after everyone pauses does the door close. The debounce transformer cancels pending timers on each keystroke and only dispatches the search event after 300ms of inactivity.*

### 2. Defensive JSON Parsing (Edge Case Handling)
- **File & Lines:** [`lib/data/models/product_model.dart` (lines 17–33)](lib/data/models/product_model.dart#L17-L33)
- **Technique:** Numerical attributes use `(json['price'] as num?)?.toDouble() ?? 0.0` and `(json['stock'] as num?)?.toInt() ?? 0`.
- **Why:** Real-world REST APIs frequently return integers (e.g., `10`) instead of floating-point numbers (`10.0`). Casting directly with `json['price'] as double` causes runtime `_TypeError` exceptions. Casting to `num` first guarantees safe conversion.

### 3. User-Centric Error Recovery & Resilience
- **File & Lines:** [`lib/presentation/widgets/error_view.dart` (lines 34–45)](lib/presentation/widgets/error_view.dart#L34-L45)
- **Technique:** Dedicated `ErrorView` component with an explicit `Retry` callback button that re-fires `GetProductsEvent()`.
- **Why:** In mobile banking and enterprise applications, network dropouts should never force the user to kill and restart the app. An inline retry maintains session context and allows seamless recovery.

### 4. Image Caching & Memory Efficiency
- **File & Lines:** [`lib/presentation/widgets/product_card.dart` (lines 33–50)](lib/presentation/widgets/product_card.dart#L33-L50)
- **Technique:** Thumbnail images wrapped with `CachedNetworkImage` with disk/memory caching and fallback error icons.
- **Why:** Prevents duplicate network downloads as users scroll up and down the list, lowering battery and bandwidth consumption.
