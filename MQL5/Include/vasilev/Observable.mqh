//+------------------------------------------------------------------+
//|                                                   Observable.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#ifndef OBSERVABLE_MQH
#define OBSERVABLE_MQH

#include <Arrays\ArrayObj.mqh>
#include <vasilev\Observer.mqh>
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
class Observer;

class Observable{
public:
   Observable(){};
   virtual ~Observable(){};
   
   void AddObserver(Observer* observer);
   void Notify() const ;
   
private:
   inline int ObserversTotal() const;
   
private:
   Observer* _observer_pointers[];
};

void Observable::AddObserver(Observer *observer){
   ArrayResize(_observer_pointers, ObserversTotal() +1);
   _observer_pointers[ObserversTotal() - 1] = observer;
}

int Observable::ObserversTotal(void) const {
   return ArraySize(_observer_pointers);
}

void Observable::Notify(void) const {
   for(int i = 0; i < ObserversTotal(); ++i){
      _observer_pointers[i].Update();
   }
}

#endif