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


#ifndef CASADI_X_FUNCTION_INTERNAL_HPP
#define CASADI_X_FUNCTION_INTERNAL_HPP

#include <stack>
#include "function_internal.hpp"
#include "../casadi_options.hpp"

// To reuse variables we need to be able to sort by sparsity pattern (preferably using a hash map)
#ifdef USE_CXX11
#include <unordered_map>
#define SPARSITY_MAP std::unordered_map
#else // USE_CXX11
// Falling back to std::map (binary search tree)
#include <map>
#define SPARSITY_MAP std::map
#endif // USE_CXX11

/// \cond INTERNAL

namespace casadi {

  /** \brief  Internal node class for the base class of SXFunctionInternal and MXFunctionInternal
      (lacks a public counterpart)
      The design of the class uses the curiously recurring template pattern (CRTP) idiom
      \author Joel Andersson
      \date 2011
  */
  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  class CASADI_EXPORT XFunctionInternal : public FunctionInternal {
  public:

    /** \brief  Constructor  */
    XFunctionInternal(const std::vector<MatType>& inputv, const std::vector<MatType>& outputv);

    /** \brief  Destructor */
    virtual ~XFunctionInternal() {}

    /** \brief  Topological sorting of the nodes based on Depth-First Search (DFS) */
    static void sort_depth_first(std::stack<NodeType*>& s, std::vector<NodeType*>& nodes);

    /** \brief  Topological (re)sorting of the nodes based on Breadth-First Search (BFS)
        (Kahn 1962) */
    static void resort_breadth_first(std::vector<NodeType*>& algnodes);

    /** \brief  Topological (re)sorting of the nodes with the purpose of postponing every
        calculation as much as possible, as long as it does not influence a dependent node */
    static void resort_postpone(std::vector<NodeType*>& algnodes, std::vector<int>& lind);

    /** \brief Gradient via source code transformation */
    MatType grad(int iind=0, int oind=0);

    /** \brief Tangent via source code transformation */
    MatType tang(int iind=0, int oind=0);

    /** \brief  Construct a complete Jacobian by compression */
    MatType jac(int iind=0, int oind=0, bool compact=false, bool symmetric=false,
                bool always_inline=true, bool never_inline=false);

    /** \brief Return gradient function  */
    virtual Function getGradient(const std::string& name, int iind, int oind, const Dict& opts);

    /** \brief Return tangent function  */
    virtual Function getTangent(const std::string& name, int iind, int oind, const Dict& opts);

    /** \brief Return Jacobian function  */
    virtual Function getJacobian(const std::string& name, int iind, int oind,
                                 bool compact, bool symmetric, const Dict& opts);

    ///@{
    /** \brief Generate a function that calculates \a nfwd forward derivatives */
    virtual Function getDerForward(const std::string& name, int nfwd, Dict& opts);
    virtual int numDerForward() const { return 64;}
    ///@}

    ///@{
    /** \brief Generate a function that calculates \a nadj adjoint derivatives */
    virtual Function getDerReverse(const std::string& name, int nadj, Dict& opts);
    virtual int numDerReverse() const { return 64;}
    ///@}

    /** \brief Generate code for the declarations of the C function */
    virtual void generateDeclarations(CodeGenerator& g) const = 0;

    /** \brief Generate code for the body of the C function */
    virtual void generateBody(CodeGenerator& g) const = 0;

    /** \brief Helper function: Check if a vector equals inputv */
    virtual bool isInput(const std::vector<MatType>& arg) const;

    /** \brief Create call to (cached) derivative function, forward mode  */
    virtual void callForward(const std::vector<MatType>& arg, const std::vector<MatType>& res,
                         const std::vector<std::vector<MatType> >& fseed,
                         std::vector<std::vector<MatType> >& fsens,
                         bool always_inline, bool never_inline);

    /** \brief Create call to (cached) derivative function, reverse mode  */
    virtual void callReverse(const std::vector<MatType>& arg, const std::vector<MatType>& res,
                         const std::vector<std::vector<MatType> >& aseed,
                         std::vector<std::vector<MatType> >& asens,
                         bool always_inline, bool never_inline);

    // Data members (all public)

    /** \brief  Inputs of the function (needed for symbolic calculations) */
    std::vector<MatType> inputv_;

    /** \brief  Outputs of the function (needed for symbolic calculations) */
    std::vector<MatType> outputv_;
  };

#ifdef casadi_implementation
  // Template implementations

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  XFunctionInternal<PublicType, DerivedType, MatType, NodeType>::XFunctionInternal(
      const std::vector<MatType>& inputv,
      const std::vector<MatType>& outputv) : inputv_(inputv),  outputv_(outputv) {
    addOption("topological_sorting", OT_STRING, "depth-first", "Topological sorting algorithm",
              "depth-first|breadth-first");
    addOption("live_variables", OT_BOOLEAN, true, "Reuse variables in the work vector");

    // Make sure that inputs are symbolic
    for (int i=0; i<inputv.size(); ++i) {
      if (inputv[i].isempty()) {
        // That's okay
      } else if (!inputv[i].isValidInput()) {
        casadi_error("XFunctionInternal::XFunctionInternal: Xfunction input arguments must be"
                     " purely symbolic." << std::endl << "Argument #" << i << " is not symbolic.");
      }
    }

    // Allocate space for inputs
    ibuf_.resize(inputv_.size());
    for (int i=0; i<inputv_.size(); ++i)
      input(i) = DMatrix::zeros(inputv_[i].sparsity());

    // Allocate space for outputs
    obuf_.resize(outputv_.size());
    for (int i=0; i<outputv_.size(); ++i)
      output(i) = DMatrix::zeros(outputv_[i].sparsity());

    // Check for duplicate entries among the input expressions
    bool has_duplicates = false;
    for (typename std::vector<MatType>::iterator it = inputv_.begin();
         it != inputv_.end(); ++it) {
      has_duplicates = it->hasDuplicates() || has_duplicates;
    }

    // Reset temporaries
    for (typename std::vector<MatType>::iterator it = inputv_.begin();
         it != inputv_.end(); ++it) {
      it->resetInput();
    }

    if (has_duplicates) {
      userOut<true, PL_WARN>() << "Input expressions:" << std::endl;
      for (int iind=0; iind<inputv_.size(); ++iind) {
        userOut<true, PL_WARN>() << iind << ": " << inputv_[iind] << std::endl;
      }
      casadi_error("The input expressions are not independent (or were not reset properly).");
    }
  }


  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  void XFunctionInternal<PublicType, DerivedType, MatType, NodeType>::sort_depth_first(
      std::stack<NodeType*>& s, std::vector<NodeType*>& nodes) {
    while (!s.empty()) {

      // Get the topmost element
      NodeType* t = s.top();

      // If the last element on the stack has not yet been added
      if (t && !t->temp) {

        // Initialize the node
        t->init();

        // Find out which not yet added dependency has most number of dependencies
        int max_deps = -1, dep_with_max_deps = -1;
        for (int i=0; i<t->ndep(); ++i) {
          if (t->dep(i).get() !=0 && static_cast<NodeType*>(t->dep(i).get())->temp == 0) {
            int ndep_i = t->dep(i)->ndep();
            if (ndep_i>max_deps) {
              max_deps = ndep_i;
              dep_with_max_deps = i;
            }
          }
        }

        // If there is any dependency which has not yet been added
        if (dep_with_max_deps>=0) {

          // Add to the stack the dependency with the most number of dependencies
          // (so that constants, inputs etc are added last)
          s.push(static_cast<NodeType*>(t->dep(dep_with_max_deps).get()));

        } else {

          // if no dependencies need to be added, we can add the node to the algorithm
          nodes.push_back(t);

          // Mark the node as found
          t->temp = 1;

          // Remove from stack
          s.pop();
        }
      } else {
        // If the last element on the stack has already been added
        s.pop();
      }
    }
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  void XFunctionInternal<PublicType, DerivedType, MatType, NodeType>::resort_postpone(
      std::vector<NodeType*>& algnodes, std::vector<int>& lind) {
    // Number of levels
    int nlevels = lind.size()-1;

    // Set the counter to be the corresponding place in the algorithm
    for (int i=0; i<algnodes.size(); ++i)
      algnodes[i]->temp = i;

    // Save the level of each element
    std::vector<int> level(algnodes.size());
    for (int i=0; i<nlevels; ++i)
      for (int j=lind[i]; j<lind[i+1]; ++j)
        level[j] = i;

    // Count the number of times each node is referenced inside the algorithm
    std::vector<int> numref(algnodes.size(), 0);
    for (int i=0; i<algnodes.size(); ++i) {
      for (int c=0; c<algnodes[i]->ndep(); ++c) { // for both children
        NodeType* child = static_cast<NodeType*>(algnodes[i]->dep(c).get());
        if (child && child->hasDep())
          numref[child->temp]++;
      }
    }

    // Stacks of additional nodes at the current and previous level
    std::stack<int> extra[2];

    // Loop over the levels in reverse order
    for (int i=nlevels-1; i>=0; --i) {

      // The stack for the current level (we are removing elements from this stack)
      std::stack<int>& extra_this = extra[i%2]; // i odd -> use extra[1]

      // The stack for the previous level (we are adding elements to this stack)
      std::stack<int>& extra_prev = extra[1-i%2]; // i odd -> use extra[0]

      // Loop over the nodes of the level
      for (int j=lind[i]; j<lind[i+1]; ++j) {
        // element to be treated
        int el = j;

        // elements in the stack have priority
        if (!extra_this.empty()) {
          // Replace the element with one from the stack
          el = extra_this.top();
          extra_this.pop();
          --j; // redo the loop
        }

        // Skip the element if belongs to a higher level (i.e. was already treated)
        if (level[el] > i) continue;

        // for both children
        for (int c=0; c<algnodes[el]->ndep(); ++c) {

          NodeType* child = static_cast<NodeType*>(algnodes[el]->dep(c).get());

          if (child && child->hasDep()) {
            // Decrease the reference count of the children
            numref[child->temp]--;

            // If this was the last time the child was referenced ...
            // ... and it is not the previous level...
            if (numref[child->temp]==0 && level[child->temp] != i-1) {

              // ... then assign a new level ...
              level[child->temp] = i-1;

              // ... and add to stack
              extra_prev.push(child->temp);

            } // if no more references
          } // if binary
        } // for c = ...
      } // for j
    } // for i

    // Count the number of elements on each level
    for (std::vector<int>::iterator it=lind.begin(); it!=lind.end(); ++it)
      *it = 0;
    for (std::vector<int>::const_iterator it=level.begin(); it!=level.end(); ++it)
      lind[*it + 1]++;

    // Cumsum to get the index corresponding to the first element of each level
    for (int i=0; i<nlevels; ++i)
      lind[i+1] += lind[i];

    // New index for each element
    std::vector<int> runind = lind; // running index for each level
    std::vector<int> newind(algnodes.size());
    for (int i=0; i<algnodes.size(); ++i)
      newind[i] = runind[level[algnodes[i]->temp]]++;

    // Resort the algorithm and reset the temporary
    std::vector<NodeType*> oldalgnodes = algnodes;
    for (int i=0; i<algnodes.size(); ++i) {
      algnodes[newind[i]] = oldalgnodes[i];
      oldalgnodes[i]->temp = 0;
    }

  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  void XFunctionInternal<PublicType, DerivedType, MatType, NodeType>::resort_breadth_first(
      std::vector<NodeType*>& algnodes) {
    // We shall assign a "level" to each element of the algorithm.
    // A node which does not depend on other binary nodes are assigned
    // level 0 and for nodes that depend on other nodes of the algorithm,
    // the level will be the maximum level of any of the children plus 1.
    // Note that all nodes of a level can be evaluated in parallel.
    // The level will be saved in the temporary variable

    // Total number of levels
    int nlevels = 0;

    // Get the earliest possible level
    for (typename std::vector<NodeType*>::iterator it=algnodes.begin(); it!=algnodes.end(); ++it) {
      // maximum level of any of the children
      int maxlevel = -1;
      for (int c=0; c<(*it)->ndep(); ++c) {    // Loop over the children
        NodeType* child = static_cast<NodeType*>((*it)->dep(c).get());
        if (child->hasDep() && child->temp > maxlevel)
          maxlevel = child->temp;
      }

      // Save the level of this element
      (*it)->temp = 1 + maxlevel;

      // Save if new maximum reached
      if (1 + maxlevel > nlevels)
        nlevels = 1 + maxlevel;
    }
    nlevels++;

    // Index of the first node on each level
    std::vector<int> lind;

    // Count the number of elements on each level
    lind.resize(nlevels+1, 0); // all zeros to start with
    for (int i=0; i<algnodes.size(); ++i)
      lind[algnodes[i]->temp+1]++;

    // Cumsum to get the index of the first node on each level
    for (int i=0; i<nlevels; ++i)
      lind[i+1] += lind[i];

    // Get a new index for each element of the algorithm
    std::vector<int> runind = lind; // running index for each level
    std::vector<int> newind(algnodes.size());
    for (int i=0; i<algnodes.size(); ++i)
      newind[i] = runind[algnodes[i]->temp]++;

    // Resort the algorithm accordingly and reset the temporary
    std::vector<NodeType*> oldalgnodes = algnodes;
    for (int i=0; i<algnodes.size(); ++i) {
      algnodes[newind[i]] = oldalgnodes[i];
      oldalgnodes[i]->temp = 0;
    }

#if 0

    int maxl=-1;
    for (int i=0; i<lind.size()-1; ++i) {
      int l = (lind[i+1] - lind[i]);
      //if (l>10)    userOut() << "#level " << i << ": " << l << std::endl;
      userOut() << l << ", ";
      if (l>maxl) maxl= l;
    }
    userOut() << std::endl << "maxl = " << maxl << std::endl;

    for (int i=0; i<algnodes.size(); ++i) {
      algnodes[i]->temp = i;
    }


    maxl=-1;
    for (int i=0; i<lind.size()-1; ++i) {
      int l = (lind[i+1] - lind[i]);
      userOut() << std::endl << "#level " << i << ": " << l << std::endl;

      int ii = 0;

      for (int j=lind[i]; j<lind[i+1]; ++j) {

        std::vector<NodeType*>::const_iterator it = algnodes.begin() + j;

        userOut() << "  "<< ii++ << ": ";

        int op = (*it)->op;
        stringstream s, s0, s1;
        s << "i_" << (*it)->temp;

        int i0 = (*it)->child[0].get()->temp;
        int i1 = (*it)->child[1].get()->temp;

        if ((*it)->child[0]->hasDep())  s0 << "i_" << i0;
        else                             s0 << (*it)->child[0];
        if ((*it)->child[1]->hasDep())  s1 << "i_" << i1;
        else                             s1 << (*it)->child[1];

        userOut() << s.str() << " = ";
        print_c[op](userOut(), s0.str(), s1.str());
        userOut() << ";" << std::endl;




      }

      userOut() << l << ", ";
      if (l>maxl) maxl= l;
    }
    userOut() << std::endl << "maxl (before) = " << maxl << std::endl;


    for (int i=0; i<algnodes.size(); ++i) {
      algnodes[i]->temp = 0;
    }


#endif

    // Resort in order to postpone all calculations as much as possible, thus saving cache
    resort_postpone(algnodes, lind);


#if 0

    for (int i=0; i<algnodes.size(); ++i) {
      algnodes[i]->temp = i;
    }



    maxl=-1;
    for (int i=0; i<lind.size()-1; ++i) {
      int l = (lind[i+1] - lind[i]);
      userOut() << std::endl << "#level " << i << ": " << l << std::endl;

      int ii = 0;

      for (int j=lind[i]; j<lind[i+1]; ++j) {

        std::vector<NodeType*>::const_iterator it = algnodes.begin() + j;

        userOut() << "  "<< ii++ << ": ";

        int op = (*it)->op;
        stringstream s, s0, s1;
        s << "i_" << (*it)->temp;

        int i0 = (*it)->child[0].get()->temp;
        int i1 = (*it)->child[1].get()->temp;

        if ((*it)->child[0]->hasDep())  s0 << "i_" << i0;
        else                             s0 << (*it)->child[0];
        if ((*it)->child[1]->hasDep())  s1 << "i_" << i1;
        else                             s1 << (*it)->child[1];

        userOut() << s.str() << " = ";
        print_c[op](userOut(), s0.str(), s1.str());
        userOut() << ";" << std::endl;




      }

      userOut() << l << ", ";
      if (l>maxl) maxl= l;
    }
    userOut() << std::endl << "maxl = " << maxl << std::endl;


    //  return;




    for (int i=0; i<algnodes.size(); ++i) {
      algnodes[i]->temp = 0;
    }



    /*assert(0);*/
#endif

  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  MatType XFunctionInternal<PublicType, DerivedType, MatType, NodeType>::grad(int iind, int oind) {
    casadi_assert_message(output(oind).isscalar(),
                          "Only gradients of scalar functions allowed. Use jacobian instead.");

    // Quick return if trivially empty
    if (input(iind).nnz()==0 || output(oind).nnz()==0 ||
       jacSparsity(iind, oind, true, false).nnz()==0) {
      return MatType(input(iind).shape());
    }

    // Adjoint seeds
    typename std::vector<std::vector<MatType> > aseed(1, std::vector<MatType>(outputv_.size()));
    for (int i=0; i<outputv_.size(); ++i) {
      if (i==oind) {
        aseed[0][i] = MatType::ones(outputv_[i].sparsity());
      } else {
        aseed[0][i] = MatType::zeros(outputv_[i].sparsity());
      }
    }

    // Adjoint sensitivities
    std::vector<std::vector<MatType> > asens(1, std::vector<MatType>(inputv_.size()));
    for (int i=0; i<inputv_.size(); ++i) {
      asens[0][i] = MatType::zeros(inputv_[i].sparsity());
    }

    // Calculate with adjoint mode AD
    static_cast<DerivedType*>(this)->callReverse(inputv_, outputv_, aseed, asens, true, false);

    int dir = 0;
    for (int i=0; i<nIn(); ++i) { // Correct sparsities #1025
      if (asens[dir][i].sparsity()!=inputv_[i].sparsity()) {
        asens[dir][i] = project(asens[dir][i], inputv_[i].sparsity());
      }
    }

    // Return adjoint directional derivative
    return asens[0].at(iind);
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  MatType XFunctionInternal<PublicType, DerivedType, MatType, NodeType>::tang(int iind, int oind) {
    casadi_assert_message(input(iind).isscalar(),
                          "Only tangent of scalar input functions allowed. Use jacobian instead.");

    // Forward seeds
    typename std::vector<std::vector<MatType> > fseed(1, std::vector<MatType>(inputv_.size()));
    for (int i=0; i<inputv_.size(); ++i) {
      if (i==iind) {
        fseed[0][i] = MatType::ones(inputv_[i].sparsity());
      } else {
        fseed[0][i] = MatType::zeros(inputv_[i].sparsity());
      }
    }

    // Forward sensitivities
    std::vector<std::vector<MatType> > fsens(1, std::vector<MatType>(outputv_.size()));
    for (int i=0; i<outputv_.size(); ++i) {
      fsens[0][i] = MatType::zeros(outputv_[i].sparsity());
    }

    // Calculate with forward mode AD
    static_cast<DerivedType*>(this)->callForward(inputv_, outputv_, fseed, fsens, true, false);

    // Return adjoint directional derivative
    return fsens[0].at(oind);
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  MatType XFunctionInternal<PublicType, DerivedType, MatType, NodeType>
  ::jac(int iind, int oind, bool compact, bool symmetric, bool always_inline, bool never_inline) {
    using namespace std;
    if (verbose()) userOut() << "XFunctionInternal::jac begin" << std::endl;

    // Quick return if trivially empty
    if (input(iind).nnz()==0 || output(oind).nnz()==0) {
      std::pair<int, int> jac_shape;
      jac_shape.first = compact ? output(oind).nnz() : output(oind).numel();
      jac_shape.second = compact ? input(iind).nnz() : input(iind).numel();
      return MatType(jac_shape);
    }

    if (symmetric) {
      casadi_assert(output(oind).isdense());
    }

    // Create return object
    MatType ret = MatType::zeros(jacSparsity(iind, oind, compact, symmetric).T());
    if (verbose()) userOut() << "XFunctionInternal::jac allocated return value" << std::endl;

    // Quick return if empty
    if (ret.nnz()==0) {
      return ret.T();
    }

    // Get a bidirectional partition
    Sparsity D1, D2;
    getPartition(iind, oind, D1, D2, true, symmetric);
    if (verbose()) userOut() << "XFunctionInternal::jac graph coloring completed" << std::endl;

    // Get the number of forward and adjoint sweeps
    int nfdir = D1.isNull() ? 0 : D1.size2();
    int nadir = D2.isNull() ? 0 : D2.size2();

    // Number of derivative directions supported by the function
    int max_nfdir = CasadiOptions::optimized_num_dir;
    int max_nadir = CasadiOptions::optimized_num_dir;

    // Current forward and adjoint direction
    int offset_nfdir = 0, offset_nadir = 0;

    // Evaluation result (known)
    std::vector<MatType> res(outputv_);

    // Forward and adjoint seeds and sensitivities
    std::vector<std::vector<MatType> > fseed, aseed, fsens, asens;

    // Get the sparsity of the Jacobian block
    Sparsity jsp = jacSparsity(iind, oind, true, symmetric).T();
    const int* jsp_colind = jsp.colind();
    const int* jsp_row = jsp.row();

    // Input sparsity
    std::vector<int> input_col = input(iind).sparsity().getCol();
    const int* input_row = input(iind).row();

    // Output sparsity
    std::vector<int> output_col = output(oind).sparsity().getCol();
    const int* output_row = output(oind).row();

    // Get transposes and mappings for jacobian sparsity pattern if we are using forward mode
    if (verbose())   userOut() << "XFunctionInternal::jac transposes and mapping" << std::endl;
    std::vector<int> mapping;
    Sparsity jsp_trans;
    if (nfdir>0) {
      jsp_trans = jsp.transpose(mapping);
    }

    // The nonzeros of the sensitivity matrix
    std::vector<int> nzmap, nzmap2;

    // Additions to the jacobian matrix
    std::vector<int> adds, adds2;

    // Temporary vector
    std::vector<int> tmp;

    // Progress
    int progress = -10;

    // Number of sweeps
    int nsweep_fwd = nfdir/max_nfdir;   // Number of sweeps needed for the forward mode
    if (nfdir%max_nfdir>0) nsweep_fwd++;
    int nsweep_adj = nadir/max_nadir;   // Number of sweeps needed for the adjoint mode
    if (nadir%max_nadir>0) nsweep_adj++;
    int nsweep = std::max(nsweep_fwd, nsweep_adj);
    if (verbose())   userOut() << "XFunctionInternal::jac " << nsweep << " sweeps needed for "
                              << nfdir << " forward and " << nadir << " adjoint directions"
                              << std::endl;

    // Sparsity of the seeds
    vector<int> seed_col, seed_row;

    // Evaluate until everything has been determined
    for (int s=0; s<nsweep; ++s) {
      // Print progress
      if (verbose()) {
        int progress_new = (s*100)/nsweep;
        // Print when entering a new decade
        if (progress_new / 10 > progress / 10) {
          progress = progress_new;
          userOut() << progress << " %"  << std::endl;
        }
      }

      // Number of forward and adjoint directions in the current "batch"
      int nfdir_batch = std::min(nfdir - offset_nfdir, max_nfdir);
      int nadir_batch = std::min(nadir - offset_nadir, max_nadir);

      // Forward seeds
      fseed.resize(nfdir_batch);
      for (int d=0; d<nfdir_batch; ++d) {
        // Nonzeros of the seed matrix
        seed_col.clear();
        seed_row.clear();

        // For all the directions
        for (int el = D1.colind(offset_nfdir+d); el<D1.colind(offset_nfdir+d+1); ++el) {

          // Get the direction
          int c = D1.row(el);

          // Give a seed in the direction
          seed_col.push_back(input_col[c]);
          seed_row.push_back(input_row[c]);
        }

        // initialize to zero
        fseed[d].resize(nIn());
        for (int ind=0; ind<fseed[d].size(); ++ind) {
          int nrow = input(ind).size1(), ncol = input(ind).size2(); // Input dimensions
          if (ind==iind) {
            fseed[d][ind] = MatType::ones(Sparsity::triplet(nrow, ncol, seed_row, seed_col));
          } else {
            fseed[d][ind] = MatType(nrow, ncol);
          }
        }
      }

      // Adjoint seeds
      aseed.resize(nadir_batch);
      for (int d=0; d<nadir_batch; ++d) {
        // Nonzeros of the seed matrix
        seed_col.clear();
        seed_row.clear();

        // For all the directions
        for (int el = D2.colind(offset_nadir+d); el<D2.colind(offset_nadir+d+1); ++el) {

          // Get the direction
          int c = D2.row(el);

          // Give a seed in the direction
          seed_col.push_back(output_col[c]);
          seed_row.push_back(output_row[c]);
        }

        //initialize to zero
        aseed[d].resize(nOut());
        for (int ind=0; ind<aseed[d].size(); ++ind) {
          int nrow = output(ind).size1(), ncol = output(ind).size2(); // Output dimensions
          if (ind==oind) {
            aseed[d][ind] = MatType::ones(Sparsity::triplet(nrow, ncol, seed_row, seed_col));
          } else {
            aseed[d][ind] = MatType(nrow, ncol);
          }
        }
      }

      // Forward sensitivities
      fsens.resize(nfdir_batch);
      for (int d=0; d<nfdir_batch; ++d) {
        // initialize to zero
        fsens[d].resize(nOut());
        for (int oind=0; oind<fsens[d].size(); ++oind) {
          fsens[d][oind] = MatType::zeros(output(oind).sparsity());
        }
      }

      // Adjoint sensitivities
      asens.resize(nadir_batch);
      for (int d=0; d<nadir_batch; ++d) {
        // initialize to zero
        asens[d].resize(nIn());
        for (int ind=0; ind<asens[d].size(); ++ind) {
          asens[d][ind] = MatType::zeros(input(ind).sparsity());
        }
      }

      // Evaluate symbolically
      if (verbose()) userOut() << "XFunctionInternal::jac making function call" << std::endl;
      if (fseed.size()>0) {
        casadi_assert(aseed.size()==0);
        static_cast<DerivedType*>(this)->callForward(inputv_, outputv_,
                                                 fseed, fsens, always_inline, never_inline);
      } else if (aseed.size()>0) {
        casadi_assert(fseed.size()==0);
        static_cast<DerivedType*>(this)->callReverse(inputv_, outputv_,
                                                 aseed, asens, always_inline, never_inline);
      }

      // Carry out the forward sweeps
      for (int d=0; d<nfdir_batch; ++d) {

        // If symmetric, see how many times each output appears
        if (symmetric) {
          // Initialize to zero
          tmp.resize(output(oind).sparsity().nnz());
          fill(tmp.begin(), tmp.end(), 0);

          // "Multiply" Jacobian sparsity by seed vector
          for (int el = D1.colind(offset_nfdir+d); el<D1.colind(offset_nfdir+d+1); ++el) {

            // Get the input nonzero
            int c = D1.row(el);

            // Propagate dependencies
            for (int el_jsp=jsp_colind[c]; el_jsp<jsp_colind[c+1]; ++el_jsp) {
              tmp[jsp_row[el_jsp]]++;
            }
          }
        }

        // Locate the nonzeros of the forward sensitivity matrix
        output(oind).sparsity().find(nzmap);
        fsens[d][oind].sparsity().getNZ(nzmap);

        if (symmetric) {
          input(iind).sparsity().find(nzmap2);
          fsens[d][oind].sparsity().getNZ(nzmap2);
        }

        // Assignments to the Jacobian
        adds.resize(fsens[d][oind].nnz());
        fill(adds.begin(), adds.end(), -1);
        if (symmetric) {
          adds2.resize(adds.size());
          fill(adds2.begin(), adds2.end(), -1);
        }

        // For all the input nonzeros treated in the sweep
        for (int el = D1.colind(offset_nfdir+d); el<D1.colind(offset_nfdir+d+1); ++el) {

          // Get the input nonzero
          int c = D1.row(el);
          //int f2_out;
          //if (symmetric) {
          //  f2_out = nzmap2[c];
          //}

          // Loop over the output nonzeros corresponding to this input nonzero
          for (int el_out = jsp_trans.colind(c); el_out<jsp_trans.colind(c+1); ++el_out) {

            // Get the output nonzero
            int r_out = jsp_trans.row(el_out);

            // Get the forward sensitivity nonzero
            int f_out = nzmap[r_out];
            if (f_out<0) continue; // Skip if structurally zero

            // The nonzero of the Jacobian now treated
            int elJ = mapping[el_out];

            if (symmetric) {
              if (tmp[r_out]==1) {
                adds[f_out] = el_out;
                adds2[f_out] = elJ;
              }
            } else {
              // Get the output seed
              adds[f_out] = elJ;
            }
          }
        }

        // Get entries in fsens[d][oind] with nonnegative indices
        tmp.resize(adds.size());
        int sz = 0;
        for (int i=0; i<adds.size(); ++i) {
          if (adds[i]>=0) {
            adds[sz] = adds[i];
            tmp[sz++] = i;
          }
        }
        adds.resize(sz);
        tmp.resize(sz);

        // Add contribution to the Jacobian
        ret[adds] = fsens[d][oind][tmp];

        if (symmetric) {
          // Get entries in fsens[d][oind] with nonnegative indices
          tmp.resize(adds2.size());
          sz = 0;
          for (int i=0; i<adds2.size(); ++i) {
            if (adds2[i]>=0) {
              adds2[sz] = adds2[i];
              tmp[sz++] = i;
            }
          }
          adds2.resize(sz);
          tmp.resize(sz);

          // Add contribution to the Jacobian
          ret[adds2] = fsens[d][oind][tmp];
        }
      }

      // Add elements to the Jacobian matrix
      for (int d=0; d<nadir_batch; ++d) {

        // Locate the nonzeros of the adjoint sensitivity matrix
        input(iind).sparsity().find(nzmap);
        asens[d][iind].sparsity().getNZ(nzmap);

        // For all the output nonzeros treated in the sweep
        for (int el = D2.colind(offset_nadir+d); el<D2.colind(offset_nadir+d+1); ++el) {

          // Get the output nonzero
          int r = D2.row(el);

          // Loop over the input nonzeros that influences this output nonzero
          for (int elJ = jsp.colind(r); elJ<jsp.colind(r+1); ++elJ) {

            // Get the input nonzero
            int inz = jsp.row(elJ);

            // Get the corresponding adjoint sensitivity nonzero
            int anz = nzmap[inz];
            if (anz<0) continue;

            // Get the input seed
            ret.at(elJ) = asens[d][iind].at(anz);
          }
        }
      }

      // Update direction offsets
      offset_nfdir += nfdir_batch;
      offset_nadir += nadir_batch;
    }

    // Return
    if (verbose()) userOut() << "XFunctionInternal::jac end" << std::endl;
    return ret.T();
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  Function XFunctionInternal<PublicType, DerivedType, MatType, NodeType>
  ::getGradient(const std::string& name, int iind, int oind, const Dict& opts) {
    // Create expressions for the gradient
    std::vector<MatType> ret_out;
    ret_out.reserve(1+outputv_.size());
    ret_out.push_back(grad(iind, oind));
    ret_out.insert(ret_out.end(), outputv_.begin(), outputv_.end());

    // Return function
    return PublicType(name, inputv_, ret_out, opts);
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  Function XFunctionInternal<PublicType, DerivedType, MatType, NodeType>
  ::getTangent(const std::string& name, int iind, int oind, const Dict& opts) {
    // Create expressions for the gradient
    std::vector<MatType> ret_out;
    ret_out.reserve(1+outputv_.size());
    ret_out.push_back(tang(iind, oind));
    ret_out.insert(ret_out.end(), outputv_.begin(), outputv_.end());

    // Return function
    return PublicType(name, inputv_, ret_out, opts);
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  Function XFunctionInternal<PublicType, DerivedType, MatType, NodeType>
  ::getJacobian(const std::string& name, int iind, int oind, bool compact, bool symmetric,
              const Dict& opts) {
    // Return function expression
    std::vector<MatType> ret_out;
    ret_out.reserve(1+outputv_.size());
    ret_out.push_back(jac(iind, oind, compact, symmetric));
    ret_out.insert(ret_out.end(), outputv_.begin(), outputv_.end());

    // Return function
    return PublicType(name, inputv_, ret_out, opts);
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  Function XFunctionInternal<PublicType, DerivedType, MatType, NodeType>
  ::getDerForward(const std::string& name, int nfwd, Dict& opts) {
    // Seeds
    std::vector<std::vector<MatType> > fseed = symbolicFwdSeed(nfwd, inputv_), fsens;

    // Evaluate symbolically
    static_cast<DerivedType*>(this)->evalFwd(fseed, fsens);
    casadi_assert(fsens.size()==fseed.size());

    // Number inputs and outputs
    int num_in = nIn();
    int num_out = nOut();

    // All inputs of the return function
    std::vector<MatType> ret_in;
    ret_in.reserve(num_in + num_out + nfwd*num_in);
    ret_in.insert(ret_in.end(), inputv_.begin(), inputv_.end());
    for (int i=0; i<num_out; ++i) {
      std::stringstream ss;
      ss << "dummy_output_" << i;
      ret_in.push_back(MatType::sym(ss.str(), Sparsity(outputv_.at(i).shape())));
    }
    for (int d=0; d<nfwd; ++d)
      ret_in.insert(ret_in.end(), fseed[d].begin(), fseed[d].end());

    // All outputs of the return function
    std::vector<MatType> ret_out;
    ret_out.reserve(num_out*nfwd);
    for (int d=0; d<nfwd; ++d) {
      ret_out.insert(ret_out.end(), fsens[d].begin(), fsens[d].end());
    }

    // Assemble function and return
    return PublicType(name, ret_in, ret_out, opts);
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  Function XFunctionInternal<PublicType, DerivedType, MatType, NodeType>
  ::getDerReverse(const std::string& name, int nadj, Dict& opts) {
    // Seeds
    std::vector<std::vector<MatType> > aseed = symbolicAdjSeed(nadj, outputv_), asens;

    // Evaluate symbolically
    static_cast<DerivedType*>(this)->evalAdj(aseed, asens);

    // Number inputs and outputs
    int num_in = nIn();
    int num_out = nOut();

    // All inputs of the return function
    std::vector<MatType> ret_in;
    ret_in.reserve(num_in + num_out + nadj*num_out);
    ret_in.insert(ret_in.end(), inputv_.begin(), inputv_.end());
    for (int i=0; i<num_out; ++i) {
      std::stringstream ss;
      ss << "dummy_output_" << i;
      ret_in.push_back(MatType::sym(ss.str(), Sparsity(outputv_.at(i).shape())));
    }
    for (int d=0; d<nadj; ++d)
      ret_in.insert(ret_in.end(), aseed[d].begin(), aseed[d].end());

    // All outputs of the return function
    std::vector<MatType> ret_out;
    ret_out.reserve(num_in*nadj);
    for (int d=0; d<nadj; ++d) {
      ret_out.insert(ret_out.end(), asens[d].begin(), asens[d].end());
    }

    // Assemble function and return
    return PublicType(name, ret_in, ret_out, opts);
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  bool XFunctionInternal<PublicType, DerivedType, MatType, NodeType>
  ::isInput(const std::vector<MatType>& arg) const {
    // Check if arguments matches the input expressions, in which case
    // the output is known to be the output expressions
    const int checking_depth = 2;
    for (int i=0; i<arg.size(); ++i) {
      if (!isEqual(arg[i], inputv_[i], checking_depth)) {
        return false;
      }
    }
    return true;
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  void XFunctionInternal<PublicType, DerivedType, MatType, NodeType>::
  callForward(const std::vector<MatType>& arg, const std::vector<MatType>& res,
          const std::vector<std::vector<MatType> >& fseed,
          std::vector<std::vector<MatType> >& fsens,
          bool always_inline, bool never_inline) {
    casadi_assert_message(!(always_inline && never_inline), "Inconsistent options");
    bool inline_function = always_inline;     // TODO(@jaeandersson): Add logic for inlining

    // Quick return if no seeds
    if (fseed.empty()) {
      fsens.clear();
      return;
    }

    // The non-inlining version is implemented in the base class
    if (!inline_function) {
      return FunctionInternal::callForward(arg, res, fseed, fsens, always_inline, never_inline);
    }

    if (isInput(arg)) {
      // Argument agrees with inputv_, call evalFwd directly
      static_cast<DerivedType*>(this)->evalFwd(fseed, fsens);
    } else {
      // Need to create a temporary function
      PublicType f("tmp", arg, res);
      f->evalFwd(fseed, fsens);
    }
  }

  template<typename PublicType, typename DerivedType, typename MatType, typename NodeType>
  void XFunctionInternal<PublicType, DerivedType, MatType, NodeType>::
  callReverse(const std::vector<MatType>& arg, const std::vector<MatType>& res,
          const std::vector<std::vector<MatType> >& aseed,
          std::vector<std::vector<MatType> >& asens,
          bool always_inline, bool never_inline) {
    casadi_assert_message(!(always_inline && never_inline), "Inconsistent options");
    bool inline_function = always_inline;     // TODO(@jaeandersson): Add logic for inlining

    // Quick return if no seeds
    if (aseed.empty()) {
      asens.clear();
      return;
    }

    // The non-inlining version is implemented in the base class
    if (!inline_function) {
      return FunctionInternal::callReverse(arg, res, aseed, asens, always_inline, never_inline);
    }

    if (isInput(arg)) {
      // Argument agrees with inputv_, call evalAdj directly
      static_cast<DerivedType*>(this)->evalAdj(aseed, asens);
    } else {
      // Need to create a temporary function
      PublicType f("tmp", arg, res);
      f->evalAdj(aseed, asens);
    }
  }

#endif

} // namespace casadi
/// \endcond

#endif // CASADI_X_FUNCTION_INTERNAL_HPP
