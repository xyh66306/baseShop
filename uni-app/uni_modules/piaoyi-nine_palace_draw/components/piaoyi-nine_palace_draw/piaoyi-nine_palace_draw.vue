<template>
	<view class="pagebox">
		<view class="pond-head" @tap="init">
			<image :src="require('./image/pond-head.png')" alt="">
		</view>
		<view class="container-out">
			<view class="container-in">
				<view class="content-out" v-for="(box,index) in list"
					:key="index"
					:style="{left:box.left+'px',top:box.top+'px','background-color':index==indexSelect?colorAwardSelect:colorAwardDefault}">
					<image class="pond-name-img" :src="box.image_url" alt="">
					<view class="pond-name">{{box.name}}</view>
				</view>
			</view>
			<view class="start-btn" @tap="startBtn">
				<image :src="require('./image/pond-button.png')" style="height:80px;width:100%;" alt="">
				<image :src="require('./image/pond-cj.png')" :style="{'top':btntop+'px'}"
					style="position:absolute;left:5px;height:68px;width:89px;top:0;" alt="">
			</view>
			<view class="circle" v-for="(item,index) in circleList"
				:key="index"
				:style="{'top':item.topCircle+'px','left':item.leftCircle+'px','background-color':index%2==0?colorCircleFirst:colorCircleSecond}">
			</view>
		</view>
		<view class="prize" v-if="prize==1">
			<view class="prize-box">
				<image class="prize-img" :src="require('./image/pond-success.png')" alt="">
				<view class="prize-msg">
					<view>恭喜</view>
					<view>抽中{{prize_name}}</view>
					<view class="continue" @tap="conTinue">继续抽奖</view>
				</view>
			</view>
		</view>
		<view class="prize" v-if="prize==2">
			<view class="prize-box">
				<image class="prize-img2" :src="require('./image/pond-empty.png')" alt="">
				<view class="prize-msg">
					<view>谢谢参与</view>
					<view>再换个姿势抽奖</view>
					<view class="continue" @tap="conTinue">继续抽奖</view>
				</view>

			</view>
		</view>
		<view class="men" v-if="men"></view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				list: [{
						id: 1,
						type: 1,
						name: '十元代金卷',
						image_url: require('./image/djj.jpg')
					},
					{
						id: 2,
						type: 2,
						name: '谢谢参与',
						image_url: require('./image/djj.jpg')
					},
					{
						id: 3,
						type: 1,
						name: '笔记本电脑',
						image_url: require('./image/djj.jpg')
					},
					{
						id: 4,
						type: 1,
						name: '20元优惠券',
						image_url: require('./image/djj.jpg')
					},
					{
						id: 5,
						type: 1,
						name: '500积分',
						image_url: require('./image/djj.jpg')
					},
					{
						id: 6,
						type: 1,
						name: '100元现金',
						image_url: require('./image/djj.jpg')
					},
					{
						id: 7,
						type: 1,
						name: '健身卡一张',
						image_url: require('./image/djj.jpg')
					},
					{
						id: 8,
						type: 2,
						name: '谢谢参与',
						image_url: require('./image/djj.jpg')
					},
				],
				circleList: [],
				colorCircleFirst: "#F12416",
				colorCircleSecond: "#FFFFFF",
				colorAwardDefault: "#F5F0FC",
				colorAwardSelect: "#ffe400",
				btntop: 0, //按钮的样式
				time: '', //定时器
				indexSelect: 0, //奖品下标
				lottert: 0, //中奖下标
				prize: 0, //是否中奖
				prize_name: '', //奖品名字
				men: false
			}
		},
		created() {
			this.init();
		},
		methods: {
			init() {
				var ts = this;
				var list = this.list;
				var left = 9;
				var top = 9;

				for (var i = 0; i < 8; i++) {
					if (i == 0) {
						left = 9;
						top = 9;
					} else if (i < 3 && i != 0) {
						top = top;
						left = left + 98 + 4;
					} else if (i >= 3 && i < 5) {
						left = left;
						top = top + 79 + 4;
					} else if (i >= 5 && i < 7) {
						left = left - 98 - 4;
						top = top;
					} else if (i >= 7 && i < 8) {
						left = left;
						top = top - 79 - 4;
					}
					list[i].top = top;
					list[i].left = left;
				}
				this.list = list;
				var cleft = 4; //e
				var ctop = 4; //a
				var dian = [];
				for (var j = 0; j < 24; j++) {
					if (j == 0) {
						cleft = 4;
						ctop = 4;
					} else if (j < 6) {
						ctop = 2;
						cleft += 55;
					} else if (j == 6) {
						ctop = 2;
						cleft = 330;
					} else if (j < 12) {
						ctop += 46;
						cleft = 331.5;
					} else if (j == 12) {
						ctop = 272.5;
						cleft = 330;
					} else if (j < 18) {
						ctop = 275;
						cleft -= 55;
					} else if (j == 18) {
						ctop = 273;
						cleft = 5;
					} else {
						if (!(j < 24)) return;
						ctop -= 46, cleft = 2.5;
					}
					dian.push({
						topCircle: ctop,
						leftCircle: cleft
					})
				}

				this.circleList = dian;
				setInterval(function() {
					if (ts.colorCircleFirst == "#FFFFFF") {
						ts.colorCircleFirst = "#F12416";
						ts.colorCircleSecond = "#FFFFFF";
					} else {
						ts.colorCircleFirst = "#FFFFFF";
						ts.colorCircleSecond = "#F12416";
						ts.btntop = 0;
					}
				}, 900)
				this.time = setInterval(function() {
					if (ts.btntop == 0) {
						ts.btntop = -3;
					} else {
						ts.btntop = 0;
					}
				}, 900)
			},
			startBtn(e) {
				clearInterval(this.time);
				this.men = true;
				this.btntop = 0;
				this.lottert = 0;
				var ts = this;
				var i = this.indexSelect;
				var list = this.list;
				var time = null;
				var s = 0;

				time = setInterval(function() {
					i++;
					i %= 8;
					s += 30;
					ts.indexSelect = i;
					if (ts.lottert > 0 && i + 1 == ts.lottert) {
						clearInterval(time);
						ts.time = setInterval(function() {
							if (ts.btntop == 0) {
								ts.btntop = -3;
							} else {
								ts.btntop = 0;
							}
						}, 900);
						if (list[i].type == 2) {
							ts.prize = 2;
						} else {
							ts.prize_name = list[i].name;
							ts.prize = 1;
						}

					}
				}, 200 + s);

				setTimeout(function() {
					ts.lottert = ts.randomNum(1, 8);
				}, 2e3);

			},
			randomNum(minNum, maxNum) {
				switch (arguments.length) {
					case 1:
						return parseInt(Math.random() * minNum + 1, 10);
						break;
					case 2:
						return parseInt(Math.random() * (maxNum - minNum + 1) + minNum, 10);
						break;
					default:
						return 0;
						break;
				}
			},
			conTinue() {
				this.men = false;
				this.prize = 0;
			}
		}
	}
</script>

<style scoped>
	.pagebox {
		width: 100%;
		height: 100vh;
		background: #f12416;
	}

	.pond-head image {
		width: 100%;
		height: 430rpx;
	}

	.container-out {
		height: 283px;
		width: 340px;
		background-color: #F47915;
		margin: 16px auto 15px auto;
		border-radius: 8px;
		position: relative;
	}

	.circle {
		position: absolute;
		display: block;
		border-radius: 50%;
		height: 7px;
		width: 7px;
	}

	.content-out {
		position: absolute;
		height: 72px;
		width: 98px;
		background-color: #f5f0fc;
		border-radius: 8px;
		box-shadow: 0 8px 0 #FFCEC0;
	}

	.container-in {
		width: 320px;
		height: 263px;
		background-color: #f12416;
		border-radius: 10px;
		position: absolute;
		left: 0;
		right: 0;
		top: 0;
		bottom: 0;
		margin: auto;
	}

	.pond-name-img {
		position: absolute;
		top: 6px;
		left: 0;
		width: 100%;
		height: 46px;
		z-index: 1;
	}

	.pond-name {
		position: absolute;
		top: 75%;
		color: #c62015;
		width: 98px;
		overflow: hidden;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 1;
		font-size: 9pt;
		text-align: center;
	}

	.start-btn {
		position: absolute;
		margin: auto;
		top: 0;
		left: 0;
		bottom: 0;
		right: 0;
		border-radius: 8px;
		height: 79px;
		width: 98px;
		color: #f6251e;
		text-align: center;
		font-weight: bolder;
		line-height: 77px;
	}

	.prize {
		background: rgba(0, 0, 0, 0.25);
		position: fixed;
		left: 0;
		top: 0;
		width: 100vw;
		height: 100vh;
		z-index: 1;
		display: -webkit-box;
		display: -webkit-flex;
		display: flex;
		-webkit-box-align: center;
		-ms-flex-align: center;
		-ms-grid-row-align: center;
		align-items: center;
		z-index: 100;
	}

	.prize-box {
		margin: 0 auto;
		position: relative;
		display: flex;
		align-items: center;
		flex-direction: column;
	}

	.prize-img {
		width: 100vw;
		max-height: 231px;
		max-width: 375px;
	}

	.prize-img2 {
		width: 100vw;
		max-height: 120px;
		max-width: 375px;
	}

	.prize-msg {
		width: 78.5vw;
		max-width: 294.5px;
		text-align: center;
		background: #ffffff;
		padding-bottom: 6px;
		font-size: 13pt;
	}

	.prize_name {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.continue {
		width: 240px;
		height: 40px;
		margin: 28px auto;
		background: #ff5c5c;
		line-height: 40px;
		color: #ffffff;
		border-radius: 20px;
	}

	.men {
		position: fixed;
		width: 100vw;
		height: 100vh;
		z-index: 1;
		left: 0;
		top: 0;
	}
</style>
