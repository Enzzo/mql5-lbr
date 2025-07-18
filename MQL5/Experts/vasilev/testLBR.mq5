//+------------------------------------------------------------------+
//|                                                      testLBR.mq5 |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"
#property version   "1.00"

#include <Controls\Defines.mqh>

#undef CONTROLS_DIALOG_COLOR_BG
#undef CONTROLS_DIALOG_COLOR_CLIENT_BG

#undef CONTROLS_DIALOG_COLOR_BORDER_LIGHT  
#undef CONTROLS_DIALOG_COLOR_BORDER_DARK   
#undef CONTROLS_DIALOG_COLOR_CLIENT_BORDER
#define CONTROLS_DIALOG_COLOR_BORDER_LIGHT  clrBlack
#define CONTROLS_DIALOG_COLOR_BORDER_DARK   clrBlack
#define CONTROLS_DIALOG_COLOR_CLIENT_BORDER clrBlack

#define INFO_LOG
#define DEBUG_LOG
#define WARN_LOG
#define ERROR_LOG
#define FATAL_LOG

input string      TITLE00     = "CUSTOMIZE DEAL";  //-------------------------------->
input int         MAGIC       = 111087;            // magic
input int         SLIPPAGE    = 5;                 // slippage
input double      RISK        = 1.00;              // risk
input double      COMISSION   = 0.0;               // comission
input string      COMMENT     = "";                // order comment

input string      TITLE01     = "CUSTOMIZE CONTROL";//--------------------------------> 
input string      HK_TP       = "T";               // hotkey for TP
input string      HK_SL       = "S";               // hotkey for SL
input string      HK_PR       = "P";               // hotkey for PRICE
input color       L_TP        = clrGreen;          // take profit line color
input color       L_SL        = clrRed;            // stop loss line color
input color       L_PR        = clrOrange;         // price open line color

input string      TITLE02     = "CUSTOMIZE PANEL"; //-------------------------------->
input color       BG_COLOR    = C'87,173,202';     // panel color
input ENUM_BASE_CORNER CORNER = CORNER_RIGHT_LOWER; // base corner
input int         X_OFFSET    = 20;                // X - offset
input int         Y_OFFSET    = 20;                // Y - offset
input int         FONTSIZE    = 7;                 // font size

#define CONTROLS_DIALOG_COLOR_BG             BG_COLOR
#define CONTROLS_DIALOG_COLOR_CLIENT_BG      BG_COLOR

#include <vasilev\expert\LBREA.mqh>
#include <vasilev\view\LbrUI.mqh>
#include <vasilev\logger\logger.mqh>

UIParams uip;

Expert* ea = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   EventSetTimer(1);   
   DEBUG("Entering " + __FUNCTION__)
   
   if(StringLen(HK_TP) != 1 || StringLen(HK_SL) != 1 || StringLen(HK_PR) != 1){
      FATAL("HOTKEY PARAMETER SIZE ERROR!!!")
      FATAL("TERMINATE ADVISOR")
      return INIT_PARAMETERS_INCORRECT;
   }
   
   uip.chart = 0;
   uip.name = "LBR";
   uip.subwin = 0;
   uip.x = X_OFFSET;
   uip.y = Y_OFFSET;
   uip.w = 120;
   uip.h = 208;
   uip.corner = CORNER;
   uip.fontSize = FONTSIZE;
   uip.hkTp = HK_TP[0];
   uip.hkSl = HK_SL[0];
   uip.hkPr = HK_PR[0];
   uip.lTp = L_TP;
   uip.lSl = L_SL;
   uip.lPr = L_PR;
   
   if(ea == NULL){
      DEBUG("Create new LBREA")
      ea = new LBREA(uip);
   }
   return(ea.OnInit());
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   EventKillTimer();
   
   ea.OnDeinit(reason);
   
   DEBUG(__FUNCTION__ + " " + IntegerToString(reason))
   
   if(reason != REASON_CHARTCHANGE){
      DEBUG("delete LBREA")
      delete(ea);
      ea = NULL;
   }
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   ea.OnTick();
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(){
   ea.OnTimer();
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
   ea.OnChartEvent(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+