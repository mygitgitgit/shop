<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

//return [
//    '__pattern__' => [
//        'name' => '\w+',
//    ],
//    '[hello]'     => [
//        ':id'   => ['site/hello', ['method' => 'get'], ['id' => '\d+']],
//        ':name' => ['site/hello', ['method' => 'post']],
//    ],
//
//];

use think\Route;

# 数据接口API，Application Program Interface
Route::get('products', 'api/product/list');
Route::get('member-info', 'api/member/info');
Route::post('member-add', 'api/member/add');
Route::post('member-cart-update', 'api/member/cartUpdate');
Route::get('member-cart-info', 'api/member/cartInfo');
Route::post('address-add', 'api/address/add');
Route::get('addresses', 'api/address/list');
Route::get('address', 'api/address/info');
Route::post('address-set-default', 'api/address/setDefault');
Route::get('regions', 'api/region/list');
Route::get('shippings', 'api/shipping/list');
Route::post('order-add', 'api/order/add');

# 购物车逻辑
// 添加
Route::post('cart-add', 'index/cart/add');
// 购物车信息
Route::get('cart-info', 'index/cart/info');
// 更新
Route::post('cart-update', 'index/cart/update');
// 删除
Route::post('cart-remove', 'index/cart/remove');
// 展示
Route::get('html/cart', 'index/cart/index');

# 会员
Route::rule('html/register', 'index/member/register', 'GET|POST');
Route::rule('html/login', 'index/member/login', 'GET|POST');
Route::post('html/logout', 'index/member/logout');
Route::post('html/checkout', 'index/member/checkout');

# 收货地址
Route::post('member-address-add', 'index/member/addressAdd');
Route::get('member-address-list', 'index/member/addressList');

# 运费
Route::get('shipping-price', 'index/shipping/price');

# 订单
Route::post('html/mkOrder', 'index/order/make');
Route::get('html/orderResult', 'index/order/result');
Route::get('order-progress', 'index/order/progress');
Route::get('order-status', 'index/order/status');
Route::get('html/pay-return', 'index/order/return');
Route::get('html/pay', 'index/order/pay');

