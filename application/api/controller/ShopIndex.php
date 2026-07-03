<?php
/*
 * @Author: Xyhao
 * @Date: 2026-03-16 10:11:11
 * @Description: 安徽爱喜网络科技有限公司
 */

namespace app\api\controller;
use app\common\controller\Api;
use app\common\model\Goods as GoodsModel;
use app\common\model\Notice as NoticeModel;
use think\Db;

/**
 * 首页
 * Class ShopIndex
 * @package app\api\controller
 */
class ShopIndex extends Api
{
    /**
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function index()
    {
        $result = [
            'status' => true,
            'msg' => '获取成功',
            'data' => []
        ];

        $GoodsModel = new GoodsModel();

        $hotlist = $GoodsModel->field("id,name,price,mktprice,image_id,brief")->where("marketable",1)->whereIn("goods_cat_id",1)->cache(3600)->select()->toArray();

        foreach ($hotlist as &$item) {
            $item['image_url'] = _sImage($item['image_id']);
            $item['price'] = floatval($item['price']);
            $item['product_id'] = Db::name("products")->where("goods_id",$item['id'])->value("id");
        }

        $noticeModel = new NoticeModel();

        $notice = $noticeModel->where('type',1)->find();

        $result['data']['gudong'] = false;
        $result['data']['notice'] = $notice;
        $result['data']['hotlist'] = $hotlist;
        return $result;
 
    }

    public function getLst()
    {
        $result = [
            'status' => true,
            'msg' => '获取成功',
            'data' => []
        ];

        $GoodsModel = new GoodsModel();

        $list = $GoodsModel->field("id,name,price,mktprice,image_id,brief")->where("marketable",1)->whereIn("goods_cat_id",2)->cache(3600)->select()->toArray();

        foreach ($list as &$item) {
            $item['image_url'] = _sImage($item['image_id']);
            $item['price'] = floatval($item['price']);
        }

        $result['data']['list'] = $list;
        return $result;
 
    }



    public function notice()
    { 
        $result = [
            'status' => true,
            'msg' => '获取成功',
            'data' => []
        ];
        
        $page = input('page', 1);
        $limit = input('limit', config('jshop.page_limit'));

        $noticeModel = new NoticeModel();
        $notice = $noticeModel->where('type',1)->page($page, $limit)->select();
        $count =  $noticeModel->where('type',1)->count("id");

        foreach ($notice as &$item) {
            $item['image_url'] = _sImage();
            $item['ctime'] = date("Y-m-d",$item['ctime']);
        }

        $result['data']['list'] = $notice;
        $result['data']['count'] = $count;
        return $result;

    }


    public function version(){
        $result = [
            'status' => true,
            'msg' => '获取成功',
            'data' => []
        ];
        $platform = input('platform', 'android');
        $info = Db::name("version")->where("device",$platform)->cache(86400)->find();
        $result['data'] = $info;
        return $result;

    }



    public function tixiangz(){
        $result = [
            'status' => true,
            'msg' => '获取成功',
            'data' => []
        ];
        $data['tocash_money_low'] = getSetting("tocash_money_low");
        $data['tocash_money_rate'] = getSetting("tocash_money_rate");
        $data['tocash_money_limit'] = getSetting("tocash_money_limit");

        $result['data'] = $data;
        return $result;

    }


    public function getproductid(){
        $result = [
            'status' => true,
            'msg' => '获取成功',
            'data' => []
        ];

        $price = input('price', 0);
        $info = Db::name("products")->where("goods_id",1)->where("price",$price)->find();
        $result['data'] = $info['id'];
        return $result;

    }
}