<?php
/**
 * Created by PhpStorm.
 * User: Kang
 * Date: 2017/11/08
 * Time: 17:07
 */

namespace app\back\controller;

use app\back\model\Category;
use app\back\validate\CategoryValidate;
use think\Cache;
use think\Config;
use think\Controller;
use think\Db;
use think\Session;

class CategoryController extends Controller
{
    // 分类树，缓存key
    const CACHE_TREE_KEY = 'category_tree';

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
            $data = Session::get('data') ?: (!is_null($id)?Db::name('category')->find($id) : []);
            $this->assign('data', $data);

            ## 全部分类
            $this->assign('category_list', (new Category())->getTree());

            ## 展示视图模板
            return $this->fetch();
        }

        # post, 处理数据
        elseif ($request->isPost()) {
            ## 验证
            $validate = new CategoryValidate();
            // 验证失败
            if (! $validate->batch(true)->check($request->post())) {
                return $this->redirect('set', ['id'=>$id], 302, [
                    'message' => $validate->getError(),
                    'data' => $request->post(),
                ]);
            }

            ## 添加到数据库
            if (is_null($id)) {
                $model = new Category();
            } else {
                $model = Category::get($id);
            }
            $model->data($request->post());
            $result = $model->allowField(true)->save();

            if ($result) {
                ## 删除缓存
                $this->deleteCache();
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
        # 获取数据
        ## 判断缓存中是否存在该数据
        if (! ($rows = Cache::get(self::CACHE_TREE_KEY))) {
            ### 没有缓存
            ### 由模型从数据表获取
            trace('no cache');// 当没有缓存时输出到调试面板上
            $rows = (new Category())->getTree();
            Cache::set(self::CACHE_TREE_KEY, $rows);
        }
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
        Category::destroy($selected);

        # 删除缓存
        $this->deleteCache();

        return $this->redirect('index');
    }

    /**
     * 删除缓存
     * @return $this
     */
    protected function deleteCache()
    {
        Cache::rm(self::CACHE_TREE_KEY);
        return $this;
    }
}