<?php
/**
 * Created by PhpStorm.
 * User: Kang
 * Date: 2017/11/10
 * Time: 11:46
 */

namespace app\back\model;

use think\Model;
use think\Session;
use traits\model\SoftDelete;

class Product extends Model
{
    use SoftDelete;
    //
    protected $auto = [
        'upc', 'admin_id',
    ];

    protected function setAdminIdAttr($value)
    {
        return Session::get('admin.id');
    }
    protected function setUpcAttr($value)
    {
        return $value ?: uniqid();
    }


    /**
     * 关联组
     * @return \think\model\relation\BelongsTo
     */
    public function group()
    {
        return $this->belongsTo('Group');
    }
}
