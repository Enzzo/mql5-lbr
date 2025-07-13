//+------------------------------------------------------------------+
//|                                              OrderController.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <Trade\Trade.mqh>
#include <vasilev\model\TradeModel.mqh>
#include <vasilev\view\LbrUI.mqh>

// +-----------------------------------------------------------+
// |  DECLARATION                                              |
// +-----------------------------------------------------------+
// |  OrderController : CObject                                |
// +-----------------------------------------------------------+
class OrderController : public CObject{
public:
   OrderController(TradeModel*, LbrUI*);
   ~OrderController();
   
   bool trade() const;
   ulong getResultDeal() const;
   ulong getResultOrder() const;
   void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam);
   
private:
   bool buy() const;
   bool sell() const;
   bool buyStop() const;
   bool sellStop() const;
   bool buyLimit() const;
   bool sellLimit() const;
   
private:
   CTrade* _trade;
   TradeModel* _model;
   LbrUI* _view;
};

OrderController::OrderController(TradeModel* model, LbrUI* view):
   _trade(new CTrade()),
   _model(model),
   _view(view){}

OrderController::~OrderController(){
   if(CheckPointer(_trade) == POINTER_DYNAMIC){
      delete(_trade);
      _trade = NULL;
   }
}

bool OrderController::trade() const {
   bool result = buy();
   _model.addTicket(getResultOrder());
   return result;
}

bool OrderController::buy() const{
   return _trade.Buy(.01);
}

ulong OrderController::getResultDeal(void) const{
   return _trade.ResultDeal();
}

ulong OrderController::getResultOrder(void) const{
   return _trade.ResultOrder();
}

void OrderController::OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
}