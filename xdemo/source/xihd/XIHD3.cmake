# foo/foo.h
# foo/libfoostatic.a
XmakeInstallHelper(TARGETS fooshared
    DESTINATION foo
)

# bar/here/that/libbarstatic.a
# bar/here/that/bar.h
# bar/here/that/bar2.h
# bar/here/that/private/bar-private.h
# bar/here/that/private/bar-private2.h
XmakeInstallHelper(TARGETS barstatic
    DOMAIN that
    DESTINATION bar/here
)

# bin/xtest/xtest
# bin/xtest/another
# bin/xtest/xtest-static
XmakeInstallHelper(TARGETS xtest xtest-static another
    DESTINATION xtest
)

# bin/awesome/awesome
# bin/awesome/xtestxx
# bin/awesome/xtestxx-static
# bin/awesome/check
# bin/awesome/bundle
# share/awesome/resource/install.ico
# share/awesome/resource/uninstall.ico
XmakeInstallHelper(TARGETS awesome xtestxx xtestxx-static check bundle
    DOMAIN here
    DESTINATION awesome
)
