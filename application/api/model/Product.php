<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/13
 * Time: 17:20
 */

namespace app\api\model;
use think\Model;
use traits\model\SoftDelete;

class Product extends Model
{
    use SoftDelete;

}