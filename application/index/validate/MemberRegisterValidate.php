<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/16
 * Time: 11:33
 */

namespace app\index\validate;

use think\Validate;

class MemberRegisterValidate extends Validate
{
    protected $rule = [
        '__token__' => 'token',
        'email' => 'require|email|emailUnique',
        'telephone' => 'require|regex:^1\d{10}$|telephoneUnique',
        'password' => 'require',
        'confirm' => 'confirm:password',
        'agree' => 'require',
    ];

    protected $field = [
        'email' => '电子邮箱',
        'telephone' => '手机号码',
        'password' => '密码',
        'confirm' => '确认密码',
//        'agree' => ''
    ];
    protected $message = [
        'agree.require' => '请阅读并同意隐私政策',
        'email.emailUnique' => '电子邮箱已经存在',
        'telephone.telephoneUnique' => '手机号码已经存在',
    ];

    protected $scene = [
        'email' => ['email', 'password', 'confirm', 'agree', '__token__'],
        'telephone' => ['telephone', 'password', 'confirm', 'agree', '__token__'],
    ];

    protected function emailUnique($value)
    {
        # 向api发出请求，确定email是否重复。
        $result = httpRequest([
            'type' => 'get',
            'url' => 'http://shop.kang.com/member-info.html',
            'data' => [
                'type' => 'email',
                'value' => $value,
            ],
            'dataType' => 'json',
        ]);

        return ! $result;//! 转成布尔型
    }
    protected function telephoneUnique($value)
    {
        # 向api发出请求，确定email是否重复。
        $result = httpRequest([
            'type' => 'get',
            'url' => 'http://shop.kang.com/member-info.html',
            'data' => [
                'type' => 'telephone',
                'value' => $value,
            ],
            'dataType' => 'json',
        ]);

        return ! $result;//! 转成布尔型
    }
}