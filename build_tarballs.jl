# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "GTK+"
version = v"3.24.10"

sources = [
    "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.10.tar.xz" =>
    "35a8f107e2b90fda217f014c0c15cb20a6a66678f6fd7e36556d469372c01b03",
]

# Bash recipe for building across all platforms
# TODO: Theora and Opus once their releases are available
script = raw"""
cd $WORKSPACE/srcdir
cd gtk+-$(version)/
./configure --prefix=$prefix --extra-cflags="-I${prefix}/include" --extra-ldflags="-L${prefix}/lib"
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, ["libgtk"], :gtk),
    LibraryProduct(prefix, ["libgdk"], :gdk),
    LibraryProduct(prefix, ["libgdk_pixbuf"], :gdk_pixbuf),
]

# Dependencies that must be installed before this package can be built
dependencies = [
    # The GLib library provides core non-graphical functionality such as high level data types, Unicode manipulation, and an object and type system to C programs.
    # Glib-related dependencies
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/PCRE-v8.42-2/build_PCRE.v8.42.0.jl",
    "https://github.com/giordano/Yggdrasil/releases/download/Libffi-v3.2.1-0/build_Libffi.v3.2.1.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Libiconv-v1.15-0/build_Libiconv.v1.15.0.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Gettext-v0.19.8-0/build_Gettext.v0.19.8.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Glib-v2.59.0%2B0/build_Glib.v2.59.0.jl",

    # The GdkPixbuf library provides facilities for loading images in a variety of file formats.
    # GdkPixBuf dependencies
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.4/build_Zlib.v1.2.11.jl",
    "https://github.com/giordano/Yggdrasil/releases/download/X11-v1.6.8/build_X11.v1.6.8.jl",
    "https://github.com/JuliaIO/LibpngBuilder/releases/download/v1.0.3/build_libpng.v1.6.37.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/JpegTurbo-v2.0.1-0/build_JpegTurbo.v2.0.1.jl",
    "https://github.com/JuliaIO/LibTIFFBuilder/releases/download/v6/build_libtiff.v4.0.9.jl",
    "https://github.com/ianshmean/SharedMimeInfoBuilder/releases/download/v1.0.0/build_shared-mime-info.v1.10.0.jl",

    # Pango is a library for internationalized text handling.
    # Pango-only dependencies
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/FriBidi-v1.0.5%2B0/build_FriBidi.v1.0.5.jl",
    "https://github.com/giordano/Yggdrasil/releases/download/Pango-v.1.42.4/build_Pango.v1.42.4.jl"

    # ATK is the Accessibility Toolkit. It provides a set of generic interfaces allowing accessibility technologies such as screen readers to interact with a graphical user interface.


    # Gobject Introspection is a framework for making introspection data available to language bindings.
    ### May be satisfied via the GLib build...

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
