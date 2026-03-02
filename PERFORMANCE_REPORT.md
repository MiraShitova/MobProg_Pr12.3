# Performance Optimization Report

## 1. Unnecessary Widget Rebuilds
- **Problem**: Using `context.watch<CartService>()` in the main screens caused the entire widget tree to rebuild whenever any item was added to the cart.
- **Fix**: 
    - Replaced `watch` with `Selector<CartService, T>` to listen only to specific fields (like `items.length` or `totalPrice`).
    - Extracted sub-widgets like `ProductTile` and `CartIconWithBadge` into `const` constructors where possible.
    - Used `context.read()` for action callbacks (like `addItem`) to avoid unnecessary subscriptions.

## 2. Heavy Computations in build()
- **Problem**: A heavy loop was running inside the `build()` method of `ProductListScreen`, causing frame drops (jank) during setiap rendering.
- **Fix**: 
    - Moved the computation logic to a static method and wrapped it in `compute()` to run it in a separate Isolate.
    - Triggered the computation once in `initState()` instead of every `build()`.

## 3. Results
- **UI Thread**: Smoother scrolling and animations.
- **CPU Usage**: Significant reduction during list interactions.
- **Memory**: Fewer short-lived objects created due to `const` usage.

*(Screenshots from DevTools would be attached here in a real scenario)*
