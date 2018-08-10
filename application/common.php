<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

// 应用公共文件


function appConfig($name)
{
    # 判断缓存是否存在
    $key = 'config';// 哈希表的缓存项key

    $redis = new Redis();
    $redis->connect(\think\Config::get('redis.host'), \think\Config::get('redis.port'));

    if (! $value = $redis->hget($key, $name)) {
        $value = \think\Db::name('config')
            ->where('name', $name)
            ->value('value')
        ;
        $redis->hSet($key, $name, $value);
    }
    return $value;
}


function httpRequest($options)
{
    # 初始化curl
    $client = curl_init();
    # 设置选项
    ## 设置url
    switch ($options['type']) {
        case 'get':
            ### 如果是get方式请求，需要将data部分，加入到url后边
            #### 确定额外参数
            $query = '';
            if (isset($options['data'])) {
                $query = http_build_query($options['data']);
            }
            #### 确定连接符号，连接
            $join = isset(parse_url($options['url'])['query']) ? '&' : '?';
            $url = $options['url'] . $join . $query;
//            echo $url;
            curl_setopt($client, CURLOPT_URL, $url);
            break;
        case 'post':
            curl_setopt($client, CURLOPT_URL, $options['url']);
            break;
    }
    ## 如果过是post请求，需要post选项
    if ('post' == $options['type']) {
        curl_setopt($client, CURLOPT_POST, true);
        if (isset($options['data'])) {
           curl_setopt($client, CURLOPT_POSTFIELDS, http_build_query($options['data']));
        }
    }
    ## 返回响应结果，而不是直接输出
    curl_setopt($client, CURLOPT_RETURNTRANSFER, true);
    ## 超时时间
    curl_setopt($client, CURLOPT_TIMEOUT, 3);
    ## 跳过SSL证书
    if ('https' == parse_url($options['url'])['scheme']) {
        curl_setopt($client, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($client, CURLOPT_SSL_VERIFYPEER, false);
    }

    # 发出请求
    $content = curl_exec($client);
    curl_close($client);
//    dump($content);die;

    # 根据需要的类型，做不同的处理
    !isset($options['dataType']) && $options['dataType']='json';
    switch($options['dataType']) {
        case 'json':
        case 'assoc':
            return json_decode($content, true);// 返回关联数组
        case 'text':
        default:
            return $content;
    }
}