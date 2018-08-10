<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/17
 * Time: 16:42
 */

namespace app\index\controller;


use think\Controller;

class ShippingController extends Controller
{
    public function priceAction()
    {
        $name = input('name');
        $class = 'shipping\\' . $name;
        $shippingObject = new $class();
        return [
            'name' => $name,
            'price' => $shippingObject->price()
            ];
    }
}