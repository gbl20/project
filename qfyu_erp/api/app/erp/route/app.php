<?php
use think\facade\Route;
Route::miss(function() {return '庆丰裕ERP欢迎您!';});
Route::rule('index', 'index/index');
Route::rule('loginInit', 'index/loginInit');
