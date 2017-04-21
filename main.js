
//==============================================    jspatch 服务器 ============================================================ //

require('CYDataCache,CYUserModel,NSMutableArray');
defineClass("CYHomeViewController", {
            
            jspatchAsyncArray: function() {
            var chatUsers = NSMutableArray.array();
            
// 0001 用户 -- 新增用户样式模板
            var model0001 = CYUserModel.alloc().init();
            model0001.setUserName("云中帆");
            model0001.setHeaderImageUrl("http://qzapp.qlogo.cn/qzapp/1105477680/ECDEB57ABB7875D4EC28E60B135DE1ED/100");
            model0001.setQqUID("ECDEB57ABB7875D4EC28E60B135DE1ED");
            model0001.setLoginType("QQ");
            model0001.setAboutMe("好朋友简简单单，好情谊清清爽爽，好缘份永永远远，愿你我珍惜这份永远的好缘份。");
            // 融云 user id 即QQ token
            model0001.setQqToken("B53953A7283C8ECD22B8D885D481B7C7");
            // 融云 user 唯一标示
            model0001.setRcToke("ZXWTiosJq1I+SgagCfFBTtgyZoIeBaWPzZr/Xh13ze2i+BfEJYmOMSMk6AkCOsJORZAG9yX+AXgdkPLghngxmdJ31Sh1K39zGrIw0CeSGpXVtWg4xt/bGH0lHdsiS/QF6i1gt3VUahE=");
            // 是否注册
            model0001.setHaveRegister(true);
            // 是否发送了注册邮件
            model0001.setHaveSendMessage(true);
            chatUsers.addObject(model0001);
            
// 0002 用户
            var model0002 = CYUserModel.alloc().init();
            model0002.setUserName("最美的时光");
            model0002.setHeaderImageUrl("http://qzapp.qlogo.cn/qzapp/1105477680/5EAF9474942F283012112A5FC6B52F3A/100");
            model0002.setQqUID("ECDEB57ABB7875D4EC28E60B135DE1ED");
            model0002.setLoginType("QQ");
            model0002.setAboutMe("贺新春，庆佳节，恭喜发财！过年好，万事顺，事事如意！祝爸妈新年快乐!");
            model0002.setQqToken("1B52EC0D86C8837AAB7B1C3E6B4BEF54");
            model0002.setRcToke("1Ygp50VQJ+ENzXgNvlAZi7GYCNrKxf1Pm7wqcvk8/xpQw+6MgqP9V+Rjd6fvzBBnF0FrYQVHLmpwiFZWE0A26K7rg5QWBX3E3Hz77IbdwaPu/uMWgsUjl3/xwMqQBkt8WabcxlyPg58=");
            model0002.setHaveRegister(true);
            model0002.setHaveSendMessage(true);
            chatUsers.addObject(model0002);
            
// 0003 用户
            var model0003 = CYUserModel.alloc().init();
            model0003.setUserName("小菜ios");
            model0003.setHeaderImageUrl("http://tva3.sinaimg.cn/crop.0.0.640.640.50/005zb5DWjw8f7s02hrhvuj30hs0hswez.jpg");
            model0003.setQqUID("5100479224");
            model0003.setLoginType("weibo");
            model0003.setAboutMe("贺新春，庆佳节，恭喜发财！\n过年好，万事顺，事事如意！祝爸妈新年快乐!");
            model0003.setQqToken("2.00wdFLZFgQFNhD50de922806VavwZB");
            model0003.setRcToke("ePuV+tLB/67GLh4zUTTsIA2LVo7sd0nBwID9wiJk+2/QXl6zGzbvh3WDOEq+7FvL01YotZrWA2vLnkGpBFpTCHILjfIdVDLFDFB+lcC+I8z7j2XXJlYi6vMsnkSBlsy/");
            model0003.setHaveRegister(true);
            model0003.setHaveSendMessage(true);
            chatUsers.addObject(model0003);

            self.setChatUserArray(chatUsers);
            }
})

require('FindBannerModel,NSMutableArray');
defineClass("CYFindViewController", {
            
            loadBannerArray: function() {
            var bannerUsers = NSMutableArray.array();
            
            // 0001 用户 -- 新增用户样式模板
            var model01 = FindBannerModel.alloc().init();
            model01.setImgUrl("http://img06.tooopen.com/images/20161204/tooopen_sy_188713354445.jpg");
            model01.setType("2");
            model01.setUrl("http://www.tooopen.com/view/1340214.html");
            bannerUsers.addObject(model01);
            
            // 0002 用户
            var model02 = FindBannerModel.alloc().init();
            model02.setImgUrl("http://img06.tooopen.com/images/20161021/tooopen_sy_182534789978.jpg");
            model02.setType("2");
            model02.setUrl("https://v.qq.com");
            bannerUsers.addObject(model02);
            self.setBannerArray(bannerUsers);
            }
            
})

