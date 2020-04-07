#ifndef TemplateSAN_H_
#define TemplateSAN_H_

#include "params/src/params.h"
#include "Cpp/BaseClasses/EmptyGroup.h"
#include "Cpp/BaseClasses/GlobalVariables.h"
#include "Cpp/BaseClasses/PreselectGroup.h"
#include "Cpp/BaseClasses/PostselectGroup.h"
#include "Cpp/BaseClasses/state/StructStateVariable.h"
#include "Cpp/BaseClasses/state/ArrayStateVariable.h"
#include "Cpp/BaseClasses/SAN/SANModel.h" 
#include "Cpp/BaseClasses/SAN/Place.h"
#include "Cpp/BaseClasses/SAN/ExtendedPlace.h"
extern Double singleFailureRate;
extern UserDistributions* TheDistribution;

void MemoryError();


/*********************************************************************
               TemplateSAN Submodel Definition                   
*********************************************************************/

class TemplateSAN:public SANModel{
public:

class tFailActivity:public Activity {
public:

  Place* canFail;
  short* canFail_Mobius_Mark;
  Place* NF;
  short* NF_Mobius_Mark;

  double* TheDistributionParameters;
  tFailActivity();
  double Rate(){return 0;}
  bool Enabled();
  void LinkVariables();
  double Weight();
  bool ReactivationPredicate();
  bool ReactivationFunction();
  double SampleDistribution();
  double* ReturnDistributionParameters();
  int Rank();
  BaseActionClass* Fire();
}; // tFailActivityActivity

class TFailActivity:public Activity {
public:

  Place* canFail;
  short* canFail_Mobius_Mark;
  Place* NF;
  short* NF_Mobius_Mark;

  double* TheDistributionParameters;
  TFailActivity();
  ~TFailActivity();
  bool Enabled();
  void LinkVariables();
  double Weight();
  bool ReactivationPredicate();
  bool ReactivationFunction();
  double SampleDistribution();
  double* ReturnDistributionParameters();
  int Rank();
  BaseActionClass* Fire();
  double Rate();
}; // TFailActivityActivity

  //List of user-specified place names
  Place* canFail;
  Place* NF;

  // Create instances of all actvities
  tFailActivity tFail;
  TFailActivity TFail;
  //Create instances of all groups 
  PreselectGroup ImmediateGroup;
  PostselectGroup tFailGroup;

  TemplateSAN();
  ~TemplateSAN();
  void CustomInitialization();

  void assignPlacesToActivitiesInst();
  void assignPlacesToActivitiesTimed();
}; // end TemplateSAN

#endif // TemplateSAN_H_
