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
   LBREA(const UIParams&);
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
   TradeModel* _model;
   LbrUI* _view;
};

LBREA::LBREA(const UIParams& uiParams){
   _model = new TradeModel();
   _view = new LbrUI(_model, uiParams);
   _ctrl = new OrderController(_model, NULL);
   DEBUG("Entering LBREA constructor")
};

LBREA::~LBREA(){
   DEBUG("LBREA destructor")
   if(CheckPointer(_ctrl) == POINTER_DYNAMIC){
      delete _ctrl;
      _ctrl = NULL;
   }
   if(CheckPointer(_view) == POINTER_DYNAMIC){
      delete _view;
      _view = NULL;
   }
   if(CheckPointer(_model) == POINTER_DYNAMIC){
      delete _model;
      _model = NULL;
   }
}
int LBREA::OnInit() override{
   DEBUG(__FUNCTION__)
   if(!_view.Redraw()){
      FATAL("Error creating dialog window!!!")
      return INIT_FAILED;
   }
   _view.Run();
   return INIT_SUCCEEDED;
};

void LBREA::OnTick() override{
};

void LBREA::OnChartEvent( const int id,
                              const long &lparam,
                              const double &dparam,
                              const string &sparam) override{

   _view.OnChartEvent(id, lparam, dparam, sparam);
   
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
   DEBUG(__FUNCTION__)
   _view.Destroy(reason);
};