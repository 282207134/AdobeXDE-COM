# App 实际运行截图

截图来自现有 Android 11 / API 30 BlueStacks 设备。62 张逐页截图覆盖 31 个页面/状态的浅色、深色主题，另附一张经过完整购物流程后的下单成功图。分辨率 1080 × 2340。

![主要界面](overview.png)

所有页面总览：[浅色](gallery-light.png) · [深色](gallery-dark.png)。另有恢复原显示设置后的 [x64 发行演示包启动截图](release-smoke.png)。

| 页面/状态 | 对应浅色原稿节点 | 浅色截图 | 深色截图 |
|---|---|---|---|
| 登录 | `0:5` | [查看](light-welcome.png) | [查看](dark-welcome.png) |
| 注册 | `0:49` | [查看](light-signup.png) | [查看](dark-signup.png) |
| 验证码 | `0:81` | [查看](light-verification.png) | [查看](dark-verification.png) |
| 首页 | `0:101` | [查看](light-home.png) | [查看](dark-home.png) |
| 首页滚动状态 | `0:205` | [查看](light-homeScroll.png) | [查看](dark-homeScroll.png) |
| 分类 | `0:407` | [查看](light-categories.png) | [查看](dark-categories.png) |
| 品牌 | `0:603` | [查看](light-brand.png) | [查看](dark-brand.png) |
| 筛选 | `0:750` | [查看](light-filter.png) | [查看](dark-filter.png) |
| 展开筛选 | `0:964` | [查看](light-filterExpanded.png) | [查看](dark-filterExpanded.png) |
| 搜索 | `0:1216` | [查看](light-search.png) | [查看](dark-search.png) |
| 搜索建议 | `0:1350` | [查看](light-suggestions.png) | [查看](dark-suggestions.png) |
| 图片搜索 | `0:1448` | [查看](light-imageSearch.png) | [查看](dark-imageSearch.png) |
| 识图结果 | `0:1554` | [查看](light-imageResults.png) | [查看](dark-imageResults.png) |
| 识图结果详情 | `0:1660` | [查看](light-imageResultDetail.png) | [查看](dark-imageResultDetail.png) |
| 商品详情 | `0:1760` | [查看](light-product.png) | [查看](dark-product.png) |
| 商品评价状态 | `0:1824` | [查看](light-reviews.png) | [查看](dark-reviews.png) |
| 购物车 | `0:1954` | [查看](light-cart.png) | [查看](dark-cart.png) |
| 结算配送 | `0:2209` | [查看](light-delivery.png) | [查看](dark-delivery.png) |
| 结算地址 | `0:2415` | [查看](light-address.png) | [查看](dark-address.png) |
| 结算支付 | `0:2681` | [查看](light-payment.png) | [查看](dark-payment.png) |
| 订单摘要 | `0:2848` | [查看](light-summary.png) | [查看](dark-summary.png) |
| 个人中心 | `0:2899` | [查看](light-profile.png) | [查看](dark-profile.png) |
| 订单历史 | `0:2993` | [查看](light-orders.png) | [查看](dark-orders.png) |
| 订单跟踪 | `0:3185` | [查看](light-tracking.png) | [查看](dark-tracking.png) |
| 订单地图 | `0:3296` | [查看](light-trackingMap.png) | [查看](dark-trackingMap.png) |
| 已存卡片 | `0:3383` | [查看](light-cards.png) | [查看](dark-cards.png) |
| 新增卡片 | `0:3558` | [查看](light-addCard.png) | [查看](dark-addCard.png) |
| 地址管理 | `0:3682` | [查看](light-addresses.png) | [查看](dark-addresses.png) |
| 收藏 | `0:3758` | [查看](light-wishlist.png) | [查看](dark-wishlist.png) |
| 编辑资料 | `补充页面` | [查看](light-editProfile.png) | [查看](dark-editProfile.png) |
| 下单成功 | `补充页面` | [查看](light-success.png) | [查看](dark-success.png) |

[设备完整流程：下单成功](journey-order-success.png)

截图由 `integration_test/app_test.dart` 采集；`overview.png` 由四张实际截图缩小排列，未替换界面内容。原始设计参考图另存于 `../reference/`。
