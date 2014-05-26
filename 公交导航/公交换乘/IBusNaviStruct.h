/*!
	\file       IBusNaviStruct.h
	\brief      定义TBT模块对外提供的接口所含数据结构
	\details    无
*/
#ifndef __AUTONAVI_ITBTSTRUCT_H__
#define __AUTONAVI_ITBTSTRUCT_H__

//--------------------------------------------------------------------------

#if defined(WIN32) || defined(WINCE)
#define IMPORT_C _declspec(dllexport)
#define EXPORT_C _declspec(dllexport)
#else
#define IMPORT_C
#define EXPORT_C
#endif

typedef unsigned char           BYTE;
typedef unsigned short          WORD;
typedef unsigned long           DWORD;

/*!
	\brief      位置变更后，导航信息结构体
*/
typedef struct tag_BusNaviInfo
{
	int m_CurGroupId;       //!< 当前所在Group编号，-1表示没有在规划路线上
	int m_GroupType;        //!< 所在道路的类别，公交，还是步行等
	
	int m_RemainStopNum;    //!< GroupType为公交时有效，表示剩余站数，否则为-1		
	BYTE* m_pCurStopName;   //!< 当前道路名称（或上一站名），UTF8编码方式
	BYTE* m_pNextStopName;  //!< 下条道路名称（或下一站名），UTF8编码方式
	BYTE* m_pLastStopName;  //!< 终点站（下车站）名，UTF8编码方式
	int m_CurNameLen;       //!< 当前道路名称长度
	int m_NextNameLen;      //!< 下条道路名称长度	
	int m_LastNameLen;      //!< 终点站名称长度
	
	int m_CurLinkId;        //!< 当前所在Link编号，从0开始，-1无效
	int m_CurPointId;       //!< 当前所在Group中刚路过的形状点号，从0开始，-1无效
	
	int m_MatchState;       //!< 当前点位是否匹配在路上	0表示未匹配，1表示匹配
	int m_Direction;        //!< 方向（单位度），以正北为基准，顺时针增加
	float m_Longitude;      //!< 经度，匹配状态下在路径上，反之为原始GPS
	float m_Latitude;       //!< 纬度，匹配状态下在路径上，反之为原始GPS

	int m_RouteRemainDist;  //!< 路径剩余距离（单位米）
	int m_RouteRemainTime;  //!< 路径剩余时间（单位秒）
	int m_GroupRemainDist;  //!< 当前Group剩余距离（单位米）
	int m_GroupRemainTime;  //!< 当前Group剩余时间（单位秒）
	
} BusNaviInfo;

/*!
	\brief      换乘线路提醒信息结构体
*/
typedef struct tag_TipInfo
{
	int  m_Distance;  			//!< 旅行距离
	int  m_Time;				//!< 旅行时间
	int  m_DestGroupId;			//!< 换乘的目的Group
	int  m_StationNum;			//!< 总计有多少站
	BYTE* m_pStartStationName;	//!< 上车站名
	BYTE* m_pStartExitName; 	//!< 地铁站入口名
	BYTE* m_pEndStationName;    //!< 下车站名
	BYTE* m_pEndExitName;		//!< 地铁站出口名
	BYTE* m_pLineName;			//!< 线路名	
	int m_StartStationLen;		//!< 上车站名长度
	int m_StartExitLen; 		//!< 地铁站入口名长度
	int m_EndStationLen;    	//!< 下车站名长度
	int m_EndExitLen;			//!< 地铁站出口名长度
	int m_LineLen;				//!< 线路名长度
} TipInfo;

/*!
	\brief      转折点通知信息结构体
*/
typedef struct tag_TurnInfo
{
	int m_GroupId;    			//!< 当前所在Group
	int m_LinkId;     			//!< 进入转折路口的link下标，-1表示位于起点
} TurnInfo;

#endif
