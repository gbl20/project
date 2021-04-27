<?php
namespace app\sales\controller;
use app\BaseController;
use app\sales\model\SelExport;
use app\sales\model\SelExportDtl;

Class SelExportCon extends BaseController{
    public function selExportList(){
        $data = SelExport::queryList($this->request->data);
        $res = ['status'=>1,'data'=>$data];
        return $res;
    }
    public function editSelExportInit(){
        $data = SelExport::queryOne($this->request->data);
        return ['status'=>1,'data'=>$data];
    }
    public function auditSelExport(){
        return SelExport::auditSelExport($this->request->data,$this->request->code);
    }
    public function reductionSelExport(){
        return SelExport::reductionSelExport($this->request->data,$this->request->code);
    }
    public function comSelExport(){
        return SelExport::comSelExport($this->request->data,$this->request->code);
    }


    public function getSelOrder()
    {
      return SelExport::custOrder($this->request->data);
    }

    public function getSelOrderDtl()
    {
      return SelExportDtl::custOrderDtl($this->request->data);
    }
}
