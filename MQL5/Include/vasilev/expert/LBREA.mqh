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
   // LbrUI* _view;
   TradeModel* _model;
   OrderController* _ctrl;
};

LBREA::LBREA(void) : _model(new TradeModel()), _ctrl(new OrderController(NULL, NULL)){

};

LBREA::~LBREA(){
   
   if(CheckPointer(_model) == POINTER_DYNAMIC){
      delete _model;
      _model = NULL;
   }
   if(CheckPointer(_ctrl) == POINTER_DYNAMIC){
      delete _ctrl;
      _ctrl = NULL;
   }
}
int LBREA::OnInit() override{
   
   return 0;
};

void LBREA::OnTick() override{
};

void LBREA::OnChartEvent( const int id,
                              const long &lparam,
                              const double &dparam,
                              const string &sparam) override{
};

void LBREA::OnTimer() override{
};     
          
void LBREA::OnDeinit(const int reason) override{
   if(reason == REASON_REMOVE){
      delete (&this);
   }
};