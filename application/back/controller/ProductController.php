<?php
/**
 * Created by PhpStorm.
 * User: Kang
 * Date: 2017/11/10
 * Time: 11:46
 */

namespace app\back\controller;

use app\back\model\Category;
use app\back\model\Gallery;
use app\back\model\Group;
use app\back\model\Product;
use app\back\model\ProductAttribute;
use app\back\validate\ProductValidate;
use think\Cache;
use think\Controller;
use think\Db;
use think\Image;
use think\Session;

class ProductController extends Controller
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
            $data = Session::get('data') ?: (!is_null($id)?Db::name('product')->find($id) : []);
            $this->assign('data', $data);

            ## 分配需要的关联数据
            $this->assign('sku_list', Db::name('sku')->order('sort')->select());
            $this->assign('stock_status_list', Db::name('stock_status')->order('sort')->select());
            $this->assign('length_unit_list', Db::name('length_unit')->order('sort')->select());
            $this->assign('weight_unit_list', Db::name('weight_unit')->order('sort')->select());
            $this->assign('brand_list', Db::name('brand')->order('sort')->select());
            if (! ($category_list = Cache::get(CategoryController::CACHE_TREE_KEY))) {
                $category_list = (new Category())->getTree();
                Cache::set(CategoryController::CACHE_TREE_KEY, $category_list);
            }
            $this->assign('category_list', $category_list);
            $this->assign('attribute_group_list', Db::name('attribute_group')->order('sort')->select());
            $this->assign('gallery_list', Db::name('gallery')->order('sort')->where('product_id', $id)->select());

            ## 展示视图模板
            return $this->fetch();
        }

        # post, 处理数据
        elseif ($request->isPost()) {
            ## 验证
            $validate = new ProductValidate();
            // 验证失败
            if (! $validate->batch(true)->check($request->post())) {
                return $this->redirect('set', ['id'=>$id], 302, [
                    'message' => $validate->getError(),
                    'data' => $request->post(),
                ]);
            }

            ## 添加到数据库
            if (is_null($id)) {
                $model = new Product();
            } else {
                $model = Product::get($id);
            }
            $model->data($request->post());
            $result = $model->allowField(true)->save();

            if ($result) {
                ## 更新产品和属性的关联
                $rows = array_map(function($row) use ($model) {
                    $row['product_id'] = $model->id;
                    return $row;
                }, input('attributes/a', []));

                (new ProductAttribute())->allowField(true)->saveAll($rows);

                ## 更新产品相册
                $rows = array_map(function($row) use ($model) {
                    $row['product_id'] = $model->id;
                    return $row;
                }, input('gallery/a', []));
//                dump($rows);die;
                (new Gallery())->saveAll($rows);
                // 删除记录下的
                Gallery::destroy(input('gallery_remove/a', [-1]));
                // 图像文件是否需要也删除

//                重定向列表
                return $this->redirect('index');
            } else {
//                重定向到创建表单
                return $this->redirect('set', ['id'=>$id]);
            }
        }

    }

    /**
     * 列表
     */
    protected function productList($type='undeleted')
    {
        $this->assign('type', $type);

        if ('undeleted' == $type) {
            # 先获取空的查询构建器
            $builder = Product::where(null);
        } elseif ('deleted') {
            $builder = Product::onlyTrashed()->where(null);
        }


        # 条件
        $filter = [];

        ## 判断是否具有title条件
        $filter_title = input('filter_title', '');
        if ('' !== $filter_title) {
            $builder->where('title', 'like', '%'. $filter_title.'%');
            $filter['filter_title'] = $filter_title;
        }

        ## 判断是否具有upc条件
        $filter_upc = input('filter_upc', '');
        if ('' !== $filter_upc) {
            $builder->where('upc', 'like', '%'. $filter_upc.'%');
            $filter['filter_upc'] = $filter_upc;
        }

        ## 判断是否具有image条件
        $filter_image = input('filter_image', '');
        if ('' !== $filter_image) {
            $builder->where('image', 'like', '%'. $filter_image.'%');
            $filter['filter_image'] = $filter_image;
        }

        ## 判断是否具有stock_status_id条件
        $filter_stock_status_id = input('filter_stock_status_id', '');
        if ('' !== $filter_stock_status_id) {
            $builder->where('stock_status_id', 'like', '%'. $filter_stock_status_id.'%');
            $filter['filter_stock_status_id'] = $filter_stock_status_id;
        }

        ## 判断是否具有is_subtract条件
        $filter_is_subtract = input('filter_is_subtract', '');
        if ('' !== $filter_is_subtract) {
            $builder->where('is_subtract', 'like', '%'. $filter_is_subtract.'%');
            $filter['filter_is_subtract'] = $filter_is_subtract;
        }

        ## 判断是否具有price条件
        $filter_price = input('filter_price', '');
        if ('' !== $filter_price) {
            $builder->where('price', 'like', '%'. $filter_price.'%');
            $filter['filter_price'] = $filter_price;
        }

        ## 判断是否具有is_sale条件
        $filter_is_sale = input('filter_is_sale', '');
        if ('' !== $filter_is_sale) {
            $builder->where('is_sale', 'like', '%'. $filter_is_sale.'%');
            $filter['filter_is_sale'] = $filter_is_sale;
        }

        ## 判断是否具有brand_id条件
        $filter_brand_id = input('filter_brand_id', '');
        if ('' !== $filter_brand_id) {
            $builder->where('brand_id', 'like', '%'. $filter_brand_id.'%');
            $filter['filter_brand_id'] = $filter_brand_id;
        }

        ## 判断是否具有category_id条件
        $filter_category_id = input('filter_category_id', '');
        if ('' !== $filter_category_id) {
            $builder->where('category_id', 'like', '%'. $filter_category_id.'%');
            $filter['filter_category_id'] = $filter_category_id;
        }

        ## 判断是否具有admin_id条件
        $filter_admin_id = input('filter_admin_id', '');
        if ('' !== $filter_admin_id) {
            $builder->where('admin_id', 'like', '%'. $filter_admin_id.'%');
            $filter['filter_admin_id'] = $filter_admin_id;
        }

        ## 搜索条件分配到模板
        $this->assign('filter', $filter);


        # 排序
        $order_field = input('order_field', 'group_id');
        $order_type = input('order_type', 'asc');
        if ('' !== $order_field) {
            $builder->order([$order_field => $order_type]);
        }
        $order = compact('order_field', 'order_type');
        $this->assign('order', $order);

        # 分页
        $limit = appConfig('back-list-pagesize');

        # 检索数据
        $paginator = $builder->paginate($limit, false, [
            'query' => array_merge($filter, $order),
        ]);
        $this->assign('paginator', $paginator);
        // 起始记录
        $this->assign('start', $paginator->listRows()*($paginator->currentPage()-1)+1);
        // 结束记录
        $this->assign('end', min($paginator->listRows()*$paginator->currentPage(), $paginator->total()));

        # 渲染模板
        return $this->fetch('index');
    }

    /**
     * 回收站
     */
    public function trashAction()
    {
        return $this->productList('deleted');
    }

    /**
     * 首页
     * @return string
     */
    public function indexAction()
    {
        return $this->productList();
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

        switch (input('operate')) {
            case 'delete':
                # 批量删除，就是软删除
                Product::destroy($selected);
                return $this->redirect('index');
            case 'restore':
                # 还原
                (new Product())->restore(['id' => ['in', $selected]]);
                return $this->redirect('trash');
            case 'shiftDelete':
                # 彻底删除
                Product::destroy($selected, true);
                return $this->redirect('trash');
            case 'group':
                # 组合
                ## 所选的产品的组情况
                $group_ids = Db::name('product')
                    ->where('id', 'in', $selected)
                    ->where('group_id', 'NEQ', '0')
                    ->distinct(true)
                    ->column('group_id')
                ;
//                dump($group_ids);die;
                if (count($group_ids) == 0) {
                    ## 没有任何组，新建一个组
                    $group = new Group();
                    $group->title = Product::get($selected[0])->title;// 以第一个产品的名字为组名
                    $group->save();

                    Db::name('product')
                        ->where('id', 'in', $selected)
                        ->update([
                            'group_id' => $group->id,
                        ])
                    ;
                    return $this->redirect('index');
                }
                elseif (count($group_ids) == 1) {
                    ## 属于一个组，加入到改组即可
                    Db::name('product')
                        ->where('id', 'in', $selected)
                        ->update([
                            'group_id' => $group_ids[0],
                        ])
                        ;
                    return $this->redirect('index');
                }
                else {
                    ## 属于多个组， 不需要处理
                    return $this->redirect('index', [], '302', [
                        'message' => '产品属于不同组，不能组合',
                    ]);
                }
                break;
        }

    }

    /**
     * 获取产品属性列表
     */
    public function attributesAction($product_id=null)
    {
        $attribute_group_id = input('attribute_group_id');
        $attribute_list = Db::name('attribute')->alias('a')
            ->join('__PRODUCT_ATTRIBUTE__ pa', "a.id=pa.attribute_id and pa.product_id='$product_id'", 'left')
            ->where('a.attribute_group_id', $attribute_group_id)
            ->field('pa.id, a.id attribute_id, pa.value, a.title')
            ->select()
            ;

        return $attribute_list;
    }

    /**
     * 复制产品
     */
    public function copyAction($id)
    {
        # 读取
        $row = Db::name('product')->find($id);
        # 去掉不必要的字段：
        unset($row['id'], $row['upc']);
        unset($row['create_time'], $row['update_time'], $row['delete_time']);
        unset($row['admin_id']);
        $row['title'] .= '-拷贝';
        # 插入
        $product = new Product();
        $product->data($row);
        $product->allowField(true)->save();

        # 读取就产品的属性
        $rows = Db::name('product_attribute')
            ->where('product_id', $id)
            ->field('attribute_id, value, is_extend, sort')
            ->select()
            ;
        # 增加新商品信息
        $rows = array_map(function($row) use ($product) {
            $row['product_id'] = $product->id;
            return $row;
        }, $rows);
        # 批量插入
        (new ProductAttribute())->saveAll($rows);

        # 产品相册图像
//        复制记录，也可以复制图像文件
        $rows = Db::name('gallery')
            ->where('product_id', $id)
            ->field('image, image_big, image_small, sort, description')
            ->select();
        $rows = array_map(function($row) use($product) {
            $row['product_id'] = $product->id;
            return $row;
        }, $rows);
        (new Gallery())->saveAll($rows);



        return $this->redirect('set', ['id'=>$product->id]);
    }


    public function uploadAction()
    {
        $type = input('type');

        $file = request()->file('file');
        $info = $file->validate(['size'=>1*1024*1024,'ext'=>'jpg,png,gif'])->move(ROOT_PATH. 'public/upload/product');

        if ($info) {
            // 上传成功

            # 做缩略图
            $image = Image::open(ROOT_PATH. 'public/upload/product/' . $info->getSaveName());

            $thumb_path = ROOT_PATH. 'public/thumb/product/' . dirname($info->getSaveName()) . '/';
            if (! is_dir(dirname($thumb_path))) {
                mkdir(dirname($thumb_path), 0755, true);
            }
            if ('product' == $type) {
                ## 主图
                $image->thumb(360, 360, Image::THUMB_FILLED)->save($thumb_path . 'thumb_' . $info->getFilename());
                return [
                    'image' => dirname($info->getSaveName()) . '/' . $info->getFilename(),
                    'image_thumb' => dirname($info->getSaveName()) . '/thumb_' . $info->getFilename(),
                ];
            }
            elseif ('gallery' == $type) {
                ## 相册
                $image->thumb(800, 800, Image::THUMB_FILLED)->save($thumb_path . 'big_' . $info->getFilename());
                $image->thumb(300, 300, Image::THUMB_FILLED)->save($thumb_path . 'small_' . $info->getFilename());
                return [
                    'image' => dirname($info->getSaveName()) . '/' . $info->getFilename(),
                    'image_big' => dirname($info->getSaveName()) . '/big_' . $info->getFilename(),
                    'image_small' => dirname($info->getSaveName()) . '/small_' . $info->getFilename(),
                ];
            }

        } else {
            return [
                'error' => $file->getError(),
            ];
        }
    }


}