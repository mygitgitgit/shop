<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/14
 * Time: 11:57
 */

namespace app\index\controller;


use cart\Cart;
use think\Controller;

class CartController extends Controller
{

    public function indexAction()
    {
        # 获取全部的购物商品
        $this->assign('product_list', Cart::instance()->exportInfo());

        # 展示
        return $this->fetch();
    }

    public function addAction()
    {
        # 操作Cart类，完成购物车管理
        Cart::instance()
            ->add(input('product_id'),input('buy_quantity', '1'))
        ;
        return [
            'error' => false,
        ];
    }

    /**
     * 获取购物车产品信息
     */
    public function infoAction()
    {
        return Cart::instance()->exportInfo();
    }
    /**
     * 更新
     */
    public function updateAction()
    {
        Cart::instance()->update(input('product_id'), input('buy_quantity'));

        return [
            'error' => false
        ];
    }

    /**
     * 删除
     */
    public function removeAction()
    {
        Cart::instance()->remove(input('product_id'));

        return [
            'error' => false,
        ];
    }

}