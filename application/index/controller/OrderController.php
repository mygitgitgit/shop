<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/19
 * Time: 10:45
 */

namespace app\index\controller;


use cart\Cart;
use think\Config;
use think\Controller;
use think\Db;
use think\Session;

class OrderController extends Controller
{

    /**
     * 生成订单
     */
    public function makeAction()
    {
        # 检测是否登录
        if (! Session::has('member')) {
            Session::set('login_redirect', '/html/cart.html');
            return $this->redirect('/html/login.html');
        }

        # 整理 order 表数据
        # 整理 order_products 表数据
        #一次性将数据 提交到api,完成订单生成
        $redis = new \Redis();
        $redis->connect(Config::get('redis.host'), Config::get('redis.port'));
        // key由日期确定，每一天一个序列号key
        $sn = date('Ymd') . str_pad($redis->incr('order_sn_'.date('Ymd')), 8, '0', STR_PAD_LEFT);
        $address_info = httpRequest([
            'type' => 'get',
            'url' => 'http://shop.kang.com/address.html',
            'data' => [
                'type' => 'id',
                'value' => input('address_id'),
            ],
            'dataType' => 'assoc',
        ]);
        $address = serialize($address_info);
        $products = [];
        $product_list = Cart::instance()->exportInfo(input('products/a', []));
        foreach($product_list['data'] as $product) {
            $row = [
                'product_id' => $product['id'],
                'buy_quantity' => $product['buy_quantity'],
                'product_attribute' => serialize($product)
                ];
            $products[] = $row;
        }


        $order = [
            'sn' => $sn,
            'member_id' => Session::get('member.id'),
            'status' => '1', //正在确认
            'address_id' => input('address_id'),
            'address' => $address,
            'shipping_id' => input('shipping_id'),
            'common' => input('comment'),
            'product_amount' => input('product_amount'),
            'shipping_price' => input('shipping_price'),
            'order_amount' => input('order_amount'),
            'products' => $products,
        ];
//
//        dump($order);
        # api完成订单生成
       $result = httpRequest([
            'type' => 'post',
            'url' => 'http://shop.kang.com/order-add.html',
            'data' => $order,
            'dataType' => 'assoc',
        ]);

//       dump($result);
        if (! $result['error']) {
            # 订单入队列, 订单的sn放入队列
            $redis->lPush('order_queue', $sn);

            # 重定向一个订单结果页
            return $this->redirect('/html/orderResult', ['id'=>$result['order_id']]);
        } else {
            return $this->redirect('/html/cart.html');
        }

    }

    public function resultAction()
    {

        $this->assign('order', Db::name('order')->find(input('id')));
        return $this->fetch();
//        return 'ID:' . input('id') . '订单的处理结果';
    }

    public function progressAction()
    {
        $sn = input('sn');

        $redis = new \Redis();
        $redis->connect(Config::get('redis.host'), Config::get('redis.port'));
        $curr_sn = $redis->get('curr_sn');

        # 算： YYYYMMDD序号
        $number = +substr($sn, -8) - +substr($curr_sn, -8);
        if ($number > 0) {
            return [
                'finshed' => false,
                'number' => $number,
            ];
        } else {
            return [
                'finshed' => true,
                'number' => 0,
            ];
        }
    }

    public function statusAction()
    {
        $sn = input('sn');

        # 只有订单处理完毕，才响应
        while(true) {
            $status = Db::name('order')
                ->where('sn', $sn)
                ->value('status')
                ;

            if ('1' == $status) {
                # 没处理完
                # 阻塞再次获取
                usleep(500000);// 微妙
                continue;
            }

            # 处理完了
            switch($status) {
                case '2':
                    return [
                        'status' => 2,
                        'result' => '订单确认成功，库存充足',
                    ];

                case '3':
                    return [
                        'status' => 3,
                        'result' => '订单确认失败，库存不足',
                    ];
            }
        }
    }

    public function payAction()
    {
        $id = input('id');
//        $order = httpRequest([
//            'url' => 'http://shop.kang.com/order-info.html',
//        ]);
        $order = Db::name('order')->find($id);

        require_once(EXTEND_PATH . "alipay/alipay.config.php");
        require_once(EXTEND_PATH . "alipay/lib/alipay_submit.class.php");

        /**************************请求参数**************************/

        //支付类型
        $payment_type = "1";
        //必填，不能修改
        //服务器异步通知页面路径
        $notify_url = "http://shop.kang.com/html/pay-notity.html";
        //需http://格式的完整路径，不能加?id=123这类自定义参数

        //页面跳转同步通知页面路径
        $return_url = "http://shop.kang.com/html/pay-return.html";
        //需http://格式的完整路径，不能加?id=123这类自定义参数，不能写成http://localhost/

        //卖家支付宝帐户
//        $seller_email = $_POST['WIDseller_email'];
        $seller_email = 'loveleihua@qq.com';
        //必填

        //商户订单号
        $out_trade_no = $order['sn'];
        //商户网站订单系统中唯一订单号，必填

        //订单名称
        $subject = '订单名称';
        //必填

        //付款金额
        $total_fee = $order['order_amount'];
        //必填

        //订单描述

        $body = '订单描述';
        //商品展示地址
        $show_url = 'http://www.xxx.com/myorder.html';
        //需以http://开头的完整路径，例如：http://www.xxx.com/myorder.html

        //防钓鱼时间戳
        $anti_phishing_key = "";
        //若要使用请调用类文件submit中的query_timestamp函数

        //客户端的IP地址
        $exter_invoke_ip = "";
        //非局域网的外网IP地址，如：221.0.0.1


        /************************************************************/

//构造要请求的参数数组，无需改动
        $parameter = array(
            "service" => "create_direct_pay_by_user",
            "partner" => trim($alipay_config['partner']),
            "payment_type"	=> $payment_type,
            "notify_url"	=> $notify_url,
            "return_url"	=> $return_url,
            "seller_email"	=> $seller_email,
            "out_trade_no"	=> $out_trade_no,
            "subject"	=> $subject,
            "total_fee"	=> $total_fee,
            "body"	=> $body,
            "show_url"	=> $show_url,
            "anti_phishing_key"	=> $anti_phishing_key,
            "exter_invoke_ip"	=> $exter_invoke_ip,
            "_input_charset"	=> trim(strtolower($alipay_config['input_charset']))
        );

//建立请求
        $alipaySubmit = new \AlipaySubmit($alipay_config);
        $html_text = $alipaySubmit->buildRequestForm($parameter,"get", "确认");
        echo $html_text;

    }

    public function returnAction()
    {

        require_once(EXTEND_PATH . "alipay/alipay.config.php");
        require_once(EXTEND_PATH . "alipay/lib/alipay_notify.class.php");

//计算得出通知验证结果
        $alipayNotify = new \AlipayNotify($alipay_config);
        $verify_result = $alipayNotify->verifyReturn();
        if($verify_result) {//验证成功
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //请在这里加上商户的业务逻辑程序代码

            //——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
            //获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表
            //商户订单号
            $out_trade_no = $_GET['out_trade_no'];//sn
            //支付宝交易号
            $trade_no = $_GET['trade_no'];
            //交易状态
            $trade_status = $_GET['trade_status'];


            if($_GET['trade_status'] == 'TRADE_FINISHED' || $_GET['trade_status'] == 'TRADE_SUCCESS') {
                //判断该笔订单是否在商户网站中已经做过处理
                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                //如果有做过处理，不执行商户的业务程序

                # 检测订单是否已经支付完毕

                # 支付完成，更新支付和订单状态
                Db::name('order')->where('sn', $out_trade_no)
                    ->update([
                        'payment_status' => 2,
                        'payment_time' => time(),
                    ])
                ;

                echo '订单支付完成， 准备收货即可';
            }
            else {
                # 订单支付失败
                echo "trade_status=".$_GET['trade_status'];
            }
            //——请根据您的业务逻辑来编写程序（以上代码仅作参考）
        }
        else {
            //验证失败
            //如要调试，请看alipay_notify.php页面的verifyReturn函数
            echo "验证失败";
        }
    }
}