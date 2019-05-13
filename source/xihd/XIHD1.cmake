# install with default layout

# include/foo.h
# include/bar.h
# include/bar2.h
# include/private/bar-private.h
# include/private/bar-private2.h
# lib/libfoostatic.a
# lib/libbarstatic.a
XmakeInstallHelper(TARGETS foostatic)
XmakeInstallHelper(TARGETS barstatic foobar)

# bin/another
# bin/xtest
# bin/xtest-static
# bin/xtestxx
# bin/xtestxx-static
# bin/check
# bin/bundle
# bin/awesome
# share/resource/install.ico
# share/resource/uninstall.ico
XmakeInstallHelper(TARGETS another)
XmakeInstallHelper(TARGETS xtest xtest-static)
XmakeInstallHelper(TARGETS xtestxx xtestxx-static)
XmakeInstallHelper(TARGETS check bundle awesome)
