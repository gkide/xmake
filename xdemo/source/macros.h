/// @file source/macros.h

// gcc and clang expose their version as follows:
//
// https://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html
// gcc 4.7.2:
//   __GNUC__          = 4
//   __GNUC_MINOR__    = 7
//   __GNUC_PATCHLEVEL = 2
//
// clang 3.4 (claims compat with gcc 4.2.1):
//   __GNUC__          = 4
//   __GNUC_MINOR__    = 2
//   __GNUC_PATCHLEVEL = 1
//   __clang__         = 1
//   __clang_major__   = 3
//   __clang_minor__   = 4
//
// To view the default defines of these compilers, you can perform:
//
// $ gcc -E -dM - </dev/null
// $ echo | clang -dM -E -

#ifndef XDEMO_SOURCE_MACROS_H
#define XDEMO_SOURCE_MACROS_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>

#ifndef INIT
/// Init for anything
#define INIT(...)   __VA_ARGS__
#endif

#ifndef MIN
/// Min number of X & Y
#define MIN(X, Y)   ((X) < (Y) ? (X) : (Y))
#endif

#ifndef MAX
/// Max number of X & Y
#define MAX(X, Y)   ((X) > (Y) ? (X) : (Y))
#endif

#ifndef STR_LEN
/// Static string with length, used by functions
/// which accept `(char *s, size_t len)` arguments.
///
/// @param[I] s
/// Static string.
///
/// @return
/// s, sizeof(s) - 1
#define STR_LEN(s)      (s), (sizeof(s) - 1)
#endif

// The host system path separator
#ifdef HOST_WINDOWS
    #define PATH_SEP_S  "\\"
    #define PATH_SEP_C  '\\'
#else
    #define PATH_SEP_S  "/"
    #define PATH_SEP_C  '/'
#endif

/// Calculate the length of a C array.
///
/// This should be called with a real array. Calling this with a pointer
/// is an error. A mechanism to detect many (though not all) of those errors
/// at compile time is implemented. It works by the second division producing
/// a division by zero in those cases (-Wdiv-by-zero in GCC).
#define ARRAY_SIZE(a) \
    ((sizeof(a)/sizeof((a)[0])) / ((size_t)(!(sizeof(a) % sizeof((a)[0])))))

// Definitions of various common control characters.
// - http://www.ascii-code.com/
// - https://en.wikipedia.org/wiki/ASCII
#define NUL             0x00 ///< 000, null char
#define BELL            0x07 ///< 007, ring bell
#define BS              0x08 ///< 010, back space
#define TAB             0x09 ///< 011, horizontal tab
#define HT              0x09 ///< 011, horizontal tab
#define NL              0x0A ///< 012, line feed, new line
#define VT              0x0B ///< 013, vertical tab
#define CR              0x0D ///< 015, carriage return, new line for MacOS
#define ESC             0x1B ///< 033, escape
#define DEL             0x7F ///< 177, delete

#define DCS             0x90 ///< 220, Device Control String
#define CSI             0x9B ///< 233, Control Sequence Introducer

#ifndef ASCII_TOUPPER
#define ASCII_TOUPPER(c)   (((c) < 'a' || (c) > 'z') ? (c) : (c) - ('a' - 'A'))
#endif

#ifndef ASCII_ISUPPER
#define ASCII_ISUPPER(c)   ((unsigned)(c) >= 'A' && (unsigned)(c) <= 'Z')
#endif

#ifndef ASCII_TOLOWER
#define ASCII_TOLOWER(c)   (((c) < 'A' || (c) > 'Z') ? (c) : (c) + ('a' - 'A'))
#endif

#ifndef ASCII_ISLOWER
#define ASCII_ISLOWER(c)   ((unsigned)(c) >= 'a' && (unsigned)(c) <= 'z')
#endif

#ifndef ASCII_ISALPHA
#define ASCII_ISALPHA(c)   (ASCII_ISUPPER(c) || ASCII_ISLOWER(c))
#endif

#ifndef ASCII_ISALNUM
#define ASCII_ISALNUM(c)   (ASCII_ISALPHA(c) || ASCII_ISDIGIT(c))
#endif

/// __has_attribute
///
/// This function-like macro takes a single identifier argument that is
/// the name of a GNU-style attribute. It evaluates to 1  if the attribute
/// is supported by the current compilation target, or 0 if not.
/// - http://clang.llvm.org/docs/LanguageExtensions.html
#ifndef __has_attribute
    // Compatibility with non-clang compilers.
    #define HAS_ATTRIBUTE(x)    0
#elif defined(__clang__) && __clang__ == 1 \
    && (__clang_major__ < 3 || (__clang_major__ == 3 && __clang_minor__ <= 5))
    // Starting in Clang 3.6, __has_attribute was fixed to only report true for
    // GNU-style attributes.  Prior to that, it reported true if _any_ backend
    // supported the attribute.
    #define HAS_ATTRIBUTE(x)    0
#else
    #define HAS_ATTRIBUTE       __has_attribute
#endif

#if HAS_ATTRIBUTE(fallthrough)
    // switch(cond)
    // {
    //     case 1:
    //     ....
    //     __attribute__ ((fallthrough));
    //     default:
    //     ...
    // }
    //
    // https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#Warning-Options
    #define FALL_THROUGH_ATTRIBUTE    __attribute__((fallthrough))
#else
    #define FALL_THROUGH_ATTRIBUTE
#endif

#ifdef __GNUC__ // For all gnulikes: gcc, clang, intel.
    // Place these after the argument list of the function declaration,
    // not definition, like: void myfunc(void) REAL_FATTR_ALWAYS_INLINE;
    #define FUNC_ATTR_MALLOC                __attribute__((__malloc__))
    #define FUNC_ATTR_ALLOC_ALIGN(x)        __attribute__((__alloc_align__(x)))
    #define FUNC_ATTR_PURE                  __attribute__((__pure__))
    #define FUNC_ATTR_CONST                 __attribute__((__const__))
    #define FUNC_ATTR_WARN_UNUSED_RESULT    __attribute__((__warn_unused_result__))
    #define FUNC_ATTR_ALWAYS_INLINE         __attribute__((__always_inline__))
    #define FUNC_ATTR_UNUSED                __attribute__((__unused__))
    #define FUNC_ATTR_NONNULL_ALL           __attribute__((__nonnull__))
    #define FUNC_ATTR_NONNULL_ARG(...)      __attribute__((__nonnull__(__VA_ARGS__)))
    #define FUNC_ATTR_NORETURN              __attribute__((__noreturn__))
    #define FUNC_ATTR_VISIBILITY(x)         __attribute__((visibility(x)))

    #if HAS_ATTRIBUTE(returns_nonnull)
    #define FUNC_ATTR_NONNULL_RETURN        __attribute__((__returns_nonnull__))
    #endif

    #if HAS_ATTRIBUTE(alloc_size)
    #define FUNC_ATTR_ALLOC_SIZE(x)         __attribute__((__alloc_size__(x)))
    #define FUNC_ATTR_ALLOC_SIZE_PROD(x, y) __attribute__((__alloc_size__(x, y)))
    #endif

    /// For function arguments not always used: windows used, but not linux
    #define FUNC_ARGS_UNUSED_MAYBE(v)   v __attribute__((__unused__))
    /// For the arguments always not used, and get an error if try to use.
    /// - it does not work for arguments which contain parenthesis.
    /// - if it always unused, maybe it is time to refact the function.
    #define FUNC_ARGS_UNUSED_NEVER(v)   UNUSED_##v  __attribute__((__unused__))
#else
    #define FUNC_ATTR_MALLOC
    #define FUNC_ATTR_ALLOC_ALIGN(x)
    #define FUNC_ATTR_PURE
    #define FUNC_ATTR_CONST
    #define FUNC_ATTR_WARN_UNUSED_RESULT
    #define FUNC_ATTR_ALWAYS_INLINE
    #define FUNC_ATTR_UNUSED
    #define FUNC_ATTR_NONNULL_ALL
    #define FUNC_ATTR_NONNULL_ARG(...)
    #define FUNC_ATTR_NORETURN
    #define FUNC_ATTR_VISIBILITY(x)
    #define FUNC_ATTR_NONNULL_RETURN
    #define FUNC_ATTR_ALLOC_SIZE(x)
    #define FUNC_ATTR_ALLOC_SIZE_PROD(x, y)

    #define FUNC_ARGS_UNUSED_MAYBE(v)
    #define FUNC_ARGS_UNUSED_NEVER(v)
#endif

static inline bool ASCII_ISWHITE(int)
FUNC_ATTR_CONST
FUNC_ATTR_ALWAYS_INLINE;

static inline bool ASCII_ISSPACE(int)
FUNC_ATTR_CONST
FUNC_ATTR_ALWAYS_INLINE;

static inline bool ASCII_ISDIGIT(int)
FUNC_ATTR_CONST
FUNC_ATTR_ALWAYS_INLINE;

static inline bool ASCII_ISXDIGIT(int)
FUNC_ATTR_CONST
FUNC_ATTR_ALWAYS_INLINE;

static inline bool ASCII_ISODIGIT(int)
FUNC_ATTR_CONST
FUNC_ATTR_ALWAYS_INLINE;

static inline bool ASCII_ISBDIGIT(int)
FUNC_ATTR_CONST
FUNC_ATTR_ALWAYS_INLINE;

/// Checks if `c` is a space or tab character.
///
/// @param[I] c
/// The input char for checking
///
/// @return true or false
static inline bool ASCII_ISWHITE(int c)
{
    return c == ' ' || c == '\t';
}

/// Check whether character is a decimal digit: 0 - 9
///
/// @param[I] c
/// The input char for checking
///
/// @return true or false
static inline bool ASCII_ISDIGIT(int c)
{
    return c >= '0' && c <= '9';
}

/// Checks if `c` is a hexadecimal digit: 0 - 9, a - f, A - F.
///
/// @param[I] c
/// The input char for checking
///
/// @return true or false
static inline bool ASCII_ISXDIGIT(int c)
{
    return (c >= '0' && c <= '9')
            || (c >= 'a' && c <= 'f')
            || (c >= 'A' && c <= 'F');
}

/// Checks if `c` is a octonary digit: 0 - 7.
///
/// @param[I] c
/// The input char for checking
///
/// @return true or false
static inline bool ASCII_ISODIGIT(int c)
{
    return (c >= '0' && c <= '9')
            || (c >= 'a' && c <= 'f')
            || (c >= 'A' && c <= 'F');
}

/// Checks if `c` is a binary digit: 0 or 1.
///
/// @param[I] c
/// The input char for checking
///
/// @return true or false
static inline bool ASCII_ISBDIGIT(int c)
{
    return (c == '0' || c == '1');
}

/// Checks if `c` is a white-space character: `\f`, `\n`, `\r`, `\t`, `\v`
///
/// @param[I] c
/// The input char for checking
///
/// @return true or false
static inline bool ASCII_ISSPACE(int c)
{
    return (c >= 9 && c <= 13) || c == ' ';
}

#define CAST(T, V)      ((T)(V))
#define UNUSED_ARG(v)   (void)v

#define __M2S__(x)      #x // do not expand, just convert to string
#define M2S(x)          __M2S__(x) // expand, then convert to string

#define API_SYNC
#define API_ASYNC
#define API_REMOTE
#define API_SINCE(x)
#define API_DEPRECATED_SINCE(x)

#ifdef __cplusplus
}
#endif

#endif // XDEMO_SOURCE_MACROS_H
