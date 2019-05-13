# install with default layout with extra domain

# include/foo/foo.h
# lib/foo/libfoostatic.a

XmakeInstallHelper(TARGETS fooshared
    DOMAIN foo
)
# include/bar/bar.h
# include/bar/bar2.h
# include/bar/private/bar-private.h
# include/bar/private/bar-private2.h
# lib/bar/libbarstatic.a
XmakeInstallHelper(TARGETS barstatic
    DOMAIN bar
)

# bin/xtest/xtest
# bin/xtest/another
# bin/xtest/xtest-static
XmakeInstallHelper(TARGETS xtest xtest-static another
    DOMAIN xtest
)

# bin/awesome/awesome
# bin/awesome/xtestxx
# bin/awesome/xtestxx-static
# bin/awesome/check
# bin/awesome/bundle
# share/awesome/resource/install.ico
# share/awesome/resource/uninstall.ico
XmakeInstallHelper(TARGETS awesome xtestxx xtestxx-static check bundle
    DOMAIN awesome
)
