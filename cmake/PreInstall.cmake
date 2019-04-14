if(true)
    PrebuildInstall(astyle TARBALL
        # SKIP # This can be skip
        VERSION     3.0.1
        URL         https://gitlab.com/gkide/prebuild/astyle/-/archive/v3.0.1/astyle-v3.0.1.tar.gz
        SHA256      1f8676c59cfb58bc15e23a402f6acc34b54156c05841f028a39650dd92075803
        PATCH_CMD   echo The patch stuff ...
        INSTALL_CMD echo The install stuff ...
    )
else()
    PrebuildInstall(astyle REPO
        # SKIP # This can be skip
        URL         https://gitlab.com/gkide/prebuild/astyle.git
        PATCH_CMD   echo The patch stuff ...
        INSTALL_CMD echo The install stuff ...
    )
endif()
