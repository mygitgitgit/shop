<?php
/**
 * Created by PhpStorm.
 * User: Kang
 * Date: 2017/11/17
 * Time: 15:52
 */

namespace app\back\validate;

use think\Validate;

class ShippingValidate extends Validate
{
    // 规则数组
    protected $rule = [
        ## 令牌校验
        '__token__' => 'require|token',
        # 自定义规则
    ];

    // 字段名称翻译
    protected $field = [
        'id' => 'ID',
        'title' => '标题',
        'intro' => '介绍',
        'enabled' => '启用',
        'sort' => '顺序',
        'name' => '名字',
        'create_time' => '创建时间',
        'update_time' => '修改时间',

    ];
}