//+------------------------------------------------------------------+
//|                                                        LBREA.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <vasilev\expert\Expert.mqh>
#include <vasilev\model\TradeModel.mqh>
#include <vasilev\view\LbrUI.mqh>
#include <vasilev\view\CommentView.mqh>
#include <vasilev\controller\OrderController.mqh>

#include <vasilev\logger\logger.mqh>

class LBREA : public Expert{
public:
   LBREA(const UIParams&, const CTRLParams&);
   ~LBREA();
   
   int OnInit() override;
   void OnTick() override;
   void OnChartEvent(const int id,
                     const long &lparam,
                     const double &dparam,
                     const string &sparam) override;
   void OnTimer() override;               
   void OnDeinit(const int reason) override;
   
private:
   OrderController* _ctrl;
   TradeModel* _model;
   LbrUI* _view;
   CommentView* _c_view;
};

LBREA::LBREA(const UIParams& uiParams, const CTRLParams& eaParams){
   _model = new TradeModel();
   _view = new LbrUI(_model, uiParams);
   _c_view = new CommentView(_model);
   _ctrl = new OrderController(_model, _view, eaParams);
   
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
   if(CheckPointer(_c_view) == POINTER_DYNAMIC){
      delete _c_view;
      _c_view = NULL;
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

   _ctrl.OnChartEvent(id, lparam, dparam, sparam);
};

void LBREA::OnTimer() override{
   _model.Notify();
};     
          
void LBREA::OnDeinit(const int reason) override{
   DEBUG(__FUNCTION__)
   _view.Destroy(reason);
};