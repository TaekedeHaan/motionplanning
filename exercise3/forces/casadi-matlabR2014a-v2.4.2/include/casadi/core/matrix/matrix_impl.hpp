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


#ifndef CASADI_MATRIX_IMPL_HPP
#define CASADI_MATRIX_IMPL_HPP

// The declaration of the class is in a separate file
#include "matrix.hpp"

#include "../casadi_interrupt.hpp"

/// \cond INTERNAL

namespace casadi {
  // Implementations

  template<typename DataType>
  const DataType& Matrix<DataType>::elem(int rr, int cc) const {
    int ind = sparsity().getNZ(rr, cc);
    if (ind==-1)
      return casadi_limits<DataType>::zero;
    else
      return at(ind);
  }

  template<typename DataType>
  int Matrix<DataType>::stream_precision_ = 6;
  template<typename DataType>
  int Matrix<DataType>::stream_width_ = 0;
  template<typename DataType>
  bool Matrix<DataType>::stream_scientific_ = false;

  template<typename DataType>
  DataType& Matrix<DataType>::elem(int rr, int cc) {
    int oldsize = sparsity().nnz();
    int ind = sparsityRef().addNZ(rr, cc);
    if (oldsize != sparsity().nnz())
      data().insert(begin()+ind, DataType(0));
    return at(ind);
  }

  template<typename DataType>
  bool Matrix<DataType>::__nonzero__() const {
    if (numel()!=1) {casadi_error("Only scalar Matrix could have a truth value, but you "
                                  "provided a shape" << dimString());}
    return at(0)!=0;
  }

  template<typename DataType>
  bool Matrix<DataType>::isSlice(bool ind1) const {
    throw CasadiException("\"isSlice\" not defined for instantiation");
    return false;
  }

  template<typename DataType>
  Slice Matrix<DataType>::toSlice(bool ind1) const {
    throw CasadiException("\"toSlice\" not defined for instantiation");
    return Slice();
  }

  template<typename DataType>
  void Matrix<DataType>::get(Matrix<DataType>& m, bool ind1,
                                const Slice& rr, const Slice& cc) const {
    // Both are scalar
    if (rr.isscalar(size1()) && cc.isscalar(size2())) {
      int k = sparsity().getNZ(rr.toScalar(size1()), cc.toScalar(size2()));
      if (k>=0) {
        m = at(k);
      } else {
        m = Matrix<DataType>(1, 1);
      }
      return;
    }

    // Fall back on IMatrix-IMatrix
    get(m, ind1, rr.getAll(size1(), ind1), cc.getAll(size2(), ind1));
  }

  template<typename DataType>
  void Matrix<DataType>::get(Matrix<DataType>& m, bool ind1,
                                const Slice& rr, const Matrix<int>& cc) const {
    // Fall back on IMatrix-IMatrix
    get(m, ind1, rr.getAll(size1(), ind1), cc);
  }

  template<typename DataType>
  void Matrix<DataType>::get(Matrix<DataType>& m, bool ind1,
                                const Matrix<int>& rr, const Slice& cc) const {
    // Fall back on IMatrix-IMatrix
    get(m, ind1, rr, cc.getAll(size2(), ind1));
  }

  template<typename DataType>
  void Matrix<DataType>::get(Matrix<DataType>& m, bool ind1,
                             const Matrix<int>& rr, const Matrix<int>& cc) const {
    // Scalar
    if (rr.isscalar(true) && cc.isscalar(true)) {
      return get(m, ind1, rr.toSlice(ind1), cc.toSlice(ind1));
    }

    // Make sure dense vectors
    casadi_assert_message(rr.isdense() && rr.isvector(),
                          "Marix::get: First index must be a dense vector");
    casadi_assert_message(cc.isdense() && cc.isvector(),
                          "Marix::get: Second index must be a dense vector");

    // Get the sparsity pattern - does bounds checking
    std::vector<int> mapping;
    Sparsity sp = sparsity().sub(rr.data(), cc.data(), mapping, ind1);

    // Copy nonzeros
    m = Matrix<DataType>::zeros(sp);
    for (int k=0; k<mapping.size(); ++k) m.at(k) = at(mapping[k]);
  }

  template<typename DataType>
  void Matrix<DataType>::get(Matrix<DataType>& m, bool ind1, const Slice& rr) const {
    // Scalar
    if (rr.isscalar(numel())) {
      int r = rr.toScalar(numel());
      int k = sparsity().getNZ(r % size1(), r / size1());
      if (k>=0) {
        m = at(k);
      } else {
        m = Matrix<DataType>(1, 1);
      }
      return;
    }

    // Fall back on IMatrix
    get(m, ind1, rr.getAll(numel(), ind1));
  }

  template<typename DataType>
  void Matrix<DataType>::get(Matrix<DataType>& m, bool ind1, const Matrix<int>& rr) const {
    // Scalar
    if (rr.isscalar(true)) {
      return get(m, ind1, rr.toSlice(ind1));
    }

    // If the indexed matrix is dense, use nonzero indexing
    if (isdense()) {
      return getNZ(m, ind1, rr);
    }

    // Get the sparsity pattern - does bounds checking
    std::vector<int> mapping;
    Sparsity sp = sparsity().sub(rr.data(), rr.sparsity(), mapping, ind1);

    // If indexed matrix was a row/column vector, make sure that the result is too
    bool tr = (iscolumn() && rr.isrow()) || (isrow() && rr.iscolumn());

    // Copy nonzeros
    m = Matrix<DataType>::zeros(tr ? sp.T() : sp);
    for (int k=0; k<mapping.size(); ++k) m.at(k) = at(mapping[k]);
  }

  template<typename DataType>
  void Matrix<DataType>::get(Matrix<DataType>& m, bool ind1, const Sparsity& sp) const {
    casadi_assert_message(shape()==sp.shape(),
                          "get(Sparsity sp): shape mismatch. This matrix has shape "
                          << shape() << ", but supplied sparsity index has shape "
                          << sp.shape() << ".");
    m = project(*this, sp);
  }

  template<typename DataType>
  void Matrix<DataType>::set(const Matrix<DataType>& m, bool ind1,
                                const Slice& rr, const Slice& cc) {
    // Both are scalar
    if (rr.isscalar(size1()) && cc.isscalar(size2()) && m.isdense()) {
      elem(rr.toScalar(size1()), cc.toScalar(size2())) = m.toScalar();
      return;
    }

    // Fall back on (IMatrix, IMatrix)
    set(m, ind1, rr.getAll(size1(), ind1), cc.getAll(size2(), ind1));
  }

  template<typename DataType>
  void Matrix<DataType>::set(const Matrix<DataType>& m, bool ind1,
                                const Slice& rr, const Matrix<int>& cc) {
    // Fall back on (IMatrix, IMatrix)
    set(m, ind1, rr.getAll(size1(), ind1), cc);
  }

  template<typename DataType>
  void Matrix<DataType>::set(const Matrix<DataType>& m, bool ind1,
                                const Matrix<int>& rr, const Slice& cc) {
    // Fall back on (IMatrix, IMatrix)
    set(m, ind1, rr, cc.getAll(size2(), ind1));
  }

  template<typename DataType>
  void Matrix<DataType>::set(const Matrix<DataType>& m, bool ind1,
                                const Matrix<int>& rr, const Matrix<int>& cc) {
    // Scalar
    if (rr.isscalar(true) && cc.isscalar(true) && m.isdense()) {
      return set(m, ind1, rr.toSlice(ind1), cc.toSlice(ind1));
    }

    // Row vector rr (e.g. in MATLAB) is transposed to column vector
    if (rr.size1()==1 && rr.size2()>1) {
      return set(m, ind1, rr.T(), cc);
    }

    // Row vector cc (e.g. in MATLAB) is transposed to column vector
    if (cc.size1()==1 && cc.size2()>1) {
      return set(m, ind1, rr, cc.T());
    }

    // Make sure rr and cc are dense vectors
    casadi_assert_message(rr.isdense() && rr.iscolumn(),
                          "Matrix::set: First index not dense vector");
    casadi_assert_message(cc.isdense() && cc.iscolumn(),
                          "Matrix::set: Second index not dense vector");

    // Assert dimensions of assigning matrix
    if (rr.size1() != m.size1() || cc.size1() != m.size2()) {
      if (m.isscalar()) {
        // m scalar means "set all"
        return set(repmat(m, rr.size1(), cc.size1()), ind1, rr, cc);
      } else if (rr.size1() == m.size2() && cc.size1() == m.size1()
                 && std::min(m.size1(), m.size2()) == 1) {
        // m is transposed if necessary
        return set(m.T(), ind1, rr, cc);
      } else {
        // Error otherwise
        casadi_error("Dimension mismatch." << "lhs is " << rr.size1() << "-by-"
                     << cc.size1() << ", while rhs is " << m.shape());
      }
    }

    // Dimensions
    int sz1 = size1(), sz2 = size2();

    // Report out-of-bounds
    if (!inBounds(rr.data(), -sz1+ind1, sz1+ind1)) {
      casadi_error("set[., r, c] out of bounds. Your rr contains "
                   << *std::min_element(rr.begin(), rr.end()) << " up to "
                   << *std::max_element(rr.begin(), rr.end())
                   << ", which is outside the range [" << -sz1+ind1 << ","<< sz1+ind1 <<  ").");
    }
    if (!inBounds(cc.data(), -sz2+ind1, sz2+ind1)) {
      casadi_error("set [., r, c] out of bounds. Your cc contains "
                   << *std::min_element(cc.begin(), cc.end()) << " up to "
                   << *std::max_element(cc.begin(), cc.end())
                   << ", which is outside the range [" << -sz2+ind1 << ","<< sz2+ind1 <<  ").");
    }

    // If we are assigning with something sparse, first remove existing entries
    if (!m.isdense()) {
      erase(rr.data(), cc.data(), ind1);
    }

    // Collect all assignments
    IMatrix el = IMatrix::zeros(m.sparsity());
    for (int j=0; j<el.size2(); ++j) { // Loop over columns of m
      int this_j = cc.at(j) - ind1; // Corresponding column in this
      if (this_j<0) this_j += sz2;
      for (int k=el.colind(j); k<el.colind(j+1); ++k) { // Loop over rows of m
        int i = m.row(k);
        int this_i = rr.at(i) - ind1; // Corresponding row in this
        if (this_i<0) this_i += sz1;
        el.at(k) = this_i + this_j*sz1;
      }
    }
    return set(m, false, el);
  }

  template<typename DataType>
  void Matrix<DataType>::set(const Matrix<DataType>& m, bool ind1, const Slice& rr) {
    // Scalar
    if (rr.isscalar(numel()) && m.isdense()) {
      int r = rr.toScalar(numel());
      elem(r % size1(), r / size1()) = m.toScalar();
      return;
    }

    // Fall back on IMatrix
    set(m, ind1, rr.getAll(numel(), ind1));
  }

  template<typename DataType>
  void Matrix<DataType>::set(const Matrix<DataType>& m, bool ind1, const Matrix<int>& rr) {
    // Scalar
    if (rr.isscalar(true) && m.isdense()) {
      return set(m, ind1, rr.toSlice(ind1));
    }

    // Assert dimensions of assigning matrix
    if (rr.sparsity() != m.sparsity()) {
      if (rr.shape() == m.shape()) {
        // Remove submatrix to be replaced
        erase(rr.data(), ind1);

        // Find the intersection between rr's and m's sparsity patterns
        Sparsity sp = rr.sparsity() * m.sparsity();

        // Project both matrices to this sparsity
        return set(project(m, sp), ind1, project(rr, sp));
      } else if (m.isscalar()) {
        // m scalar means "set all"
        if (m.isdense()) {
          return set(Matrix<DataType>(rr.sparsity(), m), ind1, rr);
        } else {
          return set(Matrix<DataType>(rr.shape()), ind1, rr);
        }
      } else if (rr.size1() == m.size2() && rr.size2() == m.size1()
                 && std::min(m.size1(), m.size2()) == 1) {
        // m is transposed if necessary
        return set(m.T(), ind1, rr);
      } else {
        // Error otherwise
        casadi_error("Dimension mismatch." << "lhs is " << rr.shape()
                     << ", while rhs is " << m.shape());
      }
    }

    // Dimensions of this
    int sz1 = size1(), sz2 = size2(), sz = nnz(), nel = numel(), rrsz = rr.nnz();

    // Quick return if nothing to set
    if (rrsz==0) return;

    // Check bounds
    if (!inBounds(rr.data(), -nel+ind1, nel+ind1)) {
      casadi_error("set[rr] out of bounds. Your rr contains "
                   << *std::min_element(rr.begin(), rr.end()) << " up to "
                   << *std::max_element(rr.begin(), rr.end())
                   << ", which is outside the range [" << -nel+ind1 << ","<< nel+ind1 <<  ").");
    }

    // Dense mode
    if (isdense() && m.isdense()) {
      return setNZ(m, ind1, rr);
    }

    // Construct new sparsity pattern
    std::vector<int> new_row=sparsity().getRow(), new_col=sparsity().getCol(), nz(rr.data());
    new_row.reserve(sz+rrsz);
    new_col.reserve(sz+rrsz);
    nz.reserve(rrsz);
    for (std::vector<int>::iterator i=nz.begin(); i!=nz.end(); ++i) {
      if (ind1) (*i)--;
      if (*i<0) *i += nel;
      new_row.push_back(*i % sz1);
      new_col.push_back(*i / sz1);
    }
    Sparsity sp = Sparsity::triplet(sz1, sz2, new_row, new_col);

    // If needed, update pattern
    if (sp != sparsity()) *this = project(*this, sp);

    // Find the nonzeros corresponding to rr
    sparsity().getNZ(nz);

    // Carry out the assignments
    for (int i=0; i<nz.size(); ++i) {
      at(nz[i]) = m.at(i);
    }
  }

  template<typename DataType>
  void Matrix<DataType>::set(const Matrix<DataType>& m, bool ind1, const Sparsity& sp) {
    casadi_assert_message(shape()==sp.shape(),
                          "set(Sparsity sp): shape mismatch. This matrix has shape "
                          << shape() << ", but supplied sparsity index has shape "
                          << sp.shape() << ".");
    std::vector<int> ii = sp.find();
    if (m.isscalar()) {
      (*this)(ii) = densify(m);
    } else {
      (*this)(ii) = densify(m(ii));
    }
  }

  template<typename DataType>
  void Matrix<DataType>::getNZ(Matrix<DataType>& m, bool ind1, const Slice& kk) const {
    // Scalar
    if (kk.isscalar(nnz())) {
      m = at(kk.toScalar(nnz()));
      return;
    }

    // Fall back on IMatrix
    getNZ(m, ind1, kk.getAll(nnz(), ind1));
  }

  template<typename DataType>
  void Matrix<DataType>::getNZ(Matrix<DataType>& m, bool ind1, const Matrix<int>& kk) const {
    // Scalar
    if (kk.isscalar(true)) {
      return getNZ(m, ind1, kk.toSlice(ind1));
    }

    // Get nonzeros of kk
    const std::vector<int>& k = kk.data();
    int sz = nnz();

    // Check bounds
    if (!inBounds(k, -sz+ind1, sz+ind1)) {
      casadi_error("getNZ[kk] out of bounds. Your kk contains "
                   << *std::min_element(k.begin(), k.end()) << " up to "
                   << *std::max_element(k.begin(), k.end())
                   << ", which is outside the range [" << -sz+ind1 << ","<< sz+ind1 <<  ").");
    }

    // If indexed matrix was a row/column vector, make sure that the result is too
    bool tr = (iscolumn() && kk.isrow()) || (isrow() && kk.iscolumn());

    // Copy nonzeros
    m = zeros(tr ? kk.sparsity().T() : kk.sparsity());
    for (int el=0; el<k.size(); ++el) {
      casadi_assert_message(!(ind1 && k[el]<=0), "Matlab is 1-based, but requested index " <<
                                                k[el] <<  ". Note that negative slices are" <<
                                                " disabled in the Matlab interface. " <<
                                                "Possibly you may want to use 'end'.");
      int k_el = k[el]-ind1;
      m.at(el) = at(k_el>=0 ? k_el : k_el+sz);
    }
  }

  template<typename DataType>
  void Matrix<DataType>::setNZ(const Matrix<DataType>& m, bool ind1, const Slice& kk) {
    // Scalar
    if (kk.isscalar(nnz())) {
      at(kk.toScalar(nnz())) = m.toScalar();
      return;
    }

    // Fallback on IMatrix
    setNZ(m, ind1, kk.getAll(nnz(), ind1));
  }

  template<typename DataType>
  void Matrix<DataType>::setNZ(const Matrix<DataType>& m, bool ind1, const Matrix<int>& kk) {
    // Scalar
    if (kk.isscalar(true)) {
      return setNZ(m, ind1, kk.toSlice(ind1));
    }

    // Assert dimensions of assigning matrix
    if (kk.sparsity() != m.sparsity()) {
      if (m.isscalar()) {
        // m scalar means "set all"
        if (!m.isdense()) return; // Nothing to set
        return setNZ(Matrix<DataType>(kk.sparsity(), m), ind1, kk);
      } else if (kk.shape() == m.shape()) {
        // Project sparsity if needed
        return setNZ(project(m, kk.sparsity()), ind1, kk);
      } else if (kk.size1() == m.size2() && kk.size2() == m.size1()
                 && std::min(m.size1(), m.size2()) == 1) {
        // m is transposed if necessary
        return setNZ(m.T(), ind1, kk);
      } else {
        // Error otherwise
        casadi_error("Dimension mismatch." << "lhs is " << kk.shape()
                     << ", while rhs is " << m.shape());
      }
    }

    // Get nonzeros
    const std::vector<int>& k = kk.data();
    int sz = nnz();

    // Check bounds
    if (!inBounds(k, -sz+ind1, sz+ind1)) {
      casadi_error("setNZ[kk] out of bounds. Your kk contains "
                   << *std::min_element(k.begin(), k.end()) << " up to "
                   << *std::max_element(k.begin(), k.end())
                   << ", which is outside the range [" << -sz+ind1 << ","<< sz+ind1 <<  ").");
    }

    // Set nonzeros, ignoring negative indices
    for (int el=0; el<k.size(); ++el) {
      casadi_assert_message(!(ind1 && k[el]<=0), "Matlab is 1-based, but requested index " <<
                                                k[el] <<  ". Note that negative slices are" <<
                                                " disabled in the Matlab interface. " <<
                                                "Possibly you may want to use 'end'.");
      int k_el = k[el]-ind1;
      at(k_el>=0 ? k_el : k_el+sz) = m.at(el);
    }
  }

  template<typename DataType>
  void Matrix<DataType>::makeDense(const DataType& val) {
    // Quick return if possible
    if (isdense()) return;

    // Get sparsity pattern
    int nrow = size1();
    int ncol = size2();
    const int* colind = this->colind();
    const int* row = this->row();

    // Resize data and copy
    data_.resize(nrow*ncol, val);

    // Loop over the columns in reverse order
    for (int cc=ncol-1; cc>=0; --cc) {
      // Loop over nonzero elements of the column in reverse order
      for (int el=colind[cc+1]-1; el>=colind[cc]; --el) {
        int rr = row[el];
        int new_el = cc*nrow + rr;
        if (el==new_el) break; // Already done, the rest of the elements must be in the same place
        std::swap(data_[new_el], data_[el]);
      }
    }

    // Update the sparsity pattern
    sparsity_ = Sparsity::dense(shape());
  }

  template<typename DataType>
  void Matrix<DataType>::makeSparse(double tol) {
    // Quick return if there are no entries to be removed
    bool remove_nothing = true;
    for (typename std::vector<DataType>::iterator it=begin(); it!=end() && remove_nothing; ++it) {
      remove_nothing = !casadi_limits<DataType>::isAlmostZero(*it, tol);
    }
    if (remove_nothing) return;

    // Get the current sparsity pattern
    int size1 = this->size1();
    int size2 = this->size2();
    const int* colind = this->colind();
    const int* row = this->row();

    // Construct the new sparsity pattern
    std::vector<int> new_colind(1, 0), new_row;

    // Loop over the columns
    for (int cc=0; cc<size2; ++cc) {
      // Loop over existing nonzeros
      for (int el=colind[cc]; el<colind[cc+1]; ++el) {
        // If it is not known to be a zero
        if (!casadi_limits<DataType>::isAlmostZero(data_[el], tol)) {
          // Save the nonzero in its new location
          data_[new_row.size()] = data_[el];

          // Add to pattern
          new_row.push_back(row[el]);
        }
      }
      // Save the new column offset
      new_colind.push_back(new_row.size());
    }

    // Trim the data vector
    data_.resize(new_row.size());

    // Update the sparsity pattern
    sparsity_ = Sparsity(size1, size2, new_colind, new_row);
  }

  template<typename DataType>
  Matrix<DataType>::Matrix() : sparsity_(Sparsity(0, 0)) {
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(const Matrix<DataType>& m) : sparsity_(m.sparsity_), data_(m.data_) {
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(const std::vector<DataType>& x) :
      sparsity_(Sparsity::dense(x.size(), 1)), data_(x) {
  }

  template<typename DataType>
  Matrix<DataType>& Matrix<DataType>::operator=(const Matrix<DataType>& m) {
    sparsity_ = m.sparsity_;
    data_ = m.data_;
    return *this;
  }

  template<typename DataType>
  std::string Matrix<DataType>::className() { return matrixName<DataType>(); }

  template<typename DataType>
  void Matrix<DataType>::printScalar(std::ostream &stream, bool trailing_newline) const {
    casadi_assert_message(numel()==1, "Not a scalar");

    std::streamsize precision = stream.precision();
    std::streamsize width = stream.width();
    std::ios_base::fmtflags flags = stream.flags();

    stream.precision(stream_precision_);
    stream.width(stream_width_);
    if (stream_scientific_) {
      stream.setf(std::ios::scientific);
    } else {
      stream.unsetf(std::ios::scientific);
    }

    if (nnz()==0) {
      stream << "00";
    } else {
      stream << toScalar();
    }

    if (trailing_newline) stream << std::endl;
    stream << std::flush;
    stream.precision(precision);
    stream.width(width);
    stream.flags(flags);
  }

  template<typename DataType>
  void Matrix<DataType>::printVector(std::ostream &stream, bool trailing_newline) const {
    casadi_assert_message(iscolumn(), "Not a vector");

    // Get components
    std::vector<std::string> nz, inter;
    printSplit(nz, inter);

    // Print intermediate expressions
    for (int i=0; i<inter.size(); ++i)
      stream << "@" << (i+1) << "=" << inter[i] << ", ";
    inter.clear();

    // Access data structures
    const int* r = row();
    int sz = nnz();

    // Nonzero
    int el=0;

    // Loop over rows
    stream << "[";
    for (int rr=0; rr<size1(); ++rr) {
      // Add delimiter
      if (rr!=0) stream << ", ";

      // Check if nonzero
      if (el<sz && rr==r[el]) {
        stream << nz.at(el++);
      } else {
        stream << "00";
      }
    }
    stream << "]";

    if (trailing_newline) stream << std::endl;
    stream << std::flush;
  }

  template<typename DataType>
  void Matrix<DataType>::printDense(std::ostream &stream, bool trailing_newline) const {
    // Print as a single line
    bool oneliner=this->size1()<=1;

    // Get components
    std::vector<std::string> nz, inter;
    printSplit(nz, inter);

    // Print intermediate expressions
    for (int i=0; i<inter.size(); ++i)
      stream << "@" << (i+1) << "=" << inter[i] << ", ";
    inter.clear();

    // Index counter for each column
    const int* cptr = this->colind();
    int ncol = size2();
    std::vector<int> cind(cptr, cptr+ncol+1);

    // Loop over rows
    for (int rr=0; rr<size1(); ++rr) {
      // Beginning of row
      if (rr==0) {
        if (!oneliner) stream << std::endl;
        stream << "[[";
      } else {
        stream << " [";
      }

      // Loop over columns
      for (int cc=0; cc<ncol; ++cc) {
        // Separating comma
        if (cc>0) stream << ", ";

        // Check if nonzero
        if (cind[cc]<colind(cc+1) && row(cind[cc])==rr) {
          stream << nz.at(cind[cc]++);
        } else {
          stream << "00";
        }
      }

      // End of row
      if (rr<size1()-1) {
        stream << "], ";
        if (!oneliner) stream << std::endl;
      } else {
        stream << "]]";
      }
    }

    if (trailing_newline) stream << std::endl;
    stream << std::flush;
  }

  template<typename DataType>
  void Matrix<DataType>::printSparse(std::ostream &stream, bool trailing_newline) const {
    if (nnz()==0) {
      stream << "all zero sparse: " << size1() << "-by-" << size2();
    } else {
      // Print header
      stream << "sparse: " << size1() << "-by-" << size2() << ", " << nnz() << " nnz";

      // Get components
      std::vector<std::string> nz, inter;
      printSplit(nz, inter);

      // Print intermediate expressions
      for (int i=0; i<inter.size(); ++i)
        stream << std::endl << " @" << (i+1) << "=" << inter[i] << ",";
      inter.clear();

      // Print nonzeros
      for (int cc=0; cc<size2(); ++cc) {
        for (int el=colind(cc); el<colind(cc+1); ++el) {
          int rr=row(el);
          stream << std::endl << " (" << rr << ", " << cc << ") -> " << nz.at(el);
          InterruptHandler::check();
        }
      }
    }
    if (trailing_newline) stream << std::endl;
    stream << std::flush;
  }

  template<typename DataType>
  void Matrix<DataType>::printSplit(std::vector<std::string>& nz,
                                    std::vector<std::string>& inter) const {
    nz.resize(nnz());
    inter.resize(0);

    // Temporary
    std::stringstream ss;
    ss.precision(stream_precision_);
    ss.width(stream_width_);
    if (stream_scientific_) {
      ss.setf(std::ios::scientific);
    } else {
      ss.unsetf(std::ios::scientific);
    }

    // Print nonzeros
    for (int i=0; i<nz.size(); ++i) {
      ss.str(std::string());
      ss << data().at(i);
      nz[i] = ss.str();
    }
  }

  template<typename DataType>
  void Matrix<DataType>::print(std::ostream &stream, bool trailing_newline) const {
    if (isempty()) {
      stream << "[]";
    } else if (numel()==1) {
      printScalar(stream, false);
    } else if (iscolumn()) {
      printVector(stream, false);
    } else if (std::max(size1(), size2())<=10 || static_cast<double>(nnz())/numel()>=0.5) {
      // if "small" or "dense"
      printDense(stream, false);
    } else {
      printSparse(stream, false);
    }
    if (trailing_newline) stream << std::endl;
  }

  template<typename DataType>
  void Matrix<DataType>::repr(std::ostream &stream, bool trailing_newline) const {
    stream << className() << "(";
    print(stream, false);
    stream << ")";
    if (trailing_newline) stream << std::endl;
    stream << std::flush;
  }

  template<typename DataType>
  void Matrix<DataType>::reserve(int nnz) {
    reserve(nnz, size2());
  }

  template<typename DataType>
  void Matrix<DataType>::reserve(int nnz, int ncol) {
    data().reserve(nnz);
  }

  template<typename DataType>
  void Matrix<DataType>::resize(int nrow, int ncol) {
    sparsity_.resize(nrow, ncol);
  }

  template<typename DataType>
  void Matrix<DataType>::clear() {
    sparsity_ = Sparsity(0, 0);
    data().clear();
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(double val) :
      sparsity_(Sparsity::dense(1, 1)), data_(std::vector<DataType>(1, val)) {
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(const std::vector< std::vector<double> >& d) {
    // Get dimensions
    int nrow=d.size();
    int ncol=d.empty() ? 1 : d.front().size();

    // Assert consistency
    for (int rr=0; rr<nrow; ++rr) {
      casadi_assert_message(ncol==d[rr].size(),
        "Matrix<DataType>::Matrix(const std::vector< std::vector<DataType> >& d): "
        "shape mismatch" << std::endl
        << "Attempting to construct a matrix from a nested list." << std::endl
        << "I got convinced that the desired size is ("<< nrow << " x " << ncol
        << " ), but now I encounter a vector of size ("
        << d[rr].size() <<  " )" << std::endl);
    }

    // Form matrix
    sparsity_ = Sparsity::dense(nrow, ncol);
    data().resize(nrow*ncol);
    typename std::vector<DataType>::iterator it=begin();
    for (int cc=0; cc<ncol; ++cc) {
      for (int rr=0; rr<nrow; ++rr) {
        *it++ = d[rr][cc];
      }
    }
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(const Sparsity& sp) : sparsity_(sp), data_(sp.nnz(), 1) {
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(int nrow, int ncol) : sparsity_(nrow, ncol) {
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(const std::pair<int, int>& rc) : sparsity_(rc) {
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(const Sparsity& sp, const DataType& val, bool dummy) :
      sparsity_(sp), data_(sp.nnz(), val) {
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(const Sparsity& sp, const std::vector<DataType>& d, bool dummy) :
      sparsity_(sp), data_(d) {
    casadi_assert_message(sp.nnz()==d.size(), "Size mismatch." << std::endl
                          << "You supplied a sparsity of " << sp.dimString()
                          << ", but the supplied vector is of length " << d.size());
  }

  template<typename DataType>
  Matrix<DataType>::Matrix(const Sparsity& sp, const Matrix<DataType>& d) {
    if (d.isscalar()) {
      *this = Matrix<DataType>(sp, d.toScalar(), false);
    } else if (d.iscolumn() || d.size1()==1) {
      casadi_assert(sp.nnz()==d.numel());
      if (d.isdense()) {
        *this = Matrix<DataType>(sp, d.data(), false);
      } else {
        *this = Matrix<DataType>(sp, densify(d).data(), false);
      }
    } else {
      casadi_error("Matrix(Sparsisty, Matrix): Only allowed for scalars and vectors");
    }
  }

  template<typename DataType>
  void Matrix<DataType>::setZero() {
    setAll(0);
  }

  template<typename DataType>
  void Matrix<DataType>::setAll(const DataType& val) {
    std::fill(begin(), end(), val);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::unary(int op, const Matrix<DataType> &x) {
    // Return value
    Matrix<DataType> ret = Matrix<DataType>::zeros(x.sparsity());

    // Nonzeros
    std::vector<DataType>& ret_data = ret.data();
    const std::vector<DataType>& x_data = x.data();

    // Do the operation on all non-zero elements
    for (int el=0; el<x.nnz(); ++el) {
      casadi_math<DataType>::fun(op, x_data[el], x_data[el], ret_data[el]);
    }

    // Check the value of the structural zero-entries, if there are any
    if (!x.isdense() && !operation_checker<F0XChecker>(op)) {
      // Get the value for the structural zeros
      DataType fcn_0;
      casadi_math<DataType>::fun(op, 0, 0, fcn_0);
      if (!casadi_limits<DataType>::isZero(fcn_0)) { // Remove this if?
        ret.makeDense(fcn_0);
      }
    }

    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::operator-() const {
    return unary(OP_NEG, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::operator+() const {
    return *this;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_plus(const Matrix<DataType> &y) const {
    return binary(OP_ADD, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_minus(const Matrix<DataType> &y) const {
    return binary(OP_SUB, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_times(const Matrix<DataType> &y) const {
    return binary(OP_MUL, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_rdivide(const Matrix<DataType> &y) const {
    return binary(OP_DIV, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_lt(const Matrix<DataType> &y) const {
    return binary(OP_LT, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_le(const Matrix<DataType> &y) const {
    return binary(OP_LE, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_eq(const Matrix<DataType> &y) const {
    return binary(OP_EQ, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_ne(const Matrix<DataType> &y) const {
    return binary(OP_NE, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_mrdivide(const Matrix<DataType>& b) const {
    casadi_assert_message(isscalar() || b.isscalar(), "Not implemented");
    return *this/b;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_mldivide(const Matrix<DataType>& b) const {
    casadi_assert_message(isscalar() || b.isscalar(), "Not implemented");
    return b/ *this;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_mpower(const Matrix<DataType>& b) const {
    casadi_assert_message(isscalar() || b.isscalar(), "Not implemented");
    return pow(*this, b);
  }

  template<typename DataType>
  Sparsity& Matrix<DataType>::sparsityRef() {
    sparsity_.makeUnique(); // NOTE: Remove?
    return sparsity_;
  }

  template<typename DataType>
  void Matrix<DataType>::getBand(int kl, int ku, int ldres, DataType *res) const {
    // delete the content of the matrix
    for (int j=0; j<size1(); ++j) // loop over rows
      for (int s=0; s<kl+ku+1; ++s) // loop over the subdiagonals
        res[s + ldres*j] = 0;

    // loop over cols
    for (int i=0; i<size2(); ++i) {

      // loop over the non-zero elements
      for (int el=colind(i); el<colind(i+1); ++el) {
        int j=row(el);  // row

        // Check if we have not yet inside the band
        if (j<i-kl) continue;

        // Check if we are already outside the band
        if (j>i+ku) break;

        // Get the subdiagonal
        int s = i - j + ku;

        // Store the element
        res[s + ldres*j] = data()[el];
      }
    }
  }

  template<typename DataType>
  void Matrix<DataType>::set(const Matrix<DataType>& val) {
    sparsity().set(getPtr(data()), getPtr(val.data()), val.sparsity());
  }

  template<typename DataType>
  void Matrix<DataType>::setBV(const Matrix<DataType>& val) {
    bvec_t* bw_this = reinterpret_cast<bvec_t*>(getPtr(data()));
    const bvec_t* bw_val = reinterpret_cast<const bvec_t*>(getPtr(val.data()));
    sparsity().set(bw_this, bw_val, val.sparsity());
  }

  template<typename DataType>
  void Matrix<DataType>::setZeroBV() {
    bvec_t* bw_this = reinterpret_cast<bvec_t*>(getPtr(data()));
    std::fill(bw_this, bw_this+nnz(), bvec_t(0));
  }

  template<typename DataType>
  void Matrix<DataType>::borBV(const Matrix<DataType>& val) {
    bvec_t* bw_this = reinterpret_cast<bvec_t*>(getPtr(data()));
    const bvec_t* bw_val = reinterpret_cast<const bvec_t*>(getPtr(val.data()));
    sparsity().bor(bw_this, bw_val, val.sparsity());
  }

  template<typename DataType>
  void Matrix<DataType>::getArrayBV(bvec_t* val, int len) const {
    casadi_assert(len==nnz());
    const bvec_t* bw_this = reinterpret_cast<const bvec_t*>(getPtr(data()));
    std::copy(bw_this, bw_this+len, val);
  }

  template<typename DataType>
  void Matrix<DataType>::setArrayBV(const bvec_t* val, int len) {
    casadi_assert(len==nnz());
    bvec_t* bw_this = reinterpret_cast<bvec_t*>(getPtr(data()));
    std::copy(val, val+len, bw_this);
  }

  template<typename DataType>
  void Matrix<DataType>::borArrayBV(const bvec_t* val, int len) {
    casadi_assert(len==nnz());
    bvec_t* bw_this = reinterpret_cast<bvec_t*>(getPtr(data()));
    for (int i=0; i<len; ++i) *bw_this++ |= *val++;
  }

  template<typename DataType>
  void Matrix<DataType>::get(Matrix<DataType>& val) const {
    val.set(*this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_power(const Matrix<DataType>& y) const {
    return binary(OP_POW, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_constpow(const Matrix<DataType>& y) const {
    return binary(OP_CONSTPOW, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_sin() const {
    return unary(OP_SIN, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_cos() const {
    return unary(OP_COS, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_tan() const {
    return unary(OP_TAN, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_erf() const {
    return unary(OP_ERF, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_asin() const {
    return unary(OP_ASIN, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_acos() const {
    return unary(OP_ACOS, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_atan() const {
    return unary(OP_ATAN, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_sinh() const {
    return unary(OP_SINH, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_cosh() const {
    return unary(OP_COSH, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_tanh() const {
    return unary(OP_TANH, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_asinh() const {
    return unary(OP_ASINH, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_acosh() const {
    return unary(OP_ACOSH, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_atanh() const {
    return unary(OP_ATANH, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_exp() const {
    return unary(OP_EXP, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_log() const {
    return unary(OP_LOG, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_log10() const {
    return log(*this)*(1/std::log(10.));
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_sqrt() const {
    return unary(OP_SQRT, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_floor() const {
    return unary(OP_FLOOR, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_ceil() const {
    return unary(OP_CEIL, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_mod(const Matrix<DataType>& y) const {
    return binary(OP_FMOD, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_abs() const {
    return unary(OP_FABS, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_sign() const {
    return unary(OP_SIGN, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_copysign(const Matrix<DataType>& y) const {
    return binary(OP_COPYSIGN, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_erfinv() const {
    return unary(OP_ERFINV, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_min(const Matrix<DataType>& y) const {
    return binary(OP_FMIN, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_atan2(const Matrix<DataType>& y) const {
    return binary(OP_ATAN2, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_max(const Matrix<DataType>& y) const {
    return binary(OP_FMAX, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::printme(const Matrix<DataType>& y) const {
    return binary(OP_PRINTME, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_not() const {
    return unary(OP_NOT, *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_and(const Matrix<DataType>& y) const {
    return binary(OP_AND, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_or(const Matrix<DataType>& y) const {
    return binary(OP_OR, *this, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_if_else_zero(const Matrix<DataType>& y) const {
    return binary(OP_IF_ELSE_ZERO, *this, y);
  }

  template<typename DataType>
  std::vector<DataType>& Matrix<DataType>::data() {
    return data_;
  }

  template<typename DataType>
  const std::vector<DataType>& Matrix<DataType>::data() const {
    return data_;
  }

  template<typename DataType>
  void Matrix<DataType>::erase(const std::vector<int>& rr, const std::vector<int>& cc, bool ind1) {
    // Erase from sparsity pattern
    std::vector<int> mapping = sparsityRef().erase(rr, cc, ind1);

    // Update non-zero entries
    for (int k=0; k<mapping.size(); ++k)
      data()[k] = data()[mapping[k]];

    // Truncate nonzero vector
    data().resize(mapping.size());
  }

  template<typename DataType>
  void Matrix<DataType>::erase(const std::vector<int>& rr, bool ind1) {
    // Erase from sparsity pattern
    std::vector<int> mapping = sparsityRef().erase(rr, ind1);

    // Update non-zero entries
    for (int k=0; k<mapping.size(); ++k)
      data()[k] = data()[mapping[k]];

    // Truncate nonzero vector
    data().resize(mapping.size());
  }

  template<typename DataType>
  void Matrix<DataType>::remove(const std::vector<int>& rr, const std::vector<int>& cc) {
    if (!inBounds(rr, size1())) {
      casadi_error("Remove(rr, cc) out of bounds. Your rr contains "
                   << *std::min_element(rr.begin(), rr.end()) << " up to "
                   << *std::max_element(rr.begin(), rr.end())
                   << ", which is outside of the matrix shape " << dimString() << ".");
    }
    if (!inBounds(cc, size2())) {
      casadi_error("Remove(rr, cc) out of bounds. Your cc contains "
                   << *std::min_element(cc.begin(), cc.end()) << " up to "
                   << *std::max_element(cc.begin(), cc.end())
                   << ", which is outside of the matrix shape " << dimString() << ".");
    }

    // Remove by performing a complementary slice
    std::vector<int> rrc = complement(rr, size1());
    std::vector<int> ccc = complement(cc, size2());

    Matrix<DataType> ret = (*this)(rrc, ccc);

    operator=(ret);

  }

  template<typename DataType>
  void Matrix<DataType>::enlarge(int nrow, int ncol, const std::vector<int>& rr,
                                 const std::vector<int>& cc, bool ind1) {
    sparsityRef().enlarge(nrow, ncol, rr, cc, ind1);
  }

  template<typename DataType>
  void Matrix<DataType>::sanityCheck(bool complete) const {
    sparsity_.sanityCheck(complete);
    if (data_.size()!=sparsity_.nnz()) {
      std::stringstream s;
      s << "Matrix is not sane. The following must hold:" << std::endl;
      s << "  data().size() = sparsity().nnz(), but got data().size()  = " << data_.size()
        << "   and sparsity().nnz() = "  << sparsity_.nnz() << std::endl;
      casadi_error(s.str());
    }
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_mtimes(const Matrix<DataType> &y) const {
    if (isscalar() || y.isscalar()) {
      // Use element-wise multiplication if at least one factor scalar
      return *this*y;
    } else {
      Matrix<DataType> z = Matrix<DataType>::zeros(mul(sparsity(), y.sparsity()));
      return mac(*this, y, z);
    }
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_mac(const Matrix<DataType> &y,
                                            const Matrix<DataType> &z) const {
    if (isscalar() || y.isscalar()) {
      // Use element-wise multiplication if at least one factor scalar
      return z + *this*y;
    }

    // Check matching dimensions
    casadi_assert_message(size2()==y.size1(),
                          "Matrix product with incompatible dimensions. Lhs is "
                          << dimString() << " and rhs is " << y.dimString() << ".");

    casadi_assert_message(y.size2()==z.size2(),
                          "Matrix addition with incompatible dimensions. Lhs is "
                          << mul(*this, y).dimString() << " and rhs is " << z.dimString() << ".");

    casadi_assert_message(size1()==z.size1(),
                          "Matrix addition with incompatible dimensions. Lhs is "
                          << mul(*this, y).dimString() << " and rhs is " << z.dimString() << ".");

    // Check if we can simplify the product
    if (isIdentity()) {
      return y + z;
    } else if (y.isIdentity()) {
      return *this + z;
    } else if (isZero() || y.isZero()) {
      return z;
    } else {
      // Carry out the matrix product
      Matrix<DataType> ret = z;
      std::vector<DataType> work(size1());
      casadi_mm_sparse(ptr(), sparsity(), y.ptr(), y.sparsity(),
                       ret.ptr(), ret.sparsity(), getPtr(work));
      return ret;
    }
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_quad_form(const Matrix<DataType>& A) const {
    casadi_assert(isvector());
    if (!iscolumn()) return quad_form(this->T(), A);

    // Call recursively if vector not dense
    if (!isdense()) return densify(*this).zz_quad_form(A);

    // Assert dimensions
    casadi_assert_message(size1()==A.size2() && size1()==A.size1(),
                          "Dimension mismatch. Got x.size1 = " << size1()
                          << " and A.shape = " << A.shape());

    // Calculate using runtime function
    return casadi_quad_form(A.ptr(), A.sparsity(), ptr());
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::T() const {
    // quick return if empty or scalar
    if ((size1()==0 && size2()==0) || isscalar()) return *this;

    // Create the new sparsity pattern and the mapping
    std::vector<int> mapping;
    Sparsity s = sparsity().transpose(mapping);

    // create the return matrix
    Matrix<DataType> ret = zeros(s);

    // Copy the content
    for (int i=0; i<mapping.size(); ++i)
      ret.at(i) = at(mapping[i]);

    return ret;
  }

  template<typename DataType>
  const DataType Matrix<DataType>::toScalar() const {
    // Make sure that the matrix is 1-by-1
    casadi_assert_message(isscalar(), "Can only convert 1-by-1 matrices to scalars");

    // return zero or the nonzero element
    if (nnz()==1)
      return data()[0];
    else
      return casadi_limits<DataType>::zero;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::binary(int op,
                                            const Matrix<DataType> &x,
                                            const Matrix<DataType> &y) {
    if (x.numel()==1)
      return scalar_matrix(op, x, y);
    else if (y.numel()==1)
      return matrix_scalar(op, x, y);
    else
      return matrix_matrix(op, x, y);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::scalar_matrix(int op,
                                                   const Matrix<DataType> &x,
                                                   const Matrix<DataType> &y) {
    // Return value
    Matrix<DataType> ret = Matrix<DataType>::zeros(y.sparsity());

    // Nonzeros
    std::vector<DataType>& ret_data = ret.data();
    const std::vector<DataType>& x_data = x.data();
    const DataType& x_val = x_data.empty() ? casadi_limits<DataType>::zero : x.front();
    const std::vector<DataType>& y_data = y.data();

    // Do the operation on all non-zero elements
    for (int el=0; el<y.nnz(); ++el) {
      casadi_math<DataType>::fun(op, x_val, y_data[el], ret_data[el]);
    }

    // Check the value of the structural zero-entries, if there are any
    if (!y.isdense() && !operation_checker<Function0Checker>(op)) {
      // Get the value for the structural zeros
      DataType fcn_0;
      casadi_math<DataType>::fun(op, x_val, casadi_limits<DataType>::zero, fcn_0);
      if (!casadi_limits<DataType>::isZero(fcn_0)) { // Remove this if?
        ret.makeDense(fcn_0);
      }
    }

    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::matrix_scalar(int op,
                                                   const Matrix<DataType> &x,
                                                   const Matrix<DataType> &y) {
    // Return value
    Matrix<DataType> ret = Matrix<DataType>::zeros(x.sparsity());

    // Nonzeros
    std::vector<DataType>& ret_data = ret.data();
    const std::vector<DataType>& x_data = x.data();
    const std::vector<DataType>& y_data = y.data();
    const DataType& y_val = y_data.empty() ? casadi_limits<DataType>::zero : y.front();

    // Do the operation on all non-zero elements
    for (int el=0; el<x.nnz(); ++el) {
      casadi_math<DataType>::fun(op, x_data[el], y_val, ret_data[el]);
    }

    // Check the value of the structural zero-entries, if there are any
    if (!x.isdense() && !operation_checker<F0XChecker>(op)) {
      // Get the value for the structural zeros
      DataType fcn_0;
      casadi_math<DataType>::fun(op, casadi_limits<DataType>::zero, y_val, fcn_0);
      if (!casadi_limits<DataType>::isZero(fcn_0)) { // Remove this if?
        ret.makeDense(fcn_0);
      }
    }

    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::matrix_matrix(int op,
                                                   const Matrix<DataType> &x,
                                                   const Matrix<DataType> &y) {

    if (!(x.size2() == y.size2() && x.size1() == y.size1())) {
      std::stringstream ss;
      casadi_math<DataType>::print(op, ss, "lhs", "rhs");
      casadi_error("matrix_matrix: dimension mismatch in element-wise matrix operation "
                   << ss.str() <<"." << std::endl << "Left argument has shape " << x.dimString()
                   << ", right has shape " << y.dimString() << ". They should be equal.");
    }

    // Get the sparsity pattern of the result
    // (ignoring structural zeros giving rise to nonzero result)
    const Sparsity& x_sp = x.sparsity();
    const Sparsity& y_sp = y.sparsity();
    Sparsity r_sp = x_sp.patternCombine(y_sp,
                                        operation_checker<F0XChecker>(op),
                                        operation_checker<Function0Checker>(op));

    // Return value
    Matrix<DataType> r = zeros(r_sp);

    // Perform the operations elementwise
    if (x_sp==y_sp) {
      // Matching sparsities
      casadi_math<DataType>::fun(op, getPtr(x.data()), getPtr(y.data()),
                                 getPtr(r.data()), r_sp.nnz());
    } else if (y_sp==r_sp) {
      // Project first argument
      Matrix<DataType> x_mod = x(r_sp);
      casadi_math<DataType>::fun(op, getPtr(x_mod.data()), getPtr(y.data()),
                                 getPtr(r.data()), r_sp.nnz());
    } else if (x_sp==r_sp) {
      // Project second argument
      Matrix<DataType> y_mod = y(r_sp);
      casadi_math<DataType>::fun(op, getPtr(x.data()),
                                 getPtr(y_mod.data()), getPtr(r.data()), r_sp.nnz());
    } else {
      // Project both arguments
      Matrix<DataType> x_mod = x(r_sp);
      Matrix<DataType> y_mod = y(r_sp);
      casadi_math<DataType>::fun(op, getPtr(x_mod.data()), getPtr(y_mod.data()),
                                 getPtr(r.data()), r_sp.nnz());
    }

    // Handle structural zeros giving rise to nonzero result, e.g. cos(0) == 1
    if (!r.isdense() && !operation_checker<F00Checker>(op)) {
      // Get the value for the structural zeros
      DataType fcn_0;
      casadi_math<DataType>::fun(op, casadi_limits<DataType>::zero,
                                 casadi_limits<DataType>::zero, fcn_0);
      r.makeDense(fcn_0);
    }

    return r;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::triplet(const std::vector<int>& row,
                                             const std::vector<int>& col,
                                             const Matrix<DataType>& d) {
    return triplet(row, col, d, *std::max_element(row.begin(), row.end()),
                   *std::max_element(col.begin(), col.end()));
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::triplet(const std::vector<int>& row,
                                             const std::vector<int>& col,
                                             const Matrix<DataType>& d,
                                             const std::pair<int, int>& rc) {
    return triplet(row, col, d, rc.first, rc.second);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::triplet(const std::vector<int>& row,
                                             const std::vector<int>& col,
                                             const Matrix<DataType>& d,
                                             int nrow, int ncol) {
    casadi_assert_message(col.size()==row.size() && col.size()==d.nnz(),
                          "Argument error in Matrix<DataType>::triplet(row, col, d): "
                          "supplied lists must all be of equal length, but got: "
                          << row.size() << ", " << col.size()  << " and " << d.nnz());
    std::vector<int> mapping;
    Sparsity sp = Sparsity::triplet(nrow, ncol, row, col, mapping);
    return Matrix<DataType>(sp, d[mapping]);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::eye(int n) {
    return Matrix<DataType>::ones(Sparsity::diag(n));
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::inf(const Sparsity& sp) {
    casadi_assert_message(std::numeric_limits<DataType>::has_infinity,
                          "Datatype cannot represent infinity");
    return Matrix<DataType>(sp, std::numeric_limits<DataType>::infinity(), false);
  }


  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::inf(const std::pair<int, int>& rc) {
    return inf(rc.first, rc.second);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::inf(int nrow, int ncol) {
    return inf(Sparsity::dense(nrow, ncol));
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::nan(const Sparsity& sp) {
    casadi_assert_message(std::numeric_limits<DataType>::has_quiet_NaN,
                          "Datatype cannot represent not-a-number");
    return Matrix<DataType>(sp, std::numeric_limits<DataType>::quiet_NaN(), false);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::nan(const std::pair<int, int>& rc) {
    return nan(rc.first, rc.second);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::nan(int nrow, int ncol) {
    return nan(Sparsity::dense(nrow, ncol));
  }

  template<typename DataType>
  void Matrix<DataType>::append(const Matrix<DataType>& y) {
    // Quick return if expr is empty
    if (size2()==0 && size1()==0) {
      *this=y;
      return;
    }

    // Quick return if empty
    if (y.size2()==0 && y.size1()==0) return;

    // Appending can be done efficiently if column vectors
    if (iscolumn()) {
      // Append the sparsity pattern vertically
      sparsityRef().append(y.sparsity());

      // Add the non-zeros at the end
      data().insert(end(), y.begin(), y.end());
    } else {
      // Fall back on vertical concatenation
      *this = vertcat(*this, y);
    }
  }

  template<typename DataType>
  void Matrix<DataType>::appendColumns(const Matrix<DataType>& y) {

    // Quick return if expr is empty
    if (size2()==0 && size1()==0) {
      *this=y;
      return;
    }

    // Quick return if empty
    if (y.size2()==0 && y.size1()==0) return;

    // Append the sparsity pattern
    sparsityRef().appendColumns(y.sparsity());

    // Add the non-zeros at the end
    data().insert(end(), y.begin(), y.end());
  }

  template<typename DataType>
  bool Matrix<DataType>::isRegular() const {
    return casadi::isRegular(data_);
  }

  template<typename DataType>
  bool Matrix<DataType>::isSmooth() const {
    return true;
  }

  template<typename DataType>
  size_t Matrix<DataType>::getElementHash() const {
    throw CasadiException("\"getElementHash\" not defined for instantiation");
  }

  template<typename DataType>
  bool Matrix<DataType>::isLeaf() const {
    throw CasadiException("\"isLeaf\" not defined for instantiation");
  }

  template<typename DataType>
  bool Matrix<DataType>::isCommutative() const {
    throw CasadiException("\"isCommutative\" not defined for instantiation");
  }

  template<typename DataType>
  bool Matrix<DataType>::isSymbolic() const {
    return false;
  }

  template<typename DataType>
  bool Matrix<DataType>::isValidInput() const {
    return false;
  }

  template<typename DataType>
  bool Matrix<DataType>::hasDuplicates() {
    throw CasadiException("\"hasDuplicates\" not defined for instantiation");
  }

  template<typename DataType>
  void Matrix<DataType>::resetInput() {
    throw CasadiException("\"resetInput\" not defined for instantiation");
  }

  template<typename DataType>
  bool Matrix<DataType>::isInteger() const {
    // loop over non-zero elements
    for (int k=0; k<nnz(); ++k)
      if (!casadi_limits<DataType>::isInteger(at(k))) // if an element is not integer
        return false;

    // Integer if reached this point
    return true;
  }

  template<typename DataType>
  bool Matrix<DataType>::isConstant() const {
    // loop over non-zero elements
    for (int k=0; k<nnz(); ++k)
      if (!casadi_limits<DataType>::isConstant(at(k))) // if an element is not constant
        return false;

    // Constant if we reach this point
    return true;
  }

  template<typename DataType>
  bool Matrix<DataType>::isOne() const {
    if (!isdense()) {
      return false;
    }

    // loop over non-zero elements
    for (int el=0; el<nnz(); ++el)
      if (!casadi_limits<DataType>::isOne(at(el)))
        return false;

    return true;
  }

  template<typename DataType>
  bool Matrix<DataType>::isMinusOne() const {
    if (!isdense()) {
      return false;
    }

    // loop over non-zero elements
    for (int el=0; el<nnz(); ++el)
      if (!casadi_limits<DataType>::isMinusOne(at(el)))
        return false;

    return true;
  }

  template<typename DataType>
  bool Matrix<DataType>::isZero() const {

    // loop over (potentially) non-zero elements
    for (int el=0; el<nnz(); ++el)
      if (!casadi_limits<DataType>::isZero(at(el)))
        return false;

    return true;
  }

  template<typename DataType>
  bool Matrix<DataType>::isIdentity() const {

    // Make sure that the matrix is diagonal
    if (!sparsity().isdiag())
      return false;

    // Make sure that all entries are one
    for (typename Matrix<DataType>::const_iterator it=begin(); it!=end(); ++it) {
      if (!casadi_limits<DataType>::isOne(*it))
        return false;
    }

    return true;
  }

  template<typename DataType>
  bool Matrix<DataType>::zz_isEqual(const Matrix<DataType> &ex2, int depth) const {
    // Assert matching dimensions
    casadi_assert_message(shape() == ex2.shape(), "Dimension mismatch");

    // Project to union of patterns and call recursively if different sparsity
    if (sparsity() != ex2.sparsity()) {
      Sparsity sp = sparsity() + ex2.sparsity();
      return isEqual(project(*this, sp), project(ex2, sp), depth);
    }

    // Check individual elements
    for (int k=0; k<nnz(); ++k) {
      if (!isEqual(at(k), ex2.at(k), depth)) return false;
    }

    // True if reched this point
    return true;
  }

  template<typename DataType>
  bool Matrix<DataType>::hasNonStructuralZeros() const {
    // Check if the structural nonzero is known to be zero
    for (int el=0; el<nnz(); ++el) {
      if (casadi_limits<DataType>::isZero(at(el)))
        return true;
    }

    // No known zeros amongst the structurally nonzero entries
    return false;
  }

  template<typename DataType>
  double Matrix<DataType>::getValue() const {
    casadi_assert(isscalar());
    if (nnz()==0) {
      return 0;
    } else {
      return getValue(0);
    }
  }

  template<typename DataType>
  double Matrix<DataType>::getValue(int k) const {
    return static_cast<double>(at(k));
  }

  template<typename DataType>
  void Matrix<DataType>::setValue(double m) {
    casadi_assert(isscalar());
    if (nnz()!=0) {
      setValue(m, 0);
    }
  }

  template<typename DataType>
  void Matrix<DataType>::setValue(double m, int k) {
    at(k) = m;
  }

  template<typename DataType>
  int Matrix<DataType>::getIntValue() const {
    return static_cast<int>(toScalar());
  }

  template<typename DataType>
  std::vector<double> Matrix<DataType>::nonzeros() const {
    std::vector<double> ret(nnz());
    std::copy(begin(), end(), ret.begin());
    return ret;
  }

  template<typename DataType>
  std::vector<int> Matrix<DataType>::nonzeros_int() const {
    std::vector<int> ret(nnz());
    std::copy(begin(), end(), ret.begin());
    return ret;
  }

  template<typename DataType>
  std::string Matrix<DataType>::getName() const {
    throw CasadiException("\"getName\" not defined for instantiation");
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::getDep(int ch) const {
    throw CasadiException("\"getDep\" not defined for instantiation");
  }

  template<typename DataType>
  int Matrix<DataType>::getNdeps() const {
    throw CasadiException("\"getNdeps\" not defined for instantiation");
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_project(const Sparsity& sp, bool intersect) const {
    if (intersect) {
      return project(*this, sp.patternIntersection(sparsity()), false);
    } else {
      Matrix<DataType> ret = Matrix<DataType>::zeros(sp);
      ret.set(*this);
      return ret;
    }
  }

  template<typename DataType>
  void Matrix<DataType>::setEqualityCheckingDepth(int eq_depth) {
    throw CasadiException("\"setEqualityCheckingDepth\" not defined for instantiation");
  }

  template<typename DataType>
  int Matrix<DataType>::getEqualityCheckingDepth() {
    throw CasadiException("\"getEqualityCheckingDepth\" not defined for instantiation");
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_det() const {
    int n = size2();
    casadi_assert_message(n == size1(), "matrix must be square");

    // Trivial return if scalar
    if (isscalar()) return toScalar();

    // Trivial case 2 x 2
    if (n==2) return elem(0, 0) * elem(1, 1) - elem(0, 1) * elem(1, 0);

    // Return expression
    Matrix<DataType> ret = 0;

    // Find out which is the best direction to expand along

    // Build up an IMatrix with ones on the non-zeros
    Matrix<int> sp = IMatrix::ones(sparsity());

    // Have a count of the nonzeros for each row
    Matrix<int> row_count = sp.zz_sumCols();

    // A blank row? determinant is structurally zero
    if (!row_count.isdense()) return 0;

    // Have a count of the nonzeros for each col
    Matrix<int> col_count = sp.zz_sumRows().T();

    // A blank col? determinant is structurally zero
    if (!row_count.isdense()) return 0;

    int min_row = std::distance(row_count.data().begin(),
                                std::min_element(row_count.data().begin(),
                                                 row_count.data().end()));
    int min_col = std::distance(col_count.data().begin(),
                                std::min_element(col_count.data().begin(),
                                                 col_count.data().end()));

    if (min_row <= min_col) {
      // Expand along row j
      int j = row_count.sparsity().row(min_row);

      Matrix<DataType> row = (*this)(j, Slice(0, n));

      std::vector< int > col_i = row.sparsity().getCol();

      for (int k=0; k<row.nnz(); ++k) {
        // Sum up the cofactors
        ret += row.at(k)*cofactor(*this, col_i.at(k), j);
      }
      return ret;
    } else {
      // Expand along col i
      int i = col_count.sparsity().row(min_col);

      Matrix<DataType> col = (*this)(Slice(0, n), i);

      const int* row_i = col.row();

      for (int k=0; k<col.nnz(); ++k) {
        // Sum up the cofactors
        ret += col.at(k)*cofactor(*this, i, row_i[k]);
      }
      return ret;
    }

  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_sumCols() const {
    return mul(*this, Matrix<DataType>::ones(size2(), 1));
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_sumRows() const {
    return mul(Matrix<DataType>::ones(1, size1()), *this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_getMinor(int i, int j) const {
    int n = size2();
    casadi_assert_message(n == size1(), "getMinor: matrix must be square");

    // Trivial return if scalar
    if (n==1) return 1;

    // Remove col i and row j
    Matrix<DataType> M = Matrix<DataType>(n-1, n-1);

    std::vector<int> col = sparsity().getCol();
    const int* row = sparsity().row();

    for (int k=0;k<nnz();++k) {
      int i1 = col[k];
      int j1 = row[k];

      if (i1 == i || j1 == j) continue;

      int i2 = (i1<i)?i1:i1-1;
      int j2 = (j1<j)?j1:j1-1;

      M(j2, i2) = (*this)(j1, i1);
    }
    return det(M);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_cofactor(int i, int j) const {

    // Calculate the i, j minor
    Matrix<DataType> minor_ij = getMinor(*this, i, j);
    // Calculate the cofactor
    int sign_i = 1-2*((i+j) % 2);

    return sign_i * minor_ij;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_adj() const {
    int n = size2();
    casadi_assert_message(n == size1(), "adj: matrix must be square");

    // Temporary placeholder
    Matrix<DataType> temp;

    // Cofactor matrix
    Matrix<DataType> C = Matrix<DataType>(n, n);
    for (int i=0; i<n; ++i)
      for (int j=0; j<n; ++j) {
        temp = cofactor(*this, i, j);
        if (!temp.isZero()) C(j, i) = temp;
      }

    return C.T();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_inv() const {
    // laplace formula
    return adj(*this)/det(*this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_reshape(int nrow, int ncol) const {
    Sparsity sp = reshape(sparsity(), nrow, ncol);
    return Matrix<DataType>(sp, data(), false);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_reshape(const Sparsity& sp) const {
    // quick return if already the right shape
    if (sp==sparsity()) return *this;

    // make sure that the patterns match
    casadi_assert(sp.isReshape(sparsity()));

    return Matrix<DataType>(sp, data(), false);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_trace() const {
    casadi_assert_message(size2() == size1(), "trace: must be square");
    DataType res=0;
    for (int i=0; i< size2(); i ++) {
      res += elem(i, i);
    }
    return res;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_vecNZ() const {
    return Matrix<DataType>(data());
  }

  template<typename DataType>
  Matrix<DataType>
  Matrix<DataType>::zz_blockcat(const std::vector< std::vector<Matrix<DataType> > > &v) {
    std::vector< Matrix<DataType> > ret;
    for (int i=0; i<v.size(); ++i)
      ret.push_back(horzcat(v[i]));
    return vertcat(ret);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_horzcat(const std::vector<Matrix<DataType> > &v) {
    // Concatenate sparsity patterns
    std::vector<Sparsity> sp(v.size());
    for (int i=0; i<v.size(); ++i) sp[i] = v[i].sparsity();
    Matrix<DataType> ret = zeros(horzcat(sp));

    // Copy nonzeros
    typename Matrix<DataType>::iterator i=ret.begin();
    for (typename std::vector<Matrix<DataType> >::const_iterator j=v.begin();
         j!=v.end(); ++j) {
      std::copy(j->begin(), j->end(), i);
      i += j->nnz();
    }
    return ret;
  }

  template<typename DataType>
  std::vector<Matrix<DataType> >
  Matrix<DataType>::zz_horzsplit(const std::vector<int>& offset) const {
    // Split up the sparsity pattern
    std::vector<Sparsity> sp = horzsplit(sparsity(), offset);

    // Return object
    std::vector<Matrix<DataType> > ret;
    ret.reserve(sp.size());

    // Copy data
    typename std::vector<DataType>::const_iterator data_start=begin(), data_stop;
    for (std::vector<Sparsity>::const_iterator j=sp.begin(); j!=sp.end(); ++j) {
      data_stop = data_start + j->nnz();
      ret.push_back(Matrix<DataType>(*j, std::vector<DataType>(data_start,
                                                               data_stop), false));
      data_start = data_stop;
    }

    // Return the assembled matrix
    casadi_assert(data_stop==end());
    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_vertcat(const std::vector<Matrix<DataType> > &v) {
    std::vector<Matrix<DataType> > vT(v.size());
    for (int i=0; i<v.size(); ++i) vT[i] = v[i].T();
    return horzcat(vT).T();
  }

  template<typename DataType>
  std::vector< Matrix<DataType> >
  Matrix<DataType>::zz_vertsplit(const std::vector<int>& offset) const {
    std::vector< Matrix<DataType> > ret = horzsplit(this->T(), offset);
    for (typename std::vector< Matrix<DataType> >::iterator it=ret.begin();
         it!=ret.end(); ++it) {
      *it = it->T();
    }
    return ret;
  }

  template<typename DataType>
  std::vector< Matrix<DataType> >
  Matrix<DataType>::zz_diagsplit(const std::vector<int>& offset1,
                                 const std::vector<int>& offset2) const {
    // Consistency check
    casadi_assert(offset1.size()>=1);
    casadi_assert(offset1.front()==0);
    casadi_assert(offset1.back()==size1());
    casadi_assert(isMonotone(offset1));

    // Consistency check
    casadi_assert(offset2.size()>=1);
    casadi_assert(offset2.front()==0);
    casadi_assert(offset2.back()==size2());
    casadi_assert(isMonotone(offset2));

    // Number of outputs
    int n = offset1.size()-1;

    // Return value
    std::vector< Matrix<DataType> > ret;

    // Caveat: this is a very silly implementation
    for (int i=0; i<n; ++i) {
      ret.push_back((*this)(Slice(offset1[i], offset1[i+1]), Slice(offset2[i], offset2[i+1])));
    }

    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_inner_prod(const Matrix<DataType> &y) const {
    casadi_assert_message(shape()==y.shape(), "inner_prod: Dimension mismatch");
    if (sparsity()!=y.sparsity()) {
      Sparsity sp = sparsity() * y.sparsity();
      return inner_prod(project(*this, sp), project(y, sp));
    }
    Matrix<DataType> ret(0);
    for (int k=0; k<nnz(); ++k) {
      ret.at(0) += at(k) * y.at(k);
    }
    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_outer_prod(const Matrix<DataType> &y) const {
    return mul(*this, y.T());
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_all() const {
    if (!isdense()) return false;
    DataType ret=1;
    for (int i=0;i<nnz();++i) {
      ret = ret && at(i)==1;
    }
    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_any() const {
    if (!isdense()) return false;
    DataType ret=0;
    for (int i=0;i<nnz();++i) {
      ret = ret || at(i)==1;
    }
    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_norm_1() const {
    return inner_prod(fabs(*this), Matrix<DataType>::ones(sparsity()));
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_norm_2() const {
    if (isvector()) {
      return norm_F(*this);
    } else {
      casadi_error("2-norms currently only supported for vectors. "
                   "Did you intend to calculate a Frobenius norms (norm_F)?");
    }
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_norm_F() const {
    return sqrt(sum_square(*this));
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_norm_inf() const {
    // Get largest element by absolute value
    Matrix<DataType> s = 0;
    for (typename std::vector<DataType>::const_iterator i=begin(); i!=end(); ++i) {
      s = fmax(s, fabs(Matrix<DataType>(*i)));
    }
    return s;
  }

  template<typename DataType>
  void Matrix<DataType>::zz_qr(Matrix<DataType>& Q, Matrix<DataType> &R) const {
    // The following algorithm is taken from J. Demmel:
    // Applied Numerical Linear Algebra (algorithm 3.1.)
    casadi_assert_message(size1()>=size2(), "qr: fewer rows than columns");

    // compute Q and R column by column
    Q = R = Matrix<DataType>();
    for (int i=0; i<size2(); ++i) {
      // Initialize qi to be the i-th column of *this
      Matrix<DataType> ai = (*this)(ALL, i);
      Matrix<DataType> qi = ai;
      // The i-th column of R
      Matrix<DataType> ri = Matrix<DataType>(size2(), 1);

      // subtract the projection of qi in the previous directions from ai
      for (int j=0; j<i; ++j) {

        // Get the j-th column of Q
        Matrix<DataType> qj = Q(ALL, j);

        ri(j, 0) = mul(qi.T(), qj); // Modified Gram-Schmidt
        // ri[j] = inner_prod(qj, ai); // Classical Gram-Schmidt

        // Remove projection in direction j
        if (ri.hasNZ(j, 0))
          qi -= ri(j, 0) * qj;
      }

      // Normalize qi
      ri(i, 0) = norm_2(qi);
      qi /= ri(i, 0);

      // Update R and Q
      Q.appendColumns(qi);
      R.appendColumns(ri);
    }
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_nullspace() const {
    int n = size1();
    int m = size2();

    Matrix<DataType> X = *this;

    casadi_assert_message(m>=n, "nullspace(): expecting a flat matrix (more columns than rows), "
                          "but got " << dimString() << ".");

    Matrix<DataType> seed = DMatrix::eye(m)(Slice(0, m), Slice(n, m));

    std::vector< Matrix<DataType> > us;
    std::vector< Matrix<DataType> > betas;

    Matrix<DataType> beta;

    for (int i=0;i<n;++i) {
      Matrix<DataType> x = X(i, Slice(i, m));
      Matrix<DataType> u = Matrix<DataType>(x);
      Matrix<DataType> sigma = sqrt(sumCols(x*x));
      const Matrix<DataType>& x0 = x(0, 0);
      u(0, 0) = 1;

      Matrix<DataType> b = -copysign(sigma, x0);

      u(Slice(0), Slice(1, m-i))*= 1/(x0-b);
      beta = 1-x0/b;

      X(Slice(i, n), Slice(i, m)) -=
        beta*mul(mul(X(Slice(i, n), Slice(i, m)), u.T()), u);
      us.push_back(u);
      betas.push_back(beta);
    }

    for (int i=n-1;i>=0;--i) {
      seed(Slice(i, m), Slice(0, m-n)) -=
        betas[i]*mul(us[i].T(), mul(us[i], seed(Slice(i, m), Slice(0, m-n))));
    }

    return seed;

  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_chol() const {
    // Cholesky-Banachiewicz algorithm
    // Naive, dense implementation O(n^3)

    // check dimensions
    casadi_assert_message(size1() == size2(), "Cholesky decomposition requires square matrix."
                                              "Got " << dimString() << " instead.");

    Matrix<DataType> ret = Matrix<DataType>(Sparsity::lower(size1()));

    for (int i=0; i<size1(); ++i) { // loop over rows
      for (int j=0; j<i; ++j) {
        // Loop over columns before diagonal
        Matrix<DataType> sum=0;
        for (int k=0;k<j;++k) {
          sum += ret(i, k)*ret(j, k);
        }
        ret(i, j) = ((*this)(i, j)-sum)/ret(j, j);
      }

      // Treat the diagonal element separately
      int j = i;
      Matrix<DataType> sum = 0;
      for (int k=0;k<j;++k) {
        sum += pow(ret(j, k), 2);
      }
      ret(j, j) = sqrt((*this)(j, j)-sum);
    }
    return ret.T();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_solve(const Matrix<DataType>& b) const {
    // check dimensions
    casadi_assert_message(size1() == b.size1(), "solve Ax=b: dimension mismatch: b has "
                          << b.size1() << " rows while A has " << size1() << ".");
    casadi_assert_message(size1() == size2(), "solve: A not square but " << dimString());

    if (istril()) {
      // forward substitution if lower triangular
      Matrix<DataType> x = b;
      const int*  Arow = row();
      const int*  Acolind = colind();
      const std::vector<DataType> & Adata = data();
      for (int i=0; i<size2(); ++i) { // loop over columns forwards
        for (int k=0; k<b.size2(); ++k) { // for every right hand side
          if (!x.hasNZ(i, k)) continue;
          x(i, k) /= (*this)(i, i);
          for (int kk=Acolind[i+1]-1; kk>=Acolind[i] && Arow[kk]>i; --kk) {
            int j = Arow[kk];
            x(j, k) -= Adata[kk]*x(i, k);
          }
        }
      }
      return x;
    } else if (istriu()) {
      // backward substitution if upper triangular
      Matrix<DataType> x = b;
      const int*  Arow = row();
      const int*  Acolind = colind();
      const std::vector<DataType> & Adata = data();
      for (int i=size2()-1; i>=0; --i) { // loop over columns backwards
        for (int k=0; k<b.size2(); ++k) { // for every right hand side
          if (!x.hasNZ(i, k)) continue;
          x(i, k) /= (*this)(i, i);
          for (int kk=Acolind[i]; kk<Acolind[i+1] && Arow[kk]<i; ++kk) {
            int j = Arow[kk];
            x(j, k) -= Adata[kk]*x(i, k);
          }
        }
      }
      return x;
    } else if (hasNonStructuralZeros()) {

      // If there are structurally nonzero entries that are known to be zero,
      // remove these and rerun the algorithm
      Matrix<DataType> A_sparse = *this;
      A_sparse.makeSparse();
      return solve(A_sparse, b);

    } else {

      // Make a BLT transformation of A
      std::vector<int> rowperm, colperm, rowblock, colblock, coarse_rowblock, coarse_colblock;
      sparsity().dulmageMendelsohn(rowperm, colperm, rowblock, colblock,
                                     coarse_rowblock, coarse_colblock);

      // Permute the right hand side
      Matrix<DataType> bperm = b(rowperm, ALL);

      // Permute the linear system
      Matrix<DataType> Aperm = (*this)(rowperm, colperm);

      // Solution
      Matrix<DataType> xperm;

      // Solve permuted system
      if (Aperm.istril()) {

        // Forward substitution if lower triangular
        xperm = solve(Aperm, bperm);

      } else if (size2()<=3) {

        // Form inverse by minor expansion and multiply if very small (up to 3-by-3)
        xperm = mul(inv(Aperm), bperm);

      } else {

        // Make a QR factorization
        Matrix<DataType> Q, R;
        qr(Aperm, Q, R);

        // Solve the factorized system (note that solve will now be fast since it is triangular)
        xperm = solve(R, mul(Q.T(), bperm));
      }

      // get the inverted column permutation
      std::vector<int> inv_colperm(colperm.size());
      for (int k=0; k<colperm.size(); ++k)
        inv_colperm[colperm[k]] = k;

      // Permute back the solution and return
      Matrix<DataType> x = xperm(inv_colperm, ALL);
      return x;
    }
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::
  zz_solve(const Matrix<DataType>& b,
           const std::string& lsolver, const Dict& dict) const {
    throw CasadiException("\"solve\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_pinv() const {
    if (size2()>=size1()) {
      return solve(mul(*this, T()), *this).T();
    } else {
      return solve(mul(this->T(), *this), this->T());
    }
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::
  zz_pinv(const std::string& lsolver, const Dict& dict) const {
    throw CasadiException("\"solve\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_kron(const Matrix<DataType>& b) const {
    const Sparsity &a_sp = sparsity();
    Matrix<DataType> filler = Matrix<DataType>(b.shape());
    std::vector< std::vector< Matrix<DataType> > >
      blocks(size1(), std::vector< Matrix<DataType> >(size2(), filler));
    for (int i=0;i<size1();++i) {
      for (int j=0;j<size2();++j) {
        int k = a_sp.getNZ(i, j);
        if (k!=-1) {
          blocks[i][j] = (*this)[k]*b;
        }
      }
    }
    return blockcat(blocks);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_diag() const {
    // Nonzero mapping
    std::vector<int> mapping;
    // Get the sparsity
    Sparsity sp = sparsity().getDiag(mapping);

    Matrix<DataType> ret = zeros(sp);

    for (int k=0;k<mapping.size();k++) ret[k] = (*this)[mapping[k]];
    return ret;
  }

  /** \brief   Construct a matrix with given block on the diagonal */
  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_diagcat(const std::vector< Matrix<DataType> > &A) {
    std::vector<DataType> data;

    std::vector<Sparsity> sp;
    for (int i=0;i<A.size();++i) {
      data.insert(data.end(), A[i].data().begin(), A[i].data().end());
      sp.push_back(A[i].sparsity());
    }

    return Matrix<DataType>(diagcat(sp), data, false);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_unite(const Matrix<DataType>& B) const {
    // Join the sparsity patterns
    std::vector<unsigned char> mapping;
    Sparsity sp = sparsity().patternUnion(B.sparsity(), mapping);

    // Create return matrix
    Matrix<DataType> ret = zeros(sp);

    // Copy sparsity
    int elA=0, elB=0;
    for (int k=0; k<mapping.size(); ++k) {
      if (mapping[k]==1) {
        ret.data()[k] = data()[elA++];
      } else if (mapping[k]==2) {
        ret.data()[k] = B.data()[elB++];
      } else {
        throw CasadiException("Pattern intersection not empty");
      }
    }

    casadi_assert(nnz()==elA);
    casadi_assert(B.nnz()==elB);

    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_polyval(const Matrix<DataType>& x) const {
    casadi_assert_message(isdense(), "polynomial coefficients vector must be dense");
    casadi_assert_message(isvector() && nnz()>0, "polynomial coefficients must be a vector");
    Matrix<DataType> ret = (*this)[0];
    for (int i=1; i<nnz(); ++i) {
      ret = ret*x + (*this)[i];
    }
    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_norm_inf_mul(const Matrix<DataType> &A) const {
    int n_row = A.size2();
    int n_col = size1();
    casadi_assert_message(A.size1()==size2(), "Dimension error. Got " << dimString()
                          << " times " << A.dimString() << ".");

    // Allocate work vectors
    std::vector<DataType> dwork(n_col);
    std::vector<int> iwork(n_row+1+n_col);

    // Call C runtime
    return casadi_norm_inf_mul(ptr(), sparsity(), A.ptr(), A.sparsity(),
                               getPtr(dwork), getPtr(iwork));
  }

  template<typename DataType>
  void Matrix<DataType>::zz_expand(Matrix<DataType> &weights, Matrix<DataType>& terms) const {
    throw CasadiException("\"expand\" not defined for instantiation");
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_pw_const(const Matrix<DataType> &tval,
                                                 const Matrix<DataType> &val) const {
    throw CasadiException("\"pw_const\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_pw_lin(const Matrix<DataType> &tval,
                                               const Matrix<DataType> &val) const {
    throw CasadiException("\"pw_lin\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_if_else(const Matrix<DataType> &if_true,
                                                const Matrix<DataType> &if_false,
                                                bool short_circuit) const {
    return *this*if_true + !*this*if_false;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_conditional(const std::vector<Matrix<DataType> > &x,
                                                    const Matrix<DataType> &x_default,
                                                    bool short_circuit) const {
    Matrix<DataType> ret = x_default;
    for (int k=0; k<x.size(); ++k) {
      ret = if_else(*this==k, x[k], ret, short_circuit);
    }
    return ret;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_heaviside() const {
    return (1+sign(*this))/2;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_rectangle() const {
    return 0.5*(sign(*this+0.5)-sign(*this-0.5));
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_triangle() const {
    return rectangle(*this/2)*(1-fabs(*this));
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_ramp() const {
    return *this*heaviside(*this);
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::
  zz_gauss_quadrature(const Matrix<DataType> &x, const Matrix<DataType> &a,
                      const Matrix<DataType> &b, int order) const {
    return zz_gauss_quadrature(x, a, b, order, Matrix<DataType>());
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_gauss_quadrature(const Matrix<DataType> &x,
                                                         const Matrix<DataType> &a,
                                                         const Matrix<DataType> &b, int order,
                                                         const Matrix<DataType>& w) const {
    throw CasadiException("\"gauss_quadrature\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_simplify() const {
    throw CasadiException("\"simplify\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_substitute(const Matrix<DataType>& v,
                                                   const Matrix<DataType>& vdef) const {
    throw CasadiException("\"substitute\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  std::vector<Matrix<DataType> >
  Matrix<DataType>::zz_substitute(const std::vector<Matrix<DataType> >& ex,
                                  const std::vector<Matrix<DataType> >& v,
                                  const std::vector<Matrix<DataType> >& vdef) {
    throw CasadiException("\"substitute\" not defined for instantiation");
    return std::vector<Matrix<DataType> >();
  }

  template<typename DataType>
  void Matrix<DataType>::zz_substituteInPlace(const std::vector<Matrix<DataType> >& v,
                                              std::vector<Matrix<DataType> >& vdef,
                                              std::vector<Matrix<DataType> >& ex,
                                              bool reverse) {
    throw CasadiException("\"substituteInPlace\" not defined for instantiation");
  }

  template<typename DataType>
  bool Matrix<DataType>::zz_dependsOn(const Matrix<DataType> &arg) const {
    throw CasadiException("\"dependsOn\" not defined for instantiation");
    return false;
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_jacobian(const Matrix<DataType> &arg) const {
    throw CasadiException("\"jacobian\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_gradient(const Matrix<DataType> &arg) const {
    throw CasadiException("\"gradient\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_tangent(const Matrix<DataType> &arg) const {
    throw CasadiException("\"tangent\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_hessian(const Matrix<DataType> &arg) const {
    throw CasadiException("\"hessian\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_hessian(const Matrix<DataType> &arg,
                                                Matrix<DataType> &g) const {
    throw CasadiException("\"hessian\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_jacobianTimesVector(const Matrix<DataType> &arg,
                                                            const Matrix<DataType> &v,
                                                            bool transpose_jacobian) const {
    throw CasadiException("\"jacobianTimesVector\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_taylor(const Matrix<DataType>& x,
                                               const Matrix<DataType>& a, int order) const {
    throw CasadiException("\"taylor\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_mtaylor(const Matrix<DataType>& x,
                                                const Matrix<DataType>& a, int order) const {
    throw CasadiException("\"mtaylor\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_mtaylor(const Matrix<DataType>& x,
                                                const Matrix<DataType>& a, int order,
                                                const std::vector<int>&order_contributions) const {
    throw CasadiException("\"mtaylor\" not defined for instantiation");
    return Matrix<DataType>();
  }

  template<typename DataType>
  int Matrix<DataType>::zz_countNodes() const {
    throw CasadiException("\"countNodes\" not defined for instantiation");
    return 0;
  }

  template<typename DataType>
  std::string
  Matrix<DataType>::zz_getOperatorRepresentation(const std::vector<std::string>& args) const {
    throw CasadiException("\"getOperatorRepresentation\" not defined for instantiation");
    return std::string();
  }

  template<typename DataType>
  std::vector<Matrix<DataType> > Matrix<DataType>::zz_symvar() const {
    throw CasadiException("\"symvar\" not defined for instantiation");
    return std::vector<Matrix<DataType> >();
  }

  template<typename DataType>
  void Matrix<DataType>::zz_extractShared(std::vector<Matrix<DataType> >& ex,
                                          std::vector<Matrix<DataType> >& v,
                                          std::vector<Matrix<DataType> >& vdef,
                                          const std::string& v_prefix,
                                          const std::string& v_suffix) {
    throw CasadiException("\"extractShared\" not defined for instantiation");
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_poly_coeff(const Matrix<DataType>&x) const {
    throw CasadiException("\"poly_coeff\" not defined for instantiation");
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_poly_roots() const {
    throw CasadiException("\"poly_roots\" not defined for instantiation");
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_eig_symbolic() const {
    throw CasadiException("\"eig_symbolic\" not defined for instantiation");
  }

  template<typename DataType>
  Matrix<DataType> Matrix<DataType>::zz_sparsify(double tol) const {
    Matrix<DataType> ret = *this;
    ret.makeSparse(tol);
    return ret;
  }


  template<typename DataType>
  void Matrix<DataType>::setNZ(const Matrix<DataType>& val) {
    setNZ(val, false, Slice());
  }

  template<typename DataType>
  void Matrix<DataType>::getNZ(Matrix<DataType>& val) const {
    getNZ(val, false, Slice());
  }

  template<typename DataType>
  void Matrix<DataType>::set(double val) {
    std::fill(this->begin(), this->end(), val);
  }

  template<typename DataType>
  void Matrix<DataType>::set(const double* val, bool tr) {
    // Get sparsity pattern
    int size1 = this->size1();
    int size2 = this->size2();
    const int* colind = this->colind();
    const int* row = this->row();

    // Fetch nonzeros
    for (int cc=0; cc<size2; ++cc) {
      for (int el=colind[cc]; el<colind[cc+1]; ++el) {
        int rr=row[el];
        setValue(val[tr ? cc + size2*rr : rr + size1*cc], el);
      }
    }
  }

  template<typename DataType>
  void Matrix<DataType>::set(const std::vector<double>& val, bool tr) {
    casadi_assert(val.size()==this->numel());
    set(getPtr(val), tr);
  }

  template<typename DataType>
  void Matrix<DataType>::get(double& val) const {
    casadi_assert(isscalar());
    get(&val);
  }

  template<typename DataType>
  void Matrix<DataType>::get(double* val, bool tr) const {
    // Get sparsity pattern
    int size1 = this->size1();
    int size2 = this->size2();
    const int* colind = this->colind();
    const int* row = this->row();

    // Initialize to zero
    if (!this->isdense()) {
      std::fill(val, val+size1*size2, 0);
    }

    // Set nonzeros
    for (int cc=0; cc<size2; ++cc) {
      for (int el=colind[cc]; el<colind[cc+1]; ++el) {
        int rr=row[el];
        val[tr ? cc + size2*rr : rr + size1*cc] = getValue(el);
      }
    }
  }

  template<typename DataType>
  void Matrix<DataType>::get(std::vector<double>& val) const {
    val.resize(this->numel());
    get(getPtr(val), false);
  }

  template<typename DataType>
  void Matrix<DataType>::setNZ(double val) {
    std::fill(this->begin(), this->end(), val);
  }

  template<typename DataType>
  void Matrix<DataType>::setNZ(const double* val) {
    int nnz = this->nnz();
    for (int el=0; el<nnz; ++el) {
      setValue(*val++, el);
    }
  }

  template<typename DataType>
  void Matrix<DataType>::setNZ(const std::vector<double>& val) {
    casadi_assert(val.size()==this->nnz());
    setNZ(getPtr(val));
  }

  template<typename DataType>
  void Matrix<DataType>::setSym(const std::vector<double>& val) {
    casadi_assert(val.size()==this->sizeU());
    setSym(getPtr(val));
  }

  template<typename DataType>
  void Matrix<DataType>::getNZ(double& val) const {
    casadi_assert(1==this->nnz());
    getNZ(&val);
  }

  template<typename DataType>
  void Matrix<DataType>::getNZ(double* val) const {
    int nnz = this->nnz();
    for (int el=0; el<nnz; ++el) {
      *val++ = getValue(el);
    }
  }

  template<typename DataType>
  void Matrix<DataType>::getNZ(std::vector<double>& val) const {
    val.resize(this->nnz());
    getNZ(getPtr(val));
  }

  template<typename DataType>
  void Matrix<DataType>::getSym(std::vector<double>& val) const {
    val.resize(this->sizeU());
    getSym(getPtr(val));
  }

  template<typename DataType>
  void Matrix<DataType>::setSym(const double* val) {
    const int* colind = this->colind();
    const int* row = this->row();
    int size2 = this->size2();
    for (int cc=0; cc<size2; ++cc) {
      for (int el=colind[cc]; el<colind[cc+1] && row[el]<=cc; ++el) {
        setValue(*val++, el);
      }
    }

    // Assign strictly lower triangular part
    std::vector<int> ind = this->getColind();
    for (int cc=0; cc<size2; ++cc) {
      for (int el=colind[cc]; el<colind[cc+1]; ++el) {
        int rr=row[el];
        if (rr>cc) {
          at(el) = at(ind[rr]++);
        }
      }
    }
  }

  template<typename DataType>
  void Matrix<DataType>::getSym(double* val) const {
    const int* colind = this->colind();
    const int* row = this->row();
    int size2 = this->size2();
    for (int cc=0; cc<size2; ++cc) {
      for (int el=colind[cc]; el<colind[cc+1] && row[el]<=cc; ++el) {
        *val++ = getValue(el);
      }
    }
  }

#ifdef USE_CXX11
  template<typename DataType>
  Matrix<DataType>::operator double() const {
    casadi_assert(isscalar());
    if (isdense()) {
      return nonzeros().at(0);
    } else {
      return 0;
    }
  }

  template<typename DataType>
  Matrix<DataType>::operator std::vector<double>() const {
    casadi_assert(isvector());
    if (isdense()) {
      return nonzeros();
    } else {
      std::vector<double> ret(numel(), 0), nz=nonzeros();
      int size1 = this->size1(), size2 = this->size2();
      const int *colind = this->colind(), *row = this->row();
      for (int cc=0; cc<size2; ++cc) {
        for (int el=colind[cc]; el<colind[cc+1]; ++el) {
          ret[row[el] + cc*size1] = nz[el];
        }
      }
      return ret;
    }
  }

  template<typename DataType>
  Matrix<DataType>::operator int() const {
    casadi_assert(isscalar());
    if (isdense()) {
      return nonzeros_int().at(0);
    } else {
      return 0;
    }
  }
#endif // USE_CXX11

} // namespace casadi

/// \endcond

#endif // CASADI_MATRIX_IMPL_HPP
