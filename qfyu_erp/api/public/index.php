<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2019 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

// [ 应用入口文件 ]
namespace think;
header('Content-Type: text/html;charset=utf-8');
header('Access-Control-Allow-Origin:*');
header('Access-Control-Allow-Methods:GET,POST,OPTIONS');
header('Access-Control-Max-Age: 86400');
header('Access-Control-Allow-Headers: Connection,Charset,Content-Type,Content-Length,Accept-Encoding,X-Requested-with,Origin,Cache-Control,Transfer-Encoding,Accept-Encoding');

require __DIR__ . '/../vendor/autoload.php';
// 执行HTTP应用并响应
define('APP_PATH', __DIR__ . '/../app/');
$http = (new App())->http;
$response = $http->run();
$response->send();
$http->end($response);
