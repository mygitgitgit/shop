<?php
/**
 * Created by PhpStorm.
 * User: THINK
 * Date: 2017/11/17
 * Time: 11:40
 */

namespace app\api\controller;


use app\api\model\Address;
use think\Controller;
use think\Db;

class AddressController extends Controller
{
    public function addAction()
    {
        # 也需要校验数据
        $address = new Address();
        if ($address->data(input())->save()) {
            return [
                'error' => false,
                'address_id' => $address->id,
            ];
        } else {
            return ['error' => true];
        }
    }

    public function setDefaultAction()
    {
        $member_id = input('member_id');
        $address_id = input('address_id');
        # 将当前会员其他的地址设为非默认，将当前的地址设置为默认
        Db::name('address')
            ->where('id', $address_id)
            ->update(['is_default'=>'1'])
            ;
        Db::name('address')
            ->where('member_id', $member_id)
            ->where('id', 'NEQ', $address_id)
            ->update(['is_default'=>'0'])
            ;
        return [
            'error' => false,
        ];
    }

    public function listAction()
    {
        $query = Db::name('address')->alias('a')
            ->join('__REGION__ r1', 'a.region_id_1=r1.id', 'left')
            ->join('__REGION__ r2', 'a.region_id_2=r2.id', 'left')
            ->join('__REGION__ r3', 'a.region_id_3=r3.id', 'left')
            ;
        switch(input('type')) {
            case 'member':
                $query->where('member_id', input('value'));
                break;
        }

        $rows = $query->field('a.*, r1.title region_title_1, r2.title region_title_2, r3.title region_title_3')
            ->select()
        ;

        return $rows;
    }

    public function infoAction()
    {
        $query = Db::name('address')->alias('a')
            ->join('__REGION__ r1', 'a.region_id_1=r1.id', 'left')
            ->join('__REGION__ r2', 'a.region_id_2=r2.id', 'left')
            ->join('__REGION__ r3', 'a.region_id_3=r3.id', 'left')
        ;
        switch(input('type')) {
            case 'id':
                $query->where('a.id', input('value'));
                break;
        }

        $row = $query->field('a.*, r1.title region_title_1, r2.title region_title_2, r3.title region_title_3')
            ->find()
        ;
        return $row;
    }

}