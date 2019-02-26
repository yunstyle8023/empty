//
//  CA_HApi.h
//  CNNoteManager
//
//  Created by 韩云智 on 2017/11/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#ifndef CA_HApi_h
#define CA_HApi_h

#define CA_H_Online 0 //0:线上 1:test 2:dev 3:本地 4:Debug

#if CA_H_Online == 0
//#define CA_H_SERVER_API @"http://equity.chengantech.com"
//#define CA_H_SERVER_API @"https://mobile.api.chengantech.com"

//#define CA_H_SERVER_API @"http://39.107.61.47"
#define CA_H_SERVER_API @"https://zgc.chengantech.cn"

#elif CA_H_Online == 1
//#define CA_H_SERVER_API @"http://test.chengantech.cn:8899"
#define CA_H_SERVER_API @"http://39.105.47.110:8889"

#elif CA_H_Online == 2
#define CA_H_SERVER_API @"http://test.chengantech.cn:9999"

#elif CA_H_Online == 3
//#define CA_H_SERVER_API @"http://192.168.31.217:8888" // 李闯
//#define CA_H_SERVER_API @"http://192.168.31.95:8088" // 小辉
//#define CA_H_SERVER_API @"http://192.168.31.64:5001" // 大志
//#define CA_H_SERVER_API @"http://pre.chengantech.cn:8080" //后台预发
#define CA_H_SERVER_API @"http://192.168.31.155:9000" // 星星


#elif CA_H_Online == 4
#define CA_H_SERVER_API [CADebugging sharedManager].api

#endif


#define CA_H_SERVER_PATH @"?v=1"

#pragma mark -------------------- 登录

#define CA_H_Api_Logout @"/company/client/v1/logout"//退出登录
#define CA_M_Api_OrganizationLogin @"/company/client/v1/login"//机构账号登录
#define CA_M_Api_GenPhoneBind @"/company/client/personal/genphonebind"//获取手机验证码
#define CA_M_Api_ValidPhoneBindCode @"/company/client/personal/validphonebindcode"//绑定手机/更换手机
#define CA_M_Api_QueryUserPhone @"/company/client/personal/queryuserphone" //通过用户名查询用户绑定的手机
#define CA_M_Api_GenForgetPwd @"/company/client/personal/genforgetpwd"//获取忘记密码的验证码
#define CA_M_Api_CheckPhoneBind @"/company/client/personal/checkphonebind"//检测手机号是否绑定
#define CA_M_Api_ValidForgetPwdCode @"/company/client/personal/validforgetpwdcode"//验证忘记密码获取的验证码
#define CA_M_Api_ResetNewPwd @"/company/client/personal/resetnewpwd"//重新设置新密码
#define CA_M_Api_CheckPhoneExist @"/company/client/personal/checkphoneexist"//检测手机号是否存在
#define CA_M_Api_GenPhoneLogin @"/company/client/personal/genphonelogin"//获取手机号登录时的验证码
#define CA_M_Api_ValidPhoneLoginCode @"/company/client/personal/validphonelogincode"//手机号登录
#define CA_M_Api_GenweChatBind @"/company/client/personal/genwechatbind"//绑定微信
#define CA_M_Api_GenweChatUnBind @"/company/client/personal/genwechatunbind"//解除绑定微信

#define CA_M_Api_CheckCompanyRegister @"/company/client/v1/checkcompanyregister"//查询机构是否已注册
#define CA_M_Api_BindCompanyInfo @"/company/client/v1/bindcompanyinfo"//校验用户信息
#define CA_M_Api_Register @"/company/client/v1/register"//注册机构
#define CA_M_Api_GenPhoneRegister @"/company/client/v1/genphoneregister"

// 文件上传
#define CA_H_Api_UpdateFile @"/web/v1/api/uploadfile"

#pragma mark -------------------- 首页
#pragma mark -------------------- 笔记

#define CA_H_Api_QueryNote @"/company/client/comm/querynote" //查询笔记/笔记详情
#define CA_H_Api_ListNote @"/company/client/comm/listnote" //搜索笔记
#define CA_H_Api_AddNoteComment @"/company/client/comm/addnotecomment" //添加笔记评论
#define CA_H_Api_DeleteNoteComment @"/company/client/comm/deletenotecomment" //删除笔记评论

#define CA_H_Api_CreateNote @"/company/client/comm/createnote" //创建笔记
#define CA_H_Api_UpdateNote @"/company/client/comm/updatenote" //创建笔记
#define CA_H_Api_DeleteNote @"/company/client/comm/deletenote" //删除笔记
#define CA_H_Api_MoveNote @"/company/client/comm/movenote" //移动笔记

#define CA_H_Api_ListNoteType @"/company/client/comm/listnotetype"//笔记类型列表
#define CA_H_Api_ShareNote @"/company/client/comm/sharenote"//分享笔记

#define CA_H_Api_NoteImage(note_id) [NSString stringWithFormat:@"/company/client/comm/generatenoteimage/%@.jpg",(note_id)] //笔记长图

#pragma mark -------------------- 待办

#define CA_H_Api_ListTaskParams @"/company/client/comm/listtaskparams" //待办参数

#define CA_H_Api_ListTodo @"/company/client/comm/listtodo" //待办列表
#define CA_H_Api_QueryTodo @"/company/client/comm/querytodo" //待办详情
#define CA_H_Api_CreateTodo @"/company/client/comm/createtodo" //添加待办
#define CA_H_Api_DeleteTodo @"/company/client/comm/deletetodo" //删除待办
#define CA_H_Api_UpdateTodo @"/company/client/comm/updatetodo" //修改待办
#define CA_H_Api_UpdateTodoStatus @"/company/client/comm/updatetodostatus" //修改待办完成状态
#define CA_H_Api_AddTodoComment @"/company/client/comm/addtodocomment" //添加待办评论
#define CA_H_Api_DeleteTodoComment @"/company/client/comm/deletetodocomment" //删除待办评论

#define CA_H_Api_ListMember @"/company/client/project/listmember" //成员列表
#define CA_H_Api_ListCompanyUser @"/company/client/project/listcompanyuser" //机构成员

#pragma mark -------------------- 文件
// 文件目录列表
#define CA_H_Api_ListDirectoryFile @"/company/client/comm/listdirectory"//@"/company/client/comm/listdirectoryfile"

// 目录
#define CA_H_Api_CreateDirectory @"/company/client/comm/createdirectory" //创建文件夹
#define CA_H_Api_DeleteDirectory @"/company/client/comm/deletedirectory" //删除文件夹
#define CA_H_Api_RenameDirectory @"/company/client/comm/renamedirectory" //重命名文件夹

// 文件
#define CA_H_Api_CreateFiles @"/company/client/comm/createfiles" //创建文件
#define CA_H_Api_DeleteFile @"/company/client/comm/deletefile" //删除文件
#define CA_H_Api_RenameFile @"/company/client/comm/renamefile" //重命名文件
#define CA_H_Api_MoveFile @"/company/client/comm/movefile" //移动文件

// 添加文件
#define CA_H_Api_ListRootDirectory @"/company/client/comm/listchoicedirectory"//@"/company/client/comm/listrootdirectory" //选择根目录
#define CA_H_Api_AuthDirectory @"/company/client/comm/authdirectory" //目录校验

// 标签
#define CA_H_Api_ListTag @"/company/client/comm/listtag"
#define CA_H_Api_CreateFileTags @"/company/client/comm/createfiletag"
#define CA_H_Api_UpdateFileTags @"/company/client/comm/updatefiletags"

#pragma mark -------------------- 项目
//项目首页
#define CA_M_Api_ListProjectHome @"/company/client/project/listprojecthome"//新的项目首页
#define CA_M_Api_QueryProjectPanel @"/company/client/project/queryprojectpanel"//展示项目面板设置
#define CA_M_Api_UpdateProjectPanel @"/company/client/project/updateprojectpanel"//编辑项目面板设置
#define CA_M_Api_UpdateFollowProject @"/company/client/project/updatefollowproject"//更新关注项目状态


#define CA_M_Api_ListProject @"/company/client/project/listproject"//项目列表
#define CA_M_Api_QueryProjectHome @"/company/client/project/queryprojecthome"//查询项目首页
#define CA_M_Api_GetDetail @"/company/client/project/getdetail"//获取项目资料
#define CA_M_Api_UpdateProject @"/company/client/project/updateproject"
#define CA_M_Api_QueryProcedure @"/company/client/project/queryprocedure"//查询项目流程
#define CA_M_Api_ForwardProcedure @"/company/client/project/forwardprocedure"//提起审批
#define CA_M_Api_BackwardProcedure @"/company/client/project/backwardprocedure"//阶段撤回
#define CA_M_Api_ListMember @"/company/client/project/listmember"//成员列表
#define CA_M_Api_UpdateMemberRole @"/company/client/project/updatememberrole"//修改成员角色
#define CA_M_Api_DeleteMember @"/company/client/project/deletemember"//移除成员
#define CA_M_Api_SureaddMember @"/company/client/project/sureaddmember"//可添加成员列表
#define CA_M_Api_AddMember @"/company/client/project/addmember"//添加成员
#define CA_M_Api_UpdateProjectPrivacy @"/company/client/project/updateprojectprivacy"//更改项目隐私状态
#define CA_M_Api_QuitProject @"/company/client/project/quitproject"//退出项目
#define CA_M_Api_DeleteProject @"/company/client/project/deleteproject"//删除项目
#define CA_M_Api_ListWorkTable @"/company/client/worktable/listworktable"//工作台
#define CA_M_Api_UpdateProjectIntro @"/company/client/project/updateprojectintro"//更改项目详情
#define CA_M_Api_CreateProjectTag @"/company/client/project/createprojecttag"//添加项目标签
#define CA_M_Api_DeleteProjectTag @"/company/client/project/deleteprojecttag"//删除项目标签
#define CA_M_Api_ListHumanrResource @"/company/client/human/listhumanresource"//人脉圈列表
#define CA_M_Api_ListHumanrTag @"/company/client/human/listhumantag"//人脉标签
#define CA_M_Api_CreateObjectHuman @"/company/client/human/createobjecthuman"//添加项目相关人员(已有联系人)
#define CA_M_Api_CreateHumanResource @"/company/client/human/createhumanresource"//添加项目相关人员（新建联系人）
#define CA_M_Api_QueryHumanResource @"/company/client/human/queryhumanresource"//查询项目相关人员详情
#define CA_M_Api_UpdateObjectHuman @"/company/client/human/updateobjecthuman"//编辑关联项目
#define CA_M_Api_DeleteObjectHuman @"/company/client/human/deleteobjecthuman"//解除关联项目
#define CA_M_Api_DeleteHumanResource @"/company/client/human/deletehumanresource"//删除人脉
#define CA_M_Api_QueryInvestStageDict @"/company/client/project/queryinveststagedict"//项目投资轮次
#define CA_M_Api_ListCategory @"/company/client/project/listcategory"//公司行业领域
#define CA_M_Api_QueryProcedureStatusDict @"/company/client/project/queryprocedurestatusdict"//项目流程状态(是指处于一个流程中的某个状态)
#define CA_M_Api_QuerySourceDict @"/company/client/project/querysourcedict"//项目来源
#define CA_M_Api_QueryValuationDict @"/company/client/project/queryvaluationdict"//项目估值方式
#define CA_M_Api_ListCurrency @"/company/client/project/listcurrency"//公司币种
#define CA_M_Api_ListArea @"/company/client/project/listarea"//公司地域信息 所在城市
#define CA_M_Api_ListProjectValutionmethod @"/company/client/project/listprojectvalutionmethod"//估值方式
#define CA_M_Api_ListCompanyProcedure @"/company/client/project/listcompanyprocedure"//项目流程
#define CA_M_Api_ListCompanyUser @"/company/client/project/listcompanyuser"//项目流程
#define CA_M_Api_CreateProject @"/company/client/project/createproject"//创建项目
#define CA_M_Api_SearchDataList @"/company/client/project/searchdatalist"//添加项目中的搜索项目
#define CA_M_Api_SearchDataDetail @"/company/client/project/searchdatadetail"//搜索项目中的详情
#define CA_M_Api_UpdateHumanResource @"/company/client/human/updatehumanresource"//编辑人脉基本资料
#define CA_M_Api_ListProjectConditions @"/company/client/project/listprojectconditions"//项目筛选条件列表

#define CA_M_Api_ListTrackHome @"/company/client/project/listtrackhome"//追踪首页
#define CA_M_Api_ListProjectDynamic @"/company/client/project/listprojectdynamic"//项目动态列表
#define CA_M_Api_ListProductDynamic @"/company/client/project/listproductdynamic"//竟品动态列表
#define CA_M_Api_ListInvestorDynamic @"/company/client/project/listinvestordynamic"//投资方动态列表

#define CA_M_Api_ListProjectProduct @"/company/client/project/listprojectproduct"//项目竟品列表

#define CA_M_Api_UpdateProjectRelation @"/company/client/project/updateprojectrelation"//修改项目关联

#pragma mark -------------------- 我的

#define CA_H_Api_CountUserStatistics @"/company/client/personal/countuserstatistics" //我的首页
#define CA_H_Api_UpdateUserInfo @"/company/client/personal/updateuserinfo"//修改个人信息
#define CA_H_Api_UpLoadAvatar @"/company/client/personal/uploadavatar"//上传用户头像
#define CA_M_Api_ListUserReceivedApproval @"/company/client/personal/listuserreceivedapproval"//我收到的审批
#define CA_M_Api_ListUserLaunchedApproval @"/company/client/personal/listuserlaunchedapproval"//我发起的审批
#define CA_M_Api_CreateFeedback @"/company/client/personal/createfeedback"//我的--添加反馈
#define CA_M_Api_QueryApproval @"/company/client/personal/queryapproval"//我的审批详情
#define CA_M_Api_SubmitProcedure @"/company/client/project/submitprocedure"//项目审批
#define CA_M_Api_ChangePassword @"/company/client/personal/changepassword"//修改密码
#define CA_M_Api_About @"/company/client/personal/about"//关于我们
#define CA_M_ListNotify @"/company/client/personal/listnotify"//消息通知列表
#define CA_M_ListObjectNotify @"/company/client/personal/listobjectnotify"//项目消息通知列表


#pragma mark -------------------- 发现

#define CA_M_SearchDataList @"/company/client/find/searchdatalist"//发现数据列表接口
#define CA_M_SearchFundDataDetail @"/company/client/find/searchdatadetail"//发现数据详情接口
#define CA_M_ProjectDetailDataList @"/company/client/find/projectdetaildatalist"//项目详情里面的列表分页接口
#define CA_M_QueryLpContact @"/company/client/find/querylpcontact"//收录出资人（确定查看出资人）
#define CA_M_LpDetailDataList @"/company/client/find/lpdetaildatalist"//出资人详情里面的列表分页接口
#define CA_M_PersonInfoList @"/company/client/find/personinfolist"//个人工商信息分页
#define CA_M_QueryFilterResult @"/company/client/find/queryfilterresult"//发现所有接口的过滤条件接口返回
#define CA_M_ListInvestorRecommend @"/company/client/find/listinvestorrecommend"//出资人-特别推荐

//企业工商
#define CA_H_Api_QueryEnterpriseListedInfo @"/company/client/find/queryenterpriselistedinfo" //上市概况
#define CA_H_Api_QueryEnterpriseFinancialData @"/company/client/find/queryenterprisefinancialdata" //财务数据
#define CA_H_Api_ListRiskInfo @"/company/client/find/listriskinfo" //风险信息
#define CA_H_Api_JudgementDocDetail @"/company/client/find/judgementdocdetail" //民事判决书
#define CA_H_Api_SendCreditReport @"/company/client/find/sendcreditreport" //申请企业报告
#define CA_H_Api_GpDetailDataList @"/company/client/find/gpdetaildatalist"//GP详情里面的列表分页接口

#define CA_H_Api_SendToDownloadCenter @"/company/client/find/sendtodownloadcenter" //下载中心
#define CA_H_Api_DeleteFromDownloadCenter @"/company/client/find/deletefromdownloadcenter" //下载中心删除报告

#define CA_H_Api_ShareDetail @"/company/client/find/sharedetail"



#pragma mark -------------------- 日程

#define CA_H_Api_CreateSchedule @"/company/client/comm/create_schedule"
#define CA_H_Api_UpdateSchedule @"/company/client/comm/update_schedule"
#define CA_H_Api_DeleteSchedule @"/company/client/comm/delete_schedule"
#define CA_H_Api_Schedule @"/company/client/comm/schedule"
#define CA_H_Api_ListSchedule @"/company/client/comm/list_schedule"

#define CA_H_Api_ListMyValidSchedule @"/company/client/comm/list_my_valid_schedule"
#define CA_H_Api_ScheduleFilter @"/company/client/comm/schedule_filter"








#endif /* CA_HApi_h */
