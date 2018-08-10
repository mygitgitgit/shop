<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/17
 * Time: 14:56
 */

namespace app\api\controller;


use think\Controller;
use think\Db;

class RegionController extends Controller
{

    public function listAction()
    {
        $query = Db::name('region');
        switch(input('type')) {
            case 'child':
                $query->where('parent_id', input('value'));
                break;
        }

        $rows = $query->select();

        return $rows;
    }

}