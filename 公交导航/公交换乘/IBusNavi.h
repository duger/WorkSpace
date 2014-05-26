/*!
	\mainpage   BusNavi SDK介绍
	\section    Introduce 概述		
	\author  刘书华   shuhua.liu@autonavi.com
*/

/*!
    \file       IBusNavi.h
    \brief      定义BusNavi模块对外提供的接口
    \details    此文件用来定义高德对外提供的BusNavi模块的接口，以及对外依赖的接口，
                BusNavi主要实现功能有导航指引、位置匹配、路径请求与解析、态势播报、
                情报板、动态光柱、道路状态查询
    \warning    使用BusNavi的对象必须继承并实现IFrameForBusNavi接口
*/
#ifndef __AUTONAVI_IBUSNAVI_H__
#define __AUTONAVI_IBUSNAVI_H__

#include "IBusNaviStruct.h"

/*!
    \brief      公交导航使用的外部依赖接口
    \details    SDK通过此接口通知使用者导航信息，或向使用者查询信息，所有接口函数都需要立即返回
*/
class IFrameForBusNavi
{
public:
    /*!
        \brief          HTTP请求
        \details        TBT调用此接口进行HTTP网络请求，此接口为异步接口，函数调用必须立即返回。
                        实现者在外部子线程中完成请求，得到请求结果后调用IBusNavi的ReceiveNetData将请求结果传入SDK，
                        并调用IBusNavi的SetNetRequestState告知请求结果状态：成功、或是超时失败、或是其他状态。
        \param[in]      iModuleID {int}. 请求类型。        
        \param[in]      iConnectID {int}. 连接ID。用于区分不同网络请求
        \param[in]      iType {int}.    0为Post方式，1为Get方式，目前仅支持0
        \param[in]      pstrUrl {char*}. 请求的URL串
        \param[in]      pstrHead {char*}. HTTP头，默认为空，非空时附带额外请求配置信息
        \param[in]      pData {BYTE*}.  Post方式的Data数据，默认为空
        \param[in]      iDataLength {int}. Post方式的Data数据长度，默认为0
        \see            SetNetRequestState , ReceiveNetData
        \return         {void}. 无返回值
    */
    virtual void RequestHTTP(int iModuleID,
							 int iConnectID,
							 int iType,
							 char* pstrUrl,
							 char* pstrHead,
							 BYTE* pData,
							 int iDataLength) = 0;

    /*!
        \brief          通知导航信息更新
        \details        包括当前所在位置信息、匹配的或是未匹配的
        \param[in]      stNaviInfo {BusNaviInfo&}. 导航信息
        \see            BusNaviInfo
        \return         {void}. 无返回值
    */
    virtual void UpdateNaviInfo(BusNaviInfo & stNaviInfo) = 0;
	
    /*!
        \brief          通知显示换乘信息
        \details        
        \param[in]      TipType {int}. 类型
						1  开始导航的起步提醒
						2  从下车点起步的换乘提醒
						3  到达上车点的提醒
						4  快要到站的提醒

        \param[in]      stTipInfo {TipInfo&}. 
        \see            TipInfo
        \return         {void}. 无返回值
    */
    virtual void ShowTip(int TipType, TipInfo& stTipInfo) = 0;
	
    virtual void HideTip() = 0;
	
	virtual void ShowTurning(int Type, TurnInfo& stTurnInfo) = 0;
	
	virtual void HideTurning() = 0;
	
	virtual void ArriveDestination() = 0;
	
	virtual void ArriveTransferStop(int newGroupId) = 0;
	
    /*!
        \brief          通知偏离路径
        \details        当车辆偏离路径后通知Frame，需要重新计算路径
        \return         {void}. 无返回值
    */
    virtual void OffRoute() = 0;

    /*!
        \brief          播报字符串
        \details        使用TTS播报一个字符串，此函数调用后应马上返回。 
                        这是因为外部的TTS线程对该字符串播报时，TBT也需要同时处理数据，继续导航
        \param[in]      iSoundType {int}. 语音类型：1 导航播报，2 前方路况播报，3 整体路况播报
        \param[in]      pwSoundStr {BYTE*}. 要播报的字符串，UTF8编码
        \param[in]      iLength {int}. 字符串长度（单位:字）
        \return         {void}. 无返回值
    */
    virtual void PlayNaviSound(int iSoundType, BYTE* pwSoundStr, int iLength) = 0;
	
    /*!
    * \brief      查询TTS是否正在播报
    * \details    TBT通过使用此接口查询来修正导航播报时机，返回值是否准确会影响到导航播报的质量。
                  若应用层无法获得TTS的状态，返回未知状态
    * \return     {int} 0 表示未知状态或空闲  1 表示正在播报
    * \date       2012/9/28 17:29:32
    */
    virtual int GetPlayState() = 0;
};

/*!
    \brief      TBT接口类
    \details    TBT SDK的所有功能都可通过本类的函数调用实现
    \author     余新彦  xinyan.yu@autonavi.com
*/
class IBusNavi
{
public:
    /*!
        \brief          初始化BusNavi
        \details        在使用BusNavi接口前必须先调用此接口对BusNavi进行初始化，初始化成功后才能使用BusNavi
        \param[in]      pstFrame {IFrameForBusNavi*}. BusNavi依赖的外部接口，BusNavi通过此接口和外部交互
        \param[in]      pstrWorkPath {const char*}. 工作路径，BusNavi的一些配置文件以及输出信息等资料将保存到此路径下
        \see            IFrameForBusNavi
        \return         {int}. 0 初始化失败，1 初始化成功
    */
    virtual int Init(IFrameForBusNavi* pstFrame, const char* pstrWorkPath) = 0;

    /*!
        \brief         销毁BusNavi
        \details       系统退出时调用此接口释放BusNavi资源，在调用此接口后不能再调用BusNavi的其它接口。
        \return        {void}. 无返回值
    */
    virtual void Destroy() = 0;

    /*!
        \brief          获得BusNavi的版本号
        \details        BusNavi每次发布，版本号都会不同，此信息用于问题调查时的版本确定
        \return         {char*}. BusNavi的版本号，例如“BASE_2.5.0_12-10-15_1”
    */
    virtual const char* GetVersion() = 0;

    /*!
        \brief          接收网络数据
        \details        网络请求有数据返回时调用此接口，如没有数据返回，调用SetNetRequestState通知请求失败。
        \param[in]      iModuleID {int}. 模块号，必须和BusNavi请求时传入的模块号一致
        \param[in]      iConnectID {int}. 连接号，必须和BusNavi请求时传入的连接号一致
        \param[in]      pData {BYTE*}. 下载的数据
        \param[in]      iLength {int}. 数据长度
        \return         {void}. 无返回值
    */
    virtual void ReceiveNetData(int iModuleID, int iConnectID, BYTE* pData, int iLength) = 0;

    /*!
        \brief          设置网络请求结果状态
        \details        使用者通过此接口通知BusNavi网络请求结果，无论成败都需调用此接口通知BusNavi，
                        BusNavi在收到此消息后才认为一次HTTP请求结束，应确保每一次HTTP网络请求都有回调本函数。

						请求结果状态有如下可能：
         * *            1   请求成功
         * *            2   请求失败
         * *            3   请求超时
         * *            4   用户手动结束请求

        \param[in]      iModuleID {int}. 模块号，必须和BusNavi请求时传入的模块号一致
        \param[in]      iConnectID {int}. 连接号，必须和BusNavi请求时传入的连接号一致
        \param[in]      iNetState {int}. 请求结果状态。
        \return         {void}. 无返回值
    */
    virtual void SetNetRequestState(int iModuleID, int iConnectID, int iNetState) = 0;

    /*!
        \brief          开始导航
        \details        收到路径计算成功消息后可以通过此接口开始GPS导航，如果当前有多路径在开始导航前必须先调用SelectRoute选择使用那条路GPS导航
        \return         {int}. 0 失败， 1 成功
    */
    virtual int StartNavi() = 0;

    /*!
        \brief          结束导航
        \details        调用该接口后会停止导航并删除BusNavi内的所有路径。
        \return         {void}. 无返回值
    */
    virtual void StopNavi() = 0;

    /*!
        \brief          设置GPS信息
        \details        BusNavi初始化成功后，只要GPS有效就可以调用此接口将GPS设置给BusNavi，
                        直到BusNavi被销毁，不论是否有路径，是否开始导航
        \param[in]      iLocType {int}. 定位类型，0 未知，1gps 2 wifi 3 基站 ...
        \param[in]      iPrecision {int}. 定位精度 单位 米		
		\param[in]      iOffsetFlag {int}. 是否偏转标识，1无偏转，2有偏转
        \param[in]      dLongitude {double}. 经度
        \param[in]      dLatitude {double}. 纬度
        \param[in]      dSpeed {double}. 速度（单位km/h）
        \param[in]      dDirection {double}. 方向，单位度，以正北为基准，顺时针增加
        \param[in]      iYear {int}. 年
        \param[in]      iMonth {int}. 月
        \param[in]      iDay {int}. 日
        \param[in]      iHour {int}. 时
        \param[in]      iMinute {int}. 分
        \param[in]      iSecond {int}. 秒
        \return         {void}. 无返回值
    */
    virtual void SetLocationInfo(int iLocType, 
							int iPrecision,
						    int iOffsetFlag,
							double dLongitude,
							double dLatitude,
							double dSpeed,
							double dDirection,
							int iYear,
							int iMonth,
							int iDay,
							int iHour,
							int iMinute,
							int iSecond) = 0;

    /*!
        \brief          将路径数据Push到BusNavi中						
        \param[in]      pData {BYTE*}. 路径二进制数据
        \param[in]      iLength {int}. 二进制数据大小
        \return         {int}. 0失败，1成功
        \warning        如果正在导航，调用此方法将停止导航，并删除现有路径，只保留新推入的路径
    */
    virtual int PushRouteData(BYTE* pData, int iLength) = 0;
	
	virtual int GetRouteNum() = 0;
	
	virtual int SelectRoute(int iRouteId) = 0;
	
	virtual int GetGroupNum(int iRouteId) = 0;
	
	virtual int GetGroupType(int iRouteId, int iGroupId) = 0;
	
    /*!
        \brief          变更公交线路
		\details        将某方案某段公交路线变更为其他线路	
		\param[in]      iRouteId  被选路径方案
		\param[in]      iGroupId  被选group编号
		\param[in]      iLineId   要更新的线路编号		
        \param[in]      pData {BYTE*}. 路径二进制数据
        \param[in]      iLength {int}. 二进制数据大小
        \return         {int}. 0失败，1成功
        \warning        group必须是公交类型 
    */	
	virtual int ChangeBusLine(int iRouteId, int iGroupId, int iLineId, BYTE* pData, int iLength) = 0;

    /*! 
        \brief      定制参数设置，用以接受客户相关的定制信息
        \details    企业用户需要设置所授权的用户名，密码等信息，方能正常使用BusNavi所用服务
        \param      pstrName {const char*}  参数名称
        \param      pstrVal {const char*}  参数值
        \return     {void} 
    */
    virtual int SetParam(const char* pstrName, const char* pstrVal) = 0;
    ///@}
};

/*!
	\brief      该类用来获得BusNavi对象
	\details    在程序退出前必须调用Release()释放BusNavi对象
*/
class EXPORT_C CBusNaviFactory
{
public:

	/*!
		\brief          获得BusNavi对象指针
		\details        BusNavi对象为全局唯一的
		\return         {IBusNavi*}. IBusNavi接口，NULL
	*/
	static IBusNavi* GetInstance();

	/*!
		\brief          释放BusNavi对象
		\details        销毁全局唯一的BusNavi对象
		\return         {void}. 无返回值
	*/
	static void Release();
};

#endif