<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/16
 * Time: 9:42
 */

namespace app\index\behavior;
use think\View;

class ShopInfo
{
    public function run()
    {

        View::share('telephone', appConfig('shop-telephone'));
        View::share('shop_title', appConfig('shop-title'));
    }
}