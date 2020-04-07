#ifndef __DAREP_DEF_IN_H_INCLUDED__   // if x.h hasn't been included yet...
#define __DAREP_DEF_IN_H_INCLUDED__   //   #define this so the compiler knows it has been included

// namespace for Join-Based Replication of SAN
namespace SANDAREP
{

 
  // namespace for SAN: Template
  namespace Template
  {
   REPS<REP,MAXNREP> rep;

   // dummy objects for each DRSV
   // pointer to dummy object for dependency-related state variable: NF
   DummyDRSV<Place>  DummyDRSV_NF; // define object
   DummyDRSV<Place>* NF=&DummyDRSV_NF; // define pointer to object

} // namespace for SAN: Template

} // namespace for Join-Based Replication of SAN

#endif 
