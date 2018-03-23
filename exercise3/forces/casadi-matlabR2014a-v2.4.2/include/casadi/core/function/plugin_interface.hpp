/*
 *    This file is part of CasADi.
 *
 *    CasADi -- A symbolic framework for dynamic optimization.
 *    Copyright (C) 2010 by Joel Andersson, Moritz Diehl, K.U.Leuven. All rights reserved.
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

#ifndef CASADI_PLUGIN_INTERFACE_HPP
#define CASADI_PLUGIN_INTERFACE_HPP

#include "../function/function_internal.hpp"
#include "../casadi_options.hpp"
#include "wrapper.hpp"
#include "adaptor.hpp"

#include <stdlib.h>

/// \cond INTERNAL

// For dynamic loading
#ifdef WITH_DL
#ifdef _WIN32 // also for 64-bit
#define NOMINMAX
#include <windows.h>
#else // _WIN32
#include <dlfcn.h>
#endif // _WIN32

// Set default shared library prefix
#ifndef SHARED_LIBRARY_PREFIX
#define SHARED_LIBRARY_PREFIX "lib"
#endif // SHARED_LIBRARY_PREFIX

// Set default shared library suffix
#ifndef SHARED_LIBRARY_SUFFIX
#define SHARED_LIBRARY_SUFFIX ".so"
#endif // SHARED_LIBRARY_SUFFIX

#endif // WITH_DL

namespace casadi {
  // Avoid segmentation faults when exposed function not implemented
  template<typename T>
  T check_exposed(T t) {
    casadi_assert_message(t!=0, "Static function not implemented for plugin");
    return t;
  }

  /** \brief Interface for accessing input and output data structures
      \author Joel Andersson
      \date 2013
  */
  template<class Derived>
  class CASADI_EXPORT PluginInterface {
    public:

    /// Fields
    struct Plugin{
      typename Derived::Creator creator;
      const char* name;
      const char* doc;
      int version;
      typename Derived::Exposed exposed;
      bool (*adaptorHasPlugin)(const std::string& name);
    };

    // Plugin registration function
    typedef int (*RegFcn)(Plugin* plugin);

    /// Check if a plugin is available or can be loaded
    static bool hasPlugin(const std::string& name, bool verbose=false);

    /// Instantiate a Plugin struct from a factory function
    static Plugin pluginFromRegFcn(RegFcn regfcn);

    /// Load a plugin dynamically
    static Plugin loadPlugin(const std::string& name, bool register_plugin=true);

    /// Register an integrator in the factory
    static void registerPlugin(const Plugin& plugin);

    /// Register an integrator in the factory
    static void registerPlugin(RegFcn regfcn);

    /// Load and get the creator function
    static Plugin& getPlugin(const std::string& name);

    // Create solver instance
    template<class Problem>
      static Derived* instantiatePlugin(const std::string& name, Problem problem);
  };

  template<class Derived>
  bool PluginInterface<Derived>::hasPlugin(const std::string& name, bool verbose) {

    // Check if any dot in the name, i.e. an adaptor
    std::string::size_type dotpos = name.find(".");

    std::string short_name = name.substr(0, dotpos);

    // Quick return if available
    if (Derived::solvers_.find(short_name) != Derived::solvers_.end()) {
      return true;
    }

    // Try loading the plugin
    try {
      Plugin plugin = loadPlugin(short_name, false);
      // Do a recursion if the name contains dots
      if (plugin.adaptorHasPlugin!=0 && dotpos!=std::string::npos) {
        return plugin.adaptorHasPlugin(name.substr(dotpos+1));
      }
      return true;
    } catch (CasadiException& ex) {
      if (verbose) {
        casadi_warning(ex.what());
      }
      return false;
    }

  }

  template<class Derived>
  typename PluginInterface<Derived>::Plugin
      PluginInterface<Derived>::pluginFromRegFcn(RegFcn regfcn) {
    // Create a temporary struct
    Plugin plugin;
    plugin.adaptorHasPlugin = 0;

    // Set the fields
    int flag = regfcn(&plugin);
    casadi_assert(flag==0);

    return plugin;
  }

  template<class Derived>
  typename PluginInterface<Derived>::Plugin
      PluginInterface<Derived>::loadPlugin(const std::string& name, bool register_plugin) {
    // Issue warning and quick return if already loaded
    if (Derived::solvers_.find(name) != Derived::solvers_.end()) {
      casadi_warning("PluginInterface: Solver " + name + " is already in use. Ignored.");
      return Plugin();
    }


#ifndef WITH_DL
    casadi_error("WITH_DL option needed for dynamic loading");
#else // WITH_DL
    // Retrieve the registration function
    RegFcn reg;

    // Get the name of the shared library
    std::string lib = SHARED_LIBRARY_PREFIX "casadi_"
      + Derived::infix_ + "_" + name + SHARED_LIBRARY_SUFFIX;

    // Load the dll
    std::string regName = "casadi_register_" + Derived::infix_ + "_" + name;

    // Build up search paths;
    std::vector<std::string> search_paths;

    #ifdef _WIN32
    char pathsep = ';';
    const std::string filesep("\\");
    #else
    char pathsep = ':';
    const std::string filesep("/");
    #endif

    // Search path: global casadipath option
    std::stringstream casadipaths(CasadiOptions::getCasadiPath());
    std::string casadipath;
    while (std::getline(casadipaths, casadipath, pathsep)) {
      search_paths.push_back(casadipath);
    }

    // Search path: CASADIPATH env variable
    char* pLIBDIR;
    pLIBDIR = getenv("CASADIPATH");

    if (pLIBDIR!=0) {
      std::stringstream casadipaths(pLIBDIR);
      std::string casadipath;
      while (std::getline(casadipaths, casadipath, pathsep)) {
        search_paths.push_back(casadipath);
      }
    }

    // Search path: bare
    search_paths.push_back("");

    // Search path : PLUGIN_EXTRA_SEARCH_PATH
    #ifdef PLUGIN_EXTRA_SEARCH_PATH
    search_paths.push_back(
      std::string("") + PLUGIN_EXTRA_SEARCH_PATH);
    #endif // PLUGIN_EXTRA_SEARCH_PATH

    // Search path : current directory
    search_paths.push_back(".");

    // Prepare error string
    std::stringstream errors;
    errors << "PluginInterface::loadPlugin: Cannot load shared library '"
           << lib << "': " << std::endl;
    errors << "   (\n"
           << "    Searched directories: 1. casadipath from CasadiOptions\n"
           << "                          2. CASADIPATH env var\n"
           << "                          3. PATH env var (Windows)\n"
           << "                          4. LD_LIBRARY_PATH env var (Linux)\n"
           << "    A library may be 'not found' even if the file exists:\n"
           << "          * library is not compatible (different compiler/bitness)\n"
           << "          * the dependencies are not found\n"
           << "   )";

    // Alocate a handle pointer
#ifdef _WIN32
    HINSTANCE handle = 0;
#else // _WIN32
    void * handle = 0;
#endif

    // Alocate a handle pointer
#ifndef _WIN32
    int flag = RTLD_LAZY | RTLD_LOCAL;
#ifdef WITH_DEEPBIND
    flag |= RTLD_DEEPBIND;
#endif
#endif

    std::string searchpath;

    // Try getting a handle
    for (int i=0;i<search_paths.size();++i) {
      searchpath = search_paths[i];
#ifdef _WIN32
      SetDllDirectory(TEXT(searchpath.c_str()));
      handle = LoadLibrary(TEXT(lib.c_str()));
      SetDllDirectory(NULL);
#else // _WIN32
      std::string name = searchpath.size()==0 ? lib : searchpath + filesep + lib;
      handle = dlopen(name.c_str(), flag);
#endif // _WIN32
      if (handle) {
        break;
      } else {
        errors << std::endl << "  Tried '" << searchpath << "' :";
#ifdef _WIN32
        errors << std::endl << "    Error code (WIN32): " << STRING(GetLastError());
#else // _WIN32
        errors << std::endl << "    Error code: " << dlerror();
#endif // _WIN32
      }
    }

    casadi_assert_message(handle!=0, errors.str());

#ifdef _WIN32
    reg = (RegFcn)GetProcAddress(handle, TEXT(regName.c_str()));
#else // _WIN32
    // Reset error
    dlerror();

    // Load creator
    reg = (RegFcn)dlsym(handle, regName.c_str());
#endif // _WIN32
    casadi_assert_message(reg!=0,
      "PluginInterface::loadPlugin: no \"" + regName + "\" found in " + searchpath + ".");

    // Create a temporary struct
    Plugin plugin = pluginFromRegFcn(reg);
    // Register the plugin
    if (register_plugin) {
      registerPlugin(plugin);
    }

    return plugin;

#endif // WITH_DL
  }

  template<class Derived>
  void PluginInterface<Derived>::registerPlugin(RegFcn regfcn) {
    registerPlugin(pluginFromRegFcn(regfcn));
  }

  template<class Derived>
  void PluginInterface<Derived>::registerPlugin(const Plugin& plugin) {

    // Check if the solver name is in use
    typename std::map<std::string, Plugin>::iterator it=Derived::solvers_.find(plugin.name);
    casadi_assert_message(it==Derived::solvers_.end(),
                          "Solver " << plugin.name << " is already in use");

    // Add to list of solvers
    Derived::solvers_[plugin.name] = plugin;
  }

  template<class Derived>
  typename PluginInterface<Derived>::Plugin&
  PluginInterface<Derived>::getPlugin(const std::string& name) {


    // Check if any dot in the name, i.e. an adaptor
    std::string::size_type dotpos = name.find(".");
    if (dotpos != std::string::npos) return getPlugin(name.substr(0, dotpos));

    // Check if the solver has been loaded
    typename std::map<std::string, Plugin>::iterator it=Derived::solvers_.find(name);

    // Load the solver if needed
    if (it==Derived::solvers_.end()) {
      loadPlugin(name);
      it=Derived::solvers_.find(name);
    }
    casadi_assert(it!=Derived::solvers_.end());
    return it->second;
  }

  template<class Derived>
  template<class Problem>
  Derived*
  PluginInterface<Derived>::instantiatePlugin(const std::string& name, Problem problem) {

    // Assert the plugin exists (needed for adaptors)
    if (!hasPlugin(name, true)) {
      casadi_error("Plugin '" << name << "' is not found.");
    }

    // Check if any dot in the name, i.e. an adaptor
    std::string::size_type dotpos = name.find(".");
    if (dotpos == std::string::npos) {
      // No dot, normal instantiation
      return getPlugin(name).creator(problem);
    } else {
      // Dot present, separate adaptor name from solver name
      std::string adaptor_name = name.substr(0, dotpos);
      std::string solver_name = name.substr(dotpos+1);

      // Load the adaptor
      Derived* adaptor = getPlugin(adaptor_name).creator(problem);

      // Pass solver name to adaptor
      if (adaptor->getAdaptorSolverName().size()==0) {
        adaptor->setOption(adaptor_name + "_solver", solver_name);
      } else {
        adaptor->setOption(adaptor->getAdaptorSolverName(), solver_name);
      }
      return adaptor;
    }
  }


} // namespace casadi

/// \endcond

#endif // CASADI_PLUGIN_INTERFACE_HPP
