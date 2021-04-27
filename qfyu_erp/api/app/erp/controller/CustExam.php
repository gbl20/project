<?php
namespace app\erp\controller;
use app\BaseController;
use app\erp\model\Customer;

class CustExam extends BaseController
{
  /**
   * 客户资料列表
   */
  public function exam_list()
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
}
