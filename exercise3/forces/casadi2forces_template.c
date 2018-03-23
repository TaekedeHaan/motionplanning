/* 
 * CasADi to FORCES Template - missing information to be filled in by createCasadi.m 
 * (C) embotech AG, Zurich, Switzerland, 2013-18. All rights reserved.
 *
 * This file is part of the FORCES client, and carries the same license.
 */ 

#ifdef __cplusplus
extern "C" {
#endif
    
#include "$SOLVER_NAME$/include/$SOLVER_NAME$.h"    
    
/* prototyes for models */
$EXTERN_FUNCTION$    

/* copies data from sparse matrix into a dense one */
static void sparse2fullcopy(solver_int32_default nrow, solver_int32_default ncol, const solver_int32_default *colidx, const solver_int32_default *row, $SOLVER_NAME$_float *data, $SOLVER_NAME$_float *out)
{
    solver_int32_default i, j;
    
    /* copy data into dense matrix */
    for(i=0; i<ncol; i++)
    {
        for( j=colidx[i]; j < colidx[i+1]; j++ )
        {
            out[i*nrow + row[j]] = data[j];
        }
    }
}

/* CasADi - FORCES interface */
extern void $SOLVER_NAME$_casadi2forces($SOLVER_NAME$_float *x,        /* primal vars                                         */
                                 $SOLVER_NAME$_float *y,        /* eq. constraint multiplers                           */
                                 $SOLVER_NAME$_float *l,        /* ineq. constraint multipliers                        */
                                 $SOLVER_NAME$_float *p,        /* parameters                                          */
                                 $SOLVER_NAME$_float *f,        /* objective function (scalar)                         */
                                 $SOLVER_NAME$_float *nabla_f,  /* gradient of objective function                      */
                                 $SOLVER_NAME$_float *c,        /* dynamics                                            */
                                 $SOLVER_NAME$_float *nabla_c,  /* Jacobian of the dynamics (column major)             */
                                 $SOLVER_NAME$_float *h,        /* inequality constraints                              */
                                 $SOLVER_NAME$_float *nabla_h,  /* Jacobian of inequality constraints (column major)   */
                                 $SOLVER_NAME$_float *hess,     /* Hessian (column major)                              */
                                 solver_int32_default stage                      /* stage number (0 indexed)                            */
                  )
{
    /* CasADi input and output arrays */
    const $SOLVER_NAME$_float *in[4];
    $SOLVER_NAME$_float *out[7];
    
    /* temporary storage for casadi sparse output */
    $SOLVER_NAME$_float this_f;
    $SOLVER_NAME$_float nabla_f_sparse[$nnzGradient$];
    $hdef$
    $hjacdef$
    $cdef$
    $cjacdef$
    $laghessdef$        
    
    /* pointers to row and column info for 
     * column compressed format used by CasADi */
    solver_int32_default nrow, ncol;
    const solver_int32_default *colind, *row;
    
    /* set inputs for CasADi */
    in[0] = x;
    in[1] = p; /* maybe should be made conditional */
    in[2] = l; /* maybe should be made conditional */     
    in[3] = y; /* maybe should be made conditional */
    
    /* set outputs for CasADi */
    out[0] = &this_f;
    out[1] = nabla_f_sparse;
                
$SWITCH_BODY$         
    
    /* add to objective */
    if( f )
    {
        *f += this_f;
    }
}

#ifdef __cplusplus
} /* extern "C" */
#endif