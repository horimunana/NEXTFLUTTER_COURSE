# 🛍️ Summer Shop — Flutter E-commerce App (Riverpod)

A functional e-commerce application built with **Flutter** and **Riverpod**
for state management. It demonstrates a clean **layered architecture** where
business logic (repositories + providers) is fully separated from widgets
(presentation).

> Data comes from a **fake API** — [Platzi Fake Store API](https://api.escuelajs.co)
> (also known as *Platzi Fake Store*). Each feature folder contains a
> `note.txt` file describing the API endpoint it uses (see
> `lib/features/auth/notes.txt`, `lib/features/home/note.txt`,
> `lib/features/filtrers/note.txt`). The *profile* screen uses **mock data**,
> and the *favorites* / *cart* are **persisted locally** with
> `shared_preferences`.

---

## ✨ Features

| Feature | Description |
| --- | --- |
| 🗂️ Product catalog | List + detail screens with **loading & error** states |
| 🧺 Shopping cart | Add / remove / change quantity, persisted locally |
| ❤️ Favorites | Toggle wishlist, persisted locally |
| 🔎 Filtering & sorting | Search by text, filter by category, sort by price/name |
| 👤 Profile | Mock user profile screen |
| 🔐 Auth | Login / register against the fake API (Platzi) |
| 🎬 Animations | Bouncing cart badge + "pop" animation when adding to cart |

---

## 📦 Packages used

| Package | Purpose |
| --- | --- |
| `flutter_hooks` + `hooks_riverpod` | State management (hooks flavor of Riverpod) |
| `dio` | HTTP client for the fake API |
| `go_router` | Navigation (routes + bottom-nav shell) |
| `shared_preferences` | Local persistence (cart, favorites, auth token) |
| `flutter_slidable` | Swipe-to-delete in the cart |

Run `flutter pub get` to install them.

---

## 🏗️ Architecture (layered)

```
lib/
├── core/
│   ├── api/dio_provider.dart                     # Dio HTTP client provider
│   └── provider/shared_preferences_provider.dart # SharedPreferences provider
├── utils/
│   ├── app_router.dart                           # go_router routes
│   ├── main_shell.dart                           # Bottom navigation shell
│   └── theme.dart                                # App theme
└── features/                                     # One folder per feature
    ├── auth/        # login/register (fake API)
    ├── home/        # product catalog, cart  (fake API)
    ├── favorites/   # wishlist (local persistence)
    ├── filtrers/    # filter + sort logic (client side)
    └── profile/     # mock user profile
        ├── models/          # data models (entities)
        ├── repositories/    # data access (HTTP / local)
        ├── providers/       # Riverpod state (business logic)
        └── presentation/    # pages + widgets (UI, no logic)
```

- **Models** (`models/`) – plain data classes (`ProductModel`, `CartModel`, …).
- **Repositories** (`repositories/`) – fetch data from the fake API.
- **Providers** (`providers/`) – encapsulate all state & business rules.
- **Presentation** (`presentation/` + `widget/`) – widgets only render state,
  they never fetch data or mutate it directly.

---

## 🧠 Providers (≥ 5 required)

| Provider | Type | Responsibility |
| --- | --- | --- |
| `dioProvider` | `Provider<Dio>` | Configured HTTP client for the fake API |
| `sharedPreferencesProvider` | `Provider<SharedPreferences>` | Local storage handle |
| `productApiProvider` | `FutureProvider<List<ProductModel>>` | Fetches the catalog (→ `AsyncValue`) |
| `productDetailProvider` | `FutureProvider.family<int>` | Fetches a single product |
| `cartProvider` | `NotifierProvider<CartController, List<CartModel>>` | Cart state + **local persistence** |
| `cartCountProvider` | `Provider<int>` | Derived badge count |
| `cartTotalProvider` | `Provider<int>` | Derived cart total |
| `favoritesProvider` | `NotifierProvider<FavoritesController, List<ProductModel>>` | Wishlist + **local persistence** |
| `filterProvider` | `NotifierProvider<FilterController, FilterModel>` | Search / category / sort state |
| `categoriesProvider` | `Provider<AsyncValue<List<String>>>` | Category list derived from catalog |
| `filteredProductsProvider` | `Provider<AsyncValue<List<ProductModel>>>` | Filtered + sorted catalog |
| `authProvider` | `NotifierProvider<AuthController, AuthState>` | Login / register / logout |
| `profileProvider` | `Provider<ProfileModel>` | Mock user profile |

Async data flows through `AsyncValue` and is rendered with `.when(...)`
(loading / error / data) in `ProductGrid`, `HomePage`, `DetailPage` and the
search screen.

---

## 🚀 Run it

```bash
flutter pub get
flutter run
```

Demo login credentials (fake API):

```
email:    john@mail.com
password: changeme
```

---

## 🧪 Tests

```bash
flutter test
```

Covers the cart controller, favorites persistence, filtering/sorting logic
and an add-to-cart widget interaction.

---

## 📁 API notes

Each feature folder ships a `note.txt` describing the endpoint / data source:

- `lib/features/auth/notes.txt` — `POST /api/v1/auth/login`, `POST /api/v1/users/`
- `lib/features/home/note.txt` — `GET /api/v1/products`, `GET /api/v1/products/{id}`
- `lib/features/filtrers/note.txt` — catalog fetch + client-side filter notes
- `lib/features/favorites/note.txt` — locally persisted, no API
- `lib/features/profile/note.txt` — mock data, no API