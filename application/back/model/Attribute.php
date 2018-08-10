<?php
/**
 * Created by PhpStorm.
 * User: Kang
 * Date: 2017/11/11
 * Time: 09:45
 */

namespace app\back\model;

use think\Model;

class Attribute extends Model
{
    //
    /**
     * 获取对应的属性分组
     */
    public function attributeGroup()
    {
        // 多个属性属于一个属性分组，M：1的关系
        return $this->belongsTo('AttributeGroup');
    }
}
