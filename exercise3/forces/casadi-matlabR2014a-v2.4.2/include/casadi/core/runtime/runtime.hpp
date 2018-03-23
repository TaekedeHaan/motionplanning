/*
 *    This file is part of CasADi.
 *
 *    CasADi -- A symbolic framework for dynamic optimization.
 *    Copyright (C) 2010-2014 Joel Andersson, Joris Gillis, Moritz Diehl,
 *                            K.U. Leuven. All rights reserved.
 *    Copyright (C) 2011-2014 Greg Horn
 *
 *    CasADi is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation; either
 *    version 3 of the License, or (at your option) any later version.
 *
 *    CasADi is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 *
 *    You should have received a copy of the GNU Lesser General Public
 *    License along with CasADi; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */


#ifndef CASADI_CASADI_RUNTIME_HPP
#define CASADI_CASADI_RUNTIME_HPP

#include <math.h>
#define CASADI_PREFIX(ID) casadi_##ID

/// \cond INTERNAL
namespace casadi {
  /// COPY: y <-x
  template<typename real_t>
  void CASADI_PREFIX(copy_n)(const real_t* x, int n, real_t* y);

  /// SWAP: x <-> y
  template<typename real_t>
  void CASADI_PREFIX(swap)(int n, real_t* x, int inc_x, real_t* y, int inc_y);

  /// Sparse copy: y <- x, w work vector (length >= number of rows)
  template<typename real_t>
  void CASADI_PREFIX(project)(const real_t* x, const int* sp_x, real_t* y, const int* sp_y, real_t* w);

  /// SCAL: x <- alpha*x
  template<typename real_t>
  void CASADI_PREFIX(scal)(int n, real_t alpha, real_t* x, int inc_x);

  /// AXPY: y <- a*x + y
  template<typename real_t>
  void CASADI_PREFIX(axpy)(int n, real_t alpha, const real_t* x, int inc_x, real_t* y, int inc_y);

  /// Inner product
  template<typename real_t>
  real_t CASADI_PREFIX(inner_prod)(int n, const real_t* x, const real_t* y);

  /// ASUM: ||x||_1 -> return
  template<typename real_t>
  real_t CASADI_PREFIX(asum)(int n, const real_t* x, int inc_x);

  /// IAMAX: index corresponding to the entry with the largest absolute value
  template<typename real_t>
  int CASADI_PREFIX(iamax)(int n, const real_t* x, int inc_x);

  /// FILL: x <- alpha
  template<typename real_t>
  void CASADI_PREFIX(fill_n)(real_t* x, int n, real_t alpha);

  /// Sparse matrix-matrix multiplication: z <- z + x*y
  template<typename real_t>
  void CASADI_PREFIX(mm_sparse)(const real_t* x, const int* sp_x, const real_t* y, const int* sp_y, real_t* z, const int* sp_z, real_t* w);

  /// Sparse matrix-matrix multiplication, first factor transposed: z <- z + trans(x)*y
  template<typename real_t>
  void CASADI_PREFIX(mm_sparse_t)(const real_t* x, const int* sp_x, const real_t* y, const int* sp_y, real_t* z, const int* sp_z, real_t* w);

  /// Sparse matrix-vector multiplication: z <- z + x*y
  template<typename real_t>
  void CASADI_PREFIX(mv)(const real_t* x, const int* sp_x, const real_t* y, real_t* z);

  /// Sparse matrix-vector multiplication, first factor transposed: z <- z + trans(x)*y
  template<typename real_t>
  void CASADI_PREFIX(mv_t)(const real_t* x, const int* sp_x, const real_t* y, real_t* z);

  /// NRM2: ||x||_2 -> return
  template<typename real_t>
  real_t CASADI_PREFIX(nrm2)(int n, const real_t* x, int inc_x);

  /// TRANS: y <- trans(x)
  template<typename real_t>
  void CASADI_PREFIX(trans)(const real_t* x, const int* sp_x, real_t* y, const int* sp_y, int *tmp);

  /** Inf-norm of a Matrix-matrix product,*
   * \param dwork  A real work vector that you must allocate
   *               Minimum size: y.size1()
   * \param iwork  A integer work vector that you must allocate
   *               Minimum size: y.size1()+x.size2()+1
   */
  template<typename real_t>
  real_t CASADI_PREFIX(norm_inf_mul)(const real_t* x, const int* sp_x, const real_t* y, const int* sp_y,
                             real_t *dwork, int *iwork);

  /// Calculates inner_prod(x, mul(A, x))
  template<typename real_t>
  real_t CASADI_PREFIX(quad_form)(const real_t* A, const int* sp_A, const real_t* x);
}

// Helper functions
namespace casadi {
  /// Check if entry is zero (false negative allowed)
  inline bool iszero(double x) { return x==0;}
}

// Implementations

// Note: due to restrictions of cmake IO processing, make sure that
//      1)   semicolons (;) are never immediately preceded by whitespace
//      2)   line continuation slashes (\) are always immediately preceded by whitespace
#define CASADI_GEMM_NT(M, N, K, A, LDA, B, LDB, C, LDC) \
  for (i=0, rr=C; i<M; ++i) \
    for (j=0; j<N; ++j, ++rr) \
      for (k=0, ss=A+i*LDA, tt=B+j*LDB; k<K; ++k) \
        *rr += *ss++**tt++;


namespace casadi {

  template<typename real_t>
  void CASADI_PREFIX(copy_n)(const real_t* x, int n, real_t* y) {
    int i;
    for (i=0; i<n; ++i) *y++ = *x++;
  }

  template<typename real_t>
  void CASADI_PREFIX(swap)(int n, real_t* x, int inc_x, real_t* y, int inc_y) {
    real_t t;
    int i;
    for (i=0; i<n; ++i) {
      t = *x;
      *x = *y;
      *y = t;
      x += inc_x;
      y += inc_y;
    }
  }

  template<typename real_t>
  void CASADI_PREFIX(project)(const real_t* x, const int* sp_x, real_t* y, const int* sp_y, real_t* w) {
    int ncol_x = sp_x[1];
    const int *colind_x = sp_x+2, *row_x = sp_x + 2 + ncol_x+1;
    int ncol_y = sp_y[1];
    const int *colind_y = sp_y+2, *row_y = sp_y + 2 + ncol_y+1;
    /* Loop over columns of x and y */
    int i, el;
    for (i=0; i<ncol_x; ++i) {
      /* Zero out requested entries in y */
      for (el=colind_y[i]; el<colind_y[i+1]; ++el) w[row_y[el]] = 0;
      /* Set x entries */
      for (el=colind_x[i]; el<colind_x[i+1]; ++el) w[row_x[el]] = x[el];
      /* Retrieve requested entries in y */
      for (el=colind_y[i]; el<colind_y[i+1]; ++el) y[el] = w[row_y[el]];
    }
  }

  template<typename real_t>
  void CASADI_PREFIX(scal)(int n, real_t alpha, real_t* x, int inc_x) {
    int i;
    for (i=0; i<n; ++i) {
      *x *= alpha;
      x += inc_x;
    }
  }

  template<typename real_t>
  void CASADI_PREFIX(axpy)(int n, real_t alpha, const real_t* x, int inc_x, real_t* y, int inc_y) {
    int i;
    for (i=0; i<n; ++i) {
      *y += alpha**x;
      x += inc_x;
      y += inc_y;
    }
  }

  template<typename real_t>
  real_t CASADI_PREFIX(inner_prod)(int n, const real_t* x, const real_t* y) {
    real_t r = 0;
    int i;
    for (i=0; i<n; ++i) r += *x++ * *y++;
    return r;
  }

  template<typename real_t>
  real_t CASADI_PREFIX(asum)(int n, const real_t* x, int inc_x) {
    real_t r = 0;
    int i;
    for (i=0; i<n; ++i) {
      r += fabs(*x);
      x += inc_x;
    }
    return r;
  }

  template<typename real_t>
  int CASADI_PREFIX(iamax)(int n, const real_t* x, int inc_x) {
    real_t t;
    real_t largest_value = -1.0;
    int largest_index = -1;
    int i;
    for (i=0; i<n; ++i) {
      t = fabs(*x);
      x += inc_x;
      if (t>largest_value) {
        largest_value = t;
        largest_index = i;
      }
    }
    return largest_index;
  }

  template<typename real_t>
  void CASADI_PREFIX(fill_n)(real_t* x, int n, real_t alpha) {
    int i;
    for (i=0; i<n; ++i) *x++ = alpha;
  }

  template<typename real_t>
  void CASADI_PREFIX(mm_sparse)(const real_t* x, const int* sp_x, const real_t* y, const int* sp_y, real_t* z, const int* sp_z, real_t* w) {
    /* Get sparsities */
    int ncol_x = sp_x[1];
    const int *colind_x = sp_x+2, *row_x = sp_x + 2 + ncol_x+1;
    int ncol_y = sp_y[1];
    const int *colind_y = sp_y+2, *row_y = sp_y + 2 + ncol_y+1;
    int ncol_z = sp_z[1];
    const int *colind_z = sp_z+2, *row_z = sp_z + 2 + ncol_z+1;

    int cc,kk, kk1;
    /* Loop over the columns of y and z */
    for (cc=0; cc<ncol_y; ++cc) {
      /* Get the dense column of z */
      for (kk=colind_z[cc]; kk<colind_z[cc+1]; ++kk) {
        w[row_z[kk]] = z[kk];
      }
      /* Loop over the nonzeros of y */
      for (kk=colind_y[cc]; kk<colind_y[cc+1]; ++kk) {
        int rr = row_y[kk];
        /* Loop over corresponding columns of x */
        for (kk1=colind_x[rr]; kk1<colind_x[rr+1]; ++kk1) {
          w[row_x[kk1]] += x[kk1]*y[kk];
        }
      }
      /* Get the sparse column of z */
      for (kk=colind_z[cc]; kk<colind_z[cc+1]; ++kk) {
        z[kk] = w[row_z[kk]];
      }
    }
  }

  template<typename real_t>
  void CASADI_PREFIX(mm_sparse_t)(const real_t* x, const int* sp_x, const real_t* y, const int* sp_y, real_t* z, const int* sp_z, real_t* w) {
    /* Get sparsities */
    int ncol_x = sp_x[1];
    const int *colind_x = sp_x+2, *row_x = sp_x + 2 + ncol_x+1;
    int ncol_y = sp_y[1];
    const int *colind_y = sp_y+2, *row_y = sp_y + 2 + ncol_y+1;
    int ncol_z = sp_z[1];
    const int *colind_z = sp_z+2, *row_z = sp_z + 2 + ncol_z+1;

    int cc,kk, kk1;
    /* Loop over the columns of y and z */
    for (cc=0; cc<ncol_z; ++cc) {
      /* Get the dense column of y */
      for (kk=colind_y[cc]; kk<colind_y[cc+1]; ++kk) {
        w[row_y[kk]] = y[kk];
      }
      /* Loop over the nonzeros of z */
      for (kk=colind_z[cc]; kk<colind_z[cc+1]; ++kk) {
        int rr = row_z[kk];
        /* Loop over corresponding columns of x */
        for (kk1=colind_x[rr]; kk1<colind_x[rr+1]; ++kk1) {
          z[kk] += x[kk1] * w[row_x[kk1]];
        }
      }
    }
  }

  template<typename real_t>
  void CASADI_PREFIX(mv)(const real_t* x, const int* sp_x, const real_t* y, real_t* z) {
    /* Get sparsities */
    int ncol_x = sp_x[1];
    const int *colind_x = sp_x+2, *row_x = sp_x + 2 + ncol_x+1;

    int i, el;
    /* loop over the columns of x */
    for (i=0; i<ncol_x; ++i) {
      /* loop over the non-zeros of x */
      for (el=colind_x[i]; el<colind_x[i+1]; ++el) {
        z[row_x[el]] += x[el] * y[i];
      }
    }
  }

  template<typename real_t>
  void CASADI_PREFIX(mv_t)(const real_t* x, const int* sp_x, const real_t* y, real_t* z) {
    /* Get sparsities */
    int ncol_x = sp_x[1];
    const int *colind_x = sp_x+2, *row_x = sp_x + 2 + ncol_x+1;

    int i, el;
    /* loop over the columns of x */
    for (i=0; i<ncol_x; ++i) {
      /* loop over the non-zeros of x */
      for (el=colind_x[i]; el<colind_x[i+1]; ++el) {
        z[i] += x[el] * y[row_x[el]];
      }
    }
  }

  template<typename real_t>
  real_t CASADI_PREFIX(nrm2)(int n, const real_t* x, int inc_x) {
    real_t r = 0;
    int i;
    for (i=0; i<n; ++i) {
      r += *x**x;
      x += inc_x;
    }
    return sqrt(r);
  }

  template<typename real_t>
  void CASADI_PREFIX(trans)(const real_t* x, const int* sp_x, real_t* y, const int* sp_y, int *tmp) {
    int ncol_x = sp_x[1];
    int nnz_x = sp_x[2 + ncol_x];
    const int* row_x = sp_x + 2 + ncol_x+1;
    int ncol_y = sp_y[1];
    const int* colind_y = sp_y+2;
    int k;
    for (k=0; k<ncol_y; ++k) tmp[k] = colind_y[k];
    for (k=0; k<nnz_x; ++k) {
      y[tmp[row_x[k]]++] = x[k];
    }
  }

  template<typename real_t>
  real_t CASADI_PREFIX(norm_inf_mul)(const real_t* x, const int* sp_x, const real_t* y, const int* sp_y, real_t* dwork, int* iwork) {
    real_t res = 0;
    /* Get sparsities */
    int nrow_x = sp_x[0], ncol_x = sp_x[1];
    const int *colind_x = sp_x+2, *row_x = sp_x + 2 + ncol_x+1;
    int ncol_y = sp_y[1];
    const int *colind_y = sp_y+2, *row_y = sp_y + 2 + ncol_y+1;

    /* Implementation borrowed from Scipy's sparsetools/csr.h */
    /* method that uses O(n) temp storage */
    int *mask = iwork + ncol_y+1;

    int i,jj,kk;
    // Pass 1
    for (i=0; i<nrow_x; ++i) mask[i] = -1;
    iwork[0] = 0;
    int nnz = 0;
    for (i=0; i<ncol_y; ++i) {
      int row_nnz = 0;
      for (jj=colind_y[i]; jj < colind_y[i+1]; jj++) {
        int j = row_y[jj];
        for (kk=colind_x[j]; kk < colind_x[j+1]; kk++) {
          int k = row_x[kk];
          if (mask[k] != i) {
            mask[k] = i;
            row_nnz++;
          }
        }
      }
      int next_nnz = nnz + row_nnz;
      nnz = next_nnz;
      iwork[i+1] = nnz;
    }

    // Pass 2
    int *next = iwork + ncol_y+1;
    for (i=0; i<nrow_x; ++i) next[i] = -1;
    real_t* sums = dwork;
    for (i=0; i<nrow_x; ++i) sums[i] = 0;
    nnz = 0;
    iwork[0] = 0;
    for (i=0; i<ncol_y; ++i) {
      int head   = -2;
      int length =  0;
      int jj_start = colind_y[i];
      int jj_end   = colind_y[i+1];
      for (jj=jj_start; jj<jj_end; ++jj) {
        int j = row_y[jj];
        real_t v = y[jj];
        int kk_start = colind_x[j];
        int kk_end   = colind_x[j+1];
        for (kk = kk_start; kk<kk_end; ++kk) {
          int k = row_x[kk];
          sums[k] += v*x[kk];
          if (next[k] == -1) {
            next[k] = head;
            head  = k;
            length++;
          }
        }
      }
      for (jj=0; jj<length; ++jj) {
        if (!iszero(sums[head])) {
          res = fmax(res, fabs(sums[head]));
          nnz++;
        }
        int temp = head;
        head = next[head];
        next[temp] = -1; //clear arrays
        sums[temp] =  0;
      }
      iwork[i+1] = nnz;
    }
    return res;
  }

    /// Calculates inner_prod(x, mul(A, x)) without memory allocation
  template<typename real_t>
  real_t CASADI_PREFIX(quad_form)(const real_t* A, const int* sp_A, const real_t* x) {
    /* Get sparsities */
    int ncol_A = sp_A[1];
    const int *colind_A = sp_A+2, *row_A = sp_A + 2 + ncol_A+1;

    // Return value
    real_t ret=0;

    int cc, el;
    // Loop over the columns of A
    for (cc=0; cc<ncol_A; ++cc) {
      // Loop over the nonzeros of A
      for (el=colind_A[cc]; el<colind_A[cc+1]; ++el) {
        // Get row
        int rr = row_A[el];

        // Add contribution
        ret += x[rr]*A[el]*x[cc];
      }
    }

    return ret;
  }

} // namespace casadi



/// \endcond

#endif // CASADI_CASADI_RUNTIME_HPP
