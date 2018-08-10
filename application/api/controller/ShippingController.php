<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/17
 * Time: 15:57
 */

namespace app\api\controller;


use think\Controller;
use think\Db;

class ShippingController extends Controller
{
    public function listAction()
    {
        $query = Db::name('shipping');

        switch(input('type')) {
            case 'enabled':
                $query->where('enabled', '1');
                break;
        }

        $rows = $query->select();

        return $rows;
    }

}