<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/19
 * Time: 11:37
 */

namespace app\api\controller;


use app\api\model\Order;
use app\api\model\OrderProduct;
use think\Controller;
use think\Db;

class OrderController extends Controller
{
    public function addAction()
    {
        $order_data = input();
        $products = $order_data['products'];
        unset($order_data['products']);

        # 事务，订单生成事务
        Db::startTrans();

        # order表
        $order = new Order();
        $order_result = $order->data($order_data)->allowField(true)->save();

        if ($order_result) {
            # order_product
            $products_result = (new OrderProduct())->saveAll(array_map(function($product) use($order) {
                $product['order_id'] = $order->id;
                return $product;
            }, $products));
        }

        # 执行提交或者回滚
        if($order_result && $products_result) {
            Db::commit();
            return [
                'error' => false,
                'order_id' => $order->id,
            ];
        } else {
            Db::rollback();
            return [
                'error' => true,
            ];
        }

    }

}