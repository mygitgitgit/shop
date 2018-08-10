<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/13
 * Time: 17:16
 */

namespace app\api\controller;


use app\api\model\Product;
use think\Controller;

class ProductController extends Controller
{

    public function listAction()
    {
        # 请求数据
        $type = input('type', 'all');
        $limit = input('limit', 4);
        $page = input('page', '1');

        # 初始化条件, 在售上架
        $query = Product::where('is_sale', 1);

        # 依据查询类型，拼凑不同的条件
        switch($type) {
            case 'new':
                $query->order('create_time desc');
                break;
            case 'id':
                $query->where('id', 'in', input('id/a', []));
                break;
        }

        # 拼凑分页部分
        $paginator = $query->paginate($limit, false, [
            'page' => $page,
        ]);

        return $paginator;
    }
}