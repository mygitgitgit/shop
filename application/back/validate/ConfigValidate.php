<?php
/**
 * Created by PhpStorm.
 * User: Kang
 * Date: 2017/11/13
 * Time: 14:36
 */

namespace app\back\validate;

use think\Validate;

class ConfigValidate extends Validate
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
        'config_group_id' => '所属组',
        'input_type_id' => '元素类型',
        'title' => '配置名称',
        'name' => '配置项标志',
        'value' => '配置值',
        'sort' => '排序',
        'create_time' => '创建时间',
        'update_time' => '修改时间',

    ];
}