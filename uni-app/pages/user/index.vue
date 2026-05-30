<template>
	<view class="content">
		<view class="Toparea">
			<view class="bg">
				<image src="/static/img/user.png" mode=""></image>
			</view>
			<view class="user-info-wrap">
				<template v-if="!hasLogin">
					<view class="login-img">
						<image src="/static/img/default_avatar.png" mode=""></image>
					</view>
					<!-- #ifdef H5 || APP-PLUS -->
					<view class="login-text" @click="toLogin">
						请先登录
					</view> 
					<!-- #endif -->
					<!-- #ifdef MP-WEIXIN -->
					<view class="login-text" @click="goLogin">
						请授权登录
					</view>
					<!-- #endif -->
					<view class="ewm">
						<image src="/static/img/ewm.png" mode=""></image>
					</view>
				</template>
				<template v-else>
					<view class="login-img">
						<image :src="userInfo.avatar" mode=""></image>
					</view>
					<view class="login-info">
						<view class="nickname">
							{{ userInfo.nickname }}
						</view>
						<view class="grade">
							{{ userInfo.grade_name }}
						</view>
					</view>
					<view class="ewm"  @click="goToPage('/pages/member/share/index')">
						<image src="/static/img/ewm.png" mode=""></image>
					</view>
				</template>	
			</view>

		</view>
		
		<view class="ss-money-menu-wrap" style="margin-top: -88rpx;"  v-if="hasLogin">
			<view class="cardbg">
				<image src="/static/images/coin.png" mode=""></image>
			</view>		
			<view class="box flex ss-col-center">
				<view class="item"  @click="goToPage('/pages/member/balance/index')">
					<view class="item-txt">{{userInfo.balance || "0.00"}}</view>
					<view class="item-name">可转积分</view>
				</view>	
				<view class="item"  @click="goToPage('/pages/member/integral/index')">
					<view class="item-txt">{{userInfo.point || "0.00"}}</view>
					<view class="item-name">兑换积分</view>
				</view>	
				<view class="item" @click="goToPage('/pages/member/exp/index')">
					<view class="item-txt">{{userInfo.num_point || "0.00"}}</view>
					<view class="item-name">期权积分</view>
				</view>	
				<view class="item">
					<view class="item-img">
						<image src='/static/img/wallet_icon.png'></image>
					</view>
					<view class="item-name">我的钱包</view>
				</view>						
			</view>							
		</view>						
		<view class="ss-order-menu-wrap flex ss-col-center">
			<view class="item"  v-for="(item, index) in orderItems" :key="index" @click="orderNavigateHandle('/pages/member/order/orderlist', item.index)">
				<view class="item-img order_item-img">
					<image :src='item.icon'></image>
					<view class="badge" v-if="item.nums>0">
						<u-badge :type="type" :showZero='false' max="99" :value="item.nums"></u-badge>
					</view>
				</view>
				<view class="item-name">{{ item.name }}</view>
			</view>
		</view>			
		<view class="ss-power-menu-wrap flex ss-col-center">
			<view class="item"  v-for="(item, index) in utilityMenus" :key="index"  @click="navigateToHandle(item.router)" v-if="!item.unshowItem">
				<view class="item-img">
					<image :src='item.icon'></image>
				</view>
				<view class="item-name">{{ item.name }}</view>
			</view>		
			<view class="item" @click="gototel()">
				<view class="item-img">
					<image src='/static/img/pow_07.png'></image>
				</view>
				<view class="item-name">联系客服</view>
			</view>				
		</view>
		
	</view>
</template>



<script>
	const delay = (function() {
		let timer = 0
		return function(callback, ms) {
			clearTimeout(timer)
			timer = setTimeout(callback, ms)
		}
	})()
	import {
		checkLogin,common
	} from '@/config/mixins.js'
	import { h5Url } from '@/config/config.js'
	
	import { apiBaseUrl } from '@/config/config.js';	
	export default {
		mixins: [checkLogin,common],	
		data() {
			return {
				backgroundImg:"/static/img/user.png",
				type:"warning",
				value:100,
				editModal:false,
				open_id: '',
				hasLogin: false,
				userInfo: {}, // 用户信息
				kefupara: '', //客服传递资料
				afterSaleNums: 0,
				isClerk: false,
				alipayNoLogin: true,
				alipayName: '',
				alipayAvatar: '',
				config: '', //配置信息
				orderItems: [{
						name: '待付款',
						icon: '/static/img/no_pay.png',
						nums: 0,
						index:1
					},
					{
						name: '待收货',
						icon: '/static/img/no_take.png',
						nums: 0,
						index:2
					},
					{
						name: '待评价',
						icon: '/static/img/no_comment.png',
						nums: 0,
						index:4
					},
					{
						name: '售后单',
						icon: '/static/img/change_order.png',
						nums: 0,
						index:99
					},	
					{
						name: '全部订单',
						icon: '/static/img/all_order.png',
						nums: 0,
						index:0
					},															
				],
				utilityMenus: {
					address: {
						name: '收货地址',
						icon: '/static/img/pow_05.png',
						router: '/pages/member/address/list',
						unshowItem: false,
						nums: 0
					},					
					group: {
						name: '我的团队',
						icon: '/static/img/pow_11.png',
						router: '/pages/member/invite/list',
						unshowItem: false,
						nums: 0
					},
					mingxi: {
						name: '收入明细',
						icon: '/static/img/pow_04.png',
						router: '/pages/member/coupon/index',
						unshowItem: false,
						nums: 0
					},										
					tixian: {
						name: '提现',
						icon: '/static/img/pow_12.png',
						router: '/pages/member/balance/withdraw_cash',
						unshowItem: false,
						nums: 0
					},										
					// balance: {
					// 	name: '充值',
					// 	icon: '/static/img/pow_02.png',
					// 	router: '/pages/member/balance/recharge',
					// 	unshowItem: false,
					// 	nums: 0
					// },	
					pointShop: {
						name: '积分商城',
						icon: '/static/img/pow_08.png',
						router: '/pointmall/point/index',
						unshowItem: false,
						nums: 0
					},						
					// renzhen:{
					// 	name: '实名认证',
					// 	icon: '/static/img/pow_11.png',
					// 	router: '/pages/member/setting/user_info/index',
					// 	unshowItem: false,
					// 	nums: 0
					// },						
					huzhuan: {
						name: '账户互转',
						icon: '/static/img/pow_10.png',
						router: '/pages/member/balance/gift',
						unshowItem: false,
						nums: 0
					},					
					setting: {
						name: '设置',
						icon: '/static/img/pow_03.png',
						router: '/pages/member/setting/index',
						unshowItem: false,
						nums: 0
					}					
				},
				list: 2,
			}
		},
		onShow() {
			this.initData()
		},
		methods: {		
			editSuccess(data) {
				this.editModal = false;
				// this.userInfo = data;
				//在这里可以把获取到的头像昵称信息通过接口保存到数据库
				this.$api.editInfo(data,res=>{
					this.closeEdit();
					this.initData()
				})
			},	
			closeEdit() {
				this.editModal = false;
			},						
			goToPage(url){
				this.$common.navigateTo(url)
			},
			goLogin() {
				this.$common.navigateTo('/pages/login/login/index1')
			},
			gototel(){
				uni.makePhoneCall({
					phoneNumber: this.shopMobile.toString(),
					success(res) {},
					fail(res) {}
				});
			},			
			getUserInfo(e) {
				let _this = this
				//return false;
				if (e.detail.errMsg == 'getUserInfo:fail auth deny') {
					_this.$common.errorToShow('未授权')
				} else {
					var data = {
						open_id: _this.open_id,
						iv: e.detail.iv,
						edata: e.detail.encryptedData,
						signature: e.detail.signature
					}
					//有推荐码的话，带上
					var invitecode = _this.$db.get('invitecode')
					if (invitecode) {
						data.invitecode = invitecode
					}
					_this.toWxLogin(data)
				}
			},
			getALICode() {
				let that = this
				uni.login({
					scopes: 'auth_user',
					success: (res) => {
						if (res.authCode) {
							uni.getUserInfo({
								provider: 'alipay',
								success: function(infoRes) {
									if (infoRes.errMsg == "getUserInfo:ok") {
										let user_info = {
											'nickname': infoRes.nickName,
											'avatar': infoRes.avatar
										}
										that.aLiLoginStep1(res.authCode, user_info);
									}
								},
								fail: function(errorRes) {
									that.$common.errorToShow('未取得用户昵称头像信息');
								}
							});
						} else {
							that.$common.errorToShow('未取得code');
						}
					},
					fail: function(res) {
						console.log(res)
						that.$common.errorToShow('用户授权失败my.login');
					}
				});
			},
			getWxCode() {
				let that = this
				uni.login({
					scopes: 'auth_user',
					success: function(res) {
						if (res.code) {
							that.wxLoginStep1(res.code)
						} else {
							this.$common.errorToShow('未取得code')
						}
					},
					fail: function(res) {
						this.$common.errorToShow('用户授权失败wx.login')
					}
				})
			},
			wxLoginStep1(code) {
				this.$api.login1({
					code
				}, res => {
					if (res.status) {
						this.open_id = res.data
					} else {
						this.$common.errorToShow(res.msg, function() {
							uni.navigateBack({
								delta: 1
							})
						})
					}
				})
			},
			aLiLoginStep1(code, user_info) {
				let data = {
					'code': code,
					'user_info': user_info
				}
				this.$api.alilogin1(data, res => {
					this.alipayNoLogin = false;
					if (res.status) {
						this.open_id = res.data.user_wx_id
						//判断是否返回了token，如果没有，就说明没有绑定账号，跳转到绑定页面
						if (!res.data.hasOwnProperty('token')) {
							this.$common.navigateTo('/pages/login/login/index?user_wx_id=' + res.data.user_wx_id);
						} else {
							this.$db.set('userToken', res.data.token)
							this.initData()
						}
					} else {
						this.$common.errorToShow(res.msg)
					}
				})
			},
			toWxLogin(data) {
				let _this = this
				_this.$api.login2(data, function(res) {
					if (res.status) {
						//判断是否返回了token，如果没有，就说明没有绑定账号，跳转到绑定页面
						if (typeof res.data.token == 'undefined') {
							uni.redirectTo({
								url: '/pages/login/login/index?user_wx_id=' + res.data.user_wx_id
							})
						} else {
							_this.$db.set('userToken', res.data.token)
							_this.initData()
						}
					} else {
						_this.$common.errorToShow('登录失败，请重试')
					}
				})
			},
			toLogin() {
				this.$common.navigateTo('/pages/login/login/index1')
			},
			initData() {
				// 获取用户信息
				var _this = this				
				if (this.$db.get('userToken')) {
					this.hasLogin = true
					this.$api.userInfo({}, res => {
						if (res.status) {
							_this.userInfo = res.data
													
							// #ifdef MP-WEIXIN
							//微信小程序打开客服时，传递用户信息
							var kefupara = {}
							kefupara.nickName = res.data.nickname
							kefupara.tel = res.data.mobile
							_this.kefupara = JSON.stringify(kefupara)
							// #endif
							// 获取订单不同状态的数量
							let data = {
								ids: '1,2,3,4',
								isAfterSale: true
							}
							_this.$api.getOrderStatusSum(data, res => {
								if (res.status) {
									_this.orderItems.forEach((item, key) => {
										item.nums = res.data[key + 1]
									})
									_this.afterSaleNums = res.data.isAfterSale ?
										res.data.isAfterSale :
										0
								}
							})
						}
					})
				} else {
					this.hasLogin = false
					// #ifdef MP-WEIXIN
					this.getWxCode()
					// #endif
				}
			},
			navigateToHandle(pageUrl) {
				if (!this.hasLogin) {
					if(this.isNavto){
						this.checkIsLogin()
						this.isNavto=false;
						return
					}
					return
				}
				this.$common.navigateTo(pageUrl)
			},
			orderNavigateHandle(url, tab = 0) {
				if (!this.hasLogin) {
					if(this.isNavto){
						this.checkIsLogin()
						this.isNavto=false;
						return
					}
					return
				}
				this.$store.commit('orderTab', tab)
				this.$common.navigateTo(url)
			},
			goAfterSaleList() {
				if (!this.hasLogin) {
					if(this.isNavto){
						this.checkIsLogin()
						this.isNavto=false;
						return
					}
					return
				}
				this.$common.navigateTo('/pages/member/after_sale/list')
			}
		},
		computed: {
			// 获取店铺联系人手机号
			shopMobile() {
				return this.$store.state.config.shop_mobile || 0;
			},
			invoice_switch() {
				return this.$store.state.config.invoice_switch || 2;
			},
			store_switch() {
				return this.$store.state.config.store_switch || 0;
			}
		},
	}
</script>


<style lang="scss" scoped>
image {
	width:100%;
	height:100%;
}
.Toparea {
	position: relative;
	.bg {
		width:750rpx;
		height:320rpx;
		// #ifdef H5
		margin-top: -30rpx;
		// #endif
		// #ifdef APP
		margin-top: -105rpx;
		// #endif
	}
	.user-info-wrap {
		position: absolute;
		left:20rpx;
		top:0rpx;
		width:710rpx;
		margin: 40rpx auto 0;
		// #ifdef APP
		padding:20rpx 20rpx 0;
		// #endif
		// #ifdef H5
		padding:10rpx 20rpx 0;
		// #endif		
		display: flex;
		align-items: center;
		.login-img {
			width:120rpx;
			height:120rpx;
			border-radius: 120rpx;
			overflow: hidden;
			border:#fff 2rpx solid;
			background: #fff;
			image {
				width:100%;
				height:100%;
			}
		}
		.login-text {
			margin-left: 20rpx;
			line-height:100rpx;
			font-size:36rpx;
			color:#333;
		}
		.login-info {
			margin-left: 20rpx;
			line-height:50rpx;			
			color:#333;
			.nickname {
				display:flex;
				align-items: center;
				justify-content: center;
				font-size:28rpx;
				.iconfont {
					font-size:50rpx;
					color:#fda14a;
				}
			}			
			.grade {
				font-size:24rpx;
			}
		}
		.ewm {
			width:45rpx;
			height:45rpx;
			margin-left:auto;
			margin-right: 20rpx;
		}
	}
}

.ss-order-menu-wrap {
	position: relative;
	z-index:9;
	height:160rpx;
	align-items: center;
	background-color: #fff;
	.item {
		flex:1;		
		.item-img {
			width:44rpx;
			height:52rpx;
			margin:0 auto;
		}
		.order_item-img {
			width:44rpx;
			height:44rpx;
			margin:0 auto;
			position: relative;
		}
		.item-name {
			font-size:24rpx;
			color:#333;
			line-height:46rpx;
			text-align: center;
			margin-top:20rpx;
		}
	}
}

.ss-coupon-menu-wrap {
	.item {
		width:25%;		
		.item-img {
			width:44rpx;
			height:44rpx;
			margin:0 auto;
		}
		.item-name {
			font-size:24rpx;
			color:#333;
			line-height:46rpx;
			text-align: center;
			margin-top:20rpx;
		}
	}	
}


.ss-power-menu-wrap {
	flex-wrap: wrap;
	background-color: #fff;
	.item {
		width:25%;
		height:176rpx;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		.item-img {
			width:48rpx;
			height:48rpx;
			margin:0 auto;
		}
		.item-name {
			font-size:24rpx;
			color:#333;
			line-height:46rpx;
			text-align: center;
			margin-top:20rpx;
		}
	}	
}

.ss-money-menu-wrap {
	position: relative;
	width:710rpx;
	height:160rpx;
	margin: 20rpx auto 0;
	overflow: hidden;
	.cardbg {
		width: 100%;
		height: 100%;
		image {
			width: 100%;
			height: 100%;
		}
	}
	.box {
		position: absolute;
		top:0rpx;
		left:0rpx;
		width:700rpx;
		height:160rpx;		
		.item {
			width:33.33%;
			.item-txt {
				font-size:24rpx;
				color:#333;
				line-height:38rpx;
				text-align: center;
			}
			.item-img {
				width:44rpx;
				height:44rpx;
				margin:0 auto;
			}
			.item-name {
				font-size:24rpx;
				color:#333;
				line-height:46rpx;
				text-align: center;
				margin-top:20rpx;
			}
		}	
	}

}
.ss-money-menu-wrap-col3 {
	.item {
		width:33.33%;
	}
}

.ss-col-center {
	width:710rpx;
	position: relative;
	z-index:9;
	min-height:160rpx;
	align-items: center;
	margin:20rpx auto 0rpx;
	border-radius: 20rpx;
	overflow: hidden;
}


.card-vip {
	width: 690rpx;
	height: 134rpx;
	margin: 0 auto;
	position: relative;
	overflow: hidden;
	z-index: 999;
	margin-top: -100rpx;
	.card-vip-bg {
		width: 100%;
		height: 100%;
	}
	.card-box {
		position: absolute;
		top:0rpx;
		left:0rpx;
		width: 690rpx;
		height: 134rpx;
		padding:0 35rpx 0 30rpx;
		display: flex;
		align-items: center;
		.pai_img {
			width: 60rpx;
			height: 60rpx;
		}
		.left-box {
			color:#ae5a2a;
			font-size: 24rpx;
			margin-left: 10rpx;
		}
		.vipbtn {
			height: 52rpx;
			line-height: 52rpx;
			text-align: center;
			padding: 0 10px;
			background: #fff;
			border-radius: 28rpx;
			font-size: 26rpx;
			color: #ae5a2a;
			margin-left: auto;
		}
	}
}

.kefuBtn {
	background: none;
	border:none;
	&::after {
		background: none;
		border:none;
	}
}
</style>