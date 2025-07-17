//+------------------------------------------------------------------+
//|                                              OrderController.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <vasilev\trade\ExtendedTrade.mqh>
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
   
   bool Trade() const;
   ulong GetResultDeal() const;
   ulong GetResultOrder() const;
   void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam);
   
public:
   bool Buy() const;
   bool Sell() const;
   bool BuyStop() const;
   bool SellStop() const;
   bool BuyLimit() const;
   bool SellLimit() const;
   bool CloseAll() const;
   
private:
   ExtendedTrade* _trade;
   TradeModel* _model;
   LbrUI* _view;
};

OrderController::OrderController(TradeModel* model, LbrUI* view):
   _trade(new ExtendedTrade()),
   _model(model),
   _view(view){}

OrderController::~OrderController(){
   if(CheckPointer(_trade) == POINTER_DYNAMIC){
      delete(_trade);
      _trade = NULL;
   }
}

bool OrderController::Trade() const {
   bool result = Buy();
   _model.AddTicket(GetResultOrder());
   return result;
}

bool OrderController::Buy() const{
   bool result = _trade.Buy(.01);
   _model.AddTicket(GetResultOrder());
   return result;
}

bool OrderController::Sell() const{
   bool result = _trade.Sell(.01);
   _model.AddTicket(GetResultOrder());
   return result;
}

bool OrderController::CloseAll(void) const{
   DEBUG(__FUNCTION__)
   bool result = _trade.CloseTrades() && _trade.DeletePendings();
   return result;
}

ulong OrderController::GetResultDeal(void) const{
   return _trade.ResultDeal();
}

ulong OrderController::GetResultOrder(void) const{
   return _trade.ResultOrder();
}

void OrderController::OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
}