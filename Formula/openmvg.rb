class Openmvg < Formula
  desc "open Multiple View Geometry library. Basis for 3D computer vision and Structure from Motion."
  homepage "http://imagine.enpc.fr/~moulonp/openMVG/"
  head "https://github.com/openMVG/openMVG.git", :using => :git, :branch => :develop
  revision 1

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "llvm"
  depends_on "flann"

  needs :cxx11

  def install
    ENV.cxx11

    llvm_path = `/usr/local/bin/brew --cellar llvm`.chomp
    llvm_version = `/usr/local/bin/brew list --versions llvm | tr ' ' '\n' | tail -1`.chomp
    clang_path = "#{llvm_path}/#{llvm_version}/bin/clang"
    clang_cpp_path = "#{llvm_path}/#{llvm_version}/bin/clang++"

    eigen_path = `/usr/local/bin/brew --cellar eigen`.chomp
    eigen_version = `/usr/local/bin/brew list --versions eigen | tr ' ' '\n' | tail -1`.chomp
    eigen_include_path = "#{llvm_path}/#{llvm_version}/include/eigen3"

    flann_path = `/usr/local/bin/brew --cellar flann`.chomp
    flann_version = `/usr/local/bin/brew list --versions flann | tr ' ' '\n' | tail -1`.chomp
    flann_include_path = "#{flann_path}/#{flann_version}/include"

    args = std_cmake_args + %W[
      -DCMAKE_C_COMPILER=#{clang_path}
      -DCMAKE_CXX_COMPILER=#{clang_cpp_path}
      -DCMAKE_BUILD_TYPE=Release
      -DOpenMVG_BUILD_SHARED=OFF
      -DOpenMVG_BUILD_TESTS=OFF
      -DOpenMVG_BUILD_DOC=OFF
      -DOpenMVG_BUILD_EXAMPLES=ON
      -DOpenMVG_BUILD_OPENGL_EXAMPLES=ON
      -DOpenMVG_BUILD_SOFTWARES=ON
      -DOpenMVG_BUILD_GUI_SOFTWARES=OFF
      -DOpenMVG_BUILD_COVERAGE=OFF
      -DOpenMVG_USE_OPENMP=OFF
      -DOpenMVG_USE_OPENCV=OFF
      -DOpenMVG_USE_OCVSIFT=OFF
      -DEIGEN_INCLUDE_DIR_HINTS=#{eigen_include_path}
      -DFLANN_INCLUDE_DIR_HINTS=#{flann_include_path}
    ]

    mkdir "build" do
      system "cmake", "../src", *args
      system "make -j4"
      system "make", "install"
    end
  end
end