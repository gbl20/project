<?php
/**
 * 商品资料管理。
 * @author      guan 作者
 * @version     2020/09/17  1.0 版本号
 */

namespace app\erp\controller;

use app\BaseController;
use app\erp\model\PermitKinds;
use think\App;
use think\facade\Db;


class GoodsCategory extends BaseController
{
  public function categoryInit()
  {
    $data = $this->request->data;
    if ($data['data'] == 'permit_kinds') {
      //获取商品许可经营大类类别、小类类别
      $res = PermitKinds::get_permit_list();
    } else if ($data['data'] == 'custom_kinds') {
      //获取自定义商品许可经营类别
      $res = PermitKinds::get_custom_kinds();
    } else {
      //获取商品功能类别列表
      $data = PermitKinds::getKinds();
      $res = ['data' => $data, 'option' => PermitKinds::build_option($data)];
    }
    exit(json_encode($res));
  }

  /** 新增-编辑商品分类 **/
  public function setKinds()
  {
    $search = $this->request->data;
    $res = PermitKinds::set_kinds($search['id'], $search['data']);
    exit(json_encode($res));
  }

  /** 删除商品分类 **/
  public function delKinds()
  {
    $data = $this->request->data;
    $res = PermitKinds::del_kinds($data);
    exit(json_encode($res));
  }

  /** 新增-修改商品许可经营类别大类 **/
  public function setPermitKinds()
  {
    $search = $this->request->data;
    $res = PermitKinds::set_permit_kind($search['data'], $this->request->code);
    exit(json_encode($res));
  }

  /** 删除商品许可经营大类 **/
  public function delPermitKinds()
  {
    $search = $this->request->data;
    $res = PermitKinds::del_permit_kinds($search['id']);
    exit(json_encode($res));
  }

  /** 修改商品许可经营小类 **/
  public function editSmallPermitKind()
  {
    $search = $this->request->data;
    $res = PermitKinds::edit_small_permit_kind($search['data'], $this->request->code);
    exit(json_encode($res));
  }

  /** 删除商品许可经营小类 **/
  public function delSmallPermitKind()
  {
    $search = $this->request->data;
    $res = PermitKinds::del_small_permit_kind($search['id'], $this->request->code);
    exit(json_encode($res));
  }

  /** 新增自定义商品许可经营类别 **/
  public function addCustomKinds()
  {
    $search = $this->request->data;
    $data['name'] = $search['name'];
    $data['parent_kid'] = $search['parent_kid'];
    $data['chlid_kid'] = $search['chlid_kid'];
    $res = PermitKinds::add_custom_kinds($data, $this->request->code);
    exit(json_encode($res));
  }

  /** 许可经营类别 多选 **/
  public function getCustomList()
  {
    $res = PermitKinds::get_custom_permit_list();
    exit(json_encode($res));
  }

  /** 删除自定义许可经营小类 **/
  public function delCustomKinds()
  {
    $data = $this->request->data;
    $res = PermitKinds::delCustomKinds($data['data']);
    exit(json_encode($res));
  }

  /** 获取商品许可经营小类类别 **/
  public function getDelKinds()
  {
    $data = $this->request->data;
    $res = PermitKinds::getPermitDelKinds($data['id']);
    exit(json_encode(['data' => $res]));
  }

  //选择许可经营类别弹出层
  public function getPopupKind()
  {
    $data = $this->request->data;
    $res = PermitKinds::get_permit_list($data['id']);
    exit(json_encode($res));
  }

  public function getGoodsCategory()
  {
    $res = PermitKinds::getKindsLCascaber();
    exit(json_encode(['status' => 1, 'data' => $res]));
  }

}
