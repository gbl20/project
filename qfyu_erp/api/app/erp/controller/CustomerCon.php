<?php

namespace app\erp\controller;
use app\BaseController;
use app\erp\model\Customer;
use app\erp\model\CustomerGoods;
use app\erp\model\CustomerImg;
use app\erp\validate\CustomerVal;
use app\helper\CommonFun;
use app\erp\model\AreaMgt;
use app\erp\model\CustomerSupplier;
use app\erp\model\DbWork;
use app\erp\model\Delivery;
use app\erp\model\Depart;
use app\erp\model\Employee;
use app\erp\model\PermitKinds;
use think\facade\Config;
use think\facade\Db;

class CustomerCon extends BaseController
{
  /**
   * 客户资料列表
   */
  public function clist()
  {
    $params = $this->request->data;
    $page = isset($params['page']) ? $params['page'] : 1;
    $search = isset($params['search']) ? $params['search'] : [];
    $map = [];
    if (isset($search['isvalid']) && intval($search['isvalid']) != 2) $map[] = array('c.isvalid', '=', $search['isvalid']);
    $list = Customer::getList($map, $page);
    $result = array('status' => 1, 'data' => $list);
    exit(json_encode($result));
  }

  /**
   * 编辑客户资料/新增客户
   */
  public function cedit()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $params = $this->request->data;
    $id = isset($params['id']) ? trim($params['id']) : '';
    $cinfo = array('sname' => '', 'name' => '', 'typebus' => '', 'stopuser' => 0, 'ismem' => 0, 'agreekind' => 0, 'dataable' => 0, 'createmanid' => $this->request->code, 'create_date' => date('Y-m-d H:i:s'));
    if (!empty($id)) {
      $map[] = array('id', '=', $id);
      $cinfo = Customer::getCinfo($map);
      if (!$cinfo) {
        $result['msg'] = '客户信息错误，请重新选择需要修改的客户！';
        goto _end;
      }
    }
    $cinfo['editmanid'] = $this->request->code;
    $cinfo['edit_date'] = date('Y-m-d H:i:s');
    $cfg['custom_type'] = Config::get('parameter.custom_type');
    $cfg['custlass'] = DbWork::queryList('custlass');
    $cfg['abc_type'] = Config::get('parameter.abc_type');
    $cfg['price_system'] = Db::name('commodity_price_system')->where(['status' => 1])->column('name', 'id');
    $selddk = Customer::where('id', '=', $id)->value('ddkindid');
    $selddk = empty($selddk) ? [] : explode(',', $selddk);
    foreach ($selddk as $k => $v) {
      $selddk[$k] = (int)$v;
    }
    $result = array('status' => 1, 'data' => $cinfo, 'cfg' => $cfg, 'selddk' => $selddk, 'selddk_txt' => $this->getcustddk($selddk));
    _end:
    exit(json_encode($result));
  }

  /**
   * 客户列表(弹出组件选择客户)
   */
  public function selcust()
  {
    $map = [];
    $params = $this->request->data;
    $page = isset($params['page']) ? $params['page'] : 1;
    if (!empty($params['noid'])) {
      $noid = '';
      foreach ($params['noid'] as $v) {
        $noid .= $noid == '' ? '\'' . $v . '\'' : ',\'' . $v . '\'';
      }
    }
    if (!empty($params['noid']) && !empty($params['keyword'])) {
      $params['keyword'] = trim($params['keyword']);
      $map[] = array('id', 'exp', Db::raw("NOT IN ({$noid}) AND (`id` like '%{$params['keyword']}%' OR `sname` like '%{$params['keyword']}%' OR `name` like '%{$params['keyword']}%' OR `mnecode` like '%{$params['keyword']}%')"));
    } elseif (!empty($params['noid'])) {
      $map[] = array('id', 'NOT IN', $params['noid']);
    } elseif (!empty($params['keyword'])) {
      $params['keyword'] = trim($params['keyword']);
      $map[] = array('id', 'exp', Db::raw("like '%{$params['keyword']}%' OR `sname` like '%{$params['keyword']}%' OR `name` like '%{$params['keyword']}%' OR `mnecode` like '%{$params['keyword']}%'"));
    }
    $list = Customer::getSimpleList($map, $page);
    $result = array('status' => 1, 'data' => $list);
    _end:
    exit(json_encode($result));
  }

  /**
   * 线路列表(弹出组件选择送货线路)
   */
  public function seldelivery()
  {
    $map = [];
    $params = $this->request->data;
    $page = isset($params['page']) ? $params['page'] : 1;
    if (!empty($params['keyword'])) {
      $params['keyword'] = trim($params['keyword']);
      $map[] = array('dname', 'exp', Db::raw("like '%{$params['keyword']}%' OR `licpla` like '%{$params['keyword']}%' OR `driver` like '%{$params['keyword']}%' OR `sttimeman` like '%{$params['keyword']}%'"));
    }
    $list = Delivery::getList($map, $page);
    $result = array('status' => 1, 'data' => $list);
    _end:
    exit(json_encode($result));
  }

  /**
   * 选择地区(弹出组件选择)
   */
  public function selarea()
  {
    $list = AreaMgt::getAreaTree();
    $result = array('status' => 1, 'data' => $list);
    _end:
    exit(json_encode($result));
  }

  /**
   * 选择员工(弹出组件选择)
   */
  public function selemp()
  {
    $map = [];
    $params = $this->request->data;
    $page = isset($params['page']) ? $params['page'] : 1;
    if (!empty($params['keyword'])) {
      $params['keyword'] = trim($params['keyword']);
      $map[] = array('e.code', 'exp', Db::raw("like '%{$params['keyword']}%' OR `e`.`name` like '%{$params['keyword']}%' OR `e`.`phone` like '%{$params['keyword']}%' OR `de`.`dept_name` like '%{$params['keyword']}%' OR `dw`.`value` like '%{$params['keyword']}%'"));
    }
    $list = Employee::getEmpList($map, $page);
    $result = array('status' => 1, 'data' => $list);
    _end:
    exit(json_encode($result));
  }

  /**
   * 选择部门(弹出组件选择)
   */
  public function seldepart()
  {
    $map[] = array('status', '=', 1);
    $list = Depart::depList($map);
    $result = array('status' => 1, 'data' => $list);
    _end:
    exit(json_encode($result));
  }

  /**
   * 选择许可经营类别
   */
  public function selddkind()
  {
    $map[] = array('status', '=', 1);
    $params = $this->request->data;
    $selddk = $params['selddk'];
    $selddk = array_unique($selddk);
    $list = PermitKinds::getddk($map, $selddk);
    $result = array('status' => 1, 'data' => $list, 'selddk' => $selddk);
    _end:
    exit(json_encode($result));
  }

  /**
   * 获取已设置的用户的经营类别(中文)
   */
  public function getcustddk($selddk = [])
  {
    $params = $this->request->data;
    $type = false;
    if (isset($params['selddk'])) {
      $selddk = $params['selddk'];
      $type = true;
    }
    return Customer::getcustddk($selddk, $type);
  }

  /**
   * 保存 新增/编辑 客户资料
   */
  public function save_customer()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $params = $this->request->data;
    $params = CommonFun::ProcessingData($params);
    $validate = new CustomerVal();
    $check_res = $validate->scene('all')->check($params);
    if (!$check_res) {
      $result['msg'] = $validate->getError();
      goto _end;
    }
    $params['retime'] = time();
    if (isset($params['id']) && !empty($params['id'])) {
        $params['sales_man_status']=0;
        $params['quality_depart_status']=0;
        $params['quality_man_status']=0;
        $params['isvalid']=0;
      $res = Db::name('customer')->strict(false)->where('id', '=', $params['id'])->update($params);
    } else {
      $params['id'] = CommonFun::createCode('CR', 'auto_id');
      $res = Db::name('customer')->strict(false)->insertGetId($params);
    }
    if (isset($params['man']) && !empty($params['man'])) {
      $cdata['cid'] = (isset($params['id']) && !empty($params['id'])) ? $params['id'] : $res;
      $cdata['user_name'] = trim($params['man']);
      if (isset($params['depart'])) $cdata['depart'] = trim($params['depart']);
      if (isset($params['mannumber'])) $cdata['phone'] = trim($params['mannumber']);
      if (isset($params['telephone'])) $cdata['tel'] = trim($params['telephone']);
      $cdata['isdefault'] = 1;
      $cdata['updater'] = $this->request->code;
      $cdata['re_date'] = date('Y-m-d H:i:s');
      $mccp[] = array('cid', '=', $cdata['cid']);
      $mccp[] = array('isdefault', '=', 1);
      $pd = Db::name('customer_supplier')->field('id')->where($mccp)->find();
      if ($pd) {
        Db::name('customer_supplier')->where($mccp)->update($cdata);
      } else {
        $cdata['creator'] = $cdata['updater'];
        $cdata['create_date'] = $cdata['re_date'];
        Db::name('customer_supplier')->insert($cdata);
      }
    }
    if (isset($params['custlass'])) DbWork::editDbWork(['value' => $params['custlass'], 'label' => $params['custlass']], 'custlass');//自动新增客户分类
    if ($res) $result = array('status' => 1, 'msg' => '保存成功！', 'id' => $params['id']);
    else $result = array('status' => 0, 'msg' => '保存失败！');
    _end:
    exit(json_encode($result));
  }

  /**
   * 获取客户联系人列表
   */
  public function contact_list()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $params = $this->request->data;
    if (isset($params['id']) && !empty($params['id'])) {
      $map[] = array('cid', '=', $params['id']);
      $list = Db::name('customer_supplier')->field('*')->where($map)->select()->toArray();
      $employee = Employee::column('name', 'code');
      foreach ($list as $k => $v) {
        $list[$k]['salesdepart_name'] = isset($employee[$v['salesdepart']]) ? $employee[$v['salesdepart']] : null;
        $list[$k]['qcdepart_name'] = isset($employee[$v['qcdepart']]) ? $employee[$v['qcdepart']] : null;
        $list[$k]['qcid_name'] = isset($employee[$v['qcid']]) ? $employee[$v['qcid']] : null;
        $list[$k]['creator_name'] = isset($employee[$v['creator']]) ? $employee[$v['creator']] : null;
        $list[$k]['updater_name'] = isset($employee[$v['updater']]) ? $employee[$v['updater']] : null;
      }
      $result = array('status' => 1, 'data' => $list, 'msg' => 'Success');
    } else {
      $result['msg'] = '未获取到ID';
    }
    _end:
    exit(json_encode($result));
  }

  /** 获取客户采购人员和联系人 */
  public function CustomerSales()
  {
    return CustomerSupplier::queryList($this->request->data);
  }

  /**
   * 新增/编辑客户,获取客户资料
   */
  public function editcontact()
  {
    $params = $this->request->data;
    $id = intval($params['id']);
    $data = array('creator' => $this->request->code, 'create_date' => date('Y-m-d'), 'salesdepart' => null, 'qcdepart' => null, 'qcid' => null, 'check_status' => 0);
    if ($id) {
      $data = Db::name('customer_supplier')->field('*')->where('id', '=', $id)->find();
      $data['create_date'] = empty($data['create_date']) ? date('Y-m-d') : date('Y-m-d', strtotime($data['create_date']));
      $data['validity_date'] = empty($data['validity_date']) ? null : date('Y-m-d', strtotime($data['validity_date']));
    }
    $result = array('status' => 1, 'data' => $data);
    exit(json_encode($result));
  }

  /**
   * 保存 客户资料
   */
  public function savecontact()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $data = $this->request->data;
    if (empty($data['cid'])) {
      $result['msg'] = '客户信息错误,保存失败！';
      goto _end;
    }
    $data = CommonFun::ProcessingData($data);
    $data['sex'] = (isset($data['sex']) && intval($data['sex']) > 0) ? intval($data['sex']) : null;
    $data['attorney_validity'] = 0;
    if (!empty($data['validity_date'])) {
      if (strtotime($data['validity_date']) > time()) $data['attorney_validity'] = 1;
    }
    if (isset($data['id']) && intval($data['id']) > 0) {
      unset($data['creator']);
      unset($data['create_date']);
      $data['updater'] = $this->request->code;
      $data['re_date'] = date('Y-m-d H:i:s');
      $res = CustomerSupplier::where('id', '=', $data['id'])->strict(false)->update($data);
    } else {
      $data['creator'] = $data['updater'] = $this->request->code;
      $data['create_date'] = $data['re_date'] = date('Y-m-d H:i:s');
      $res = CustomerSupplier::strict(false)->insert($data);
    }
    if ($res) $result = array('status' => 1, 'msg' => '保存成功！');
    else $result = array('status' => 0, 'msg' => '保存失败！');
    _end:
    exit(json_encode($result));
  }

  /**
   * 设置默认联系人
   */
  public function defaultcontact()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $data = $this->request->data;
    if (empty($data['id'])) {
      $result['msg'] = '客户信息错误,设置失败！';
      goto _end;
    }
    $info = Db::name('customer_supplier')->field('cid,user_name,depart,tel,phone')->where('id', '=', $data['id'])->find();
    if (!$info) {
      $result['msg'] = '客户信息错误！';
      goto _end;
    } else {
      $map[] = array('id', '=', $info['cid']);
      $udata['man'] = $info['user_name'];
      $udata['depart'] = $info['depart'];
      $udata['mannumber'] = $info['phone'];
      $udata['telephone'] = $info['tel'];
      $udata['retime'] = time();
      $res = Db::name('customer')->where($map)->update($udata);
      if ($res) $result = array('status' => 1, 'msg' => '设置成功！');
      else $result = array('status' => 0, 'msg' => '设置失败！');
    }
    _end:
    exit(json_encode($result));
  }

  /**
   * 删除联系人
   */
  public function delcontact()
  {
    $result = array('statua' => 0, 'msg' => '');
    $params = $this->request->data;
    if (isset($params['id']) && intval($params['id']) > 0) {
      $res = CustomerSupplier::where('id', '=', $params['id'])->delete();
      if ($res) $result = array('status' => 1, 'msg' => '删除成功');
      else $result = array('status' => 0, 'msg' => '删除失败');
    } else {
      $result['msg'] = '请选择需要删除的联系人';
    }
    _end:
    exit(json_encode($result));
  }

  /**
   * 获取客户洽谈记录列表
   */
  public function neg_list()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $params = $this->request->data;
    if (isset($params['id']) && !empty($params['id'])) {
      $map[] = array('cs.cid', '=', $params['id']);
      $list = Db::name('customer_business')->alias('cs')->field('cs.*,e.name as mman_name')->join('employee e', 'e.code=cs.mman', 'LEFT')->where($map)->select()->toArray();
      foreach ($list as $k => $v) {
        $list[$k]['bus_date'] = date('Y-m-d H:i', strtotime($v['bus_date']));
      }
      $result = array('status' => 1, 'data' => $list, 'msg' => 'Success');
    } else {
      $result['msg'] = '未获取到ID';
    }
    _end:
    exit(json_encode($result));
  }

  /**
   * 保存业务联系记录
   */
  public function savebusiness()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $data = $this->request->data;
    if (empty($data['cid'])) {
      $result['msg'] = '客户信息错误,保存失败！';
      goto _end;
    }
    $data = CommonFun::ProcessingData($data);
    $data['retime'] = time();
    if (intval($data['id']) > 0) $res = Db::name('customer_business')->where('id', '=', $data['id'])->strict(false)->update($data);
    else $res = Db::name('customer_business')->strict(false)->insert($data);
    if ($res) $result = array('status' => 1, 'msg' => '保存成功！');
    else $result = array('status' => 0, 'msg' => '保存失败！');
    _end:
    exit(json_encode($result));
  }

  /**
   * 删除业务联系记录
   */
  public function delbusiness()
  {
    $result = array('statua' => 0, 'msg' => '');
    $params = $this->request->data;
    if (isset($params['id']) && intval($params['id']) > 0) {
      $res = Db::name('customer_business')->where('id', '=', $params['id'])->delete();
      if ($res) $result = array('status' => 1, 'msg' => '删除成功');
      else $result = array('status' => 0, 'msg' => '删除失败');
    } else {
      $result['msg'] = '请选择需要删除的业务联系记录';
    }
    _end:
    exit(json_encode($result));
  }

  /**
   * 获取客户证照图片
   */
  public function cimg_list()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $params = $this->request->data;
    if (isset($params['id']) && !empty($params['id'])) {
      $list = CustomerImg::getList($params['id']);
      $result = array('status' => 1, 'data' => $list, 'msg' => 'Success');
    } else {
      $result['msg'] = '未获取到ID';
    }
    _end:
    exit(json_encode($result));
  }

  /**
   * 查看证照
   */
  public function getcustphoto()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $data = $this->request->data;
    if (!isset($data['id'])) {
      $result['msg'] = '客户信息错误！';
      goto _end;
    }
    $result = CustomerImg::oneIMG($data['id']);
    $result['status'] = 1;
    _end:
    exit(json_encode($result));
  }

  /**
   * 保存证照
   */
  public function comcustphoto()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $data = $this->request->data;
    $data = CommonFun::ProcessingData($data);
    $fileName = APP_PATH . '../public' . $data['pic_url'];
    if (!file_exists($fileName)) {
      $result['msg'] = '图片信息有误，请重新上传提交！';
      goto _end;
    }
    $fileNameVal = '/uploads/customer_img/' . $data['cid'] . '_' . $data['pic_name'] . strstr($data['pic_url'], '.');
    $newFileName = APP_PATH . '../public' . $fileNameVal;
    $re = @rename($fileName, $newFileName);
    if (!$re) {
      $result['msg'] = '图片保存失败，请重新再试！';
      goto _end;
    }
    $data['pic_url'] = $fileNameVal;
    $data['man'] = $this->request->code;
    $data['retime'] = time();
    $result = CustomerImg::addImg($data);
    _end:
    exit(json_encode($result));
  }

  /**
   * 删除证照
   */
  public function delcustphoto()
  {
    $result = array('statua' => 0, 'msg' => '');
    $params = $this->request->data;
    if (isset($params['id']) && intval($params['id']) > 0) {
      $res = CustomerImg::where('id', '=', $params['id'])->delete();
      if ($res) $result = array('status' => 1, 'msg' => '删除成功');
      else $result = array('status' => 0, 'msg' => '删除失败');
    } else {
      $result['msg'] = '请选择需要删除的证照';
    }
    _end:
    exit(json_encode($result));
  }

  /**
   * 获取客户协议品种
   */
  public function goods_list()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $params = $this->request->data;
    if (isset($params['id']) && !empty($params['id'])) {
      $list = CustomerGoods::getList($params['id']);
      $result = array('status' => 1, 'data' => $list);
    } else {
      $result['msg'] = '未获取到ID';
    }
    _end:
    exit(json_encode($result));
  }

  /**
   * 保存客户协议品种
   */
  public function savecustgoods()
  {
    $result = array('status' => 0, 'msg' => 'init');
    $data = $this->request->data;
    $data = CommonFun::ProcessingData($data);
    if (empty($data['cid']) || empty($data['goods_code'])) {
      $result['msg'] = '提交信息不正确';
      goto _end;
    }
    $data['update_time'] = date('Y-m-d H:i:s');
    $map[] = array('id', '=', $data['id']);
    $res = CustomerGoods::where($map)->strict(false)->update($data);
    if (!$res) $res = CustomerGoods::strict(false)->replace(true)->insert($data);
    if ($res) $result = array('status' => 1, 'msg' => '保存成功！');
    else $result = array('status' => 0, 'msg' => '保存失败！');
    _end:
    exit(json_encode($result));
  }

  /**
   * 删除客户协议品种
   */
  public function delcustgoods()
  {
    $result = array('statua' => 0, 'msg' => '');
    $params = $this->request->data;
    if (isset($params['id']) && intval($params['id']) > 0) {
      $res = CustomerGoods::where('id', '=', $params['id'])->delete();
      if ($res) $result = array('status' => 1, 'msg' => '删除成功');
      else $result = array('status' => 0, 'msg' => '删除失败');
    } else {
      $result['msg'] = '请选择需要删除的协议品种';
    }
    _end:
    exit(json_encode($result));
  }

  //获取限制销售客户列表
  public function getCustomerLimit()
  {
    $data = $this->request->data;
    $res = Customer::getSellLimmit($data['goods_code']);
    exit(json_encode($res));
  }
}
