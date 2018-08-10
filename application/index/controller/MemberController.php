<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/16
 * Time: 11:20
 */

namespace app\index\controller;


use app\index\validate\MemberRegisterValidate;
use cart\Cart;
use think\Config;
use think\Controller;
use think\Request;
use think\Session;

class MemberController extends Controller
{

    public function registerAction(Request $request)  // 依赖注入
    {
        if ($request->isGet()) {
            $this->assign('data', Session::get('data')?:[]);
            $this->assign('message', Session::get('message')?:[]);
            return $this->fetch();
        }

        elseif ($request->isPost()) {
            # 验证
            $validate = new MemberRegisterValidate();
            if (! $validate->scene(input('register_type'))->batch(true)->check($request->post())) {
                ## 验证失败
                return $this->redirect('/html/register', [], '302', [
                    'data' => $request->post(),
                    'message' => $validate->getError(),
                ]);
            }
            # 入库
            ## 整理数据
            $data = [
                'sort' => 0,
                'status' => 2,// 已激活
                'active_time' => time(),
            ];
            if ('email' == $request->post('register_type')) {
                $data['email'] = $request->post('email');
            } elseif ('telephone' == $request->post('register_type')) {
                $data['telephone'] = $request->post('telephone');
            }
            $data['hash_str'] = substr(str_shuffle('abcdefghijklnmopqrstuvwxyzABCDEFGHIJKLNMOPQRSTUVWXYZ12345567890!@#$%^&*()_'), 0, mt_rand(2, 16));
            $data['password'] = crypt($request->post('password'), $data['hash_str']);

            ## 向接口发送请求
            $resp = httpRequest([
                'type' => 'post',
                'url' => Config::get('api_url_base') . 'member-add.html',
                'data' => $data,
                'dataType' => 'json',
            ]);

            if (! $resp['error']) {
                return $this->redirect('/html/login.html');
            } else {
                return $this->redirect('/html/register.html');
            }

        }
    }

    public function loginAction(Request $request)
    {
        if ($request->isGet()) {
            $this->assign('data', Session::get('data')?:[]);
            $this->assign('message', Session::get('message')?:'');
            return $this->fetch();
        }
        elseif ($request->isPost()) {
            # 通过邮箱或者电话检索用户。
            ## 电话获取用户
            ($member=httpRequest([
                'type' => 'get',
                'url' => 'http://shop.kang.com/member-info.html',
                'data' => [
                    'type' => 'telephone',
                    'value' => input('account'),
                ],
                'dataType' => 'json',
            ]))
            || // 短路运算
            ## email获取用户
            ($member=httpRequest([
                    'type' => 'get',
                    'url' => 'http://shop.kang.com/member-info.html',
                    'data' => [
                        'type' => 'email',
                        'value' => input('account'),
                    ],
                    'dataType' => 'json',
                ]));

            if($member) {
                # 可以检索到会员
                # 再比对密码是否正确
                if ($member['password'] == crypt(input('password'), $member['hash_str'])) {
                    # 密码也正确
                    Session::set('member', $member);
                    # 同步购物车
                    Cart::instance()->sync();

                    # 重定向
                    $route = Session::pull('login_redirect')?:'/html/index.html';
                    return $this->redirect($route);
                }
            }

            # 会员信息非法
            return $this->redirect('/html/login.html', [], '302', [
                'data' => input(),
                'message' => '登录信息错误',
            ]);
        }
    }

    /**
     * 退出
     */
    public function logoutAction()
    {
        Session::delete('member');

        return $this->redirect('/html/index.html');
    }

    /**
     * 结算
     */
    public function checkoutAction()
    {
        # 检测是否登录
        if (! Session::has('member')) {
            Session::set('login_redirect', '/html/cart.html');
            return $this->redirect('/html/login.html');
        }

        # 所购产品信息
        $this->assign('product_list', Cart::instance()->exportInfo(input('product/a')));
        # 配送方式列表
        $shipping_list = httpRequest([
            'type' => 'get',
            'url' => 'http://shop.kang.com/shippings.html',
            'data' => [
                'type' => 'enabled',
            ],
            'dataType' => 'json',
        ]);
        # 计算运费
//        foreach($shipping_list as $key=>$shipping) {
//            $name = $shipping['name'];
//            $class = 'shipping\\' . $name;
//            $shippingObject = new $class();
//            $shipping_list[$key]['price'] = $shippingObject->price();
//        }
        $this->assign('shipping_list', $shipping_list);

        # 展示结算表单，订单信息表单
        return $this->fetch();
    }

    public function addressAddAction()
    {
        # 检测是否登录
        if (! Session::has('member')) {
            return [
                'error' => true,
                'error_info' => '为认证用户',
            ];
        }

        # 验证
        # 加入会员信息
        $data = input();
        $data['member_id'] = Session::get('member.id');
        $data['is_default'] = '1';

        # 调用api完成address插入
        $resp = httpRequest([
           'type' => 'post',
           'url' => 'http://shop.kang.com/address-add.html',
           'data' => $data,
           'dataType' => 'json',
        ]);

        # 添加成功，将当前的地址设为默认
        if (false == $resp['error']) {
            # 设置默认
            httpRequest([
                'type' => 'post',
                'url' => 'http://shop.kang.com/address-set-default.html',
                'data' => [
                    'member_id' => Session::get('member.id'),
                    'address_id' => $resp['address_id'],
                ],
//                'dataType' => 'json',
            ]);
        }

        return $resp;
    }

    public function addressListAction()
    {
        # 检测是否登录
        if (! Session::has('member')) {
            return [
                'error' => true,
                'error_info' => '为认证用户',
            ];
        }

        # 调用api完成address插入
        $resp = httpRequest([
            'type' => 'get',
            'url' => 'http://shop.kang.com/addresses.html',
            'data' => [
                'type' => 'member',
                'value' => Session::get('member.id')
            ],
            'dataType' => 'json',
        ]);

        return $resp;

    }
}