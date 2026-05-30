<template>
	<view class="content" style="padding-top: 0rpx" id="jshop-content">
	</view>
</template>
<script>
export default {
	data() {
		return {
			page: 1,
			limit: 5,
			pageData: [],
			pageCode: 'mobile_home', //页面布局编码
			viewHeight: 0, //页面加载组件高度
			windowHeight: 0, //页面窗口高度
			config: '', //配置信息
			userInfo: {}, // 用户信息
			kefupara: '', //客服传递资料
			loadStatus: 'more',
			loadText: {
				contentdown: '上拉显示更多',
				contentrefresh: '正在加载...',
				contentnomore: ''
			},
			shareUrl: '/pages/share/jump',
		};
	},
	created() {
		//获取窗口高度信息
		let _this = this;
		uni.getSystemInfo({
			success: function (data) {
				_this.windowHeight = data.windowHeight;
			}
		});
	},
	onLoad(e) {
		this.initData();
		if (this.$store.state.config.shop_name) {
			uni.setNavigationBarTitle({
				title: this.$store.state.config.shop_name || ''
			});
		}
		// 分享朋友和朋友圈
		// #ifdef H5
		if (this.$common.isWeiXinBrowser()) {
			this.shareAll();
		}
		// #endif
	},
	onShow() {},
	methods: {
		// 首页初始化获取数据
		initData() {
			this.$api.shopConfig((res) => {
				this.config = res;
			});

			var _this = this;
			if (this.$db.get('userToken')) {
				this.$api.userInfo({}, (res) => {
					if (res.status) {
						_this.userInfo = res.data;
					}
				});
			}
			this.getShareUrl();
		},
		//获取分享URL
		getShareUrl() {
			let data = {
				client: 2,
				url: '/pages/share/jump',
				type: 1,
				page: 1
			};
			let userToken = this.$db.get('userToken');
			if (userToken && userToken != '') {
				data['token'] = userToken;
			}
			this.$api.share(data, (res) => {
				this.shareUrl = res.data;
			});
		},
		// 分享到朋友或朋友圈
		shareAll() {
			// 微信浏览器里面
			// console.log(window.location.href);
			let data = {
				url: window.location.href
			};
			let _this = this;
			this.$api.getShareInfo(data, (res) => {
				if (res.status) {
					_this.$wx.config({
						debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
						appId: res.data.appId, // 必填，公众号的唯一标识
						timestamp: res.data.timestamp, // 必填，生成签名的时间戳
						nonceStr: res.data.nonceStr, // 必填，生成签名的随机串
						signature: res.data.signature, // 必填，签名，见附录1
						jsApiList: ['updateAppMessageShareData', 'updateTimelineShareData']
					});
					_this.$wx.ready(function () {
						let shareInfo = {
							title: '首页',
							desc: '首页',
							imgUrl: _this.config.shop_default_image
						};
						// 分享朋友
						_this.$wx.updateAppMessageShareData(shareInfo);
						// 分享朋友圈
						_this.$wx.updateTimelineShareData(shareInfo);
					});
				}
			});
		}
	},
	//分享
	onShareAppMessage() {
		return {
			title: this.$store.state.config.share_title,
			// #ifdef MP-ALIPAY
			desc: this.$store.state.config.share_desc,
			// #endif
			imageUrl: this.$store.state.config.share_image,
			path: this.shareUrl
		};
	},
	// #ifdef MP-WEIXIN || APP-PLUS || APP-PLUS-NVUE
	onPageScroll() {
		var _this = this;
		const query = uni.createSelectorQuery();
		query
			.select('.content >>> .search')
			.boundingClientRect(function (res) {
				if (res) {
					if (res.top < 0) {
						_this.$store.commit('searchFixed', true);
					} else {
						_this.$store.commit('searchFixed', false);
					}
				}
			})
			.exec();
	}
	//#endif
};
</script>

<style>
.cell-item {
	border: none;
}

.cell-ft-text {
	font-size: 22rpx;
	color: #999;
}

.service {
	width: 80rpx;
	height: 80rpx;
	background-color: #fff;
	border-radius: 50%;
	position: fixed;
	right: 30rpx;
	bottom: 120rpx;
	display: flex;
	justify-content: center;
	align-items: center;
	box-shadow: 0 0 10rpx #ccc;
	padding: 0;
	z-index: 996;
}

.service .icon {
	width: 60rpx;
	height: 60rpx;
}

.subscription-notice {
	background-color: #ffffff;
	box-shadow: 0 2rpx 18rpx #eeeeee;
	position: relative;
	z-index: 99;
	height: 66rpx;
	line-height: 66rpx;
	padding: 0 20rpx;
	font-size: 28rpx;
	color: #333333;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.subscription-notice > view {
	display: flex;
	align-items: center;
}

.subscription-notice .icon {
	width: 32rpx;
	height: 32rpx;
	margin-right: 10rpx;
}

.subscription-notice-btn {
	color: #4285f4;
}

.subscription-notice-btn-close {
	color: #888888;
	padding-left: 10px;
	font-size: 30rpx;
}
</style>
