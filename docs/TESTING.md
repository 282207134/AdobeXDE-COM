# 测试说明

## 环境

| 项目 | 本次环境 |
|---|---|
| 日期 | 2026-11-08 |
| Flutter / Dart | 3.47.7 / 3.13.5 |
| Android 设备 | 已运行的 BlueStacks，设备名称 SM S908E |
| 设备 ID | emulator-5554 |
| 系统 | Android 11 / API 30 / x64 |
| 组件布局尺寸 | 375 × 667，浅色及深色 |
| 设备截图尺寸 | 1080 × 2340，460 dpi |

复用了现有 SDK、Gradle 缓存和模拟器。截图期间临时调整显示尺寸，完成后恢复原来的 1080 × 1920、240 dpi。

## 已通过的检查

1. `flutter analyze`：无问题。
2. `flutter test --concurrency=1`：6 项测试全部通过。
3. Android debug 构建与安装成功。
4. Android 设备集成测试成功：逐页渲染 31 个页面/状态的浅色、深色主题，并检查 Flutter 异常。
5. 设备上完成登录 → 搜索 Nike → 商品详情 → 加入购物车 → 配送 → 地址 → 支付 → 订单摘要 → 下单成功。
6. 已保存 62 张主题截图，加 1 张设备下单结果图；`overview.png` 为实际截图生成的文档预览。
7. ARM64 与 x64 release 演示包构建通过，x64 包重新安装并启动验证；显示尺寸恢复为原配置。

组件测试覆盖数量、优惠、税费和总价；本地状态恢复；卡号和有效期校验；两种主题的小屏布局；通过可见控件完成购物流程。为避免本地存储模拟与渲染测试共享状态，两类测试分文件组织。

## 截图复现

```bash
flutter drive --driver=test_driver/screenshots.dart --target=integration_test/app_test.dart -d emulator-5554
```

测试使用独立的内存数据，不覆盖普通 App 已保存的数据。文件写入 `docs/screenshots/`，按 `light-页面名.png` 和 `dark-页面名.png` 命名。

原稿位图在 `docs/reference/`，实际 App 截图在 `docs/screenshots/`，两者没有混用。

## 未验证部分

- iOS 编译、签名与真机运行需要 macOS/Xcode，本机未验证。
- ARM64 安装包的运行未经过 ARM64 真机测试。
- 未连接真实账户、支付、物流、远程商品及图像识别服务。
- Android 发行包用于演示，使用调试签名。

## 构建配置

保留 Flutter 3.47.7 对应的 AGP 9.1.0 / Gradle 9.3.1。当前机器的 Kotlin DSL 模板在 app 模块出现扩展引用解析错误，因此 app 模块使用等价的 Groovy 构建文件，已实际通过构建。

当前 Kotlin 插件兼容配置可用，Flutter 提示未来版本将迁移到内置 Kotlin；升级时需按[官方迁移说明](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers)同步调整。
