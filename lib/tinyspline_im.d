/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.12
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

module tinyspline_im;
static import core.stdc.config;

static import std.conv;

static import std.conv;
static import std.string;


private {
  version(linux) {
    version = Nix;
  } else version(darwin) {
    version = Nix;
  } else version(OSX) {
    version = Nix;
  } else version(FreeBSD) {
    version = Nix;
    version = freebsd;
  } else version(freebsd) {
    version = Nix;
  } else version(Unix) {
    version = Nix;
  } else version(Posix) {
    version = Nix;
  }

  version(Tango) {
    static import tango.stdc.string;
    static import tango.stdc.stringz;

    version (PhobosCompatibility) {
    } else {
      alias char[] string;
      alias wchar[] wstring;
      alias dchar[] dstring;
    }
  } else {
    version(D_Version2) {
      static import std.conv;
    }
    static import std.string;
    static import std.c.string;
  }

  version(D_Version2) {
    mixin("alias const(char)* CCPTR;");
  } else {
    alias char* CCPTR;
  }

  CCPTR swigToCString(string str) {
    version(Tango) {
      return tango.stdc.stringz.toStringz(str);
    } else {
      return std.string.toStringz(str);
    }
  }

  string swigToDString(CCPTR cstr) {
    version(Tango) {
      return tango.stdc.stringz.fromStringz(cstr);
    } else {
      version(D_Version2) {
        mixin("return std.conv.to!string(cstr);");
      } else {
        return std.c.string.toString(cstr);
      }
    }
  }
}

class SwigSwigSharedLibLoadException : Exception {
  this(in string[] libNames, in string[] reasons) {
    string msg = "Failed to load one or more shared libraries:";
    foreach(i, n; libNames) {
      msg ~= "\n\t" ~ n ~ " - ";
      if(i < reasons.length)
        msg ~= reasons[i];
      else
        msg ~= "Unknown";
    }
    super(msg);
  }
}

class SwigSymbolLoadException : Exception {
  this(string SwigSharedLibName, string symbolName) {
    super("Failed to load symbol " ~ symbolName ~ " from shared library " ~ SwigSharedLibName);
    _symbolName = symbolName;
  }

  string symbolName() {
    return _symbolName;
  }

private:
  string _symbolName;
}

private {
  version(Nix) {
    version(freebsd) {
      // the dl* functions are in libc on FreeBSD
    }
    else {
      pragma(lib, "dl");
    }

    version(Tango) {
      import tango.sys.Common;
    } else version(linux) {
      import std.c.linux.linux;
    } else {
      extern(C) {
        const RTLD_NOW = 2;

        void *dlopen(CCPTR file, int mode);
        int dlclose(void* handle);
        void *dlsym(void* handle, CCPTR name);
        CCPTR dlerror();
      }
    }

    alias void* SwigSharedLibHandle;

    SwigSharedLibHandle swigLoadSharedLib(string libName) {
      return dlopen(swigToCString(libName), RTLD_NOW);
    }

    void swigUnloadSharedLib(SwigSharedLibHandle hlib) {
      dlclose(hlib);
    }

    void* swigGetSymbol(SwigSharedLibHandle hlib, string symbolName) {
      return dlsym(hlib, swigToCString(symbolName));
    }

    string swigGetErrorStr() {
      CCPTR err = dlerror();
      if (err is null) {
        return "Unknown Error";
      }
      return swigToDString(err);
    }
  } else version(Windows) {
    alias ushort WORD;
    alias uint DWORD;
    alias CCPTR LPCSTR;
    alias void* HMODULE;
    alias void* HLOCAL;
    alias int function() FARPROC;
    struct VA_LIST {}

    extern (Windows) {
      HMODULE LoadLibraryA(LPCSTR);
      FARPROC GetProcAddress(HMODULE, LPCSTR);
      void FreeLibrary(HMODULE);
      DWORD GetLastError();
      DWORD FormatMessageA(DWORD, in void*, DWORD, DWORD, LPCSTR, DWORD, VA_LIST*);
      HLOCAL LocalFree(HLOCAL);
    }

    DWORD MAKELANGID(WORD p, WORD s) {
      return (((cast(WORD)s) << 10) | cast(WORD)p);
    }

    enum {
      LANG_NEUTRAL                    = 0,
      SUBLANG_DEFAULT                 = 1,
      FORMAT_MESSAGE_ALLOCATE_BUFFER  = 256,
      FORMAT_MESSAGE_IGNORE_INSERTS   = 512,
      FORMAT_MESSAGE_FROM_SYSTEM      = 4096
    }

    alias HMODULE SwigSharedLibHandle;

    SwigSharedLibHandle swigLoadSharedLib(string libName) {
      return LoadLibraryA(swigToCString(libName));
    }

    void swigUnloadSharedLib(SwigSharedLibHandle hlib) {
      FreeLibrary(hlib);
    }

    void* swigGetSymbol(SwigSharedLibHandle hlib, string symbolName) {
      return GetProcAddress(hlib, swigToCString(symbolName));
    }

    string swigGetErrorStr() {
      DWORD errcode = GetLastError();

      LPCSTR msgBuf;
      DWORD i = FormatMessageA(
        FORMAT_MESSAGE_ALLOCATE_BUFFER |
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        null,
        errcode,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        cast(LPCSTR)&msgBuf,
        0,
        null);

      string text = swigToDString(msgBuf);
      LocalFree(cast(HLOCAL)msgBuf);

      if (i >= 2) {
        i -= 2;
      }
      return text[0 .. i];
    }
  } else {
    static assert(0, "Operating system not supported by the wrapper loading code.");
  }

  final class SwigSharedLib {
    void load(string[] names) {
      if (_hlib !is null) return;

      string[] failedLibs;
      string[] reasons;

      foreach(n; names) {
        _hlib = swigLoadSharedLib(n);
        if (_hlib is null) {
          failedLibs ~= n;
          reasons ~= swigGetErrorStr();
          continue;
        }
        _name = n;
        break;
      }

      if (_hlib is null) {
        throw new SwigSwigSharedLibLoadException(failedLibs, reasons);
      }
    }

    void* loadSymbol(string symbolName, bool doThrow = true) {
      void* sym = swigGetSymbol(_hlib, symbolName);
      if(doThrow && (sym is null)) {
        throw new SwigSymbolLoadException(_name, symbolName);
      }
      return sym;
    }

    void unload() {
      if(_hlib !is null) {
        swigUnloadSharedLib(_hlib);
        _hlib = null;
      }
    }

  private:
    string _name;
    SwigSharedLibHandle _hlib;
  }
}

static this() {
  string[] possibleFileNames;
  version (Posix) {
    version (OSX) {
      possibleFileNames ~= ["libtinysplinedlang.dylib", "libtinysplinedlang.bundle"];
    }
    possibleFileNames ~= ["libtinysplinedlang.so"];
  } else version (Windows) {
    possibleFileNames ~= ["tinysplinedlang.dll", "libtinysplinedlang.so"];
  } else {
    static assert(false, "Operating system not supported by the wrapper loading code.");
  }

  auto library = new SwigSharedLib;
  library.load(possibleFileNames);

  string bindCode(string functionPointer, string symbol) {
    return functionPointer ~ " = cast(typeof(" ~ functionPointer ~
      "))library.loadSymbol(`" ~ symbol ~ "`);";
  }

  //#if !defined(SWIG_D_NO_EXCEPTION_HELPER)
  mixin(bindCode("swigRegisterExceptionCallbackstinyspline", "SWIGRegisterExceptionCallbacks_tinyspline"));
  //#endif // SWIG_D_NO_EXCEPTION_HELPER
  //#if !defined(SWIG_D_NO_STRING_HELPER)
  mixin(bindCode("swigRegisterStringCallbacktinyspline", "SWIGRegisterStringCallback_tinyspline"));
  //#endif // SWIG_D_NO_STRING_HELPER
  
  mixin(bindCode("TS_MAX_NUM_KNOTS_get", "D_TS_MAX_NUM_KNOTS_get"));
  mixin(bindCode("TS_MIN_KNOT_VALUE_get", "D_TS_MIN_KNOT_VALUE_get"));
  mixin(bindCode("TS_MAX_KNOT_VALUE_get", "D_TS_MAX_KNOT_VALUE_get"));
  mixin(bindCode("TS_KNOT_EPSILON_get", "D_TS_KNOT_EPSILON_get"));
  mixin(bindCode("ts_bspline_degree", "D_ts_bspline_degree"));
  mixin(bindCode("ts_bspline_set_degree", "D_ts_bspline_set_degree"));
  mixin(bindCode("ts_bspline_order", "D_ts_bspline_order"));
  mixin(bindCode("ts_bspline_set_order", "D_ts_bspline_set_order"));
  mixin(bindCode("ts_bspline_dimension", "D_ts_bspline_dimension"));
  mixin(bindCode("ts_bspline_set_dimension", "D_ts_bspline_set_dimension"));
  mixin(bindCode("ts_bspline_len_control_points", "D_ts_bspline_len_control_points"));
  mixin(bindCode("ts_bspline_num_control_points", "D_ts_bspline_num_control_points"));
  mixin(bindCode("ts_bspline_sof_control_points", "D_ts_bspline_sof_control_points"));
  mixin(bindCode("ts_bspline_control_points", "D_ts_bspline_control_points"));
  mixin(bindCode("ts_bspline_control_point_at", "D_ts_bspline_control_point_at"));
  mixin(bindCode("ts_bspline_set_control_points", "D_ts_bspline_set_control_points"));
  mixin(bindCode("ts_bspline_set_control_point_at", "D_ts_bspline_set_control_point_at"));
  mixin(bindCode("ts_bspline_num_knots", "D_ts_bspline_num_knots"));
  mixin(bindCode("ts_bspline_sof_knots", "D_ts_bspline_sof_knots"));
  mixin(bindCode("ts_bspline_knots", "D_ts_bspline_knots"));
  mixin(bindCode("ts_bspline_set_knots", "D_ts_bspline_set_knots"));
  mixin(bindCode("ts_deboornet_knot", "D_ts_deboornet_knot"));
  mixin(bindCode("ts_deboornet_index", "D_ts_deboornet_index"));
  mixin(bindCode("ts_deboornet_multiplicity", "D_ts_deboornet_multiplicity"));
  mixin(bindCode("ts_deboornet_num_insertions", "D_ts_deboornet_num_insertions"));
  mixin(bindCode("ts_deboornet_dimension", "D_ts_deboornet_dimension"));
  mixin(bindCode("ts_deboornet_len_points", "D_ts_deboornet_len_points"));
  mixin(bindCode("ts_deboornet_num_points", "D_ts_deboornet_num_points"));
  mixin(bindCode("ts_deboornet_sof_points", "D_ts_deboornet_sof_points"));
  mixin(bindCode("ts_deboornet_points", "D_ts_deboornet_points"));
  mixin(bindCode("ts_deboornet_len_result", "D_ts_deboornet_len_result"));
  mixin(bindCode("ts_deboornet_num_result", "D_ts_deboornet_num_result"));
  mixin(bindCode("ts_deboornet_sof_result", "D_ts_deboornet_sof_result"));
  mixin(bindCode("ts_deboornet_result", "D_ts_deboornet_result"));
  mixin(bindCode("ts_bspline_init", "D_ts_bspline_init"));
  mixin(bindCode("ts_bspline_new", "D_ts_bspline_new"));
  mixin(bindCode("ts_bspline_copy", "D_ts_bspline_copy"));
  mixin(bindCode("ts_bspline_move", "D_ts_bspline_move"));
  mixin(bindCode("ts_bspline_free", "D_ts_bspline_free"));
  mixin(bindCode("ts_deboornet_init", "D_ts_deboornet_init"));
  mixin(bindCode("ts_deboornet_copy", "D_ts_deboornet_copy"));
  mixin(bindCode("ts_deboornet_move", "D_ts_deboornet_move"));
  mixin(bindCode("ts_deboornet_free", "D_ts_deboornet_free"));
  mixin(bindCode("ts_bspline_interpolate_cubic", "D_ts_bspline_interpolate_cubic"));
  mixin(bindCode("ts_bspline_eval", "D_ts_bspline_eval"));
  mixin(bindCode("ts_bspline_domain_min", "D_ts_bspline_domain_min"));
  mixin(bindCode("ts_bspline_domain_max", "D_ts_bspline_domain_max"));
  mixin(bindCode("ts_bspline_is_closed", "D_ts_bspline_is_closed"));
  mixin(bindCode("ts_bspline_derive", "D_ts_bspline_derive"));
  mixin(bindCode("ts_bspline_insert_knot", "D_ts_bspline_insert_knot"));
  mixin(bindCode("ts_bspline_split", "D_ts_bspline_split"));
  mixin(bindCode("ts_bspline_buckle", "D_ts_bspline_buckle"));
  mixin(bindCode("ts_bspline_to_beziers", "D_ts_bspline_to_beziers"));
  mixin(bindCode("ts_bspline_to_json", "D_ts_bspline_to_json"));
  mixin(bindCode("ts_bspline_from_json", "D_ts_bspline_from_json"));
  mixin(bindCode("ts_bspline_save_json", "D_ts_bspline_save_json"));
  mixin(bindCode("ts_bspline_load_json", "D_ts_bspline_load_json"));
  mixin(bindCode("ts_fequals", "D_ts_fequals"));
  mixin(bindCode("ts_arr_fill", "D_ts_arr_fill"));
  mixin(bindCode("ts_ctrlp_dist2", "D_ts_ctrlp_dist2"));
  mixin(bindCode("new_DeBoorNet", "D_new_DeBoorNet"));
  mixin(bindCode("delete_DeBoorNet", "D_delete_DeBoorNet"));
  mixin(bindCode("DeBoorNet_knot", "D_DeBoorNet_knot"));
  mixin(bindCode("DeBoorNet_index", "D_DeBoorNet_index"));
  mixin(bindCode("DeBoorNet_multiplicity", "D_DeBoorNet_multiplicity"));
  mixin(bindCode("DeBoorNet_numInsertions", "D_DeBoorNet_numInsertions"));
  mixin(bindCode("DeBoorNet_dimension", "D_DeBoorNet_dimension"));
  mixin(bindCode("DeBoorNet_points", "D_DeBoorNet_points"));
  mixin(bindCode("DeBoorNet_result", "D_DeBoorNet_result"));
  mixin(bindCode("new_BSpline__SWIG_0", "D_new_BSpline__SWIG_0"));
  mixin(bindCode("new_BSpline__SWIG_1", "D_new_BSpline__SWIG_1"));
  mixin(bindCode("new_BSpline__SWIG_2", "D_new_BSpline__SWIG_2"));
  mixin(bindCode("new_BSpline__SWIG_3", "D_new_BSpline__SWIG_3"));
  mixin(bindCode("new_BSpline__SWIG_4", "D_new_BSpline__SWIG_4"));
  mixin(bindCode("new_BSpline__SWIG_5", "D_new_BSpline__SWIG_5"));
  mixin(bindCode("delete_BSpline", "D_delete_BSpline"));
  mixin(bindCode("BSpline_opCall", "D_BSpline_opCall"));
  mixin(bindCode("BSpline_degree", "D_BSpline_degree"));
  mixin(bindCode("BSpline_order", "D_BSpline_order"));
  mixin(bindCode("BSpline_dimension", "D_BSpline_dimension"));
  mixin(bindCode("BSpline_controlPoints", "D_BSpline_controlPoints"));
  mixin(bindCode("BSpline_controlPointAt", "D_BSpline_controlPointAt"));
  mixin(bindCode("BSpline_knots", "D_BSpline_knots"));
  mixin(bindCode("BSpline_eval", "D_BSpline_eval"));
  mixin(bindCode("BSpline_domainMin", "D_BSpline_domainMin"));
  mixin(bindCode("BSpline_domainMax", "D_BSpline_domainMax"));
  mixin(bindCode("BSpline_isClosed__SWIG_0", "D_BSpline_isClosed__SWIG_0"));
  mixin(bindCode("BSpline_isClosed__SWIG_1", "D_BSpline_isClosed__SWIG_1"));
  mixin(bindCode("BSpline_toJSON", "D_BSpline_toJSON"));
  mixin(bindCode("BSpline_fromJSON", "D_BSpline_fromJSON"));
  mixin(bindCode("BSpline_save", "D_BSpline_save"));
  mixin(bindCode("BSpline_load", "D_BSpline_load"));
  mixin(bindCode("BSpline_setControlPoints", "D_BSpline_setControlPoints"));
  mixin(bindCode("BSpline_setControlPointAt", "D_BSpline_setControlPointAt"));
  mixin(bindCode("BSpline_setKnots", "D_BSpline_setKnots"));
  mixin(bindCode("BSpline_insertKnot", "D_BSpline_insertKnot"));
  mixin(bindCode("BSpline_split", "D_BSpline_split"));
  mixin(bindCode("BSpline_buckle", "D_BSpline_buckle"));
  mixin(bindCode("BSpline_toBeziers", "D_BSpline_toBeziers"));
  mixin(bindCode("BSpline_derive__SWIG_0", "D_BSpline_derive__SWIG_0"));
  mixin(bindCode("BSpline_derive__SWIG_1", "D_BSpline_derive__SWIG_1"));
  mixin(bindCode("Utils_interpolateCubic", "D_Utils_interpolateCubic"));
  mixin(bindCode("Utils_fequals", "D_Utils_fequals"));
  mixin(bindCode("delete_Utils", "D_delete_Utils"));
  mixin(bindCode("Vector_empty", "D_Vector_empty"));
  mixin(bindCode("Vector_clear", "D_Vector_clear"));
  mixin(bindCode("Vector_push_back", "D_Vector_push_back"));
  mixin(bindCode("Vector_pop_back", "D_Vector_pop_back"));
  mixin(bindCode("Vector_size", "D_Vector_size"));
  mixin(bindCode("Vector_capacity", "D_Vector_capacity"));
  mixin(bindCode("Vector_reserve", "D_Vector_reserve"));
  mixin(bindCode("new_Vector__SWIG_0", "D_new_Vector__SWIG_0"));
  mixin(bindCode("new_Vector__SWIG_1", "D_new_Vector__SWIG_1"));
  mixin(bindCode("new_Vector__SWIG_2", "D_new_Vector__SWIG_2"));
  mixin(bindCode("Vector_remove__SWIG_0", "D_Vector_remove__SWIG_0"));
  mixin(bindCode("Vector_remove__SWIG_1", "D_Vector_remove__SWIG_1"));
  mixin(bindCode("Vector_removeBack", "D_Vector_removeBack"));
  mixin(bindCode("Vector_linearRemove", "D_Vector_linearRemove"));
  mixin(bindCode("Vector_insertAt", "D_Vector_insertAt"));
  mixin(bindCode("Vector_getElement", "D_Vector_getElement"));
  mixin(bindCode("Vector_setElement", "D_Vector_setElement"));
  mixin(bindCode("delete_Vector", "D_delete_Vector"));
}

//#if !defined(SWIG_D_NO_EXCEPTION_HELPER)
extern(C) void function(
  SwigExceptionCallback exceptionCallback,
  SwigExceptionCallback illegalArgumentCallback,
  SwigExceptionCallback illegalElementCallback,
  SwigExceptionCallback ioCallback,
  SwigExceptionCallback noSuchElementCallback) swigRegisterExceptionCallbackstinyspline;
//#endif // SWIG_D_NO_EXCEPTION_HELPER

//#if !defined(SWIG_D_NO_STRING_HELPER)
extern(C) void function(SwigStringCallback callback) swigRegisterStringCallbacktinyspline;
//#endif // SWIG_D_NO_STRING_HELPER


mixin template SwigOperatorDefinitions() {
  public override bool opEquals(Object o) {
    if (auto rhs = cast(typeof(this))o) {
      if (swigCPtr == rhs.swigCPtr) return true;
      static if (is(typeof(swigOpEquals(rhs)))) {
        return swigOpEquals(rhs);
      } else {
        return false; 
      }
    }
    return super.opEquals(o);
  }

  
  public override int opCmp(Object o) {
    static if (__traits(compiles, swigOpLt(typeof(this).init) &&
        swigOpEquals(typeof(this).init))) {
      if (auto rhs = cast(typeof(this))o) {
        if (swigOpLt(rhs)) {
          return -1;
        } else if (swigOpEquals(rhs)) {
          return 0;
        } else {
          return 1;
        }
      }
    }
    return super.opCmp(o);
  }

  private template swigOpBinary(string operator, string name) {
    enum swigOpBinary = `public void opOpAssign(string op, T)(T rhs) if (op == "` ~ operator ~
      `" && __traits(compiles, swigOp` ~ name ~ `Assign(rhs))) { swigOp` ~ name ~ `Assign(rhs);}` ~
      `public auto opBinary(string op, T)(T rhs) if (op == "` ~ operator ~
      `" && __traits(compiles, swigOp` ~ name ~ `(rhs))) { return swigOp` ~ name ~ `(rhs);}`;
  }
  mixin(swigOpBinary!("+", "Add"));
  mixin(swigOpBinary!("-", "Sub"));
  mixin(swigOpBinary!("*", "Mul"));
  mixin(swigOpBinary!("/", "Div"));
  mixin(swigOpBinary!("%", "Mod"));
  mixin(swigOpBinary!("&", "And"));
  mixin(swigOpBinary!("|", "Or"));
  mixin(swigOpBinary!("^", "Xor"));
  mixin(swigOpBinary!("<<", "Shl"));
  mixin(swigOpBinary!(">>", "Shr"));
  
  private template swigOpUnary(string operator, string name) {
    enum swigOpUnary = `public auto opUnary(string op)() if (op == "` ~ operator ~
      `" && __traits(compiles, swigOp` ~ name ~ `())) { return swigOp` ~ name ~ `();}`;   
  }
  mixin(swigOpUnary!("+", "Pos"));
  mixin(swigOpUnary!("-", "Neg"));
  mixin(swigOpUnary!("~", "Com"));
  mixin(swigOpUnary!("++", "Inc"));
  mixin(swigOpUnary!("--", "Dec"));


}


private class SwigExceptionHelper {
  static this() {
	// The D1/Tango version maps C++ exceptions to multiple exception types.
    swigRegisterExceptionCallbackstinyspline(
      &setException,
      &setException,
      &setException,
      &setException,
      &setException
    );
  }

  static void setException(const char* message) {
    auto exception = new object.Exception(std.conv.to!string(message));
    SwigPendingException.set(exception);
  }
}

package struct SwigPendingException {
public:
  static this() {
    m_sPendingException = null;
  }

  static bool isPending() {
    return m_sPendingException !is null;
  }

  static void set(object.Exception e) {
    if (m_sPendingException !is null) {
      e.next = m_sPendingException;
      throw new object.Exception("FATAL: An earlier pending exception from C/C++ code " ~
        "was missed and thus not thrown (" ~ m_sPendingException.classinfo.name ~
        ": " ~ m_sPendingException.msg ~ ")!", e);
    }

    m_sPendingException = e;
  }

  static object.Exception retrieve() {
    auto e = m_sPendingException;
    m_sPendingException = null;
    return e;
  }

private:
  // The reference to the pending exception (if any) is stored thread-local.
  static object.Exception m_sPendingException;
}
alias void function(const char* message) SwigExceptionCallback;


private class SwigStringHelper {
  static this() {
    swigRegisterStringCallbacktinyspline(&createString);
  }

  static const(char)* createString(const(char*) cString) {
    // We are effectively dup'ing the string here.
    // TODO: Is this also correct for D2/Phobos?
    return std.string.toStringz(std.conv.to!string(cString));
  }
}
alias const(char)* function(const(char*) cString) SwigStringCallback;


template SwigExternC(T) if (is(typeof(*(T.init)) P == function)) {
  static if (is(typeof(*(T.init)) R == return)) {
    static if (is(typeof(*(T.init)) P == function)) {
      alias extern(C) R function(P) SwigExternC;
    }
  }
}

SwigExternC!(int function()) TS_MAX_NUM_KNOTS_get;
SwigExternC!(double function()) TS_MIN_KNOT_VALUE_get;
SwigExternC!(double function()) TS_MAX_KNOT_VALUE_get;
SwigExternC!(double function()) TS_KNOT_EPSILON_get;
SwigExternC!(size_t function(void* jarg1)) ts_bspline_degree;
SwigExternC!(int function(void* jarg1, size_t jarg2, void* jarg3)) ts_bspline_set_degree;
SwigExternC!(size_t function(void* jarg1)) ts_bspline_order;
SwigExternC!(int function(void* jarg1, size_t jarg2, void* jarg3)) ts_bspline_set_order;
SwigExternC!(size_t function(void* jarg1)) ts_bspline_dimension;
SwigExternC!(int function(void* jarg1, size_t jarg2, void* jarg3)) ts_bspline_set_dimension;
SwigExternC!(size_t function(void* jarg1)) ts_bspline_len_control_points;
SwigExternC!(size_t function(void* jarg1)) ts_bspline_num_control_points;
SwigExternC!(size_t function(void* jarg1)) ts_bspline_sof_control_points;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_bspline_control_points;
SwigExternC!(int function(void* jarg1, size_t jarg2, void* jarg3, void* jarg4)) ts_bspline_control_point_at;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_bspline_set_control_points;
SwigExternC!(int function(void* jarg1, size_t jarg2, void* jarg3, void* jarg4)) ts_bspline_set_control_point_at;
SwigExternC!(size_t function(void* jarg1)) ts_bspline_num_knots;
SwigExternC!(size_t function(void* jarg1)) ts_bspline_sof_knots;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_bspline_knots;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_bspline_set_knots;
SwigExternC!(double function(void* jarg1)) ts_deboornet_knot;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_index;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_multiplicity;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_num_insertions;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_dimension;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_len_points;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_num_points;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_sof_points;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_deboornet_points;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_len_result;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_num_result;
SwigExternC!(size_t function(void* jarg1)) ts_deboornet_sof_result;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_deboornet_result;
SwigExternC!(void* function()) ts_bspline_init;
SwigExternC!(int function(size_t jarg1, size_t jarg2, size_t jarg3, int jarg4, void* jarg5, void* jarg6)) ts_bspline_new;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_bspline_copy;
SwigExternC!(void function(void* jarg1, void* jarg2)) ts_bspline_move;
SwigExternC!(void function(void* jarg1)) ts_bspline_free;
SwigExternC!(void* function()) ts_deboornet_init;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_deboornet_copy;
SwigExternC!(void function(void* jarg1, void* jarg2)) ts_deboornet_move;
SwigExternC!(void function(void* jarg1)) ts_deboornet_free;
SwigExternC!(int function(void* jarg1, size_t jarg2, size_t jarg3, void* jarg4, void* jarg5)) ts_bspline_interpolate_cubic;
SwigExternC!(int function(void* jarg1, double jarg2, void* jarg3, void* jarg4)) ts_bspline_eval;
SwigExternC!(double function(void* jarg1)) ts_bspline_domain_min;
SwigExternC!(double function(void* jarg1)) ts_bspline_domain_max;
SwigExternC!(int function(void* jarg1, double jarg2, void* jarg3, void* jarg4)) ts_bspline_is_closed;
SwigExternC!(int function(void* jarg1, size_t jarg2, void* jarg3, void* jarg4)) ts_bspline_derive;
SwigExternC!(int function(void* jarg1, double jarg2, size_t jarg3, void* jarg4, void* jarg5, void* jarg6)) ts_bspline_insert_knot;
SwigExternC!(int function(void* jarg1, double jarg2, void* jarg3, void* jarg4, void* jarg5)) ts_bspline_split;
SwigExternC!(int function(void* jarg1, double jarg2, void* jarg3, void* jarg4)) ts_bspline_buckle;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_bspline_to_beziers;
SwigExternC!(int function(void* jarg1, void* jarg2, void* jarg3)) ts_bspline_to_json;
SwigExternC!(int function(const(char)* jarg1, void* jarg2, void* jarg3)) ts_bspline_from_json;
SwigExternC!(int function(void* jarg1, const(char)* jarg2, void* jarg3)) ts_bspline_save_json;
SwigExternC!(int function(const(char)* jarg1, void* jarg2, void* jarg3)) ts_bspline_load_json;
SwigExternC!(int function(double jarg1, double jarg2)) ts_fequals;
SwigExternC!(void function(void* jarg1, size_t jarg2, double jarg3)) ts_arr_fill;
SwigExternC!(double function(void* jarg1, void* jarg2, size_t jarg3)) ts_ctrlp_dist2;
SwigExternC!(void* function(void* jarg1)) new_DeBoorNet;
SwigExternC!(void function(void* jarg1)) delete_DeBoorNet;
SwigExternC!(double function(void* jarg1)) DeBoorNet_knot;
SwigExternC!(size_t function(void* jarg1)) DeBoorNet_index;
SwigExternC!(size_t function(void* jarg1)) DeBoorNet_multiplicity;
SwigExternC!(size_t function(void* jarg1)) DeBoorNet_numInsertions;
SwigExternC!(size_t function(void* jarg1)) DeBoorNet_dimension;
SwigExternC!(void* function(void* jarg1)) DeBoorNet_points;
SwigExternC!(void* function(void* jarg1)) DeBoorNet_result;
SwigExternC!(void* function()) new_BSpline__SWIG_0;
SwigExternC!(void* function(void* jarg1)) new_BSpline__SWIG_1;
SwigExternC!(void* function(size_t jarg1, size_t jarg2, size_t jarg3, int jarg4)) new_BSpline__SWIG_2;
SwigExternC!(void* function(size_t jarg1, size_t jarg2, size_t jarg3)) new_BSpline__SWIG_3;
SwigExternC!(void* function(size_t jarg1, size_t jarg2)) new_BSpline__SWIG_4;
SwigExternC!(void* function(size_t jarg1)) new_BSpline__SWIG_5;
SwigExternC!(void function(void* jarg1)) delete_BSpline;
SwigExternC!(void* function(void* jarg1, double jarg2)) BSpline_opCall;
SwigExternC!(size_t function(void* jarg1)) BSpline_degree;
SwigExternC!(size_t function(void* jarg1)) BSpline_order;
SwigExternC!(size_t function(void* jarg1)) BSpline_dimension;
SwigExternC!(void* function(void* jarg1)) BSpline_controlPoints;
SwigExternC!(void* function(void* jarg1, size_t jarg2)) BSpline_controlPointAt;
SwigExternC!(void* function(void* jarg1)) BSpline_knots;
SwigExternC!(void* function(void* jarg1, double jarg2)) BSpline_eval;
SwigExternC!(double function(void* jarg1)) BSpline_domainMin;
SwigExternC!(double function(void* jarg1)) BSpline_domainMax;
SwigExternC!(uint function(void* jarg1, double jarg2)) BSpline_isClosed__SWIG_0;
SwigExternC!(uint function(void* jarg1)) BSpline_isClosed__SWIG_1;
SwigExternC!(const(char)* function(void* jarg1)) BSpline_toJSON;
SwigExternC!(void function(void* jarg1, const(char)* jarg2)) BSpline_fromJSON;
SwigExternC!(void function(void* jarg1, const(char)* jarg2)) BSpline_save;
SwigExternC!(void function(void* jarg1, const(char)* jarg2)) BSpline_load;
SwigExternC!(void function(void* jarg1, void* jarg2)) BSpline_setControlPoints;
SwigExternC!(void function(void* jarg1, size_t jarg2, void* jarg3)) BSpline_setControlPointAt;
SwigExternC!(void function(void* jarg1, void* jarg2)) BSpline_setKnots;
SwigExternC!(void* function(void* jarg1, double jarg2, size_t jarg3)) BSpline_insertKnot;
SwigExternC!(void* function(void* jarg1, double jarg2)) BSpline_split;
SwigExternC!(void* function(void* jarg1, double jarg2)) BSpline_buckle;
SwigExternC!(void* function(void* jarg1)) BSpline_toBeziers;
SwigExternC!(void* function(void* jarg1, size_t jarg2)) BSpline_derive__SWIG_0;
SwigExternC!(void* function(void* jarg1)) BSpline_derive__SWIG_1;
SwigExternC!(void* function(void* jarg1, size_t jarg2)) Utils_interpolateCubic;
SwigExternC!(uint function(double jarg1, double jarg2)) Utils_fequals;
SwigExternC!(void function(void* jarg1)) delete_Utils;
SwigExternC!(uint function(void* jarg1)) Vector_empty;
SwigExternC!(void function(void* jarg1)) Vector_clear;
SwigExternC!(void function(void* jarg1, double jarg2)) Vector_push_back;
SwigExternC!(void function(void* jarg1)) Vector_pop_back;
SwigExternC!(size_t function(void* jarg1)) Vector_size;
SwigExternC!(size_t function(void* jarg1)) Vector_capacity;
SwigExternC!(void function(void* jarg1, size_t jarg2)) Vector_reserve;
SwigExternC!(void* function()) new_Vector__SWIG_0;
SwigExternC!(void* function(void* jarg1)) new_Vector__SWIG_1;
SwigExternC!(void* function(size_t jarg1)) new_Vector__SWIG_2;
SwigExternC!(double function(void* jarg1)) Vector_remove__SWIG_0;
SwigExternC!(double function(void* jarg1, size_t jarg2)) Vector_remove__SWIG_1;
SwigExternC!(void function(void* jarg1, size_t jarg2)) Vector_removeBack;
SwigExternC!(void function(void* jarg1, size_t jarg2, size_t jarg3)) Vector_linearRemove;
SwigExternC!(void function(void* jarg1, size_t jarg2, double jarg3)) Vector_insertAt;
SwigExternC!(double function(void* jarg1, size_t jarg2)) Vector_getElement;
SwigExternC!(void function(void* jarg1, size_t jarg2, double jarg3)) Vector_setElement;
SwigExternC!(void function(void* jarg1)) delete_Vector;
