# install with default layout

# include/foo.h
# include/bar.h
# include/bar2.h
# include/private/bar-private.h
# include/private/bar-private2.h
# lib/libfoostatic.a
# lib/libbarstatic.a
XmakeInstallHelper(TARGETS fooshared
    DOMAIN xdemo
    EXPORT_LIBRARY_INFO
)
XmakeInstallHelper(TARGETS barshared foobar
    EXPORT_LIBRARY_INFO
    EXPORT_LIBRARY_WITH_EXTRA_LIBS abc def
)

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
