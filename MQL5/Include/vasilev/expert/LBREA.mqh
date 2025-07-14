//+------------------------------------------------------------------+
//|                                                        LBREA.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <controls\dialog.mqh>

#include <vasilev\expert\Expert.mqh>
#include <vasilev\model\TradeModel.mqh>
#include <vasilev\view\LbrUI.mqh>
#include <vasilev\controller\OrderController.mqh>

#include <vasilev\logger\logger.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

class LBREA : public Expert{
public:
   LBREA();
   ~LBREA();
   
   int OnInit() override;
   void OnTick() override;
   void OnChartEvent( const int id,
                              const long &lparam,
                              const double &dparam,
                              const string &sparam) override;
   void OnTimer() override;               
   void OnDeinit(const int reason) override;
   
private:
   OrderController* _ctrl;
};

LBREA::LBREA(void) : _ctrl(new OrderController(NULL, NULL)){
   DEBUG("Entering LBREA constructor")
};

LBREA::~LBREA(){
   DEBUG("LBREA destructor")
   if(CheckPointer(_ctrl) == POINTER_DYNAMIC){
      delete _ctrl;
      _ctrl = NULL;
   }
}
int LBREA::OnInit() override{
   
   return INIT_SUCCEEDED;
};

void LBREA::OnTick() override{
};

void LBREA::OnChartEvent( const int id,
                              const long &lparam,
                              const double &dparam,
                              const string &sparam) override{
   DEBUG(__FUNCTION__ + " " + 
         IntegerToString(id) + " " + 
         IntegerToString(lparam) + " " + 
         DoubleToString(dparam) + " " + 
         sparam)
   
   if(id == CHARTEVENT_KEYDOWN){
      DEBUG("Key down: " + IntegerToString(lparam))
      if(lparam == 'B'){
         DEBUG("BUY")
      }
      if(lparam == 'S'){
         DEBUG("SELL")
      }
   }
};

void LBREA::OnTimer() override{
};     
          
void LBREA::OnDeinit(const int reason) override{
   DEBUG("LBREA " + __FUNCTION__ + " reason: " + IntegerToString(reason))
   if(reason == REASON_REMOVE){
      delete (&this);
   }
};