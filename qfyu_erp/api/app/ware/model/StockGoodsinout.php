<?php
namespace app\ware\model;
use think\facade\Db;
use think\Model;
/**
 * 商品出入库查询-模型类
 * @author wuzhonggui
 * @package app\ware\model
 */
class StockGoodsinout extends Model
{
    /**
     * 查询商品入库明细列表
     * @param $data 请求参数
     */
    public static function getInQtyList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?30:intval($data['pageSize']);
        $where[]=['inout_kind','<=',50]; //入库记录
        $order='create_date desc';
        $list=Db::name('view_goodsinout')->where($where)->order($order)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }
    /**
     * 查询商品出库明细列表
     * @param $data 请求参数
     */
    public static function getOutQtyList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?30:intval($data['pageSize']);
        $where[]=['inout_kind','>',50]; //出库记录
        $order='create_date desc';
        $list=Db::name('view_goodsinout')->where($where)->order($order)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }
    /**
     * 查询商品库存明细列表
     * @param $data 请求参数
     */
    public static function getQtyDetailList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?30:intval($data['pageSize']);
        $order='id desc';
        $where=[];
        $list=Db::name('view_stockdetails')->where($where)->order($order)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }
    /**
     * 查询商品分仓库存列表
     * @param $data 请求参数
     */
    public static function getBatchPartQtyList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?30:intval($data['pageSize']);
        $order='id desc';
        $where=[];
        $list=Db::name('view_stock_batchpart')->where($where)->order($order)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }
    /**
     * 查询商品总库存列表
     * @param $data 请求参数
     */
    public static function getTotalQtyList($data){
        $page=empty($data['page'])?1:intval($data['page']);
        $pageSize=empty($data['pageSize'])?30:intval($data['pageSize']);
        $order='id desc';
        $where=[];
        $list=Db::name('view_stock_sum')->where($where)->order($order)->paginate(['list_rows'=>$pageSize,'page'=>$page])->toArray();
        return $list;
    }
}