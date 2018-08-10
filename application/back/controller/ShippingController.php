<?php
/**
 * Created by PhpStorm.
 * User: Kang
 * Date: 2017/11/17
 * Time: 15:52
 */

namespace app\back\controller;

use app\back\model\Shipping;
use app\back\validate\ShippingValidate;
use think\Controller;
use think\Db;
use think\Session;

class ShippingController extends Controller
{
    /**
     * 设置（添加和更新）动作
     */
    public function setAction($id = null)
    {

        $this->assign('id', $id);

        # 获取请求对象
        $request = request();

        # get, 展示表单
        if ($request->isGet()) {

            ## 获取session中的消息，并分配到模板
            $message = Session::get('message') ?: [];
            $this->assign('message', $message);
            // 上次错误数据与当前正在编辑的数据进行整合
            $data = Session::get('data') ?: (!is_null($id)?Db::name('shipping')->find($id) : []);
            $this->assign('data', $data);

            ## 展示视图模板
            return $this->fetch();
        }

        # post, 处理数据
        elseif ($request->isPost()) {
            ## 验证
            $validate = new ShippingValidate();
            // 验证失败
            if (! $validate->batch(true)->check($request->post())) {
                return $this->redirect('set', ['id'=>$id], 302, [
                    'message' => $validate->getError(),
                    'data' => $request->post(),
                ]);
            }

            ## 添加到数据库
            if (is_null($id)) {
                $model = new Shipping();
            } else {
                $model = Shipping::get($id);
            }
            $model->data($request->post());
            $result = $model->allowField(true)->save();

            if ($result) {
//                重定向列表
                return $this->redirect('index');
            } else {
//                重定向到创建表单
                return $this->redirect('set', ['id'=>$id]);
            }
        }

    }

    /**
     * 首页
     * @return string
     */
    public function indexAction()
    {
        # 查询配送插件
        $path = ROOT_PATH . 'extend/shipping/';
        $handle = opendir($path);
        $plugins = [];
        while($filename = readDir($handle)) {
            if (in_array($filename, ['.', '..'])) continue;
            $name = strchr($filename, '.', true);// "ShunFeng.php"
            $class = 'shipping\\' . $name;
//            检测是实现了I_Shipping
            if (!in_array('contract\\I_Shipping', class_implements($class))) {
                continue;
            }
            $shipping = new $class();
            $plugin = [
                'title' => $shipping->title(),
                'intro' => $shipping->intro(),
                'name' => $name,
                ];
            $plugins[$name] = $plugin;
        }
        closedir($handle);

        # 读取数据库存在的配送方式信息
        $rows = Db::name('shipping')->select();

        # 保证 记录与插件一致，整合数据
        $plugin_names = array_map(function($plugin) {
            return $plugin['name'];
        }, $plugins);
        $row_names = array_map(function($row) {
            return $row['name'];
        }, $rows);
        ## 找到 记录存在，但是插件不存在，直接删除
        $deletes = array_diff($row_names, $plugin_names);
        Db::name('shipping')->where('name', 'in', $deletes)->delete();

        ## 找到 插件存在，但是记录不存在，插入数据
        $inserts = array_diff($plugin_names, $row_names);
        $shipping_rows = array_map(function($name) use ($plugins) {
            return array_merge([
                'sort' => 0,
                'enabled' => 1
            ], $plugins[$name]);
        }, $inserts);
        (new Shipping())->saveAll(array_values($shipping_rows));

        # 获取此时合理的数据即可
        $rows = Db::name('shipping')->order('sort')->select();
        $this->assign('rows', $rows);
        # 渲染模板
        return $this->fetch();
    }

    /**
     * 批量操作
     */
    public function multiAction()
    {
        $selected = input('selected/a', []);
        if (empty($selected)) {
            return $this->redirect('index');
        }

        # 批量删除
        Shipping::destroy($selected);

        return $this->redirect('index');
    }
}