#ifndef __c2_GeneratedModelTest_h__
#define __c2_GeneratedModelTest_h__

/* Include files */
#include "sf_runtime/sfc_sf.h"
#include "sf_runtime/sfc_mex.h"
#include "rtwtypes.h"
#include "multiword_types.h"

/* Type Definitions */
#ifndef typedef_SFc2_GeneratedModelTestInstanceStruct
#define typedef_SFc2_GeneratedModelTestInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c2_sfEvent;
  boolean_T c2_isStable;
  boolean_T c2_doneDoubleBufferReInit;
  uint8_T c2_is_active_c2_GeneratedModelTest;
  real_T *c2_dq1;
  real_T (*c2_ddq)[2];
  real_T *c2_dq2;
  real_T *c2_q1;
  real_T *c2_q2;
  real_T *c2_tau1;
  real_T *c2_tau2;
} SFc2_GeneratedModelTestInstanceStruct;

#endif                                 /*typedef_SFc2_GeneratedModelTestInstanceStruct*/

/* Named Constants */

/* Variable Declarations */
extern struct SfDebugInstanceStruct *sfGlobalDebugInstanceStruct;

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c2_GeneratedModelTest_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c2_GeneratedModelTest_get_check_sum(mxArray *plhs[]);
extern void c2_GeneratedModelTest_method_dispatcher(SimStruct *S, int_T method,
  void *data);

#endif
