<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/16
 * Time: 11:47
 */

namespace app\api\controller;


use app\api\model\Cart;
use app\api\model\Member;
use think\Controller;
use think\Model;

class MemberController extends Controller
{

    public function infoAction()
    {
        $type = input('type');
        $value = input('value');

        switch($type) {
            case 'email':
                $query = Member::where('email', $value);
                break;
            case 'telephone':
                $query = Member::where('telephone', $value);
                break;
            case 'username':
                $query = Member::where('username', $value);
                break;
            case 'id':
            default:
                $query = Member::where('id', $value);
                break;
        }

        return $query->find() ?: null;
    }


    /**
     * 添加会员
     */
    public function addAction()
    {
        # 一定需要做验证

        $member = new Member();
        $result = $member->data(input())->allowField(true)->save();

        if ($result) {
            return [
                'error' => false,
                'member_id' => $member->id,
            ];
        } else {
            return [
                'error' => true,
            ];
        }
    }

    /**
     * 更新会员购物车表
     */
    public function cartUpdateAction()
    {
        $member_id = input('member_id');
        $content = input('content');

        # 判断会员是否存在购物车, 不存在则实例化新购物车
        $cart = Cart::get(['member_id'=>$member_id]) ?: (new Cart());

        $cart->member_id = $member_id;
        $cart->content = $content;
        $cart->save();

        return [
            'error' => false,
            'cart_id' => $cart->id,
        ];
    }

    /**
     * 会员购物车信息
     * @return null|static
     */
    public function cartInfoAction()
    {
        $member_id = input('member_id');
        $cart = Cart::get(['member_id'=>$member_id]);

        return $cart;
    }
}